# Mindful Journal - Mental Wellness App

<p align="center">
  <img src="assets/images/app_logo.png" width="200" alt="Mindful Journal Logo">
</p>

## 📱 About The App

**Mindful Journal** is an Android application designed to help users improve their mental wellness through daily journaling, mood tracking, and habit building. The app provides a safe, private space for self-reflection and emotional awareness.

### 🎯 Key Features
- **Daily Journaling**: Simple text editor for daily reflections
- **Mood Tracking**: Track emotions with visual calendar
- **Habit Builder**: Build healthy habits with streak tracking
- **AI Insights**: Get personalized wellness recommendations
- **Privacy Focus**: Your data stays secure and private

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android SDK (API 33+)
- Java JDK (17 or higher)

### Installation
1. Clone this repository
2. Navigate to project directory:
   ```bash
   cd mindful_journal
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Generate necessary files:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                    # Application entry point
├── core/
│   ├── constants/              # App constants and enums
│   ├── theme/                  # Theme data and styling
│   └── utils/                  # Utility functions and helpers
├── features/
│   ├── journal/               # Journaling feature module
│   ├── mood/                  # Mood tracking module
│   ├── habits/                # Habit building module
│   ├── insights/              # AI insights module
│   └── settings/             # App settings module
├── data/
│   ├── models/               # Data models and entities
│   ├── repositories/        # Data repositories
│   └── local/                # Local storage implementation
├── presentation/
│   ├── widgets/             # Reusable UI widgets
│   ├── screens/            # Screen layouts
│   └── providers/          # Riverpod providers
└── services/
    ├── ai_service.dart      # AI integration service
    └── notification_service.dart
```

## 🛠 Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Riverpod** - State management
- **GoRouter** - Navigation routing
- **Hive** - Local NoSQL database

### Optional Backend
- **Firebase** - Authentication & Database
- **Firestore** - Cloud data sync
- **Firebase Analytics** - Usage tracking

### AI Integration
- **Google ML Kit** - On-device sentiment analysis
- **OpenAI API** - Advanced text analysis (optional)

## 📊 Features Breakdown

### 1. Journaling Module
- Create, read, update, delete journal entries
- Rich text formatting options
- Tagging and categorization
- Search functionality

### 2. Mood Tracking Module
- 5-point mood scale with emojis
- Calendar view for mood history
- Mood patterns visualization
- Daily reminders

### 3. Habit Builder Module
- Create daily wellness habits
- Streak counter and statistics
- Achievement badges
- Custom reminders

### 4. Insights Module
- Mood pattern analysis
- Journal sentiment analysis
- Personalized recommendations
- Weekly wellness reports

## 🔧 Development Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Build APK for release
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release

# Analyze code
flutter analyze

# Format code
flutter format .

# Clean build
flutter clean
```

## 📱 Platform Support

### Android
- Minimum SDK: 23 (Android 6.0)
- Target SDK: 34 (Android 14)
- Recommended: Android 10+

### iOS (Future Release)
- Minimum: iOS 13.0
- Recommended: iOS mm16.0+

## 🎨 Design System

### Colors
```dart
primaryColor: #6C63FF    // Main purple
secondaryColor: #4ECDC4   // Teal accent
backgroundColor: #F8F9FA   // Light background
textColor: #2D3436       // Dark text
moodColors:              // Mood scale colors
  - 😢: #FF6B6B          // Sad
  - 😐: #FFD166          // Neutral  
  - 🙂: #06D6A0          // Happy
  - 😊: #4ECDC4          // Very Happy
  - 🥰: #6C63FF          // Excellent
```

### Typography
- **Primary Font**: Inter (Regular, Medium, SemiBold)
- **Sizes**: 12px, 14px, 16px, 20px, 24px
- **Line Height**: 1.5 for body, 1.2 for headings

## 🔒 Privacy & Security

- **Local Storage**: All data stored locally by default
- **Optional Sync**: Cloud sync only with user consent
- **Data Encryption**: Hive encryption for sensitive data
- **No Data Sharing**: No third-party data sharing

## 📈 Analytics

### Basic Analytics (Optional)
- Daily active users
- Feature usage statistics
- Retention rates
- Conversion metrics

## 🚀 Deployment

### Play Store Requirements
- **App Icon**: 1024x1024 PNG
- **Feature Graphic**: 1024x500 PNG
- **Screenshots**: Multiple device screenshots
- **Privacy Policy**: Required for data collection apps
- **Age Rating**: 12+ (Teen)

### Build Process
1. Update version in `pubspec.yaml`
2. Run `flutter build appbundle --release`
3. Test release build on device
4. Upload to Google Play Console
5. Submit for review

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for amazing framework
- Mental health advocates for inspiration
- Open source community for libraries

---

**Made with ❤️ for better mental health**