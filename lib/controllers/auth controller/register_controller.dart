import 'dart:developer';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:aiponics_web_app/views/drawer_screen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../api information/api_constants.dart';
import '../../routes/route.dart';
import '../network controllers/network_controller.dart';

class RegisterController {
  static Future<Map<String, dynamic>> registerUser(
      GlobalKey<FormState> formKey,
      TextEditingController userNameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      BuildContext context,
      ) async {
    if (formKey.currentState!.validate()) {
      try {
        if (await NetworkController.isInternetAvailable()) {
          final dio = Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 10),
          ));
          String apiUrl = registerApi;

          final response = await dio.post(
            apiUrl,
            data: {
              'username': userNameController.text.trim(),
              'email': emailController.text.trim(),
              'password': passwordController.text.trim(),
              "role": ["regular"],
              "first_name": firstNameController.text.trim(),
              "last_name": lastNameController.text.trim(),
            },
            options: Options(
              headers: {
                "Content-Type": "application/json",
              },
            ),
          );

          if (response.statusCode == 200) {
            log("REGISTER_RESPONSE: Registration Successful");
            final Map<String, dynamic> responseMap = response.data;
            Get.to(() => const DrawerScreen(TRoutes.login),
                routeName: TRoutes.login);
            return {'success': true, 'message': responseMap['status']};
          } else if (response.statusCode == 400) {
            final Map<String, dynamic> responseBody = response.data;
            String errorMessage = "An error occurred. Please try again later.";
            if (responseBody.containsKey('username')) {
              errorMessage = responseBody['username'][0];
            } else if (responseBody.containsKey('email')) {
              errorMessage = responseBody['email'][0];
            }
            log("REGISTER_RESPONSE: $errorMessage");
            return {'success': false, 'message': errorMessage};
          }
          log("REGISTER_RESPONSE: Response error ${response.statusCode}");
          log("REGISTER_RESPONSE: Response error ${response.data}");
          return {
            'success': false,
            'message': 'An error occurred. Please try again later.'
          };
        } else {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Internet not available", "failure");
          return {'success': false, 'message': 'Internet not available'};
        }
      } on DioException catch (e) {
        log("REGISTER_RESPONSE: Register failed: ${e.message}");
        return {
          'success': false,
          'message': 'An error occurred. Please try again later.'
        };
      }
    } else {
      return {'success': false, 'message': 'Please fill all details to continue'};
    }
  }
}
