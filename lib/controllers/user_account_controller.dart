import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:aiponics_web_app/api%20information/api_constants.dart';
import 'package:aiponics_web_app/controllers/token%20controllers/access_and_refresh_token_controller.dart';
import '../models/user info model/user_info_model.dart';

class UserAccountInfoApi {

  static Future<UserAccountInfoModel> getUserAccountInfo() async {
    UserAccountInfoModel userAccountInfoModel = UserAccountInfoModel(
        id: 0, password: '', isSuperuser: false, username: 'Error', isStaff: false, isActive: false,
        dateJoined: DateTime(2025), email: '', firstName: 'Error', lastName: '',
        isActiveSubscription: false, registeredDate: DateTime(2025), role: ['Operator'], plan: 1,
        groups: [], userPermissions: []);

    // Get your access token
    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      throw Exception("Access token not available");
    }

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ));

      final response = await dio.get(
        userAccountInfoApi, // Ensure this is defined in your api_constants.dart
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
      );

      log("USER_INFO_RESPONSE: Received response with status code ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("USER_INFO_RESPONSE: Response Data: ${response.data}");
        userAccountInfoModel =  UserAccountInfoModel.fromJson(response.data);
      } else {
        log("USER_INFO_RESPONSE: Response error ${response.statusCode}");
        throw Exception("Error fetching user information");
      }
    } on DioException catch (e) {
      log("USER_INFO_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
      throw Exception("Error fetching user information");
    }
    return userAccountInfoModel;
  }
}
