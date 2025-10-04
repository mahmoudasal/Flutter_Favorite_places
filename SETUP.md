# Environment Setup Guide

## Google Maps API Key Configuration

This app requires a Google Maps API key to function properly. Follow these steps to set it up securely:

### 1. Get Your Google Maps API Key

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Geocoding API
   - Maps Static API
4. Create credentials (API Key)
5. Configure API key restrictions for security

### 2. Configure the API Key

You have several options to configure your API key:

#### Option A: Using dart-define (Recommended for development)
```bash
flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

#### Option B: Using environment variables
1. Create a `.env` file in the project root:
```bash
cp .env.example .env
```

2. Edit `.env` and add your API key:
```
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

#### Option C: Using Android gradle.properties
1. Create or edit `android/gradle.properties`:
```
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

### 3. Build Commands

#### Development
```bash
# With dart-define
flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key

# Debug build
flutter build apk --debug --dart-define=GOOGLE_MAPS_API_KEY=your_key
```

#### Production
```bash
# Release build
flutter build apk --release --dart-define=GOOGLE_MAPS_API_KEY=your_key

# App bundle
flutter build appbundle --release --dart-define=GOOGLE_MAPS_API_KEY=your_key
```

### 4. Security Best Practices

1. **Never commit your API key to version control**
2. **Use API key restrictions** in Google Cloud Console
3. **Restrict by application** (package name/bundle ID)
4. **Restrict by API** (only enable needed APIs)
5. **Monitor usage** in Google Cloud Console
6. **Rotate keys regularly**

### 5. Troubleshooting

#### Common Issues:

1. **"API key not found" error**
   - Ensure you're passing the API key correctly
   - Check spelling of environment variable name

2. **"API key invalid" error**
   - Verify the key is correct
   - Check API restrictions in Google Cloud Console
   - Ensure required APIs are enabled

3. **Maps not loading**
   - Check internet connection
   - Verify API key has Maps SDK enabled
   - Check for API quota limits

#### Verification:
You can verify your setup by checking if the API key is loaded:
```dart
import 'package:favorite_places/utils/constants.dart';

// This will throw an exception if the key is not configured
print(AppConstants.googleMapsApiKey);
```

### 6. CI/CD Configuration

For continuous integration, add the API key as a secret environment variable:

#### GitHub Actions:
```yaml
- name: Build APK
  run: flutter build apk --release --dart-define=GOOGLE_MAPS_API_KEY=${{ secrets.GOOGLE_MAPS_API_KEY }}
```

#### GitLab CI:
```yaml
build:
  script:
    - flutter build apk --release --dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY
```

Remember to add `GOOGLE_MAPS_API_KEY` to your CI/CD secrets!