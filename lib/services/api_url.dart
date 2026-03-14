class ApiUrl {
  ApiUrl._();

  // Default base URL for physical devices on the same LAN as the backend.
  static const String _defaultBaseUrl = 'http://192.168.1.44:8000';

  // Override at runtime if needed:
  // flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
  // flutter run --dart-define=API_BASE_URL=http://<your-laptop-lan-ip>:8000
  static String get baseUrl {
    const String fromEnv = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: '',
    );
    final String normalized = fromEnv.trim();
    if (normalized.isEmpty) {
      return _defaultBaseUrl;
    }

    // Prevent loopback values from breaking Android emulator/device requests.
    if (normalized.contains('127.0.0.1') || normalized.contains('localhost')) {
      return _defaultBaseUrl;
    }

    return normalized;
  }

  // Base Url for login and Profile fetching
  static const String _mrBase = '/onboarding/mr';
  // Login Endpoint
  static const String mrLogin = '$_mrBase/login';
  // Get Profile by ID Endpoint
  static String mrGetById(String mrId) => '$_mrBase/get-by/$mrId';
  // Update Profile by ID Endpoint
  static String mrUpdateById(String mrId) => '$_mrBase/update-by/$mrId';

  // Distributor Endpoints
  static const String distributorGetAll = '/distributor/get-all';
  static String distributorGetById(String distId) =>
      '/distributor/get-by/$distId';

  // Visual Ads Endpoints
  static const String visualAdsGetAll = '/visual-ads/get-all';
  static String visualAdsGetById(String adId) => '/visual-ads/get-by/$adId';

  // Monthly Plan Endpoints
  static String monthlyPlanGetByMr(String mrId) =>
      '/monthly-plan/get-by-mr/$mrId';
  static String monthlyPlanGetByMrAndDate(String mrId, String planDate) =>
      '/monthly-plan/get-by-mr/$mrId/date/$planDate';

  static String getFullUrl(String path) {
    final String trimmed = path.trim();
    if (trimmed.isEmpty) {
      return baseUrl;
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    final String normalizedPath = trimmed.startsWith('/')
        ? trimmed
        : '/$trimmed';
    return '$baseUrl$normalizedPath';
  }
}
