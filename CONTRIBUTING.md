# Contributing to The Family Altar

Thank you for your interest in contributing to The Family Altar! We welcome contributions from the community and are grateful for your support.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Questions?](#questions)

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/thefamilyaltar.git
   cd thefamilyaltar
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/thefamilyaltar.git
   ```
4. Create a branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Android Studio / VS Code with Flutter extensions
- Firebase account (for testing authentication features)

### Installation

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run code generation (if needed):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. Run tests:
   ```bash
   flutter test
   ```

5. Run static analysis:
   ```bash
   flutter analyze
   ```

## How to Contribute

### Reporting Bugs

- Use the GitHub Issues tab
- Use the bug report template
- Include steps to reproduce, expected behavior, and actual behavior
- Add screenshots or error logs if applicable

### Suggesting Features

- Use the GitHub Issues tab
- Use the feature request template
- Clearly describe the feature and its benefits
- Consider how it fits with the app's vision

### Code Contributions

1. Check existing issues or create a new one to discuss your changes
2. Wait for approval/feedback before starting major work
3. Follow the coding standards (see below)
4. Write tests for your changes (TDD approach)
5. Ensure all tests pass
6. Submit a pull request

## Coding Standards

### Architecture

This project follows **Clean Architecture** with **BLoC** state management:

- **Domain Layer**: Business entities and use cases (no external dependencies)
- **Data Layer**: Repository implementations, data sources, and models
- **Presentation Layer**: UI, widgets, and BLoC state management

### Folder Structure

```
lib/src/<feature>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

### Style Guidelines

1. **Follow Dart style guide**: Use `dart format` to format code
2. **Naming conventions**:
   - Classes: `PascalCase`
   - Variables/functions: `camelCase`
   - Constants: `camelCase` with `static const`
   - Files: `snake_case`
3. **Use meaningful names**: Avoid abbreviations unless widely understood
4. **Add documentation**: Use `///` for public APIs
5. **Logging**: Use `log()` from `dart:developer`, not `print()`

### BLoC Pattern

- Events: `<Feature><Action>Event` (e.g., `AuthenticationSignInEvent`)
- States: `<Feature><Status>State` (e.g., `AuthenticationLoadingState`)
- BLoC: `<Feature>Bloc` (e.g., `AuthenticationBloc`)

### Use Cases

- Extend `UseCaseWithParams<Type, Params>` or `UseCaseWithoutParams<Type>`
- Use `ResultFuture<T>` and `ResultVoid` type definitions
- Single responsibility: One use case = one business operation

### Dependency Injection

- Register all dependencies in `lib/core/services/injection_container.dart`
- Use `sl<Type>()` to resolve dependencies
- Follow the existing registration pattern

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build, etc.)
- `perf`: Performance improvements

### Examples

```
feat(auth): add password reset functionality

fix(bible): resolve verse loading issue on slow connections

docs(readme): update installation instructions

test(notes): add unit tests for note creation
```

## Pull Request Process

1. **Update your branch** with the latest changes from upstream:
   ```bash
   git fetch upstream
   git rebase upstream/dev
   ```

2. **Ensure your code**:
   - Passes all tests: `flutter test`
   - Has no analysis issues: `flutter analyze`
   - Is properly formatted: `dart format .`

3. **Create a Pull Request**:
   - Target the `dev` branch (not `main`)
   - Use the PR template
   - Reference related issues (e.g., "Closes #123")
   - Provide a clear description of changes
   - Add screenshots/videos for UI changes

4. **Code Review**:
   - Address review comments promptly
   - Push additional commits if needed
   - Request re-review after making changes

5. **Merge**:
   - Maintainers will merge your PR once approved
   - PRs are typically squashed before merging

## Testing

We follow **Test-Driven Development (TDD)**:

1. Write tests first (in `/test` directory)
2. Implement the feature
3. Ensure tests pass

### Test Structure

```
test/
├── src/
│   └── <feature>/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── ...
```

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/src/authentication/domain/usecases/sign_in_test.dart

# With coverage
flutter test --coverage
```

## Questions?

- Open an issue for bugs or feature requests
- Start a discussion for general questions
- Check existing issues and documentation first

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to The Family Altar!