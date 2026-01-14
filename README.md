# The Family Altar

<div align="center">

**A Modern Spiritual Companion App**

[![Flutter](https://img.shields.io/badge/Flutter-3.5.4+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?logo=firebase)](https://firebase.google.com)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State-BLoC-blue)](https://bloclibrary.dev)

*Built with professional software engineering practices and modern Flutter architecture*

</div>

---

## Overview

**The Family Altar** is a comprehensive spiritual companion application that provides daily scripture readings, complete Bible access, and reading tracking features. Developed using industry-standard **Clean Architecture** principles with **BLoC pattern** state management, this app demonstrates enterprise-level mobile development practices.

### Copyright & Attribution
Copyright © Voice of God Recordings Inc.
Developed by ZionSphere Team

---

## Current Features

### Daily Scripture Readings (Manna Tab)
- **Daily Devotionals**: Access curated daily readings from "The Family Altar" collection
- **Interactive Calendar**: Navigate and browse readings by date
- **Streak Tracking**: Monitor reading consistency with visual streak counters
- **Reading History**: View recent readings and track spiritual journey
- **Detailed Reading View**: Full scripture passages with sermon content

### Complete Bible Access
- **Multiple Translations**: Support for KJV, NKJV, and Hindi Bible versions
- **Offline Capability**: Full Bible access without internet connection
- **Structured Navigation**: Browse by Book → Chapter → Verse
- **Version Management**: Download and manage multiple Bible translations
- **Verse Display**: Clean, numbered verse presentation with selectable text
- **Chapter Navigation**: Intuitive previous/next chapter controls

### Notes & Highlights
- **Personal Notes**: Create, edit, and delete notes on readings
- **Text Highlighting**: Highlight important passages with custom colors
- **Reading Association**: Notes and highlights linked to specific readings
- **Metadata Tracking**: Timestamps and position tracking for organization
- **Cloud Sync**: Synchronized across devices via Firebase

### Multi-Language Support
- **4 Languages**: English, Hindi (हिन्दी), Marathi (मराठी), Gujarati (ગુજરાતી)
- **Complete Localization**: All UI elements translated
- **Regional Bible Versions**: Language-specific Bible translations

### User Experience
- **Onboarding Flow**: Beautiful 3-slide introduction for new users
- **Theme System**: Light, Dark, and System theme options
- **Material Design 3**: Modern, polished UI with Material 3 components
- **Responsive Design**: Optimized for various screen sizes

### Settings & Account Management
- **Theme Preferences**: Persistent theme selection
- **Language Selection**: Easy language switching
- **Account Controls**: Sign out and account deletion options
- **Version Information**: App version and credits

---

## Architecture & Design Patterns

### Clean Architecture Implementation

This project follows **Clean Architecture** principles, ensuring separation of concerns, testability, and maintainability.

```
┌─────────────────────────────────────────────┐
│          Presentation Layer                 │
│  (UI, BLoCs, Pages, Widgets)               │
│  ↓ Events & States                         │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│          Domain Layer                       │
│  (Entities, Use Cases, Repository Contracts)│
│  ↓ Business Logic                          │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│          Data Layer                         │
│  (Repository Impl, Data Sources, Models)   │
│  ↓ External Services                       │
└─────────────────────────────────────────────┘
```

#### Layer Responsibilities

**Presentation Layer** (`/lib/src/<feature>/presentation/`)
- UI components and screens
- BLoC state management (events, states, business logic)
- User interaction handling
- State-driven UI updates

**Domain Layer** (`/lib/src/<feature>/domain/`)
- Business entities (pure Dart objects)
- Repository contracts (abstract interfaces)
- Use cases (single-responsibility business operations)
- No external framework dependencies

**Data Layer** (`/lib/src/<feature>/data/`)
- Repository implementations
- Remote data sources (Firebase Firestore)
- Local data sources (SharedPreferences, local storage)
- Data models with JSON serialization

### State Management: BLoC Pattern

**Why BLoC?**
- Predictable state management
- Separation of business logic from UI
- Testability and maintainability
- Scalable for complex applications

**Implementation Details:**
- `flutter_bloc` (v9.1.1) for state management
- Event-driven architecture
- Immutable states using `Equatable`
- Dependency injection via `get_it`

**Example Flow:**
```dart
// 1. User Action
ElevatedButton → Triggers Event

// 2. Event Processing
HomeEvent.getTodaysReading → HomeBLoC

// 3. Business Logic
HomeBLoC → GetTodaysReadingUseCase → HomeRepository

// 4. Data Fetching
HomeRepositoryImpl → HomeRemoteDataSource → Firestore

// 5. State Update
Data/Error → HomeState → UI Updates
```

### Key Architectural Patterns

#### Repository Pattern
- **Abstract Repositories**: Defined in domain layer as contracts
- **Concrete Implementations**: In data layer with dependency injection
- **Testability**: Easy to mock repositories for unit tests

```dart
// Domain Layer
abstract class HomeRepository {
  ResultFuture<Reading> getTodaysReading();
}

// Data Layer
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  @override
  ResultFuture<Reading> getTodaysReading() async {
    // Implementation with error handling
  }
}
```

#### Use Case Pattern
Single-responsibility classes for business operations:

```dart
// Use case with parameters
class GetReadingByDate extends UseCaseWithParams<Reading, DateParams> {
  final HomeRepository repository;

  @override
  ResultFuture<Reading> call(DateParams params) =>
    repository.getReadingByDate(params.date);
}

// Use case without parameters
class GetTodaysReading extends UseCaseWithoutParams<Reading> {
  final HomeRepository repository;

  @override
  ResultFuture<Reading> call() => repository.getTodaysReading();
}
```

#### Error Handling
- **Functional Approach**: Using `dartz` for `Either<Failure, Success>`
- **Type Aliases**: `ResultFuture<T>` and `ResultVoid` for cleaner code
- **Exception Mapping**: Data layer exceptions → Domain layer failures
- **Graceful Degradation**: Error states handled in BLoC

#### Dependency Injection
- **Service Locator**: `get_it` package
- **Centralized Configuration**: `injection_container.dart`
- **Registration Types**:
  - Lazy singletons for repositories and data sources
  - Factories for BLoCs (new instance per request)
  - Singletons for shared services

```dart
// Dependency Registration Example
final sl = GetIt.instance;

// Data sources
sl.registerLazySingleton<HomeRemoteDataSource>(
  () => HomeRemoteDataSourceImpl(firestore: sl())
);

// Repositories
sl.registerLazySingleton<HomeRepository>(
  () => HomeRepositoryImpl(remoteDataSource: sl())
);

// Use cases
sl.registerLazySingleton(() => GetTodaysReading(sl()));

// BLoCs
sl.registerFactory(() => HomeBloc(
  getTodaysReading: sl(),
  getReadingByDate: sl(),
  // ... other use cases
));
```

---

## Tech Stack

### Core Framework
| Technology | Version | Purpose |
|-----------|---------|---------|
| Flutter | 3.5.4+ | Cross-platform mobile framework |
| Dart | Latest | Programming language |
| Material 3 | Latest | Modern UI design system |

### State Management & Architecture
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | 9.1.1 | BLoC state management |
| `bloc` | 9.0.0 | Core BLoC library |
| `provider` | 6.1.5 | Provider pattern for shared state |
| `get_it` | 8.0.3 | Dependency injection |
| `dartz` | 0.10.1 | Functional programming (Either, Option) |
| `equatable` | 2.0.7 | Value equality for immutable objects |

### Backend & Cloud Services
| Service | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | 3.13.1 | Firebase initialization |
| `firebase_auth` | 5.5.4 | Authentication services |
| `cloud_firestore` | 5.4.4 | Cloud database |
| `firebase_storage` | 12.3.6 | Cloud file storage |
| `firebase_analytics` | 11.3.5 | User analytics |
| `firebase_crashlytics` | 4.1.5 | Crash reporting |
| `firebase_messaging` | 15.1.5 | Push notifications |
| `firebase_remote_config` | 5.1.5 | Remote configuration |

### Authentication
| Package | Version | Purpose |
|---------|---------|---------|
| `google_sign_in` | 6.2.1 | Google OAuth integration |
| `sign_in_with_apple` | 6.1.2 | Apple Sign-In integration |

### UI Components
| Package | Version | Purpose |
|---------|---------|---------|
| `table_calendar` | 3.2.0 | Interactive calendar widget |
| `iconly` | 1.0.1 | Icon library |
| `google_fonts` | 6.2.1 | Custom fonts |
| `cupertino_icons` | 1.0.8 | iOS-style icons |

### Utilities
| Package | Version | Purpose |
|---------|---------|---------|
| `shared_preferences` | 2.5.3 | Local data persistence |
| `url_launcher` | 6.3.1 | External link handling |
| `share_plus` | 10.1.1 | Content sharing |
| `intl` | 0.20.2 | Internationalization |

### Development Tools
| Tool | Version | Purpose |
|------|---------|---------|
| `build_runner` | 2.4.7 | Code generation |
| `flutter_lints` | 4.0.0 | Dart linting rules |

---

## Project Structure

```
lib/
├── core/                          # Shared utilities and services
│   ├── common/                    # Shared providers and global state
│   │   └── user_provider.dart     # User state management
│   ├── errors/                    # Error handling
│   │   ├── exceptions.dart        # Data layer exceptions
│   │   └── failures.dart          # Domain layer failures
│   ├── res/                       # Resources (assets, constants)
│   │   └── media_res.dart
│   ├── services/                  # Core services
│   │   └── injection_container.dart  # Dependency injection setup
│   ├── usecases/                  # Base use case classes
│   │   └── usecase.dart
│   ├── utils/                     # Utilities
│   │   ├── routes.dart            # Navigation routes
│   │   ├── typedef.dart           # Type aliases
│   │   ├── theme.dart             # App theming
│   │   └── firebase_options.dart  # Firebase configuration
│   └── widgets/                   # Reusable widgets
│       ├── loader_dialog.dart
│       └── tab_button.dart
│
├── src/                           # Feature modules
│   ├── authentication/            # Auth feature (infrastructure ready)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_data_source.dart
│   │   │   │   └── auth_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in.dart
│   │   │       ├── sign_up.dart
│   │   │       ├── sign_out.dart
│   │   │       ├── sign_in_with_google.dart
│   │   │       ├── sign_in_with_apple.dart
│   │   │       └── delete_account.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── authentication_bloc.dart
│   │
│   ├── home/                      # Daily readings feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── home_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── reading_model.dart
│   │   │   └── repositories/
│   │   │       └── home_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── reading.dart
│   │   │   ├── repositories/
│   │   │   │   └── home_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_todays_reading.dart
│   │   │       ├── get_reading_by_date.dart
│   │   │       ├── get_user_streak.dart
│   │   │       └── update_user_streak.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── home_bloc.dart
│   │       ├── pages/
│   │       │   ├── home_screen.dart
│   │       │   └── reading_detail_screen.dart
│   │       └── widgets/
│   │           ├── manna_tab.dart
│   │           ├── todays_reading_card.dart
│   │           ├── reading_calendar.dart
│   │           └── streak_display.dart
│   │
│   ├── bible/                     # Bible reading feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── bible_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── bible_version_model.dart
│   │   │   │   ├── bible_book_model.dart
│   │   │   │   └── bible_verse_model.dart
│   │   │   └── repositories/
│   │   │       └── bible_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── bible_version.dart
│   │   │   │   ├── bible_book.dart
│   │   │   │   ├── bible_chapter.dart
│   │   │   │   ├── bible_verse.dart
│   │   │   │   └── scripture_reference.dart
│   │   │   ├── repositories/
│   │   │   │   └── bible_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_available_versions.dart
│   │   │       ├── get_bible_books.dart
│   │   │       ├── get_bible_chapter.dart
│   │   │       └── get_scripture_verses.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── bible_books_screen.dart
│   │       │   ├── bible_chapter_screen.dart
│   │       │   └── bible_reading_screen.dart
│   │       └── widgets/
│   │           └── bible_tab.dart
│   │
│   ├── notes/                     # Notes & highlights feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── notes_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── note_model.dart
│   │   │   │   └── highlight_model.dart
│   │   │   └── repositories/
│   │   │       └── notes_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── note.dart
│   │   │   │   └── highlight.dart
│   │   │   ├── repositories/
│   │   │   │   └── notes_repository.dart
│   │   │   └── usecases/
│   │   │       ├── save_note.dart
│   │   │       ├── save_highlight.dart
│   │   │       ├── get_notes_by_reading.dart
│   │   │       └── delete_note.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── notes_bloc.dart
│   │
│   ├── onboarding/                # First-time user experience
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── onboarding_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── onboarding_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── onboarding_slide.dart
│   │   │   ├── repositories/
│   │   │   │   └── onboarding_repository.dart
│   │   │   └── usecases/
│   │   │       ├── cache_first_timer.dart
│   │   │       └── check_if_user_is_first_timer.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── onboarding_bloc.dart
│   │       ├── pages/
│   │       │   └── onboarding_screen.dart
│   │       └── widgets/
│   │           └── onboarding_slide_widget.dart
│   │
│   └── settings/                  # App settings
│       └── presentation/
│           └── pages/
│               └── settings_screen.dart
│
├── l10n/                          # Localization files
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   ├── app_localizations_hi.dart
│   ├── app_localizations_mr.dart
│   └── app_localizations_gu.dart
│
└── main.dart                      # App entry point
```

---

## Development Practices

### Test-Driven Development (TDD)
- Test files in `/test/` directory mirror `/lib/` structure
- Unit tests for use cases and repositories
- Widget tests for UI components
- BLoC tests for state management logic

### Code Quality
- **Static Analysis**: `flutter analyze` with strict linting rules
- **Code Generation**: `build_runner` for model generation
- **Consistent Logging**: `dart:developer` log function throughout
- **Error Handling**: Comprehensive try-catch with typed exceptions
- **Documentation**: Code comments and architectural documentation

### Git Workflow
- Feature branch development
- Descriptive commit messages
- Current branch: `dev`
- Recent features: Bible integration, Notes system, Social auth

---

## Future Roadmap

### Planned Features

#### Enhanced Bible Study Tools
- **Advanced Search**: Full-text search across all Bible versions
- **Cross-References**: Interactive cross-reference navigation
- **Verse Comparison**: Side-by-side version comparison
- **Audio Bible**: Audio playback of scripture passages
- **Reading Plans**: Guided Bible reading plans (1-year, topical, etc.)

#### Social & Community Features
- **Community Sharing**: Share readings and notes with friends
- **Discussion Groups**: Bible study group collaboration
- **Prayer Requests**: Community prayer wall
- **Reading Challenges**: Group reading challenges with leaderboards

#### Personalization
- **Custom Reading Plans**: Create personalized devotional schedules
- **Bookmarking System**: Bookmark favorite verses and readings
- **Font Customization**: Adjustable font sizes and styles
- **Dark Mode Enhancements**: OLED black theme option

#### Notifications & Reminders
- **Daily Reminders**: Customizable reading reminders
- **Streak Notifications**: Encourage reading consistency
- **Prayer Time Alerts**: Configurable prayer reminders

#### Offline Capabilities
- **Enhanced Offline Mode**: Full app functionality without internet
- **Download Management**: Background downloads for Bible versions
- **Sync Optimization**: Efficient cloud sync when online

#### Analytics & Insights
- **Reading Analytics**: Track reading habits and progress
- **Yearly Reports**: Comprehensive annual reading summaries
- **Goal Setting**: Set and track spiritual growth goals
- **Heatmap Visualization**: Calendar heatmap of reading activity

#### Accessibility
- **Text-to-Speech**: Read-aloud functionality
- **Screen Reader Support**: Enhanced accessibility features
- **High Contrast Mode**: Better visibility options
- **Large Text Mode**: Accessibility font scaling

#### Additional Translations
- **More Bible Versions**: Expand to 10+ translations
- **More Languages**: Add Tamil, Telugu, Kannada, Bengali
- **Regional Dialects**: Support for language variants

---

## Getting Started

### Prerequisites
- Flutter SDK 3.5.4 or higher
- Dart SDK (comes with Flutter)
- Android Studio / Xcode for platform-specific development
- Firebase account and project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd thefamilyaltar
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`
   - Firebase configuration is in `lib/core/utils/firebase_options.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands

| Command | Purpose |
|---------|---------|
| `flutter pub get` | Install dependencies |
| `flutter run` | Run the app in development mode |
| `flutter build apk` | Build Android APK |
| `flutter build ios` | Build iOS app |
| `flutter test` | Run all tests |
| `flutter analyze` | Static analysis and linting |
| `flutter clean` | Clean build artifacts |
| `flutter pub run build_runner build` | Generate code |

---

## Configuration

### Firebase Services Used
- **Authentication**: Email/password, Google, Apple sign-in
- **Firestore**: Cloud database for readings, notes, user data
- **Storage**: Cloud storage for media assets
- **Analytics**: User behavior tracking
- **Crashlytics**: Crash reporting and debugging
- **Remote Config**: Feature flags and configuration
- **Messaging**: Push notifications (prepared for future use)

### Environment Setup
The app automatically configures Firebase using `DefaultFirebaseOptions.currentPlatform` based on the platform (iOS/Android).

---

## Why This Project Stands Out

### Professional Software Engineering
- **Enterprise Architecture**: Clean Architecture used by Fortune 500 companies
- **Scalable State Management**: BLoC pattern for complex state handling
- **Dependency Injection**: Proper DI for testability and maintainability
- **Error Handling**: Robust error handling with typed failures

### Production-Ready Features
- **Multi-platform**: Single codebase for iOS and Android
- **Internationalization**: Real multi-language support
- **Cloud Integration**: Full Firebase backend integration
- **Offline-First**: Works without internet connection

### Code Quality
- **Type Safety**: Strong typing throughout the application
- **Immutable Data**: Equatable entities for predictable state
- **Separation of Concerns**: Clear boundaries between layers
- **Test-Friendly**: Architecture designed for comprehensive testing

### Modern Development Practices
- **Functional Programming**: Using `dartz` for functional constructs
- **Repository Pattern**: Abstracted data access
- **Use Case Pattern**: Single-responsibility business logic
- **SOLID Principles**: Applied throughout the codebase

---

## Performance Considerations

- **Lazy Loading**: BLoCs created only when needed
- **Efficient State Updates**: Immutable states prevent unnecessary rebuilds
- **Local Caching**: SharedPreferences for quick data access
- **Firestore Optimization**: Indexed queries and efficient data structures
- **Asset Optimization**: Compressed images and optimized resources

---

## Security

- **Firebase Security Rules**: Configured for production use
- **No Hardcoded Secrets**: Environment-based configuration
- **Secure Authentication**: Firebase Auth with social providers
- **Data Validation**: Input validation at multiple layers
- **HTTPS Only**: All network requests over secure connections

---

## Contributing

This project demonstrates professional mobile development practices suitable for production applications. The codebase follows industry standards and best practices, making it maintainable and extensible.

### Code Style
- Follow official Dart style guide
- Use provided lints (`flutter_lints`)
- Maintain clean architecture layer separation
- Write descriptive commit messages

---

## License & Credits

**Copyright © Voice of God Recordings Inc.**

**Development Team**: ZionSphere Team

**Powered by**:
- Flutter & Dart
- Firebase Platform
- Open-source Flutter community

---

## Contact & Support

For questions, feature requests, or bug reports, please contact the development team.

**App Version**: 1.0.0 (Build 19)

---

<div align="center">

**Built with Flutter, powered by Firebase, designed with care.**

*Demonstrating enterprise-level mobile development with Clean Architecture and BLoC pattern*

</div>
