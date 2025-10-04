class AppConstants {
  // App Information
  static const String appName = 'Favorite Places';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'places.db';
  static const String tableName = 'user_places';
  static const int databaseVersion = 2;
  
  // Image Configuration
  static const int maxImageWidth = 600;
  static const int maxImageHeight = 600;
  static const int imageQuality = 80;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  
  // Location Configuration
  static const int mapZoomLevel = 16;
  static const int staticMapWidth = 600;
  static const int staticMapHeight = 300;
  
  // Validation
  static const int minTitleLength = 2;
  static const int maxTitleLength = 50;
  
  // Error Messages
  static const String errorEmptyTitle = 'Please enter a place title';
  static const String errorTitleTooShort = 'Title must be at least 2 characters long';
  static const String errorNoImage = 'Please select an image';
  static const String errorNoLocation = 'Please select a location';
  static const String errorImageTooLarge = 'Image file is too large. Please select a smaller image.';
  static const String errorLocationService = 'Location service is disabled. Please enable it in settings.';
  static const String errorLocationPermission = 'Location permission denied. Please grant permission to use this feature.';
  static const String errorNetworkFailed = 'Network request failed. Please check your internet connection.';
  static const String errorDatabaseFailed = 'Database operation failed. Please try again.';
  
  // Success Messages
  static const String successPlaceAdded = 'Place added successfully!';
  static const String successPlaceDeleted = 'Place deleted successfully';
  
  // Google Maps API Key - loaded from environment variables
  static String get googleMapsApiKey {
    const key = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    if (key.isEmpty) {
      throw Exception(
        'GOOGLE_MAPS_API_KEY not found in environment variables. '
        'Please run: flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key_here'
      );
    }
    return key;
  }
  
  // API Endpoints
  static String geocodingApiUrl(double lat, double lng) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey';
  
  static String staticMapUrl(double lat, double lng) =>
      'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=$mapZoomLevel&size=${staticMapWidth}x$staticMapHeight&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$googleMapsApiKey';
}