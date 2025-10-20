import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';

class LoginManager extends GetxService {
  static LoginManager get instance => Get.find<LoginManager>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Observable properties
  RxString userId = ''.obs;
  RxString phoneNumber = ''.obs;
  RxBool isLoggedIn = false.obs;
  RxBool isBypassLoginEnabled = false.obs;
  RxString bypassUserId = ''.obs;
  RxBool isLoading = true.obs;

  // Non-observable properties for quick access
  String get currentUserId => userId.value;
  String get currentPhoneNumber => phoneNumber.value;
  bool get loggedIn => isLoggedIn.value;
  bool get bypassEnabled => isBypassLoginEnabled.value;

  @override
  void onInit() {
    super.onInit();
    _initializeLoginManager();
  }

  /// Initialize login manager and load user data from Firebase
  Future<void> _initializeLoginManager() async {
    try {
      isLoading.value = true;
      LoggerService.logInfo('Initializing LoginManager');

      // Check if bypass login is enabled
      _checkBypassLogin();

      // If bypass is enabled and configured, use bypass user
      if (isBypassLoginEnabled.value && bypassUserId.value.isNotEmpty) {
        _loadBypassUser();
        isLoading.value = false;
        return;
      }

      // Otherwise, load from Firebase current user
      final User? firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        userId.value = firebaseUser.uid;
        phoneNumber.value = firebaseUser.phoneNumber ?? '';
        isLoggedIn.value = true;

        LoggerService.logInfo(
          'User loaded from Firebase: $userId, Phone: $phoneNumber',
        );
      } else {
        isLoggedIn.value = false;
        LoggerService.logInfo('No user found in Firebase');
      }

      isLoading.value = false;
    } catch (e) {
      LoggerService.logError('Error initializing LoginManager: $e');
      isLoading.value = false;
    }
  }

  /// Check if bypass login is enabled (useful for development/testing)
  void _checkBypassLogin() {
    // This can be controlled via environment variables or feature flags
    // For now, we'll set it to false by default
    isBypassLoginEnabled.value = false;
  }

  /// Load bypass user data
  void _loadBypassUser() {
    try {
      userId.value = bypassUserId.value;
      phoneNumber.value = '+91-BYPASS-MODE'; // Placeholder
      isLoggedIn.value = true;

      LoggerService.logInfo('Bypass login enabled for user: $userId');
    } catch (e) {
      LoggerService.logError('Error loading bypass user: $e');
    }
  }

  /// Enable bypass login for development/testing
  /// Warning: Only use in development builds
  void enableBypassLogin({required String testUserId}) {
    if (testUserId.isEmpty) {
      LoggerService.logWarning('Bypass user ID cannot be empty');
      return;
    }

    isBypassLoginEnabled.value = true;
    bypassUserId.value = testUserId;
    _loadBypassUser();

    LoggerService.logWarning(
      'BYPASS LOGIN ENABLED - Test User: $testUserId. Do not use in production!',
    );
  }

  /// Disable bypass login
  void disableBypassLogin() {
    isBypassLoginEnabled.value = false;
    bypassUserId.value = '';
    userId.value = '';
    phoneNumber.value = '';
    isLoggedIn.value = false;

    LoggerService.logInfo('Bypass login disabled');
  }

  /// Update user data after successful login
  void updateUserOnLogin(User firebaseUser) {
    try {
      userId.value = firebaseUser.uid;
      phoneNumber.value = firebaseUser.phoneNumber ?? '';
      isLoggedIn.value = true;
      isBypassLoginEnabled.value = false; // Disable bypass on actual login
      bypassUserId.value = '';

      LoggerService.logInfo(
        'User updated on login: $userId, Phone: $phoneNumber',
      );
    } catch (e) {
      LoggerService.logError('Error updating user on login: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      userId.value = '';
      phoneNumber.value = '';
      isLoggedIn.value = false;
      isBypassLoginEnabled.value = false;
      bypassUserId.value = '';

      LoggerService.logInfo('User logged out successfully');
    } catch (e) {
      LoggerService.logError('Error during logout: $e');
      rethrow;
    }
  }

  /// Get user ID (returns bypass user if bypass is enabled)
  String getUserId() {
    if (isBypassLoginEnabled.value) {
      return bypassUserId.value;
    }
    return userId.value;
  }

  /// Get phone number
  String getPhoneNumber() {
    return phoneNumber.value;
  }

  /// Check if user is logged in or bypass is enabled
  bool isUserAuthenticated() {
    return isLoggedIn.value || isBypassLoginEnabled.value;
  }

  /// Get user login status as a string
  String getLoginStatus() {
    if (isBypassLoginEnabled.value) {
      return 'BYPASS_LOGIN_ENABLED';
    } else if (isLoggedIn.value) {
      return 'LOGGED_IN';
    } else {
      return 'LOGGED_OUT';
    }
  }

  /// Refresh user data from Firebase
  Future<void> refreshUserData() async {
    try {
      if (isBypassLoginEnabled.value) {
        LoggerService.logInfo('Skipping refresh - bypass login enabled');
        return;
      }

      final User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.reload();
        userId.value = firebaseUser.uid;
        phoneNumber.value = firebaseUser.phoneNumber ?? '';
        isLoggedIn.value = true;

        LoggerService.logInfo('User data refreshed from Firebase');
      }
    } catch (e) {
      LoggerService.logError('Error refreshing user data: $e');
      rethrow;
    }
  }

  /// Get Firebase current user
  User? getFirebaseUser() {
    if (isBypassLoginEnabled.value) {
      return null; // No Firebase user in bypass mode
    }
    return _firebaseAuth.currentUser;
  }
}
