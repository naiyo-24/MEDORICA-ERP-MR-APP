
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
    // Salary Slip Endpoints
    static const String salarySlipMrDownloadByMrId = '/salary-slip/mr/download-by-mr';

    static String salarySlipDownloadByMrId(String mrId) => '$salarySlipMrDownloadByMrId/$mrId';
  // Get Profile by ID Endpoint
  static String mrGetById(String mrId) => '$_mrBase/get-by/$mrId';
  // Update Profile by ID Endpoint
  static String mrUpdateById(String mrId) => '$_mrBase/update-by/$mrId';

  
  // Team Endpoints
  static const String _teamMrBase = '/team';
  static String teamGetByMrId(String mrId) => '$_teamMrBase/get-by-mr/$mrId';
  
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

  // Attendance Endpoints
  static const String _attendanceMrBase = '/attendance/mr';
  static const String attendanceMrPost = '$_attendanceMrBase/post';
  static const String attendanceMrGetAll = '$_attendanceMrBase/get-all';
  static String attendanceMrGetByMrId(String mrId) =>
      '$_attendanceMrBase/get-by/$mrId';
  static String attendanceMrGetByMrIdAndAttendanceId(String mrId, int id) =>
      '$_attendanceMrBase/get-by/$mrId/$id';
  static String attendanceMrUpdateByMrIdAndAttendanceId(String mrId, int id) =>
      '$_attendanceMrBase/update-by/$mrId/$id';

  // Doctor Network (MR) Endpoints
  static const String _doctorNetworkMrBase = '/doctor-network/mr';
  static const String doctorNetworkMrPost = '$_doctorNetworkMrBase/post';
  static const String doctorNetworkMrGetAll = '$_doctorNetworkMrBase/get-all';
  static String doctorNetworkMrGetByMrId(String mrId) =>
      '$_doctorNetworkMrBase/get-by-mr/$mrId';
  static String doctorNetworkMrGetByMrIdAndDoctorId(
    String mrId,
    String doctorId,
  ) => '$_doctorNetworkMrBase/get-by/$mrId/$doctorId';
  static String doctorNetworkMrUpdateByMrIdAndDoctorId(
    String mrId,
    String doctorId,
  ) => '$_doctorNetworkMrBase/update-by/$mrId/$doctorId';
  static String doctorNetworkMrDeleteByDoctorId(String doctorId) =>
      '$_doctorNetworkMrBase/delete-by/$doctorId';
  
    // ASM Appointment Endpoints
  static const String appointmentAsmPost = '/appointment/mr/post';
  static String appointmentGetBymrId(String mrId) =>
      '/appointment/mr/get-by-mr/$mrId';
  static String appointmentGetById(String appointmentId) =>
      '/appointment/mr/get-by/$appointmentId';
  static String appointmentUpdateById(String appointmentId) =>
      '/appointment/mr/update-by/$appointmentId';
  static String appointmentDeleteById(String appointmentId) =>
      '/appointment/mr/delete-by/$appointmentId';

  // Chemist Shop (MR Network) Endpoints
  static const String _chemistShopMrBase = '/chemist-shop/mr';
  static const String chemistShopMrPost = '$_chemistShopMrBase/post';
  static const String chemistShopMrGetAll = '$_chemistShopMrBase/get-all';
  static String chemistShopMrGetByMrId(String mrId) =>
      '$_chemistShopMrBase/get-by-mr/$mrId';
  static String chemistShopMrGetByMrIdAndShopId(String mrId, String shopId) =>
      '$_chemistShopMrBase/get-by/$mrId/$shopId';
  static String chemistShopMrGetByShopId(String shopId) =>
      '$_chemistShopMrBase/get-by-shop/$shopId';
  static String chemistShopMrUpdateByMrIdAndShopId(
    String mrId,
    String shopId,
  ) => '$_chemistShopMrBase/update-by/$mrId/$shopId';
  static String chemistShopMrDeleteByMrIdAndShopId(
    String mrId,
    String shopId,
  ) => '$_chemistShopMrBase/delete-by/$mrId/$shopId';
  
  // MR Monthly Target Endpoints (GET)
  static const String monthlyTargetmrGetAll = '/monthly-target/mr/get-all';
  static String monthlyTargetmrGetByMrId(String mrId) =>
      '/monthly-target/mr/get-by-mr/$mrId';
  static String monthlyTargetmrGetByMrYearMonth(
    String mrId,
    int year,
    int month,
  ) => '/monthly-target/mr/get-by/$mrId/$year/$month';

  // MR Order Endpoints
  static String orderMrPostByMrId(String mrId) =>
      '/order/mr/post-by/$mrId';
  static const String orderMrGetAll = '/order/mr/get-all';
  static String orderMrGetByMrId(String mrId) =>
      '/order/mr/get-by-mr/$mrId';
  static String orderMrGetByMrAndOrderId(String mrId, String orderId) =>
      '/order/mr/get-by/$mrId/$orderId';
  static String orderMrUpdateByOrderId(String orderId) =>
      '/order/mr/update-by/$orderId';
  static String orderMrDeleteByOrderId(String orderId) =>
      '/order/mr/delete-by/$orderId';
  
   // Notification Endpoints
  static const String notificationsGetAllmr = '/notifications/get-all/mr';

   // Helper to construct full URL for a given path   
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

  // Gift Inventory Endpoints
  static const String giftInventoryGetAll = '/gift-inventory/get-all';
  static String giftInventoryGetById(int giftId) => '/gift-inventory/get-by/$giftId';

  // MR Gift Application Endpoints
  static const String mrGiftApplicationPost = '/gift-application/mr/post';
  static String mrGiftApplicationGetByMrId(String mrId) => '/gift-application/mr/get-by-mr/$mrId';
  static String mrGiftApplicationUpdateByMrId(String mrId, int requestId) => '/gift-application/mr/update-by/$mrId/$requestId';
  static String mrGiftApplicationDeleteByRequestId(int requestId) => '/gift-application/mr/delete-by/$requestId';
}