import 'dart:developer';

import 'package:aiponics_web_app/models/dashboard%20management%20models/control_panel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControlPanelInfoNotifier extends StateNotifier<ControlPanelInfoModel> {
  ControlPanelInfoNotifier() : super(_initialState()) {
    _simulateApiCallForControlPanel();
  }

  /// Initialize state with default values
  static ControlPanelInfoModel _initialState() {
    return ControlPanelInfoModel(
      tabButtonNamesList: ["Fan", "Pump", "Misting"],
      buttonsStateLists: [
        [true, false],
        [false, true],
        [true, true],
      ],
      monitoringSystemButtonsCount: [2, 2, 2],
      remainingTime: "00:00:00",
      controlPanelGaugesValues: [],
      controlPanelGaugesIcons: [],
      controlPanelGaugesLabels: [],
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
        "noOfFans": 11,
        "noOfWaterPumps": 3,
        "noOfMistingPumps": 3,
        "buttonsStateLists": [
          [false, true, true, true, true, true, true, true, true, true, true],
          [true, false, false],
          [false, false, true],
        ],
        "monitoringSystemButtonsCount": [11, 3, 3],
        "controlPanelGaugesLabels": [
          "Farm Temperature",
          "Farm Humidity",
          "External Temperature",
          "External Humidity"
        ],
        "controlPanelGaugesIcons": [
          Icons.thermostat,
          Icons.water_drop,
          Icons.ac_unit,
          Icons.cloud_queue
        ],
        "controlPanelGaugesValues": [10.0, 20.0, 30.0, 40.0],
      };

      // Update state with fetched data
      state = state.copyWith(
        noOfFans: fetchedData["noOfFans"],
        noOfWaterPumps: fetchedData["noOfWaterPumps"],
        noOfMistingPumps: fetchedData["noOfMistingPumps"],
        buttonsStateLists: fetchedData["buttonsStateLists"],
        monitoringSystemButtonsCount:
            fetchedData["monitoringSystemButtonsCount"],
        controlPanelGaugesLabels: fetchedData["controlPanelGaugesLabels"],
        controlPanelGaugesIcons: fetchedData["controlPanelGaugesIcons"],
        controlPanelGaugesValues: fetchedData["controlPanelGaugesValues"],
      );
    } catch (e) {
      // Handle errors, e.g., log or show error messages
      log("Error fetching control panel data: $e");
    }
  }

  // Other methods to update state remain unchanged
  void updateFans(int newCount) {
    state = state.copyWith(noOfFans: newCount);
  }

  void updateWaterPumps(int newCount) {
    state = state.copyWith(noOfWaterPumps: newCount);
  }

  void updateMistingPumps(int newCount) {
    state = state.copyWith(noOfMistingPumps: newCount);
  }

  void updatePhValue(double newValue) {
    state = state.copyWith(phOldValue: newValue);
  }

  void updateTdsValue(double newValue) {
    state = state.copyWith(tdsOldValue: newValue);
  }

  void updateWaterLevel(double newValue) {
    state = state.copyWith(waterLevelOldValue: newValue);
  }

  void toggleWaterLevelManual() {
    state = state.copyWith(isWaterLevelManual: !state.isWaterLevelManual);
  }

  void toggleMonitoringSystemManual() {
    state = state.copyWith(
        isMonitoringSystemManual: !state.isMonitoringSystemManual);
  }

  void updateSelectedTabButtonIndex(int newIndex) {
    state = state.copyWith(selectedTabButtonIndex: newIndex);
  }

  void updateRemainingTime(String newTime) {
    state = state.copyWith(remainingTime: newTime);
  }

  void updateStartTimeTimer(TimeOfDay startTime) {
    state = state.copyWith(startTimeTimerProvider: startTime);
  }

  void updateEndTimeTimer(TimeOfDay endTime) {
    state = state.copyWith(endTimeTimerProvider: endTime);
  }

  void updateCountdownTimeInSeconds(int endTime) {
    state = state.copyWith(countdownTimeInSeconds: endTime);
  }

  void updateCountdownRemainingTimeInMilliSeconds(int endTime) {
    state = state.copyWith(countdownRemainingTimeInMilliSeconds: endTime);
  }

  void updateStatusOfMonitoringSystemButtonState(
      int indexForSelectedMonitoringSystem, int indexForSelectedButton) {
    // Create a copy of the current buttonsStateLists
    final updatedButtonsStateLists = [...state.buttonsStateLists];

    // Update the specific button's state
    updatedButtonsStateLists[indexForSelectedMonitoringSystem] = [
      ...updatedButtonsStateLists[indexForSelectedMonitoringSystem]
    ];
    updatedButtonsStateLists[indexForSelectedMonitoringSystem]
            [indexForSelectedButton] =
        !updatedButtonsStateLists[indexForSelectedMonitoringSystem]
            [indexForSelectedButton];

    // Update the state with the modified list
    state = state.copyWith(
      buttonsStateLists: updatedButtonsStateLists,
    );
  }

  void updateButtonStatesAndCounts({
    required List<List<bool>> newButtonStates,
    required List<int> newButtonCounts,
  }) {
    state = state.copyWith(
      buttonsStateLists: newButtonStates,
      monitoringSystemButtonsCount: newButtonCounts,
    );
  }
}

/// Riverpod provider for ControlPanelInfoModel
final controlPanelInfoProvider =
    StateNotifierProvider<ControlPanelInfoNotifier, ControlPanelInfoModel>(
  (ref) {
    return ControlPanelInfoNotifier();
  },
);
