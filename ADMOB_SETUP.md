# Google AdMob Setup - Mindful Journal

## Overview

Iklan banner kecil hanya muncul di **halaman Settings** (paling bawah). Tidak ada iklan di halaman Journal, Mood, Habits, atau Insights — UX tetap bersih.

## Langkah Setup

### 1. Buat AdMob Account

1. Buka https://admob.google.com
2. Login dengan Google account kamu
3. Klik **"Sign up for AdMob"**
4. Isi info:
   - Country: Indonesia
   - App type: Individual
   - Payment: nanti diisi (threshold $100 baru bisa cair)

### 2. Buat AdMob App

1. AdMob Console → **Apps** → **Add App**
2. Pilih: "No, my app is not listed on a supported app store" (karena belum publish)
3. App name: **Mindful Journal**
4. Platform: **Android**
5. Package name: `com.madajabbar.mindfuljournal`
6. Klik **Add**

### 3. Buat Ad Unit (Banner)

1. Setelah app dibuat → **Ad units** → **Create ad unit**
2. Pilih **Banner**
3. Ad unit name: `settings_banner`
4. Settings default aja:
   - Banner size: Standard (320x50)
   - Refresh rate: 60 seconds
5. Klik **Create**

### 4. Dapatkan 2 ID Penting

Dari AdMob Console, kamu akan dapat:

**App ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX~NNNNNNNNNN`):
- Ada di App Settings → App ID
- Contoh: `ca-app-pub-1234567890123456~9876543210`

**Banner Ad Unit ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX/NNNNNNNNNN`):
- Ada di Ad units → settings_banner
- Contoh: `ca-app-pub-1234567890123456/1111111111`

### 5. Ganti ID di Code

**File 1:** `android/app/src/main/AndroidManifest.xml`

Cari line ini:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/>
```

Ganti value-nya dengan **App ID** kamu:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~NNNNNNNNNN"/>
```

**File 2:** `lib/widgets/ad_banner_widget.dart`

Cari line ini:
```dart
static const _adUnitId = 'ca-app-pub-3940256099942544/6300978111';
```

Ganti dengan **Ad Unit ID** kamu:
```dart
static const _adUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/NNNNNNNNNN';
```

### 6. Rebuild APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### 7. Test Iklan

1. Install APK baru di HP
2. Buka app → masuk ke tab **Settings**
3. Scroll ke bawah → harusnya muncul banner iklan kecil (320x50)
4. Kalau belum muncul, tunggu 1-2 menit (AdMob butuh waktu buat serve iklan baru)

⚠️ **JANGAN klik iklan kamu sendiri!** Google bisa detect dan bakal ban account AdMob kamu. Biarkan user yang klik.

## Penting: Sebelum Publish ke Play Store

Setelah app dipublish di Play Store:

1. AdMob Console → Apps → **Link to Google Play**
2. Pilih app kamu → Link
3. AdMob akan verify → setelah verified, iklan real bakal muncul (sebelumnya mungkin test ads)

## Estimasi Pendapatan

| Metric | Estimasi |
|--------|----------|
| eCPM Indonesia | $0.30 - $1.00 per 1000 impressions |
| 100 active users/day | ~$0.03 - $0.10/hari |
| 1000 active users/day | ~$0.30 - $1.00/hari |
| 10000 active users/day | ~$3 - $10/hari |

Banner di Settings page = impressions lebih sedikit (user jarang buka Settings), tapi **zero complaint**.

## Kalau Mau Tambah Banner di Halaman Lain

Edit file screen lain, tambah di bottom:

```dart
import 'package:mindful_journal/widgets/ad_banner_widget.dart';

// Di build method, setelah body:
Column(
  children: [
    Expanded(child: ...existing content...),
    const AdBannerWidget(),
  ],
)
```

## Rules AdMob (JANGAN DILANGGAR!)

1. ❌ Jangan klik iklan sendiri
2. ❌ Jangan suruh orang klik iklan ("Support us by clicking!")
3. ❌ Jangan taruh iklan terlalu banyak (max 1 banner per screen)
4. ❌ Jangan taruh iklan terlalu dekat tombol (min 16px padding)
5. ✅ Boleh taruh di Settings, Insights, atau halaman yang user lihat > 3 detik

## Troubleshooting

**Iklan nggak muncul?**
- Cek App ID di AndroidManifest → harus pake `~` bukan `/`
- Cek Ad Unit ID di code → harus pake `/` bukan `~`
- Tunggu 1-2 jam setelah buat Ad Unit baru
- Test dengan HP yang ada internet

**Error "No ad config"?**
- AdMob app baru butuh 1-24 jam untuk active
- Test ads pakai test ID dulu, baru ganti ke real ID

**App crash pas buka Settings?**
- Pastikan `google_mobile_ads` dependency sudah terinstall
- `flutter pub get` lalu rebuild
