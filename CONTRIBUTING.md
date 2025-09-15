# Contributing to OSCAR Career Platform

Thank you for your interest in contributing to the OSCAR Career Platform! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### 1. Fork the Repository
- Fork the project on GitHub
- Clone your fork locally
- Add the original repository as upstream

```bash
git clone https://github.com/your-username/oscar-career-platform.git
cd oscar-career-platform
git remote add upstream https://github.com/original-owner/oscar-career-platform.git
```

### 2. Create a Branch
Create a new branch for your feature or bug fix:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b bugfix/issue-description
```

### 3. Make Your Changes
- Follow the coding standards outlined below
- Write clear, concise commit messages
- Add tests for new functionality
- Update documentation as needed

### 4. Test Your Changes
- **Flutter App**: Run `flutter test` and ensure all tests pass
- **React App**: Run `npm test` and verify functionality
- Test on multiple devices/browsers if applicable

### 5. Submit a Pull Request
- Push your changes to your fork
- Create a pull request with a clear description
- Link any relevant issues

## 🛠️ Development Setup

### Flutter Development
```bash
cd flutter_app
flutter pub get
flutter analyze
flutter test
flutter run
```

### React Development
```bash
cd oscar-frontend
npm install
npm run lint
npm test
npm start
```

## 📋 Coding Standards

### Flutter/Dart Guidelines
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Format code with `dart format`
- Use meaningful variable and function names
- Add documentation comments for public APIs

```dart
/// Calculates the career compatibility score based on user responses.
/// 
/// Returns a [double] between 0.0 and 1.0 representing compatibility.
double calculateCompatibilityScore(List<Answer> answers) {
  // Implementation
}
```

### React/JavaScript Guidelines
- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use ESLint and Prettier for code formatting
- Use functional components with hooks
- Implement proper error boundaries
- Use TypeScript for type safety (if migrating)

```javascript
/**
 * Calculates the ATS score for a resume
 * @param {Object} resumeData - The parsed resume data
 * @returns {number} Score between 0-100
 */
const calculateATSScore = (resumeData) => {
  // Implementation
};
```

### General Guidelines
- **Commit Messages**: Use conventional commits format
  ```
  feat: add career assessment algorithm
  fix: resolve navigation issue on mobile
  docs: update API documentation
  test: add unit tests for resume parser
  ```

- **File Naming**: Use consistent naming conventions
  - Flutter: `snake_case` for files, `PascalCase` for classes
  - React: `PascalCase` for components, `camelCase` for utilities

- **Documentation**: Update relevant documentation for any changes
- **Testing**: Maintain or improve test coverage
- **Performance**: Consider performance implications of changes

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Environment Information**
   - OS and version
   - Flutter/Node.js version
   - Device/browser information

2. **Steps to Reproduce**
   - Clear, numbered steps
   - Expected vs actual behavior
   - Screenshots/videos if applicable

3. **Additional Context**
   - Error messages or logs
   - Related issues or PRs
   - Possible solutions you've tried

## 💡 Feature Requests

For new features:

1. **Check Existing Issues** - Avoid duplicates
2. **Provide Context** - Explain the problem you're solving
3. **Describe the Solution** - Detail your proposed approach
4. **Consider Alternatives** - Mention other solutions considered
5. **Additional Context** - Screenshots, mockups, or examples

## 🔍 Code Review Process

### For Contributors
- Ensure your PR has a clear description
- Link related issues using keywords (fixes #123)
- Respond promptly to review feedback
- Keep PRs focused and reasonably sized

### For Reviewers
- Be constructive and respectful
- Focus on code quality, not personal preferences
- Test the changes locally when possible
- Approve when satisfied with the implementation

## 📚 Project Structure

### Flutter App Structure
```
flutter_app/
├── lib/
│   ├── main.dart              # App entry point
│   ├── providers/             # State management
│   ├── screens/               # UI screens
│   ├── widgets/               # Reusable widgets
│   ├── models/                # Data models
│   ├── services/              # API and business logic
│   └── utils/                 # Helper functions
├── test/                      # Unit and widget tests
└── integration_test/          # Integration tests
```

### React App Structure
```
oscar-frontend/
├── src/
│   ├── components/            # Reusable UI components
│   ├── pages/                 # Page components
│   ├── context/               # React Context providers
│   ├── hooks/                 # Custom React hooks
│   ├── services/              # API services
│   ├── utils/                 # Helper functions
│   └── styles/                # CSS/styling files
├── public/                    # Static assets
└── tests/                     # Test files
```

## 🚀 Release Process

1. **Version Bumping**: Follow semantic versioning (SemVer)
2. **Changelog**: Update CHANGELOG.md with new features and fixes
3. **Testing**: Ensure all tests pass and manual testing is complete
4. **Documentation**: Update relevant documentation
5. **Release Notes**: Create comprehensive release notes

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For questions and general discussion
- **Email**: [developers@oscar-platform.com](mailto:developers@oscar-platform.com)

## 🏆 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- Annual contributor appreciation posts

## 📄 License

By contributing to OSCAR Career Platform, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to OSCAR Career Platform! Together, we're building a platform that empowers careers through technology. 🚀
