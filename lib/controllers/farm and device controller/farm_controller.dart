import 'dart:developer';
import 'package:aiponics_web_app/api%20information/api_constants.dart';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:aiponics_web_app/controllers/network%20controllers/network_controller.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import '../../models/farm and devices models/farm_model.dart';
import '../token controllers/access_and_refresh_token_controller.dart'; // Import your snackbar utility

class FarmService {

  static Future<FarmModel> addFarmToServer(FarmModel farmModel) async {
    FarmModel farm = FarmModel(
        id: 0,
        owner: '',
        name: '',
        regDate: '',
        location: '',
        farmsArea: 0.0,
        areaUnit: '',
        farmType: '',
        crops: '',
        farmDescription: '',
        cropDescription: '',
        images: null,
        operationalStatus: ''
    );


    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", ContentType.failure);
      return farm;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        ));

        final response = await dio.post(
          addFarmApi,
          data: farmModel.toJson(),
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("FARM_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("FARM_RESPONSE: Farm added successfully");
          log("FARM_RESPONSE: Response Data: ${response.data}");

          CommonMethods.showSnackBarWithoutContext(
              "Success", "Farm added successfully", ContentType.success);
          farm = FarmModel.fromJson(response.data);
        } else {
          log("FARM_RESPONSE: Response error ${response.statusCode}");
          log("FARM_RESPONSE: Response error ${response.data}");
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Error adding farm. Please try again.", ContentType.failure);
        }
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "Internet not available", ContentType.failure);
      }
    } on DioException catch (e) {
      log("FARM_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");

      if (e.response?.statusCode == 403 &&
          e.response?.data['detail'].contains("Free plan allows only 1 farm")) {
        CommonMethods.showSnackBarWithoutContext(
            "Farms limit reached",
            "Free plan allows only 1 farm. Upgrade to a paid plan to add more farms.",
            ContentType.failure);
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", ContentType.failure);
      }
    }

    return farm;
  }

  static Future<bool> updateFarmToServer(FarmModel farmModel) async {
    bool status = false;


    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", ContentType.failure);
      return status;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        ));

        final response = await dio.put(
          "$updateFarmApi${farmModel.id}/",
          data: farmModel.toJson(),
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("FARM_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("FARM_RESPONSE: Farm added successfully");
          log("FARM_RESPONSE: Response Data: ${response.data}");

          CommonMethods.showSnackBarWithoutContext(
              "Success", "Farm updated successfully", ContentType.success);
          status = true;
        } else {
          log("FARM_RESPONSE: Response error ${response.statusCode}");
          log("FARM_RESPONSE: Response error ${response.data}");
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Error adding farm. Please try again.", ContentType.failure);
        }
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "Internet not available", ContentType.failure);
      }
    } on DioException catch (e) {
      log("FARM_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");

      if (e.response?.statusCode == 403 &&
          e.response?.data['detail'].contains("Free plan allows only 1 farm")) {
        CommonMethods.showSnackBarWithoutContext(
            "Farms limit reached",
            "Free plan allows only 1 farm. Upgrade to a paid plan to add more farms.",
            ContentType.failure);
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", ContentType.failure);
      }
    }

    return status;
  }

  static Future<List<FarmModel>> fetchAllFarms() async {
    List<FarmModel> farmModels = [];

    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", ContentType.failure);
      });
      return farmModels;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

        final response = await dio.get(
          viewFarmsApi,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("FARM_FETCH_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("FARM_FETCH_RESPONSE: Response Data: ${response.data}");

          farmModels = response.data.map<FarmModel>((json) => FarmModel.fromJson(json)).toList();

          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Success", "${farmModels.length} Farms fetched successfully", ContentType.success);
          });
        } else {
          log("FARM_FETCH_RESPONSE: Response error ${response.statusCode}");
          log("FARM_FETCH_RESPONSE: Response error ${response.data}");
          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Error", "Error adding farm. Please try again.", ContentType.failure);
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Internet not available", ContentType.failure);
        });
      }
    } on DioException catch (e) {
      log("FARM_FETCH_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", ContentType.failure);
      });
    }

    return farmModels;
  }

  static Future<bool> deleteFarmFromServer(int farmId) async {
    bool status = false;

    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", ContentType.failure);
      return status;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        ));

        final response = await dio.delete(
          "$deleteFarmApi$farmId/",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("FARM_DELETE_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 204) {
          log("FARM_DELETE_RESPONSE: Farm deleted successfully");
          CommonMethods.showSnackBarWithoutContext(
              "Success", "Farm deleted successfully", ContentType.success);
          status = true;
        } else {
          log("FARM_DELETE_RESPONSE: Response error ${response.statusCode}");
          log("FARM_DELETE_RESPONSE: Response error ${response.data}");
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Error deleting farm. Please try again.", ContentType.failure);
        }
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "Internet not available", ContentType.failure);
      }
    } on DioException catch (e) {
      log("FARM_DELETE_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", ContentType.failure);
    }

    return status;
  }

}
