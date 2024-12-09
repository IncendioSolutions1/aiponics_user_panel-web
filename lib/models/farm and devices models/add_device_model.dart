import 'package:flutter/material.dart';

class AddDeviceModel {
  final bool acquiredThroughUs;
  final bool userOwnDevice;

  final TextEditingController deviceName;
  final TextEditingController farm;
  final TextEditingController noOfFans;
  final TextEditingController noOfPumps;
  final TextEditingController noOfLights;
  final TextEditingController noOfCoolingPumps;
  final TextEditingController noOfMistingPumps;
  final TextEditingController waterTankSize;
  final TextEditingController deviceEmei;
  final TextEditingController parameter;

  final List<String> airParametersTypesList;
  final List<IconData> airParametersIconsList;
  final Map<String, bool> airCheckboxValues;
  final List<String> soilParametersTypesList;
  final List<IconData> soilParametersIconsList;
  final Map<String, bool> soilCheckboxValues;
  final List<String> devicesTypesList;
  final List<String> farmTypesList;

  final String climateControlSystem;
  final String dosingSystem;
  final String conventionalSystem;

  final String farmType;
  final String openFarm;
  final String itemToDisable;

  AddDeviceModel({
    required this.acquiredThroughUs,
    required this.userOwnDevice,
    required this.deviceName,
    required this.farm,
    required this.noOfFans,
    required this.noOfPumps,
    required this.noOfLights,
    required this.noOfCoolingPumps,
    required this.noOfMistingPumps,
    required this.waterTankSize,
    required this.deviceEmei,
    required this.parameter,
    required this.airParametersTypesList,
    required this.airParametersIconsList,
    required this.airCheckboxValues,
    required this.soilParametersTypesList,
    required this.soilParametersIconsList,
    required this.soilCheckboxValues,
    required this.devicesTypesList,
    required this.farmTypesList,
    required this.climateControlSystem,
    required this.dosingSystem,
    required this.conventionalSystem,
    required this.farmType,
    required this.openFarm,
    required this.itemToDisable,
  });

  AddDeviceModel copyWith({
    bool? acquiredThroughUs,
    bool? userOwnDevice,
    TextEditingController? deviceName,
    TextEditingController? farm,
    TextEditingController? noOfFans,
    TextEditingController? noOfPumps,
    TextEditingController? noOfLights,
    TextEditingController? noOfCoolingPumps,
    TextEditingController? noOfMistingPumps,
    TextEditingController? waterTankSize,
    TextEditingController? deviceEmei,
    TextEditingController? parameter,
    List<String>? airParametersTypesList,
    List<IconData>? airParametersIconsList,
    Map<String, bool>? airCheckboxValues,
    List<String>? soilParametersTypesList,
    List<IconData>? soilParametersIconsList,
    Map<String, bool>? soilCheckboxValues,
    List<String>? devicesTypesList,
    List<String>? farmTypesList,
    String? climateControlSystem,
    String? dosingSystem,
    String? conventionalSystem,
    String? farmType,
    String? openFarm,
    String? itemToDisable,
  }) {
    return AddDeviceModel(
      acquiredThroughUs: acquiredThroughUs ?? this.acquiredThroughUs,
      userOwnDevice: userOwnDevice ?? this.userOwnDevice,
      deviceName: deviceName ?? this.deviceName,
      farm: farm ?? this.farm,
      noOfFans: noOfFans ?? this.noOfFans,
      noOfPumps: noOfPumps ?? this.noOfPumps,
      noOfLights: noOfLights ?? this.noOfLights,
      noOfCoolingPumps: noOfCoolingPumps ?? this.noOfCoolingPumps,
      noOfMistingPumps: noOfMistingPumps ?? this.noOfMistingPumps,
      waterTankSize: waterTankSize ?? this.waterTankSize,
      deviceEmei: deviceEmei ?? this.deviceEmei,
      parameter: parameter ?? this.parameter,
      airParametersTypesList: airParametersTypesList ?? this.airParametersTypesList,
      airParametersIconsList: airParametersIconsList ?? this.airParametersIconsList,
      airCheckboxValues: airCheckboxValues ?? this.airCheckboxValues,
      soilParametersTypesList: soilParametersTypesList ?? this.soilParametersTypesList,
      soilParametersIconsList: soilParametersIconsList ?? this.soilParametersIconsList,
      soilCheckboxValues: soilCheckboxValues ?? this.soilCheckboxValues,
      devicesTypesList: devicesTypesList ?? this.devicesTypesList,
      farmTypesList: farmTypesList ?? this.farmTypesList,
      climateControlSystem: climateControlSystem ?? this.climateControlSystem,
      dosingSystem: dosingSystem ?? this.dosingSystem,
      conventionalSystem: conventionalSystem ?? this.conventionalSystem,
      farmType: farmType ?? this.farmType,
      openFarm: openFarm ?? this.openFarm,
      itemToDisable: itemToDisable ?? this.itemToDisable,
    );
  }
}
