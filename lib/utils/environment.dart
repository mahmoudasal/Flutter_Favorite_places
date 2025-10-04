/// Environment configuration helper
class Environment {
  static const String _googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  
  /// Get Google Maps API Key from environment variables
  static String get googleMapsApiKey {
    if (_googleMapsApiKey.isEmpty) {
      throw const EnvironmentException(
        'GOOGLE_MAPS_API_KEY not found in environment variables. '
        'Please add it to your .env file or pass it as --dart-define.',
      );
    }
    return _googleMapsApiKey;
  }
  
  /// Check if all required environment variables are set
  static bool get isConfigured {
    return _googleMapsApiKey.isNotEmpty;
  }
  
  /// Validate environment configuration
  static void validate() {
    if (!isConfigured) {
      throw const EnvironmentException(
        'Missing required environment variables. '
        'Please check your .env file and ensure GOOGLE_MAPS_API_KEY is set.',
      );
    }
  }
}

class EnvironmentException implements Exception {
  final String message;
  
  const EnvironmentException(this.message);
  
  @override
  String toString() => 'EnvironmentException: $message';
}