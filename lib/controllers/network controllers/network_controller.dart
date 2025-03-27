import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isOffline = false.obs;
  var isSlowOrNoInternet = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  // Check connection initially
  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  // Update connectivity status
  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) async {
    bool isConnected = connectivityResults.isNotEmpty && !connectivityResults.contains(ConnectivityResult.none);
    isOffline.value = !isConnected;

    if (isConnected) {
      isSlowOrNoInternet.value = !(await _hasWorkingInternet());
    } else {
      isSlowOrNoInternet.value = true;
    }

    // Show or hide popup
    _handleNoInternetPopup();
  }

  // Static method to check real internet availability
  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool hasNetwork = connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);

    if (!hasNetwork) return false;

    return await _hasWorkingInternet();
  }

  static Future<bool> _hasWorkingInternet() async {
    try {
      final response = await http.get(
        Uri.parse('https://dns.google/resolve?name=example.com'),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      log("⚠️ No real internet connection: $e");
      return false;
    }
  }

  // Handle Internet Popup
  void _handleNoInternetPopup() {
    if (isOffline.value) {
      log("internet is not connected");
      if (Get.isDialogOpen != true) {
        _showNoInternetDialog();
      }
    } else {
      log("internet is connected");
      if (Get.isDialogOpen == true) {
        Get.back(); // Close the dialog when internet is restored
      }
    }
  }

  // Show No Internet Popup
  void _showNoInternetDialog() {
    Get.dialog(
      PopScope(
        canPop: false, // Prevent users from manually closing the dialog
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 50, color: Colors.red),
                SizedBox(height: 15),
                Text(
                  "No Internet Connection",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Please check your internet connection and try again.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent dismissing manually
    );
  }

}
