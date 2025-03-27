import 'dart:developer';
import 'package:aiponics_web_app/api%20information/api_constants.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:get/get.dart';
import '../../views/authentication/login_screen.dart';
import '../common_methods.dart';
import '../network controllers/network_controller.dart';

// Create a static TokenManager to store token expiry info in memory
class TokenManager {
  static DateTime? refreshTokenExpiry;

  static bool isRefreshTokenExpired() {
    if (refreshTokenExpiry == null) return true;
    return DateTime.now().isAfter(refreshTokenExpiry!);
  }

  static void updateRefreshTokenExpiry(DateTime expiry) {
    refreshTokenExpiry = expiry;
  }
}

const secureStorage = secure.FlutterSecureStorage();

// When saving tokens, also update our in-memory TokenManager
Future<void> saveTokens(String accessToken, String refreshToken, String isRememberPassword) async {
  final expiryDate = DateTime.now().add(const Duration(days: 7));
  final accessExpiryDate = DateTime.now().add(const Duration(days: 7));

  await secureStorage.write(key: "isRememberPassword", value: isRememberPassword);
  await secureStorage.write(key: "accessToken", value: accessToken);
  await secureStorage.write(key: "refreshToken", value: refreshToken);
  await secureStorage.write(key: "accessTokenExpiry", value: accessExpiryDate.toIso8601String());
  await secureStorage.write(key: "refreshTokenExpiry", value: expiryDate.toIso8601String());

  // Update in-memory expiry for synchronous checks
  TokenManager.updateRefreshTokenExpiry(expiryDate);
}

Future<void> savePassword(String password) async {
  await secureStorage.write(key: "password", value: password);
}

Future<String?> fetchUserPassword() async {
  return await getStoredToken("password");
}

Future<bool> checkLoginStatus() async {
  if (!(await isTokenValid("refreshTokenExpiry"))) {
    return false;
  } else if (await isRememberPassword()){
    await fetchAccessToken();
    return true;
  } else {
    return false;
  }
}

Future<String?> getStoredToken(String key) async => await secureStorage.read(key: key);

Future<bool> isRememberPassword() async {
  final isRememberPassword = await getStoredToken("isRememberPassword");
  if (isRememberPassword == null) return false;
  return isRememberPassword == "true";
}

Future<bool> isTokenValid(String key) async {
  final expiryString = await getStoredToken(key);
  if (expiryString == null) return false;
  return DateTime.now().isBefore(DateTime.parse(expiryString));
}

Future<String?> fetchAccessToken() async {
  if (!(await isTokenValid("accessTokenExpiry"))) {
    return await refreshAccessToken();
  }
  return await getStoredToken("accessToken");
}

Future<String?> refreshAccessToken() async {
  if (!(await isTokenValid("refreshTokenExpiry"))) {
    await logoutUser();
    return null;
  }

  String? refreshToken = await getStoredToken("refreshToken");

  if (refreshToken == null) {
    await logoutUser();
    return null;
  }

  try {
    if (!await NetworkController.isInternetAvailable()) {
      CommonMethods.showSnackBarWithoutContext("Error", "Internet not available", ContentType.failure);
      return null;
    }

    CommonMethods.showSnackBarWithoutContext("Info", "New Refresh Token called", ContentType.help);

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ));

    final response = await dio.post(
      refreshTokenApi,
      data: {
        "refresh_token": refreshToken,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      CommonMethods.showSnackBarWithoutContext("Info", "Refresh Token called Success", ContentType.success);
      log("✅ Token Refresh Success: ${response.data}");
      final newToken = response.data['access_token'];
      await saveTokens(newToken, refreshToken, "true");
      log("✅ Token Refresh Success: $newToken");
      return newToken;
    }
  } on DioException catch (e) {
    log("❌ Token Refresh Error: ${e.message}");
  }

  return null;
}

Future<void> logoutUser() async {
  try {
    await secureStorage.deleteAll();
    // Clear the in-memory token expiry as well
    TokenManager.updateRefreshTokenExpiry(DateTime.fromMillisecondsSinceEpoch(0));
    // Navigate to Login Screen
    Get.offAll(() => const LoginScreen());
  } catch (e) {
    log('Error: $e');
    CommonMethods.showSnackBarWithoutContext("Logout Error", "Error while logging out. Please try again later", ContentType.failure);
  }
}

Future<void> initializeTokenManager() async {
  final expiryString = await getStoredToken("refreshTokenExpiry");
  if (expiryString != null) {
    TokenManager.updateRefreshTokenExpiry(DateTime.parse(expiryString));
  }
}
