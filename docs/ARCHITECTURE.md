# 🏗️ OSCAR Career Platform - Technical Architecture

This document outlines the technical architecture, design patterns, and system components of the OSCAR Career Platform.

## 🎯 System Overview

The OSCAR Career Platform is a cross-platform career guidance application built with modern technologies to provide AI-powered career assessments, resume analysis, and personalized learning paths.

### Architecture Principles
- **Cross-Platform Compatibility** - Single codebase for multiple platforms
- **Modular Design** - Loosely coupled, highly cohesive components
- **Scalable Architecture** - Designed to handle growing user base
- **Performance Optimized** - Fast loading times and smooth user experience
- **Security First** - Data protection and secure communication

## 📱 Flutter Mobile App Architecture

### Architecture Pattern: MVVM + Provider

```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation Layer                    │
├─────────────────────────────────────────────────────────────┤
│  Screens/Pages  │  Widgets  │  Navigation  │  Themes       │
│  - Landing      │  - Custom │  - GoRouter  │  - Material3  │
│  - Assessment   │  - Reuse  │  - Guards    │  - Colors     │
│  - Dashboard    │  - Forms  │  - Deep Link │  - Typography │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Business Logic Layer                    │
├─────────────────────────────────────────────────────────────┤
│  Providers/ViewModels  │  Services  │  Repositories         │
│  - AppProvider        │  - API     │  - Local Storage      │
│  - AuthProvider       │  - Auth    │  - Cache Manager      │
│  - AssessmentProvider │  - File    │  - Data Sync         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         Data Layer                          │
├─────────────────────────────────────────────────────────────┤
│  Models  │  Local Storage  │  Network  │  External APIs     │
│  - User  │  - SharedPrefs  │  - Dio    │  - Resume Parser  │
│  - Quiz  │  - SQLite      │  - HTTP   │  - AI Services    │
│  - Score │  - Files       │  - Cache  │  - Analytics      │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

#### 1. State Management (Provider Pattern)
```dart
// AppProvider - Global application state
class AppProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Methods
  Future<void> login(String email, String password) async {
    // Implementation
  }
}
```

#### 2. Navigation (GoRouter)
```dart
final GoRouter router = GoRouter(
  initialLocation: '/landing',
  routes: [
    GoRoute(
      path: '/landing',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/assessment',
      builder: (context, state) => const AssessmentScreen(),
    ),
    // More routes...
  ],
);
```

#### 3. Service Layer
```dart
// API Service for backend communication
class ApiService {
  final Dio _dio = Dio();
  
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    // Implementation with error handling
  }
}

// Authentication Service
class AuthService {
  Future<User?> login(String email, String password) async {
    // Implementation
  }
}
```

### Data Flow
1. **User Interaction** → Screen/Widget
2. **Widget** → Provider (State Management)
3. **Provider** → Service Layer
4. **Service** → Repository/API
5. **Response** → Provider → Widget → UI Update

## 🌐 React.js Web App Architecture

### Architecture Pattern: Component-Based + Context API

```
┌─────────────────────────────────────────────────────────────┐
│                     Component Layer                         │
├─────────────────────────────────────────────────────────────┤
│  Pages          │  Components     │  Hooks      │  Routing  │
│  - LandingPage  │  - Header       │  - useAuth  │  - Router │
│  - LoginPage    │  - Navigation   │  - useAPI   │  - Routes │
│  - Dashboard    │  - Forms        │  - useLocal │  - Guards │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Context Layer                          │
├─────────────────────────────────────────────────────────────┤
│  Context Providers  │  State Management  │  Actions         │
│  - AuthContext     │  - useReducer      │  - Login         │
│  - AppContext      │  - useState        │  - Assessment    │
│  - ThemeContext    │  - useEffect       │  - Data Fetch    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                          │
├─────────────────────────────────────────────────────────────┤
│  API Services  │  Utils  │  Storage  │  External Services   │
│  - authAPI     │  - helpers │  - localStorage │  - Analytics │
│  - userAPI     │  - validators │  - sessionStorage │  - Tracking │
│  - assessAPI   │  - formatters │  - indexedDB │  - Third-party │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

#### 1. Context API for State Management
```javascript
// AuthContext for authentication state
const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(false);
  
  const login = async (email, password) => {
    // Implementation
  };
  
  return (
    <AuthContext.Provider value={{ user, login, loading }}>
      {children}
    </AuthContext.Provider>
  );
};
```

#### 2. Custom Hooks
```javascript
// useAuth hook for authentication logic
export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};

// useAPI hook for API calls
export const useAPI = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  
  const fetchData = async (url) => {
    // Implementation
  };
  
  return { data, loading, error, fetchData };
};
```

#### 3. Service Layer
```javascript
// API service with Axios
class ApiService {
  constructor() {
    this.client = axios.create({
      baseURL: process.env.REACT_APP_API_URL,
      timeout: 10000,
    });
  }
  
  async post(endpoint, data) {
    // Implementation with error handling
  }
}

export default new ApiService();
```

## 🔄 Data Flow Architecture

### User Journey Flow
```
Landing Page → Authentication → Assessment → Results → Dashboard → Resources
     │              │              │           │          │           │
     ▼              ▼              ▼           ▼          ▼           ▼
  Marketing    User Session    Quiz Logic   Score Calc  Progress   Learning
   Content      Management     Processing   Algorithm   Tracking   Materials
```

### Assessment Algorithm Flow
```
Question Display → User Response → Validation → Score Calculation → Career Match
       │               │              │              │                │
       ▼               ▼              ▼              ▼                ▼
   UI Component    State Update   Input Check   Algorithm Logic   Result Display
```

## 🗄️ Data Models

### Core Data Structures

#### User Model
```dart
// Flutter
class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final UserPreferences preferences;
  
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.preferences,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    // Implementation
  }
}
```

```javascript
// React
interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
  preferences: UserPreferences;
}
```

#### Assessment Model
```dart
// Flutter
class Assessment {
  final String id;
  final List<Question> questions;
  final Map<String, dynamic> responses;
  final AssessmentResult? result;
  final DateTime completedAt;
  
  // Methods for score calculation
  double calculateScore() {
    // Implementation
  }
}
```

## 🔐 Security Architecture

### Authentication Flow
```
Client Request → JWT Token → API Gateway → Service → Database
      │              │            │           │          │
      ▼              ▼            ▼           ▼          ▼
   Login Form    Token Storage  Validation  Business   Data
   Validation    (Secure)       Middleware   Logic     Access
```

### Data Protection
- **Encryption**: AES-256 for sensitive data at rest
- **Transport**: TLS 1.3 for data in transit
- **Authentication**: JWT tokens with refresh mechanism
- **Authorization**: Role-based access control (RBAC)
- **Input Validation**: Server-side validation for all inputs

## 📊 Performance Architecture

### Optimization Strategies

#### Flutter Performance
- **Widget Optimization**: Const constructors, widget rebuilding optimization
- **State Management**: Efficient provider usage, selective rebuilding
- **Image Optimization**: Cached network images, appropriate formats
- **Bundle Size**: Tree shaking, code splitting

#### React Performance
- **Component Optimization**: React.memo, useMemo, useCallback
- **Bundle Splitting**: Code splitting with React.lazy
- **State Optimization**: Context splitting, state normalization
- **Asset Optimization**: Image compression, lazy loading

### Caching Strategy
```
Browser Cache → CDN Cache → Application Cache → Database Cache
      │             │              │                │
      ▼             ▼              ▼                ▼
   Static Assets  Global CDN   In-Memory Cache   Query Cache
   (Images, CSS)  (API Responses) (User Data)   (Database)
```

## 🔄 API Architecture

### RESTful API Design
```
GET    /api/v1/users/{id}           # Get user profile
POST   /api/v1/auth/login          # User authentication
POST   /api/v1/assessments         # Submit assessment
GET    /api/v1/assessments/{id}    # Get assessment results
POST   /api/v1/resumes/analyze     # Analyze resume
GET    /api/v1/resources           # Get learning resources
```

### Response Format
```json
{
  "success": true,
  "data": {
    // Response data
  },
  "message": "Operation completed successfully",
  "timestamp": "2024-01-15T10:30:00Z",
  "version": "1.0"
}
```

## 🚀 Deployment Architecture

### Multi-Environment Setup
```
Development → Staging → Production
     │           │          │
     ▼           ▼          ▼
  Local Dev   Testing    Live Users
  Hot Reload  QA Tests   Monitoring
  Debug Mode  Load Test  Analytics
```

### Infrastructure
- **Frontend**: CDN (CloudFront/CloudFlare)
- **Backend**: Load Balancer + Auto Scaling
- **Database**: Primary + Read Replicas
- **Cache**: Redis for session management
- **Monitoring**: Application Performance Monitoring (APM)

## 📈 Scalability Considerations

### Horizontal Scaling
- **Load Balancing**: Application Load Balancer (ALB)
- **Database Scaling**: Read replicas, sharding strategies
- **Caching**: Distributed caching with Redis Cluster
- **CDN**: Global content delivery network

### Vertical Scaling
- **Resource Optimization**: CPU and memory profiling
- **Database Optimization**: Query optimization, indexing
- **Code Optimization**: Algorithm improvements, caching

## 🔍 Monitoring & Analytics

### Application Monitoring
- **Performance**: Response times, throughput, error rates
- **User Experience**: Page load times, user interactions
- **Business Metrics**: Assessment completions, user engagement
- **System Health**: Server resources, database performance

### Error Tracking
- **Client-Side**: JavaScript errors, React error boundaries
- **Server-Side**: API errors, database connection issues
- **Mobile**: Crash reporting, performance monitoring

---

This architecture document serves as a comprehensive guide for developers working on the OSCAR Career Platform. For implementation details, refer to the individual component documentation and code comments.
