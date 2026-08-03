# Firebase Setup Guide - Mindful Journal

## Langkah-langkah Setup Firebase

### 1. Buat Firebase Project

1. Buka https://console.firebase.google.com
2. Klik **"Add project"**
3. Nama project: **Mindful Journal** (atau terserah)
4. Klik Continue → **Disable Google Analytics** (opsional, bisa enable nanti) → Continue
5. Tunggu project dibuat

### 2. Tambahkan Android App ke Firebase

1. Di Firebase Console, klik icon **Android** (⚙️ → Project Settings → Your Apps → Android)
2. **Android package name**: `com.madajabbar.mindfuljournal`
3. **App nickname**: Mindful Journal (opsional)
4. **SHA-1 certificate** (untuk Google Sign-In):
   ```
   keytool -list -v -keystore D:\Code\Flutter\AI\mindful_journal\android\keystores\mindful_journal_key.jks -alias mindful_journal
   ```
   Copy SHA-1 fingerprint → paste ke Firebase Console
5. Klik **"Register app"**

### 3. Download google-services.json

1. Firebase akan generate file **google-services.json**
2. **Download** file ini
3. Copy ke:
   ```
   D:\Code\Flutter\AI\mindful_journal\android\app\google-services.json
   ```

### 4. Enable Authentication

1. Firebase Console → **Authentication** → **Sign-in method**
2. **Google** → Enable → Pilih project email → Save
3. **Email/Password** → Enable → Save

### 5. Enable Firestore

1. Firebase Console → **Firestore Database** → **Create database**
2. Pilih **Start in production mode**
3. Pilih region: **asia-southeast1** (Singapore, paling dekat ke Indonesia)
4. Klik **Enable**

### 6. Setup Security Rules (Firestore)

Di Firestore → Rules tab, paste ini:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Hanya user yang login bisa akses data mereka sendiri
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Klik **Publish**

### 7. Setup SHA-1 untuk Release (Google Sign-In)

Untuk release build, perlu SHA-1 dari release keystore:

```bash
keytool -list -v -keystore android/keystores/mindful_journal_key.jks -alias mindful_journal -storepass mindfuljournal2026
```

Copy SHA-1 → Firebase Console → Project Settings → Add SHA-1

### 8. Rebuild APK

Setelah google-services.json sudah di tempatnya:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## Tanpa Firebase (Offline-Only)

App tetap jalan **tanpa google-services.json** — semua fitur offline (Hive) tetap berfungsi:
- ✅ Journal CRUD
- ✅ Mood tracking
- ✅ Habit builder
- ✅ Statistics
- ✅ Dark mode

Yang **tidak jalan** tanpa Firebase:
- ❌ Login / Google Sign-in
- ❌ Cloud sync
- ❌ Cross-device data

User bisa pilih **"Continue Offline"** di login screen untuk langsung pakai tanpa login.

---

## Keystroke Info

- **Keystore**: `android/keystores/mindful_journal_key.jks`
- **Alias**: `mindful_journal`
- **Password**: `mindfuljournal2026`
- **Package**: `com.madajabbar.mindfuljournal`

---

## Firestore Data Structure

```
/users/{uid}/
  /journal_entries/{entryId}
    - title, content, mood, tags[], isFavorite, createdAt, updatedAt
  /mood_entries/{entryId}
    - mood, date, note, factors[], intensity
  /habits/{habitId}
    - title, description, daysOfWeek[], reminderTime, streak, lastCompleted, isActive, createdAt
```

---

## Checklist

- [ ] Buat Firebase project
- [ ] Tambahkan Android app (package name + SHA-1)
- [ ] Download google-services.json → copy ke android/app/
- [ ] Enable Google Sign-In di Auth
- [ ] Enable Email/Password di Auth
- [ ] Buat Firestore database
- [ ] Set security rules
- [ ] Add release SHA-1
- [ ] Rebuild APK
- [ ] Test Google Sign-In di HP
- [ ] Test cloud sync
