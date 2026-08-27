# Contributing to RouteShare

Thank you for your interest in contributing to RouteShare! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

1. Getting Started
2. Development Setup
3. Code Style Guidelines
4. Pull Request Process
5. Issue Reporting
6. Community Guidelines

---

## 1. Getting Started

### Prerequisites
- Git installed on your system
- Node.js (v18 or higher) for backend development
- Flutter SDK (v3.0 or higher) for mobile development
- Code editor (VS Code, Android Studio, etc.)

### Fork and Clone
1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/RouteShare-Carpooling-System.git
   cd RouteShare-Carpooling-System
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/lucifers-0666/RouteShare-Carpooling-System.git
   ```

---

## 2. Development Setup

### Backend Setup
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

### Frontend Setup
```bash
cd frontend
flutter pub get
flutter run
```

---

## 3. Code Style Guidelines

### General Guidelines
- Write clean, readable, and maintainable code
- Follow DRY (Don't Repeat Yourself) principles
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Backend (Node.js)
- Use ES6+ syntax
- Follow async/await patterns
- Use proper error handling
- Follow Express.js best practices
- Add JSDoc comments for functions

### Frontend (Flutter)
- Follow Dart style guide
- Use const constructors where possible
- Implement proper widget structure
- Use Provider/Riverpod for state management
- Add comments for complex widgets

### Commit Messages
- Use clear and descriptive commit messages
- Follow conventional commits format:
  ```
  feat: add journey search functionality
  fix: resolve route matching bug
  docs: update API documentation
  style: format code according to guidelines
  refactor: improve database query performance
  test: add unit tests for booking module
  ```

---

## 4. Pull Request Process

### Before Submitting
1. Update your branch with the latest upstream changes:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```
2. Test your changes thoroughly
3. Ensure all tests pass
4. Update documentation if needed

### Creating a Pull Request
1. Create a new branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Make your changes and commit them
3. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
4. Create a pull request on GitHub
5. Fill in the pull request template with all details

### Pull Request Template
```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] New tests added (if applicable)

## Screenshots (if applicable)
Add screenshots of UI changes.

## Related Issues
Link to related issues (e.g., Closes #123)
```

---

## 5. Issue Reporting

### Before Reporting
- Check existing issues to avoid duplicates
- Test on the latest version
- Gather relevant information (logs, screenshots, etc.)

### Issue Template
Use the provided issue template when creating new issues. Include:
- Clear description
- Steps to reproduce (for bugs)
- Expected behavior
- Actual behavior
- Environment details
- Screenshots (if applicable)

---

## 6. Community Guidelines

### Code of Conduct
- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Avoid personal attacks or offensive language

### Communication
- Use GitHub issues for bug reports and feature requests
- Use discussions for general questions and ideas
- Be patient and understanding

---

## Areas for Contribution

### High Priority
- Bug fixes
- Performance improvements
- Security enhancements
- Documentation improvements

### Medium Priority
- New features (check issue tracker)
- UI/UX improvements
- Test coverage
- Code refactoring

### Low Priority
- Minor UI tweaks
- Additional documentation
- Example code
- Translation support

---

## Questions?

If you have any questions, feel free to:
- Open an issue with the 'question' label
- Contact the maintainer
- Join community discussions

---

**Thank you for contributing to RouteShare!** 🚗🤝

Together, we can make transportation more sustainable and affordable for everyone.
