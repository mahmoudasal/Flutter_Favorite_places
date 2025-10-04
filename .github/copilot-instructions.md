# Favorite Places App - AI Coding Guidelines

## Project Overview
This is a Flutter app for managing favorite places using **flutter_riverpod** for state management. The architecture follows a simple MVVM pattern with providers for business logic and screens for UI.

## Key Architecture Patterns

### State Management with Riverpod
- All state management uses `flutter_riverpod` - prefer `ConsumerWidget` over `StatelessWidget`
- Provider pattern: `lib/provider/places_provider.dart` contains `PlacesNotifer` extending `Notifier<List<Place>>`
- Access providers with `ref.watch(placesProvider)` to listen to changes
- Modify state with `ref.read(placesProvider.notifier).methodName()`

### Project Structure
```
lib/
├── main.dart              # App entry point with ProviderScope wrapper
├── models/place.dart      # Data models using uuid package
├── provider/              # Riverpod state management
├── screens/               # Full-screen UI components
└── widgets/               # Reusable UI components
```

### Navigation Pattern
- Uses `Navigator.of(context).push(MaterialPageRoute(...))` for screen transitions
- Example: `YourPlaces` → `AddPlace` → back to `YourPlaces` with updated state

## Development Conventions

### UI/UX Standards
- **Theme**: Dark theme with purple seed color (`Color.fromARGB(255, 102, 6, 247)`)
- **Typography**: Google Fonts Ubuntu Condensed with bold variants for titles
- **Feedback**: Always show `SnackBar` for user actions (success/error messages)
- **Empty states**: Include helpful illustrations and guidance text

### Code Patterns
- **Form validation**: Check for empty/invalid input before processing
- **Error handling**: Show user-friendly error messages via SnackBar
- **Controllers**: Use `TextEditingController` for form inputs, dispose properly
- **Imports**: Group by type (Flutter → packages → relative imports)

## Key Files to Reference

### Core State Management
- `lib/provider/places_provider.dart` - Shows Riverpod Notifier pattern
- `lib/models/place.dart` - Simple model with UUID generation
- `lib/main.dart` - ProviderScope setup and theme configuration

### UI Patterns
- `lib/screens/your_places.dart` - ListView with empty state handling
- `lib/screens/add_place.dart` - Form with validation and provider integration
- `lib/widgets/image_picker.dart` - Component pattern (currently incomplete)

## Development Commands
```bash
flutter pub get                    # Install dependencies
flutter run                       # Run on connected device
flutter analyze                   # Static code analysis
flutter test                     # Run unit tests
```

## Dependencies
- `flutter_riverpod` - State management
- `uuid` - Unique ID generation  
- `google_fonts` - Typography
- `image_picker` - Camera/gallery access (in progress)

## Common Tasks
- **Adding new screens**: Create in `lib/screens/`, use `ConsumerWidget`, implement navigation
- **New models**: Add to `lib/models/`, use UUID for IDs
- **State updates**: Extend notifiers in `lib/provider/`, follow immutable state pattern
- **UI components**: Create in `lib/widgets/`, make them reusable and testable