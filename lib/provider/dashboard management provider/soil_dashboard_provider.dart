import 'dart:developer';
import 'package:aiponics_web_app/models/dashboard%20management%20models/soil_dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoilInfoNotifier extends StateNotifier<SoilInfoModel> {
  SoilInfoNotifier() : super(_initialState()) {
    _simulateApiCallForControlPanel();
  }

  /// Initialize state with default values
  static SoilInfoModel _initialState() {
    return SoilInfoModel(
        airTemperature: null,
        windDirection: null,
        windSpeed: null,
        airHumidity: null,
        solarRadiation: null,
        barometricPressure: null,
        rainGauge: null,
        moistureLevel: null,
        electricalConductivity: null,
        pHLevel: null,
        soilTemperature: null,
        salinity: null,
        npkValues: null,
        gaugesNames: []
    );
  }

  /// Simulate an API call to fetch data
  Future<void> _simulateApiCallForControlPanel() async {
    try {
      // Simulating network request (replace this with actual API call)
      // await Future.delayed(
      //     const Duration(seconds: 2)); // Simulate network delay

      // Replace with actual API response parsing
      final Map<String, double?> fetchedData = {
        "airTemperature": 25.5,
        "windDirection": 120.0,
        "windSpeed": 15.3,
        "airHumidity": 60.0,
        "solarRadiation": 500.0,
        "barometricPressure": 1013.0,
        "rainGauge": 5.2,
        "moistureLevel": 45.0,
        "electricalConductivity": 1.2,
        "pHLevel": 6.8,
        "soilTemperature": 22.4,
        "salinity": 0.8,
      };

      final Map<String, List<List<double>>> fetchedDataNpk = {
        "npk": [[0,0,1], [2,0,2], [3,0,3], [4,0,4], [5,0,5], [6,0,4], [7,0,3], [8,0,2], [9,0,1], [10,0,3],],
      };

      // Update state with fetched data
      state = state.copyWith(
        airTemperature: fetchedData["airTemperature"],
        windDirection: fetchedData["windDirection"],
        windSpeed: fetchedData["windSpeed"],
        airHumidity: fetchedData["airHumidity"],
        solarRadiation: fetchedData["solarRadiation"],
        barometricPressure: fetchedData["barometricPressure"],
        rainGauge: fetchedData["rainGauge"],
        moistureLevel: fetchedData["moistureLevel"],
        electricalConductivity: fetchedData["electricalConductivity"],
        pHLevel: fetchedData["pHLevel"],
        soilTemperature: fetchedData["soilTemperature"],
        salinity: fetchedData["salinity"],
        npkValues: fetchedDataNpk["npk"],
      );
    } catch (e) {
      // Handle errors, e.g., log or show error messages
      log("Error fetching dashboard data: $e");
    }
  }

}

/// Riverpod provider for ControlPanelInfoModel
final soilDashboardInfoProvider =
StateNotifierProvider<SoilInfoNotifier, SoilInfoModel>(
      (ref) {
    return SoilInfoNotifier();
  },
);
