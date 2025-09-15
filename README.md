# OSCAR Career Platform - Flutter Mobile App

A comprehensive Flutter mobile application for AI-powered career guidance and skill development.

## 🚀 Features

### Complete User Journey
- **Landing Page**: Compelling problem statement with statistics and call-to-action
- **Authentication**: Login/Register with social authentication options
- **Career Assessment**: Interactive quiz with career path selection (10th, 12th, NEET, JEE, Govt Jobs, SSC, Professional)
- **Dashboard**: Personalized roadmap with progress tracking and analytics
- **Resume Analysis**: ATS scoring with detailed feedback and skill gap analysis
- **Resource Recommendations**: Curated learning materials with filtering and progress tracking

### 🛠️ Technical Stack
- **Framework**: Flutter 3.9.2+
- **State Management**: Provider pattern
- **Navigation**: GoRouter for declarative routing
- **UI Components**: Material Design 3 with Google Fonts
- **Charts & Progress**: FL Chart, Percent Indicator
- **File Handling**: File Picker for resume uploads
- **HTTP Client**: Dio for API integration
- **Local Storage**: SharedPreferences

### 📱 Mobile-First Design
- Responsive layouts for all screen sizes
- Touch-friendly interfaces
- Material Design 3 components
- Smooth animations and transitions
- Accessibility support

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point with routing
├── providers/
│   └── app_provider.dart       # Global state management
└── screens/
    ├── landing_screen.dart     # Problem statement/landing
    ├── login_screen.dart       # Authentication
    ├── assessment_screen.dart  # Career assessment quiz
    ├── dashboard_screen.dart   # User dashboard
    ├── resume_analysis_screen.dart # ATS scoring
    └── resources_screen.dart   # Learning resources
```

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  go_router: ^14.2.7              # Navigation
  provider: ^6.1.2               # State Management
  flutter_svg: ^2.0.10+1         # SVG support
  google_fonts: ^6.2.1           # Typography
  http: ^1.2.2                   # HTTP requests
  dio: ^5.4.3+1                  # Advanced HTTP client
  file_picker: ^8.0.6            # File selection
  path_provider: ^2.1.4          # File paths
  shared_preferences: ^2.2.3     # Local storage
  fl_chart: ^0.68.0              # Charts
  percent_indicator: ^4.2.3      # Progress indicators
  lottie: ^3.1.2                 # Animations
  intl: ^0.19.0                  # Internationalization
```

## 🚀 Getting Started

### Prerequisites
1. **Install Flutter SDK**
   - Download from [Flutter Official Website](https://flutter.dev/docs/get-started/install)
   - Add Flutter to your PATH
   - Run `flutter doctor` to verify installation

2. **Install Development Environment**
   - **Android Studio** (for Android development)
   - **VS Code** with Flutter extension (recommended)
   - **Xcode** (for iOS development on macOS)

### Installation Steps

1. **Clone and Navigate**
   ```bash
   cd flutter_app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d chrome    # Web
   flutter run -d android   # Android
   flutter run -d ios       # iOS (macOS only)
   ```

4. **Build for Production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle
   flutter build appbundle --release
   
   # iOS (macOS only)
   flutter build ios --release
   
   # Web
   flutter build web --release
   ```

## 🎯 Key Features Implementation

### 🔐 Authentication System
- Email/password authentication with validation
- Social login integration (Google, LinkedIn)
- Form validation and error handling
- Remember me functionality
- Secure state management

### 📊 Career Assessment
- Multi-step career path selection
- Interactive questionnaire with progress tracking
- Skip functionality for optional questions
- Results storage in global state
- Smooth page transitions

### 📈 Dashboard Analytics
- Personalized welcome with user data
- Visual career roadmap with timeline
- Skill development progress indicators
- Achievement tracking and quick stats
- Interactive progress visualizations

### 📄 Resume Analysis
- File picker for PDF/DOC uploads
- Target job/company specification
- Mock ATS compatibility scoring (0-100%)
- Detailed breakdown by categories
- Skill gap identification with recommendations
- Visual progress indicators

### 📚 Learning Resources
- Categorized resource library (Courses, Books, Videos, Certifications, Communities)
- Advanced filtering and search functionality
- Bookmark and progress tracking
- Rating and review system
- Platform integration links
- Tabbed interface for organization

## 🎨 UI/UX Features

### Design System
- **Material Design 3** components
- **Google Fonts (Poppins)** for typography
- **Consistent color scheme** with primary blue theme
- **Rounded corners** and modern card layouts
- **Smooth animations** and transitions

### Responsive Design
- Adaptive layouts for different screen sizes
- Touch-friendly button sizes and spacing
- Optimized for mobile-first experience
- Tablet and desktop support

### Accessibility
- Semantic widget structure
- Proper contrast ratios
- Touch target sizes (minimum 44px)
- Screen reader support
- Keyboard navigation support

## 🔧 State Management

The app uses Provider pattern with a comprehensive state structure:

```dart
class AppProvider extends ChangeNotifier {
  // User authentication and profile
  User? user;
  bool isAuthenticated;
  
  // Assessment data and progress
  AssessmentData assessmentData;
  
  // Resume analysis results
  ResumeAnalysis resumeAnalysis;
  
  // Resource tracking
  List<String> bookmarkedResources;
  List<String> inProgressResources;
  List<String> completedResources;
  
  // UI state
  bool isLoading;
  String? error;
}
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11.0+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🚀 Deployment

### Android
1. Configure signing in `android/app/build.gradle`
2. Build release APK: `flutter build apk --release`
3. Upload to Google Play Store

### iOS
1. Configure signing in Xcode
2. Build for release: `flutter build ios --release`
3. Archive and upload to App Store Connect

### Web
1. Build for web: `flutter build web --release`
2. Deploy `build/web` folder to hosting service

## 🔮 Future Enhancements

- **Push Notifications** for learning reminders
- **Offline Support** with local database
- **Dark Mode** theme support
- **Multi-language** internationalization
- **AI Chatbot** integration
- **Social Features** for peer interaction
- **Advanced Analytics** with detailed insights
- **Integration** with job portals and learning platforms

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- 📧 Email: support@oscarcareer.com
- 💬 Discord: [OSCAR Community](https://discord.gg/oscar)
- 📖 Documentation: [docs.oscarcareer.com](https://docs.oscarcareer.com)

---

**Built with ❤️ for Smart India Hackathon 2024**

*Empowering careers through AI-driven guidance and personalized learning paths.*
