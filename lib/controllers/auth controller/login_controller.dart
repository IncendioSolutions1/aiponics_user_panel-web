import 'dart:developer';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:aiponics_web_app/controllers/network%20controllers/network_controller.dart';
import 'package:aiponics_web_app/routes/route.dart';
import 'package:aiponics_web_app/views/drawer_screen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../api information/api_constants.dart';
import '../token controllers/access_and_refresh_token_controller.dart';

class LoginController {

  static Future<Map<String, dynamic>> signInInSecured(
      GlobalKey<FormState> formKey,
      TextEditingController usernameController,
      TextEditingController passwordController,
      bool isRememberPassword,
      BuildContext context,) async {
    if (formKey.currentState!.validate()) {
      final String username = usernameController.text.trim();
      final String password = passwordController.text;

      try {
        if (await NetworkController.isInternetAvailable()) {
          final dio = Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 10),
          ));

          final response = await dio.post(
            loginApi,
            data: {
              'username': username,
              'password': password,
            },
            options: Options(
              headers: {
                "Content-Type": "application/json",
              },
            ),
          );

          // Add a unique identifier to the log output.
          log("LOGIN_RESPONSE: Received response with status code ${response.statusCode}");

          if (response.statusCode == 200) {
            log("LOGIN_RESPONSE: Login Successful");
            log("LOGIN_RESPONSE: Response: ${response.data}");

            final Map<String, dynamic> responseMap = response.data;
            String accessToken = responseMap["access"];
            String refreshToken = responseMap["refresh"];
            await saveTokens(
                accessToken, refreshToken, isRememberPassword ? "true" : "false")
                .then((value) async {
              await savePassword(password).then((value) {
                log("LOGIN_RESPONSE: ✅ Api-Response-Log APIs-Response Login Successful");
                log("LOGIN_RESPONSE: 🔑 Api-Response-Log Access Token: $accessToken");
                log("LOGIN_RESPONSE: 🔄 Api-Response-Log Refresh Token: $refreshToken");

                CommonMethods.showSnackBarWithoutContext(
                    "Success", "Login Successful", ContentType.success);
              });
            });

            Get.to(() => const DrawerScreen(TRoutes.dashboard),
                routeName: TRoutes.dashboard);
            return {'success': true, 'message': responseMap['message']};
          } else if (response.statusCode == 400) {
            log("LOGIN_RESPONSE: Response error ${response.statusCode}");
            log("LOGIN_RESPONSE: Response error ${response.data}");
            final Map<String, dynamic> responseMap = response.data;
            return {
              'success': false,
              'message': 'Error ${responseMap['non_field_errors'][0]}'
            };
          } else {
            log("LOGIN_RESPONSE: Response error ${response.statusCode}");
            log("LOGIN_RESPONSE: Response error ${response.data}");
            return {
              'success': false,
              'message': 'Error Please try again later'
            };
          }
        } else {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Internet not available", ContentType.failure);
          return {'success': false, 'message': 'Internet not available'};
        }
      } on DioException catch (e) {
        if(e.response != null && e.response?.data['non_field_errors'][0].contains("Invalid")){
          return {
            'success': false,
            'message': 'Invalid credentials.'
          };
        }else{
          log("LOGIN_RESPONSE: Login failed: ${e.message} - ${e.error} - ${e.response?.data}");
        }
        return {
          'success': false,
          'message': 'An error occurred. Please try again later.'
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Please fill all details to continue'
      };
    }
  }
}
