import 'package:flutter/material.dart';

import 'device_model.dart';


class AddDeviceModel {
  final bool acquiredThroughUs;
  final bool userOwnDevice;

  final bool areFarmsLoading;
  final DeviceModel deviceModel;

  final bool isEditing;

  final List<String> airParametersTypesList;
  final List<IconData> airParametersIconsList;
  final Map<String, bool> airCheckboxValues;
  final List<String> soilParametersTypesList;
  final List<IconData> soilParametersIconsList;
  final Map<String, bool> soilCheckboxValues;
  final List<String> devicesTypesList;
  final Map<int, String> farmTypesList;


  AddDeviceModel({
    required this.acquiredThroughUs,
    required this.userOwnDevice,
    required this.deviceModel,

    required this.airParametersTypesList,
    required this.airParametersIconsList,
    required this.airCheckboxValues,

    required this.soilParametersTypesList,
    required this.soilParametersIconsList,
    required this.soilCheckboxValues,

    required this.devicesTypesList,
    required this.farmTypesList,
    this.areFarmsLoading = false,
    this.isEditing = false,
  });

  AddDeviceModel copyWith({
    bool? acquiredThroughUs,
    bool? userOwnDevice,
    List<String>? airParametersTypesList,
    List<IconData>? airParametersIconsList,
    Map<String, bool>? airCheckboxValues,
    List<String>? soilParametersTypesList,
    List<IconData>? soilParametersIconsList,
    Map<String, bool>? soilCheckboxValues,
    List<String>? devicesTypesList,
    Map<int, String>? farmTypesList,
    DeviceModel? deviceModel,
    bool? areFarmsLoading,
    bool? isEditing,
  }) {
    return AddDeviceModel(
      acquiredThroughUs: acquiredThroughUs ?? this.acquiredThroughUs,
      userOwnDevice: userOwnDevice ?? this.userOwnDevice,
      airParametersTypesList: airParametersTypesList ?? this.airParametersTypesList,
      airParametersIconsList: airParametersIconsList ?? this.airParametersIconsList,
      airCheckboxValues: airCheckboxValues ?? this.airCheckboxValues,
      soilParametersTypesList: soilParametersTypesList ?? this.soilParametersTypesList,
      soilParametersIconsList: soilParametersIconsList ?? this.soilParametersIconsList,
      soilCheckboxValues: soilCheckboxValues ?? this.soilCheckboxValues,
      devicesTypesList: devicesTypesList ?? this.devicesTypesList,
      farmTypesList: farmTypesList ?? this.farmTypesList,
      deviceModel: deviceModel ?? this.deviceModel,
      areFarmsLoading: areFarmsLoading ?? this.areFarmsLoading,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
