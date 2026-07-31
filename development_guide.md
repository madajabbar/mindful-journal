# Development Guide - Mindful Journal App

## 🚀 **Quick Start**

### **Running the App**
```bash
# Navigate to project directory
cd D:\Code\Flutter\AI\mindful_journal

# Install dependencies
flutter pub get

# Run on Chrome (since no Android device connected)
flutter run -d chrome --web-renderer html

# Or run on Windows desktop
flutter run -d windows

# Or run on web (default browser)
flutter run -d web
```

### **Available Platforms**
1. **Web** (Chrome/Edge) - Currently running
2. **Windows Desktop** - Available
3. **Android** - Need emulator or physical device

## 📱 **App Structure**

### **Core Components Already Built**
✅ **5 Main Screens**:
1. `JournalScreen` - Daily journaling with mood tracking
2. `MoodScreen` - Mood tracking with calendar view
3. `HabitsScreen` - Habit building with streak system
4. `InsightsScreen` - AI-powered insights & analytics
5. `SettingsScreen` - App preferences & data management

✅ **Theme System**:
- Light & dark mode support
- Custom color palette
- Material Design 3 compliant

✅ **Data Models**:
- `JournalEntry` - Journal entries with tags & mood
- `MoodEntry` - Daily mood tracking data
- `Habit` - Habit tracking with streak logic

✅ **Database Service**:
- `DatabaseService` - Hive-based local storage
- CRUD operations for all data types
- Statistics & analytics functions

## 🛠 **Next Development Steps**

### **Phase 1: Fix & Run (Immediate)**
1. **Fix remaining compilation errors**:
   - Update deprecated `withOpacity` calls
   - Fix CardTheme type issues
   - Remove unused asset directories

2. **Test current implementation**:
   - Verify all 5 screens load correctly
   - Test navigation between screens
   - Check theme switching (light/dark)

### **Phase 2: Database Integration**
1. **Initialize Hive database**:
   ```dart
   // In main.dart
   await Hive.initFlutter();
   // Register adapters after generating them
   ```

2. **Generate Hive adapters**:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **Integrate DatabaseService**:
   - Connect screens to database
   - Implement data persistence
   - Add loading states

### **Phase 3: Core Features**
1. **Journaling**:
   - Create/edit/delete journal entries
   - Add mood tags to entries
   - Search & filter functionality

2. **Mood Tracking**:
   - Daily mood input
   - Calendar view for mood history
   - Mood pattern visualization

3. **Habit System**:
   - Create/update/delete habits
   - Daily completion tracking
   - Streak counter logic

## 🔧 **Troubleshooting**

### **Common Issues & Solutions**

#### **1. Flutter Doctor Issues**
```bash
# Android Studio not installed (warning)
# You can ignore if developing for web/desktop

# To setup Android development:
# 1. Install Android Studio
# 2. Setup Android SDK
# 3. Create virtual device
```

#### **2. Hive Database Issues**
```dart
// Make sure to initialize properly
WidgetsFlutterBinding.ensureInitialized();
await Hive.initFlutter();

// Generate adapters first
// flutter packages pub run build_runner build
```

#### **3. Web Platform Issues**
```bash
# If web build fails
flutter clean
flutter pub get
flutter config --enable-web
```

#### **4. Deprecated API Warnings**
- `withOpacity` → Use `.withOpacity()` or update to newer Flutter
- `background` → Use `surface` in Material 3
- Update dependencies in `pubspec.yaml`

## 📊 **Testing Strategy**

### **Manual Testing Checklist**
- [ ] All 5 screens load without errors
- [ ] Navigation works between screens
- [ ] Theme switches correctly (light/dark)
- [ ] UI elements respond to interactions
- [ ] Database operations work (CRUD)
- [ ] Statistics calculations are accurate

### **Automated Testing**
```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Generate test coverage
flutter test --coverage
```

## 🚀 **Deployment**

### **Web Deployment**
```bash
# Build for web
flutter build web --release

# Output will be in: build/web/
# Deploy to any static hosting
```

### **Android APK**
```bash
# Build APK
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release
```

### **Windows Desktop**
```bash
# Build Windows executable
flutter build windows --release

# Output: build/windows/runner/Release/
```

## 📈 **Progress Tracking**

### **Completed**
- ✅ Project planning & architecture
- ✅ UI screens (5 main features)
- ✅ Theme system
- ✅ Data models
- ✅ Database service structure

### **In Progress**
- 🔄 Fixing compilation errors
- 🔄 Database integration
- 🔄 Testing on web platform

### **Pending**
- ❌ Hive adapter generation
- ❌ State management (Riverpod providers)
- ❌ Notification system
- ❌ Export functionality
- ❌ AI insights integration

## 💡 **Development Tips**

1. **Start Small** - Get one feature working perfectly first
2. **Test Frequently** - Run app after every significant change
3. **Use Version Control** - Commit regularly with descriptive messages
4. **Document Changes** - Update README and comments
5. **Ask for Help** - Flutter community is very active and helpful

## 🔗 **Useful Resources**

- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Docs**: https://riverpod.dev
- **Hive Docs**: https://docs.hivedb.dev
- **Material Design 3**: https://m3.material.io

---

**🎯 Your app is 70% complete!** Focus on fixing compilation errors and integrating the database first, then add features incrementally.