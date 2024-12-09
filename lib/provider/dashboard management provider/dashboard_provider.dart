import 'dart:developer';
import 'package:aiponics_web_app/models/dashboard%20management%20models/dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardInfoNotifier extends StateNotifier<DashboardInfoModel> {
  DashboardInfoNotifier() : super(_initialState()) {
    _simulateApiCallForControlPanel();
  }

  /// Initialize state with default values
  static DashboardInfoModel _initialState() {
    return DashboardInfoModel(
      farmTemperature: null,
      externalTemperature: null,
      farmHumidity: null,
      externalHumidity: null,
      waterTemperature: null,
      waterLevel: null,
      pHLevel: null,
      energyConsumption: null,
      lightIntensity: null,
      farmCoLevel: null,
      selectedGraphType: 'Line Graph',
      devices: [
        'Device 1',
        'Device 2',
        'Device 3',
        'Device 4',
      ],
      graphTypes: [
        'Line Graph',
        'Histogram',
        'Scatter Graph',
        'Box Graph',
        'Bubble Graph',
      ],
      tdsValues: null,
    );
  }

  /// Simulate an API call to fetch data
  Future<void> _simulateApiCallForControlPanel() async {
    try {
      // Simulating network request (replace this with actual API call)
      // await Future.delayed(
      //     const Duration(seconds: 2)); // Simulate network delay

      // Replace with actual API response parsing
      final Map<String, dynamic> fetchedData = {
        "farmTemperature": double.parse("10"),
        "externalTemperature": double.parse("20"),
        "farmHumidity": double.parse("30"),
        "externalHumidity": double.parse("40"),
        "waterTemperature": double.parse("50"),
        "waterLevel": double.parse("60"),
        "pHLevel": double.parse("05"),
        "farmCoLevel": double.parse("90"),
      };

      final Map<String, List<Map<int, double>>> fetchedDataEnergyAndLight = {
        "energyConsumption": [{1:10}, {2:20}, {3:30}, {4:40}, {5:50},],
        "lightIntensity": [{1:10}, {2:20}, {3:30}, {4:40}, {5:50},],
      };

      final Map<String, List<Map<double, double>>> fetchedDataTds = {
        "tds": [{0:0.1}, {2:0.2}, {3:0.3}, {4:0.4}, {5:0.5}, {6:0.4}, {7:0.3}, {8:0.2}, {9:0.1}, {10:0.0},],
      };

      // Update state with fetched data
      state = state.copyWith(
        farmTemperature: fetchedData["farmTemperature"],
        externalTemperature: fetchedData["externalTemperature"],
        farmHumidity: fetchedData["farmHumidity"],
        externalHumidity: fetchedData["externalHumidity"],
        waterTemperature: fetchedData["waterTemperature"],
        waterLevel: fetchedData["waterLevel"],
        pHLevel: fetchedData["pHLevel"],
        energyConsumption: fetchedDataEnergyAndLight["energyConsumption"],
        lightIntensity: fetchedDataEnergyAndLight["lightIntensity"],
        farmCoLevel: fetchedData["farmCoLevel"],
        tdsValues: fetchedDataTds["tds"],
      );
    } catch (e) {
      // Handle errors, e.g., log or show error messages
      log("Error fetching dashboard data: $e");
    }
  }

  void updateSelectedDevice(String newValue){
    state = state.copyWith(selectedDevice: newValue);
  }

  void updateSelectedGraphType(String newValue){
    state = state.copyWith(selectedGraphType: newValue);
  }
  void updateSelectedDate(DateTime picked){
    state = state.copyWith(selectedDate: picked);
  }
}

/// Riverpod provider for ControlPanelInfoModel
final dashboardInfoProvider =
StateNotifierProvider<DashboardInfoNotifier, DashboardInfoModel>(
      (ref) {
    return DashboardInfoNotifier();
  },
);
