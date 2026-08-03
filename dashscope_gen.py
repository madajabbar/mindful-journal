#!/usr/bin/env python3
"""DashScope Image & Video Generator — Windows standalone with auto key rotation.

Usage:
  # Image generation
  python dashscope_gen.py --mode image --prompt "a calm journal with coffee"

  # Video generation (T2V)
  python dashscope_gen.py --mode video --prompt "a person writing in a journal, warm lighting" --duration 5

  # Video generation (I2V — requires public image URL)
  python dashscope_gen.py --mode i2v --prompt "girl turns around smiling" --image_url "https://example.com/ref.png"

Key Management:
  Keys are loaded automatically from: D:\\Enviroment\\qwen key.txt
  On rate limit (429) or quota exhausted (403), automatically rotates to next key.
  Working key index saved to .dashscope_key_index for faster startup next time.
"""

import argparse
import json
import os
import sys
import time
import urllib.request
import urllib.error
from datetime import datetime
from pathlib import Path

# ── Configuration ──────────────────────────────────────────────────
IMAGE_ENDPOINT = "https://dashscope-intl.aliyuncs.com/api/v1/services/aigc/image-generation/generation"
VIDEO_ENDPOINT = "https://dashscope-intl.aliyuncs.com/api/v1/services/aigc/video-generation/video-synthesis"
TASK_ENDPOINT = "https://dashscope-intl.aliyuncs.com/api/v1/tasks/"

OUTPUT_DIR = Path(__file__).parent / "generated_media"
OUTPUT_DIR.mkdir(exist_ok=True)

KEY_FILE = Path(r"D:\Enviroment\qwen key.txt")
INDEX_FILE = Path(__file__).parent / ".dashscope_key_index"

# ── Key Management ─────────────────────────────────────────────────

def load_all_keys():
    """Load all API keys from file. Returns list of stripped keys."""
    if not KEY_FILE.exists():
        print(f"❌ Key file not found: {KEY_FILE}")
        sys.exit(1)
    keys = [line.strip() for line in KEY_FILE.read_text().splitlines() if line.strip()]
    if not keys:
        print(f"❌ No keys found in {KEY_FILE}")
        sys.exit(1)
    return keys


def load_key_index(total_keys):
    """Load last working key index. Returns 0 if not found or invalid."""
    if INDEX_FILE.exists():
        try:
            idx = int(INDEX_FILE.read_text().strip())
            if 0 <= idx < total_keys:
                return idx
        except ValueError:
            pass
    return 0


def save_key_index(idx):
    """Save working key index for next run."""
    INDEX_FILE.write_text(str(idx))


def is_retriable_error(status_code, body_str):
    """Check if error warrants key rotation (rate limit or quota exhausted)."""
    if status_code == 429:
        return True
    if status_code == 403:
        lower_body = body_str.lower()
        if any(kw in lower_body for kw in ["allocationquota", "quota", "exhausted", "free tier"]):
            return True
        # Generic 403 without parseable body — might be bad key, try next
        if not body_str.strip():
            return True
    if status_code == 401:
        return True  # Invalid/expired key
    return False


# ── Helpers ────────────────────────────────────────────────────────

def submit_task(url, payload, api_key):
    """Submit async task. Returns (task_id, error_code, error_body) or (None, code, body) on failure."""
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "X-DashScope-Async": "enable",
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers, method="POST")

    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            body = json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        raw = e.read().decode()
        body_str = raw
        try:
            body_parsed = json.loads(raw)
            body_str = body_parsed.get("message", raw)
        except (json.JSONDecodeError, AttributeError):
            pass
        return None, e.code, body_str

    task_id = body.get("output", {}).get("task_id")
    if not task_id:
        msg = body.get("message", str(body))
        return None, 0, msg

    return task_id, 0, ""


def poll_task(task_id, api_key, max_wait=300, interval=10):
    """Poll task until SUCCEEDED/FAILED or timeout. Returns result URL or None."""
    headers = {"Authorization": f"Bearer {api_key}"}
    url = f"{TASK_ENDPOINT}{task_id}"

    start = time.time()
    poll_count = 0

    while True:
        elapsed = time.time() - start
        if elapsed > max_wait:
            print(f"❌ Timeout after {max_wait}s")
            return None

        req = urllib.request.Request(url, headers=headers)
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                body = json.loads(resp.read().decode())
        except urllib.error.HTTPError as e:
            print(f"⚠️ Poll error {e.code}, retrying...")
            time.sleep(interval)
            continue

        output = body.get("output", {})
        status = output.get("task_status", "UNKNOWN")
        poll_count += 1

        if status == "SUCCEEDED":
            print(f"✅ Task succeeded! (poll #{poll_count})")
            if "video_url" in output:
                return output["video_url"]
            choices = output.get("choices", [])
            if choices:
                content = choices[0].get("message", {}).get("content", [])
                for item in content:
                    if item.get("type") == "image":
                        return item["image"]
            print(f"❌ Could not extract result URL")
            return None

        elif status in ("FAILED", "CANCELED"):
            msg = body.get("message", output.get("message", "Unknown error"))
            print(f"❌ Task {status}: {msg}")
            return None

        else:
            if status not in ("PENDING", "RUNNING"):
                print(f"⚠️ Unexpected status: {status} (poll #{poll_count})")
                if poll_count >= 3:
                    print(f"❌ Auto-failing after 3 unexpected statuses")
                    return None
            else:
                print(f"⏳ Status: {status} ({int(elapsed)}s elapsed, poll #{poll_count})")

            time.sleep(interval)


def download_file(url, filename):
    """Download file from URL to local path."""
    filepath = OUTPUT_DIR / filename
    print(f"📥 Downloading to {filepath}...")

    try:
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req, timeout=120) as resp:
            data = resp.read()
        filepath.write_bytes(data)
        size_mb = len(data) / (1024 * 1024)
        print(f"✅ Saved: {filepath} ({size_mb:.1f} MB)")
        return str(filepath)
    except Exception as e:
        print(f"❌ Download failed: {e}")
        return None


# ── Payload Builders ───────────────────────────────────────────────

def build_image_payload(args):
    return {
        "model": args.model,
        "input": {
            "messages": [
                {"role": "user", "content": [{"type": "text", "text": args.prompt}]}
            ]
        },
        "parameters": {"size": args.size, "n": 1}
    }


def build_video_payload(args):
    payload = {
        "model": args.model,
        "input": {"prompt": args.prompt},
        "parameters": {
            "duration": args.duration,
            "resolution": args.resolution,
            "prompt_extend": True,
            "watermark": False,
        }
    }
    if args.mode in ("i2v", "r2v") and args.image_url:
        media_type = "first_frame" if args.mode == "i2v" else "reference"
        payload["input"]["media"] = [{"type": media_type, "url": args.image_url}]
    return payload


# ── Main ───────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="DashScope Image & Video Generator (auto key rotation)")
    parser.add_argument("--mode", required=True, choices=["image", "video", "i2v", "r2v"])
    parser.add_argument("--prompt", required=True)
    parser.add_argument("--model", default=None)
    parser.add_argument("--size", default="1024*1024")
    parser.add_argument("--duration", type=int, default=5, choices=[5, 10, 15])
    parser.add_argument("--resolution", default="720P", choices=["720P", "1080P"])
    parser.add_argument("--image_url", default=None)

    args = parser.parse_args()

    # Auto-select model
    if not args.model:
        args.model = {"image": "wan2.7-image", "video": "wan2.7-t2v", "i2v": "wan2.7-i2v", "r2v": "wan2.7-r2v"}[args.mode]

    # Validate I2V/R2V
    if args.mode in ("i2v", "r2v") and not args.image_url:
        print("❌ I2V/R2V mode requires --image_url with a public HTTPS URL")
        sys.exit(1)

    # Load keys
    keys = load_all_keys()
    start_index = load_key_index(len(keys))
    print(f"🔑 Loaded {len(keys)} keys, starting from index {start_index}")

    # Build payload
    if args.mode == "image":
        payload = build_image_payload(args)
        endpoint = IMAGE_ENDPOINT
        ext, max_wait, interval = "png", 120, 5
    else:
        payload = build_video_payload(args)
        endpoint = VIDEO_ENDPOINT
        ext, max_wait, interval = "mp4", 300, 10

    print(f"🎨 Mode: {args.mode} | Model: {args.model}")
    print(f"📝 Prompt: {args.prompt}")
    if args.mode == "image":
        print(f"📐 Size: {args.size}")
    else:
        print(f"⏱️ {args.duration}s | {args.resolution}")
    if args.image_url:
        print(f"🖼️ Ref: {args.image_url}")
    print()

    # Try keys in rotation
    task_id = None
    working_key_idx = None

    for attempt in range(len(keys)):
        idx = (start_index + attempt) % len(keys)
        key = keys[idx]
        masked = key[:20] + "..." + key[-8:]

        print(f"🔑 Trying key [{idx}/{len(keys)-1}] {masked}")
        task_id, err_code, err_body = submit_task(endpoint, payload, key)

        if task_id:
            print(f"✅ Task submitted: {task_id}")
            working_key_idx = idx
            save_key_index(idx)
            break

        # Check if retriable
        if is_retriable_error(err_code, str(err_body)):
            reason = f"HTTP {err_code}: {err_body[:100]}" if err_code else str(err_body)[:100]
            print(f"⚠️ Key [{idx}] failed ({reason}), rotating...")
            continue
        else:
            # Non-retriable error (bad prompt, wrong model, etc.) — don't rotate
            print(f"❌ Non-retriable error ({err_code}): {err_body}")
            sys.exit(1)

    if not task_id:
        print(f"❌ All {len(keys)} keys exhausted. No working key found.")
        sys.exit(1)

    # Poll
    result_url = poll_task(task_id, keys[working_key_idx], max_wait=max_wait, interval=interval)
    if not result_url:
        sys.exit(1)

    # Download
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"dashscope_{args.mode}_{timestamp}.{ext}"
    filepath = download_file(result_url, filename)
    if not filepath:
        sys.exit(1)

    print()
    print(f"🎉 Done! File: {filepath}")


if __name__ == "__main__":
    main()
