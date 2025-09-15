# 🎯 OSCAR Career Platform

> **AI-Powered Career Guidance Platform for Smart India Hackathon 2024**

A comprehensive career guidance platform that helps students and professionals make informed career decisions through AI-powered assessments, resume analysis, and personalized learning paths.

## 🌟 Features

### 🎯 **Core Functionalities**
- **Interactive Career Assessment** - 7 specialized career paths (10th, 12th, NEET, JEE, Govt Jobs, SSC, Professional)
- **ATS Resume Analysis** - AI-powered resume scoring with detailed feedback
- **Personalized Dashboard** - Custom roadmaps and progress tracking
- **Curated Resources** - Filtered learning materials with bookmark functionality
- **Progress Analytics** - Visual charts for skill development tracking

### 📱 **Cross-Platform Support**
- **Flutter Mobile App** - Native iOS/Android experience
- **React.js Web App** - Responsive web application
- **PWA Support** - Progressive Web App capabilities

## 🚀 Quick Start

### Prerequisites
- **Flutter SDK** 3.9.2+ (for mobile app)
- **Node.js** 16+ (for web app)
- **Git** for version control

### 📱 Flutter Mobile App (Recommended)

```bash
# Clone the repository
git clone <repository-url>
cd oscar-career-platform

# Navigate to Flutter app
cd flutter_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 🌐 React.js Web App

```bash
# Navigate to React app
cd oscar-frontend

# Install dependencies
npm install

# Start development server
npm start
```

## 📁 Project Structure

```
oscar-career-platform/
├── 📱 flutter_app/                 # Mobile Application
│   ├── lib/
│   │   ├── main.dart              # App entry point
│   │   ├── providers/             # State management
│   │   │   └── app_provider.dart
│   │   └── screens/               # UI screens
│   │       ├── landing_screen.dart
│   │       ├── login_screen.dart
│   │       ├── assessment_screen.dart
│   │       ├── dashboard_screen.dart
│   │       ├── resume_analysis_screen.dart
│   │       └── resources_screen.dart
│   ├── pubspec.yaml               # Flutter dependencies
│   └── README.md                  # Flutter setup guide
│
├── 🌐 oscar-frontend/             # Web Application
│   ├── src/
│   │   ├── components/            # Reusable UI components
│   │   ├── context/               # React Context API
│   │   ├── pages/                 # Application pages
│   │   │   ├── LandingPage.js
│   │   │   ├── LoginPage.js
│   │   │   ├── AssessmentPage.js
│   │   │   ├── DashboardPage.js
│   │   │   ├── ResumeAnalysisPage.js
│   │   │   └── ResourcesPage.js
│   │   └── App.js                 # Main React component
│   ├── package.json               # Node.js dependencies
│   └── README.md                  # React setup guide
│
├── 📚 docs/                       # Documentation
│   ├── API.md                     # API documentation
│   ├── DEPLOYMENT.md              # Deployment guide
│   └── ARCHITECTURE.md            # Technical architecture
│
├── 🔧 scripts/                    # Build and deployment scripts
│   ├── build-flutter.sh
│   ├── build-react.sh
│   └── deploy.sh
│
├── README.md                      # Main project documentation
├── LICENSE                        # Project license
├── CONTRIBUTING.md                # Contribution guidelines
├── .gitignore                     # Git ignore rules
└── OSCAR_PROJECT_SUMMARY.md       # Detailed project summary
```

## 🛠️ Technology Stack

### Flutter Mobile App
| Component | Technology |
|-----------|------------|
| **Framework** | Flutter 3.9.2+ |
| **Language** | Dart |
| **State Management** | Provider Pattern |
| **Navigation** | GoRouter |
| **UI Design** | Material Design 3 |
| **HTTP Client** | Dio |
| **Local Storage** | SharedPreferences |

### React.js Web App
| Component | Technology |
|-----------|------------|
| **Framework** | React 18.2.0 |
| **Language** | JavaScript |
| **State Management** | Context API |
| **Routing** | React Router DOM 6.8.1 |
| **UI Library** | Mantine 7.3.2 |
| **HTTP Client** | Axios |
| **Icons** | Tabler Icons |

## 🎯 Target Audience

- **🎓 Students** - 10th & 12th grade career guidance
- **📚 Exam Aspirants** - NEET, JEE, competitive exam preparation
- **💼 Job Seekers** - Government jobs, SSC, private sector
- **🚀 Professionals** - Career advancement and upskilling

## 🌟 Key Achievements

- ✅ **100% Feature Completion** - All planned functionalities implemented
- ✅ **Cross-Platform Ready** - Mobile and web versions available
- ✅ **Production Quality** - Error handling, validation, accessibility
- ✅ **Modern Architecture** - Clean, scalable code structure
- ✅ **Comprehensive Testing** - Ready for deployment

## 🚀 Deployment

### Flutter Mobile App
```bash
# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release

# Build for Web
flutter build web
```

### React.js Web App
```bash
# Build for production
npm run build

# Deploy to Netlify/Vercel
npm run deploy
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏆 Smart India Hackathon 2024

This project was developed for **Smart India Hackathon 2024** to address the critical problem of career guidance and skill development in India.

### Problem Statement
- **Career Confusion** among students and professionals
- **Lack of personalized guidance** in career planning
- **Skill gap identification** and development
- **Resource accessibility** for continuous learning

### Our Solution
A comprehensive AI-powered platform that provides:
- Personalized career assessments
- ATS-optimized resume analysis
- Curated learning resources
- Progress tracking and analytics

## 📞 Support

For support, email us at [support@oscar-platform.com](mailto:support@oscar-platform.com) or create an issue in this repository.

## 🙏 Acknowledgments

- **Smart India Hackathon 2024** for the opportunity
- **Flutter Team** for the amazing framework
- **React Community** for continuous innovation
- **Open Source Contributors** for their valuable libraries

---

**Built with ❤️ for empowering careers through technology**

⭐ **Star this repository if you found it helpful!**
