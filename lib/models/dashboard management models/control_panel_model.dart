import 'package:flutter/material.dart';

class ControlPanelInfoModel {
  final int noOfFans;
  final int noOfWaterPumps;
  final int noOfMistingPumps;
  final double phOldValue;
  final double tdsOldValue;
  final double waterLevelOldValue;
  final bool isWaterLevelManual;
  final bool isMonitoringSystemManual;
  final int selectedTabButtonIndex;
  final List<String> tabButtonNamesList;
  final List<List<bool>> buttonsStateLists;
  final List<int> monitoringSystemButtonsCount;
  final String remainingTime;
  final TimeOfDay? startTimeTimerProvider;
  final TimeOfDay? endTimeTimerProvider;
  final int countdownTimeInSeconds;
  final int countdownRemainingTimeInMilliSeconds;
  final List<String> controlPanelGaugesLabels;
  final List<IconData> controlPanelGaugesIcons;
  final List<double> controlPanelGaugesValues;

  ControlPanelInfoModel({
    this.noOfFans = 0,
    this.noOfWaterPumps = 0,
    this.noOfMistingPumps = 0,
    this.phOldValue = 0,
    this.tdsOldValue = 0,
    this.waterLevelOldValue = 0,
    this.isWaterLevelManual = true,
    this.isMonitoringSystemManual = true,
    this.selectedTabButtonIndex = 0,
    required this.tabButtonNamesList,
    required this.buttonsStateLists,
    required this.monitoringSystemButtonsCount,
    this.remainingTime = "",
    this.startTimeTimerProvider,
    this.endTimeTimerProvider,
    this.countdownTimeInSeconds = 0,
    this.countdownRemainingTimeInMilliSeconds = 0,
    required this.controlPanelGaugesLabels,
    required this.controlPanelGaugesIcons,
    required this.controlPanelGaugesValues,
  });

  // Add copyWith method for immutability
  ControlPanelInfoModel copyWith({
    int? noOfFans,
    int? noOfWaterPumps,
    int? noOfMistingPumps,
    double? phOldValue,
    double? tdsOldValue,
    double? waterLevelOldValue,
    bool? isWaterLevelManual,
    bool? isMonitoringSystemManual,
    int? selectedTabButtonIndex,
    List<String>? tabButtonNamesList,
    List<List<bool>>? buttonsStateLists,
    List<int>? monitoringSystemButtonsCount,
    String? remainingTime,
    TimeOfDay? startTimeTimerProvider,
    TimeOfDay? endTimeTimerProvider,
    int? countdownTimeInSeconds,
    int? countdownRemainingTimeInMilliSeconds,
    List<String>? controlPanelGaugesLabels,
    List<IconData>? controlPanelGaugesIcons,
    List<double>? controlPanelGaugesValues,
  }) {
    return ControlPanelInfoModel(
      noOfFans: noOfFans ?? this.noOfFans,
      noOfWaterPumps: noOfWaterPumps ?? this.noOfWaterPumps,
      noOfMistingPumps: noOfMistingPumps ?? this.noOfMistingPumps,
      phOldValue: phOldValue ?? this.phOldValue,
      tdsOldValue: tdsOldValue ?? this.tdsOldValue,
      waterLevelOldValue: waterLevelOldValue ?? this.waterLevelOldValue,
      isWaterLevelManual: isWaterLevelManual ?? this.isWaterLevelManual,
      isMonitoringSystemManual: isMonitoringSystemManual ?? this.isMonitoringSystemManual,
      selectedTabButtonIndex: selectedTabButtonIndex ?? this.selectedTabButtonIndex,
      tabButtonNamesList: tabButtonNamesList ?? this.tabButtonNamesList,
      buttonsStateLists: buttonsStateLists ?? this.buttonsStateLists,
      monitoringSystemButtonsCount: monitoringSystemButtonsCount ?? this.monitoringSystemButtonsCount,
      remainingTime: remainingTime ?? this.remainingTime,
      startTimeTimerProvider : startTimeTimerProvider ?? this.startTimeTimerProvider,
      endTimeTimerProvider : endTimeTimerProvider ?? this.endTimeTimerProvider,
      countdownTimeInSeconds : countdownTimeInSeconds ?? this.countdownTimeInSeconds,
      countdownRemainingTimeInMilliSeconds : countdownRemainingTimeInMilliSeconds ?? this.countdownRemainingTimeInMilliSeconds,
      controlPanelGaugesLabels : controlPanelGaugesLabels ?? this.controlPanelGaugesLabels,
      controlPanelGaugesIcons : controlPanelGaugesIcons ?? this.controlPanelGaugesIcons,
      controlPanelGaugesValues : controlPanelGaugesValues ?? this.controlPanelGaugesValues,
    );
  }

}