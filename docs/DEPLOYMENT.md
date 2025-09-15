# 🚀 Deployment Guide

This guide covers deployment options for both the Flutter mobile app and React.js web application of the OSCAR Career Platform.

## 📱 Flutter Mobile App Deployment

### Android Deployment

#### Prerequisites
- Android Studio with SDK tools
- Java Development Kit (JDK) 8 or higher
- Signed APK keystore (for production)

#### Development Build
```bash
cd flutter_app
flutter build apk --debug
```

#### Production Build
```bash
# Create keystore (first time only)
keytool -genkey -v -keystore ~/oscar-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias oscar

# Build signed APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### Google Play Store
1. Create a Google Play Console account
2. Upload the signed App Bundle
3. Complete store listing with screenshots and descriptions
4. Submit for review

### iOS Deployment

#### Prerequisites
- macOS with Xcode
- Apple Developer Account
- iOS Distribution Certificate

#### Production Build
```bash
cd flutter_app
flutter build ios --release
```

#### App Store Connect
1. Open `ios/Runner.xcworkspace` in Xcode
2. Archive the project
3. Upload to App Store Connect
4. Complete app metadata and submit for review

### Web Deployment

#### Build for Web
```bash
cd flutter_app
flutter build web --release
```

#### Deploy to Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize Firebase
firebase init hosting

# Deploy
firebase deploy
```

#### Deploy to Netlify
```bash
# Build the web app
flutter build web

# Deploy build/web folder to Netlify
# Or use Netlify CLI:
npm install -g netlify-cli
netlify deploy --prod --dir=build/web
```

## 🌐 React.js Web App Deployment

### Build for Production
```bash
cd oscar-frontend
npm run build
```

### Netlify Deployment

#### Method 1: Drag and Drop
1. Run `npm run build`
2. Drag the `build` folder to Netlify dashboard

#### Method 2: Git Integration
1. Connect your GitHub repository to Netlify
2. Set build command: `npm run build`
3. Set publish directory: `build`
4. Deploy automatically on git push

#### Method 3: Netlify CLI
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login to Netlify
netlify login

# Deploy
netlify deploy --prod --dir=build
```

### Vercel Deployment

#### Method 1: Vercel CLI
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod
```

#### Method 2: Git Integration
1. Connect GitHub repository to Vercel
2. Automatic deployments on git push
3. Preview deployments for pull requests

### AWS S3 + CloudFront

#### Setup S3 Bucket
```bash
# Create S3 bucket
aws s3 mb s3://oscar-career-platform

# Upload build files
aws s3 sync build/ s3://oscar-career-platform --delete

# Configure bucket for static website hosting
aws s3 website s3://oscar-career-platform --index-document index.html
```

#### Setup CloudFront Distribution
1. Create CloudFront distribution
2. Set S3 bucket as origin
3. Configure custom error pages for SPA routing
4. Set up custom domain and SSL certificate

### Docker Deployment

#### Dockerfile for React App
```dockerfile
# Build stage
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### Build and Deploy
```bash
# Build Docker image
docker build -t oscar-frontend .

# Run locally
docker run -p 80:80 oscar-frontend

# Deploy to cloud (AWS ECS, Google Cloud Run, etc.)
```

## 🔧 Environment Configuration

### Environment Variables

#### Flutter App
Create `lib/config/environment.dart`:
```dart
class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.oscar-platform.com',
  );
  
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
}
```

#### React App
Create `.env.production`:
```env
REACT_APP_API_URL=https://api.oscar-platform.com
REACT_APP_ENVIRONMENT=production
REACT_APP_ANALYTICS_ID=your-analytics-id
```

### CI/CD Pipeline

#### GitHub Actions for Flutter
```yaml
name: Flutter CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.9.2'
    
    - name: Install dependencies
      run: flutter pub get
      working-directory: flutter_app
    
    - name: Run tests
      run: flutter test
      working-directory: flutter_app
    
    - name: Build APK
      run: flutter build apk --release
      working-directory: flutter_app
```

#### GitHub Actions for React
```yaml
name: React CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
        cache-dependency-path: oscar-frontend/package-lock.json
    
    - name: Install dependencies
      run: npm ci
      working-directory: oscar-frontend
    
    - name: Run tests
      run: npm test
      working-directory: oscar-frontend
    
    - name: Build
      run: npm run build
      working-directory: oscar-frontend
    
    - name: Deploy to Netlify
      uses: nwtgck/actions-netlify@v2.0
      with:
        publish-dir: './oscar-frontend/build'
        production-branch: main
      env:
        NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
        NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

## 📊 Monitoring and Analytics

### Performance Monitoring
- **Flutter**: Firebase Performance Monitoring
- **React**: Web Vitals, Lighthouse CI
- **Backend**: Application Performance Monitoring (APM)

### Error Tracking
- **Flutter**: Firebase Crashlytics
- **React**: Sentry, Bugsnag
- **Logs**: Centralized logging with ELK stack

### Analytics
- **Google Analytics**: User behavior tracking
- **Firebase Analytics**: Mobile app analytics
- **Custom Events**: Career assessment completions, resume uploads

## 🔒 Security Considerations

### HTTPS/SSL
- Always use HTTPS in production
- Configure SSL certificates properly
- Use HTTP Strict Transport Security (HSTS)

### API Security
- Implement proper authentication (JWT tokens)
- Use API rate limiting
- Validate all inputs server-side
- Implement CORS properly

### Data Protection
- Encrypt sensitive data at rest
- Use secure communication protocols
- Implement proper session management
- Regular security audits

## 🚨 Troubleshooting

### Common Flutter Issues
```bash
# Clear build cache
flutter clean && flutter pub get

# Fix iOS build issues
cd ios && pod install && cd ..

# Android signing issues
flutter build apk --debug --verbose
```

### Common React Issues
```bash
# Clear npm cache
npm cache clean --force

# Fix dependency issues
rm -rf node_modules package-lock.json
npm install

# Build issues
npm run build -- --verbose
```

## 📈 Scaling Considerations

### CDN Setup
- Use CloudFront, CloudFlare, or similar
- Configure proper caching headers
- Optimize images and assets

### Database Scaling
- Implement database indexing
- Use connection pooling
- Consider read replicas for scaling

### Load Balancing
- Use Application Load Balancer (ALB)
- Implement health checks
- Auto-scaling groups for high availability

---

For additional support with deployment, please refer to the [Contributing Guide](../CONTRIBUTING.md) or create an issue in the repository.
