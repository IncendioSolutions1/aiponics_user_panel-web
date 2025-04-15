import 'dart:convert';
import 'dart:developer';
import 'package:aiponics_web_app/api%20information/api_constants.dart';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:aiponics_web_app/controllers/network%20controllers/network_controller.dart';
import 'package:aiponics_web_app/models/farm%20and%20devices%20models/device_model.dart';
import 'package:aiponics_web_app/provider/farm%20and%20devices%20provider/add_device_provider.dart';
import 'package:aiponics_web_app/provider/farm%20and%20devices%20provider/add_farm_provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/farm and devices models/add_device_model.dart';
import '../../provider/farm and devices provider/view_farms_and_devices_provider.dart';
import '../token controllers/access_and_refresh_token_controller.dart'; // Import your snackbar utility

class DeviceService {

  static Future<bool> addDeviceToServer(WidgetRef ref, String dosingSystem, String climateControlSystem, String conventionalSystem) async {
    bool status = false;


    AddDeviceModel addDeviceModel = ref.watch(addDeviceProvider);
    Map<String, dynamic> dataToSend = {};

    dataToSend['name'] = addDeviceModel.deviceModel.name;
    dataToSend['device_type'] = addDeviceModel.deviceModel.deviceType.toString().toLowerCase();
    dataToSend['farm'] = addDeviceModel.deviceModel.farm;
    dataToSend['imei_or_api_key'] = addDeviceModel.deviceModel.imeiOrApiKey;

    if(addDeviceModel.deviceModel.deviceType != conventionalSystem){

      dataToSend['num_fans'] = addDeviceModel.deviceModel.numFans;
      dataToSend['num_cooling_pumps'] = addDeviceModel.deviceModel.numCoolingPumps;
      dataToSend['num_water_supply_pumps'] = addDeviceModel.deviceModel.numWaterSupplyPumps;
      dataToSend['num_lights'] = addDeviceModel.deviceModel.numLights;
      dataToSend['num_humidity_sensors'] = addDeviceModel.deviceModel.numHumiditySensors;
      dataToSend['num_temperature_sensors'] = 0;
      dataToSend['water_tank_size'] = addDeviceModel.deviceModel.waterTankSize;

    }else{
      final List<String> selectedAirParameters = addDeviceModel.airCheckboxValues.entries
          .where((entry) => entry.value == true) // Filter entries where value is true
          .map((entry) => entry.key) // Extract only the keys
          .toList();

      final List<String> selectedSoilParameters = addDeviceModel.soilCheckboxValues.entries
          .where((entry) => entry.value == true) // Filter entries where value is true
          .map((entry) => entry.key) // Extract only the keys
          .toList();

      log("Air Parameters: $selectedAirParameters");
      log("Soil Parameters: $selectedSoilParameters");

      dataToSend["parameters"] = {
          "air": selectedAirParameters,
          "soil": selectedSoilParameters,
      };
    }


    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", "failure");
      return status;
    }


    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        ));

        final response = await dio.post(
          addDeviceApi,
          data: dataToSend,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("Device_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("Device_RESPONSE: Device updated successfully");
          log("Device_RESPONSE: Response Data: ${response.data}");

          CommonMethods.showSnackBarWithoutContext(
              "Success", "Device added successfully", "success");
          status = true;
        } else {
          log("Device_RESPONSE: Response error ${response.statusCode}");
          log("Device_RESPONSE: Response error ${response.data}");
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Error adding Device. Please try again.", "failure");
        }
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "Internet not available", "failure");
      }
    } on DioException catch (e) {
      log("Device_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");

      if (e.response?.statusCode == 403 &&
          e.response?.data['detail'].contains("Free plan allows only one device")) {
        CommonMethods.showSnackBarWithoutContext(
            "Devices limit reached",
            "Free plan allows only 1 Device. Upgrade to a paid plan to add more Devices.",
            "failure");
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      }
    }

    return status;
  }

  static Future<bool> updateDeviceToServer(WidgetRef ref, String dosingSystem, String climateControlSystem, String conventionalSystem) async {
    bool status = false;


    AddDeviceModel addDeviceModel = ref.watch(addDeviceProvider);
    Map<String, dynamic> dataToSend = {};

    dataToSend['name'] = addDeviceModel.deviceModel.name;
    dataToSend['device_type'] = addDeviceModel.deviceModel.deviceType.toString().toLowerCase();
    dataToSend['farm'] = addDeviceModel.deviceModel.farm;
    dataToSend['imei_or_api_key'] = addDeviceModel.deviceModel.imeiOrApiKey;

    if(addDeviceModel.deviceModel.deviceType != conventionalSystem){

      dataToSend['num_fans'] = addDeviceModel.deviceModel.numFans;
      dataToSend['num_cooling_pumps'] = addDeviceModel.deviceModel.numCoolingPumps;
      dataToSend['num_water_supply_pumps'] = addDeviceModel.deviceModel.numWaterSupplyPumps;
      dataToSend['num_lights'] = addDeviceModel.deviceModel.numLights;
      dataToSend['num_humidity_sensors'] = addDeviceModel.deviceModel.numHumiditySensors;
      dataToSend['num_temperature_sensors'] = 0;
      dataToSend['water_tank_size'] = addDeviceModel.deviceModel.waterTankSize;

    }else{
      final List<String> selectedAirParameters = addDeviceModel.airCheckboxValues.entries
          .where((entry) => entry.value == true) // Filter entries where value is true
          .map((entry) => entry.key) // Extract only the keys
          .toList();

      final List<String> selectedSoilParameters = addDeviceModel.soilCheckboxValues.entries
          .where((entry) => entry.value == true) // Filter entries where value is true
          .map((entry) => entry.key) // Extract only the keys
          .toList();

      log("Air Parameters: $selectedAirParameters");
      log("Soil Parameters: $selectedSoilParameters");

      dataToSend["parameters"] = {
        "air": selectedAirParameters,
        "soil": selectedSoilParameters,
      };
    }


    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", "failure");
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
          "$updateDeviceApi${addDeviceModel.deviceModel.id}/",
          data: dataToSend,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("Device_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("Device_RESPONSE: Device added successfully");
          log("Device_RESPONSE: Response Data: ${response.data}");

          CommonMethods.showSnackBarWithoutContext(
              "Success", "Device updated successfully", "success");
          status = true;
        } else {
          log("Device_RESPONSE: Response error ${response.statusCode}");
          log("Device_RESPONSE: Response error ${response.data}");
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Error updating Device. Please try again.", "failure");
        }
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "Internet not available", "failure");
      }
    } on DioException catch (e) {
      log("Device_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");

      if (e.response?.statusCode == 403 &&
          e.response?.data['detail'].contains("Free plan allows only one device")) {
        CommonMethods.showSnackBarWithoutContext(
            "Devices limit reached",
            "Free plan allows only 1 Device. Upgrade to a paid plan to add more Devices.",
            "failure");
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      }
    }

    return status;
  }

  static Future<bool> deleteDeviceFromServer(WidgetRef ref) async {
    bool status = false;


    AddDeviceModel addDeviceModel = ref.watch(addDeviceProvider);

    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", "failure");
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
          "$deleteDeviceApi${addDeviceModel.deviceModel.id}/",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("Device_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("Device_RESPONSE: Device deleted successfully");
          log("Device_RESPONSE: Response Data: ${response.data}");

          CommonMethods.showSnackBarWithoutContext(
              "Success", "Device added successfully", "success");
          status = true;
        } else {
          log("Device_RESPONSE: Response error ${response.statusCode}");
          log("Device_RESPONSE: Response error ${response.data}");
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Error adding Device. Please try again.", "failure");
        }
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "Internet not available", "failure");
      }
    } on DioException catch (e) {
      log("Device_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");

      if (e.response?.statusCode == 403 &&
          e.response?.data['detail'].contains("Free plan allows only one device")) {
        CommonMethods.showSnackBarWithoutContext(
            "Devices limit reached",
            "Free plan allows only 1 Device. Upgrade to a paid plan to add more Devices.",
            "failure");
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      }
    }

    return status;
  }

  static Future< Map<bool, List<DeviceModel>>> fetchDevices(int farmId) async {
    Map<bool, List<DeviceModel>> deviceModels = {};
    deviceModels[false] = [];
    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      CommonMethods.showSnackBarWithoutContext(
          "Error", "An error occurred. Please try again later.", "failure");
      return deviceModels;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

        // Fetch Devices for Each Device
        String apiUrl2 = "$viewDevicesApi$farmId/devices";
        try {
          final response2 = await dio.get(
            apiUrl2,
            options: Options(
              headers: {
                "Authorization": "Bearer $bearerToken",
              },
            ),
          );

          if (response2.statusCode == 200) {
            dynamic rawData = response2.data;
            List<dynamic> devicesData = rawData is String ? jsonDecode(rawData) : rawData;

            log('Devices Data for $farmId: ${jsonEncode(devicesData)}');

            deviceModels.clear();
            deviceModels[true] = devicesData.map<DeviceModel>((json) => DeviceModel.fromJson(json)).toList();

          } else {
            log("DEVICE_FETCH_RESPONSE: Error ${response2.statusCode} - ${response2.data}");
          }
        } catch (e) {
          log('DEVICE_FETCH_EXCEPTION: $e');
        }
      }
    } on DioException catch (e) {
      log("DEVICE_FETCH_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");

      if (e.response?.statusCode == 403 &&
          e.response?.data['detail'].contains("Free plan allows only 1 Device")) {
        CommonMethods.showSnackBarWithoutContext(
            "Devices limit reached",
            "Free plan allows only 1 Device. Upgrade to a paid plan to add more Devices.",
            "failure");
      } else {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      }
    }
    return deviceModels;
  }
}
