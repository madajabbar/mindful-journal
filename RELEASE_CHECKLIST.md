# Mindful Journal - Play Store Release Checklist

## ✅ Completed

### App Build
- [x] Flutter 3.35.4 / Dart 3.9.2 project
- [x] Material Design 3 with light/dark theme
- [x] Hive local database (offline-first)
- [x] Riverpod state management
- [x] GoRouter navigation
- [x] **Signed release AAB built**: `build/app/outputs/bundle/release/app-release.aab` (38.1MB)
- [x] **Android SDK 36** (compileSdk & targetSdk)
- [x] **Keystore signing** configured (`android/keystores/mindful_journal_key.jks`)
- [x] Package ID: `com.madajabbar.mindfuljournal`
- [x] Version: 1.0.0+1

### App Icons
- [x] 1024x1024 Play Store icon: `assets/icons/app_icon.png`
- [x] 1024x500 Feature Graphic: `assets/icons/feature_graphic.png`
- [x] Adaptive icon (background + foreground)
- [x] All Android mipmap densities (mdpi → xxxhdpi)

### Legal & Compliance
- [x] **Privacy Policy**: `PRIVACY_POLICY.md` (GDPR/CCPA compliant)
- [x] **Terms of Service**: `TERMS_OF_SERVICE.md`
- [x] Contact email: `madajabbar22@gmail.com`
- [x] Permissions cleaned: only `VIBRATE` (no INTERNET, no sensitive permissions)
- [x] `AndroidManifest.xml`: `allowBackup="false"`, exported MainActivity

### GitHub Repository
- [x] **Pushed to**: https://github.com/madajabbar/mindful-journal
- [x] All source code committed
- [x] Privacy Policy & Terms included
- [x] `.gitignore` configured (keystore passwords excluded)

---

## 🔴 You Still Need To Do

### 1. Google Play Console Registration
- [ ] Go to https://play.google.com/console
- [ ] Pay **$25 developer fee** (one-time)
- [ ] Complete developer profile

### 2. Create App in Play Console
- [ ] Click "Create app"
- [ ] App name: **Mindful Journal**
- [ ] Default language: English (US) or Indonesian
- [ ] App type: App (not game)
- [ ] Free or Paid: **Free** (recommended)

### 3. Upload Release
- [ ] Go to **Production** or **Internal Testing**
- [ ] Upload: `D:\Code\Flutter\AI\mindful_journal\build\app\outputs\bundle\release\app-release.aab`
- [ ] Fill in release notes

### 4. Store Listing (Main Page)
- [ ] **Short description** (80 chars):
  ```
  Track your mood, build mindful habits, and find peace one day at a time.
  ```
- [ ] **Full description**:
  ```
  Mindful Journal is your daily mental wellness companion. 

  ✨ FEATURES:
  • Track your daily mood with beautiful visualizations
  • Build healthy habits with streak tracking
  • Write gratitude journal entries
  • Guided breathing & meditation timer
  • Weekly & monthly mood insights with charts
  • 100% offline - your data stays on your device
  • Clean Material Design 3 interface
  • Light & dark mode support

  🎯 WHY MINDFUL JOURNAL?
  Unlike other journal apps, Mindful Journal is designed to be simple, 
  private, and beautiful. No accounts, no cloud, no ads. Just you and 
  your thoughts, organized in a way that helps you grow.

  Your mental health matters. Start today. 💜
  ```
- [ ] Upload **App Icon**: `assets/icons/app_icon.png` (1024x1024)
- [ ] Upload **Feature Graphic**: `assets/icons/feature_graphic.png` (1024x500)
- [ ] Upload **Phone Screenshots** (minimum 2, recommended 4-8):
  - Take screenshots from the running app (Home, Mood, Habit, Journal, Stats pages)
  - Resolution: 16:9 or 9:16, JPG or PNG

### 5. Data Safety Section
- [ ] Answer the questionnaire:
  - **Does your app collect data?** → No (all data stored locally)
  - **Does your app share data?** → No
  - **Is all data encrypted in transit?** → N/A (no network)
  - **Committed to Google Play Families Policy?** → No

### 6. Privacy Policy URL
- [ ] **Option A**: Upload `PRIVACY_POLICY.md` to GitHub, use raw URL:
  ```
  https://raw.githubusercontent.com/madajabbar/mindful-journal/main/PRIVACY_POLICY.md
  ```
- [ ] **Option B** (better): Enable GitHub Pages on the repo, use:
  ```
  https://madajabbar.github.io/mindful-journal/privacy
  ```
- [ ] Paste URL in Play Console → **Privacy Policy** field

### 7. Content Rating
- [ ] Complete IARC questionnaire (should be rated **Everyone**)

### 8. Target Audience
- [ ] Select: **All ages** or **13+**

### 9. App Access
- [ ] Declare: "All functionality is available without any special access" (no login needed)

### 10. Ads Declaration
- [ ] Select: **No, my app does not contain ads**

### 11. Submit for Review
- [ ] Review all sections complete
- [ ] Click **Submit for review**
- [ ] Wait 3-7 days for approval

---

## 📦 Key Files

| File | Purpose |
|------|---------|
| `build/app/outputs/bundle/release/app-release.aab` | Upload to Play Store |
| `assets/icons/app_icon.png` | 1024x1024 store icon |
| `assets/icons/feature_graphic.png` | 1024x500 banner |
| `PRIVACY_POLICY.md` | Legal compliance |
| `TERMS_OF_SERVICE.md` | Terms of use |
| `android/keystores/mindful_journal_key.jks` | ⚠️ KEEP SAFE - signing key |
| `android/key.properties` | Keystore passwords |

---

## 🔑 Keystore Info (SAVE THIS!)

- **File**: `android/keystores/mindful_journal_key.jks`
- **Alias**: `mindful_journal`
- **Store Password**: `mindfuljournal2026`
- **Key Password**: `mindfuljournal2026`
- **Validity**: 10,000 days (~27 years)

⚠️ **BACK UP THE KEYSTORE!** If you lose it, you can't update the app on Play Store.

---

## Next Steps Summary

1. **Register** Play Console ($25)
2. **Create App** → Upload AAB
3. **Fill store listing** → Add screenshots, description, icons
4. **Complete Data Safety** → Answer "No data collected"
5. **Host Privacy Policy** → Paste URL
6. **Submit** → Wait for review

Good luck! 🚀
