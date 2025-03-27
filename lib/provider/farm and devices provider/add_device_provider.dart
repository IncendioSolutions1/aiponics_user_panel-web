import 'package:aiponics_web_app/models/farm%20and%20devices%20models/add_device_model.dart';
import 'package:aiponics_web_app/models/farm%20and%20devices%20models/farm_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/farm and device controller/farm_controller.dart';
import '../../models/farm and devices models/device_model.dart';

class AddDeviceNotifier extends StateNotifier<AddDeviceModel> {
  AddDeviceNotifier()
      : super(
          AddDeviceModel(
            acquiredThroughUs: false,
            userOwnDevice: false,
            deviceModel: DeviceModel(
              id: 0,
              name: '',
              deviceType: '',
              imeiOrApiKey: '',
              farm: 0,
              numFans: 0,
              numCoolingPumps: 0,
              numWaterSupplyPumps: 0,
              numLights: 0,
              numHumiditySensors: 0,
              numTemperatureSensors: 0,
              waterTankSize: 0,
              deviceId: ''
            ),
            airParametersTypesList: [
              'Wind Direction',
              'Wind Speed',
              'Solar Radiation',
              'Air Humidity',
              'Barometric Pressure',
              'Rain Gauge',
              'Air Temperature',
            ],
            airParametersIconsList: [
              FontAwesomeIcons.locationArrow,
              FontAwesomeIcons.wind,
              FontAwesomeIcons.sun,
              FontAwesomeIcons.cloudRain,
              FontAwesomeIcons.minimize,
              FontAwesomeIcons.cloudShowersHeavy,
              FontAwesomeIcons.temperatureHalf,
            ],
            airCheckboxValues: {
              for (var element in [
                'Wind Direction',
                'Wind Speed',
                'Solar Radiation',
                'Air Humidity',
                'Barometric Pressure',
                'Rain Gauge',
                'Air Temperature',
              ])
                element: false
            },
            soilParametersTypesList: [
              'NPK Values',
              'Moisture Level',
              'pH Value',
              'Electrical Conductivity',
              'Soil Temperature',
              'Salinity',
            ],
            soilParametersIconsList: [
              FontAwesomeIcons.seedling, // NPK Values
              FontAwesomeIcons.droplet, // Moisture Level
              FontAwesomeIcons.vial, // pH Value
              FontAwesomeIcons.bolt, // Electrical Conductivity
              FontAwesomeIcons.temperatureHalf, // Soil Temperature
              FontAwesomeIcons.water, // Salinity
            ],
            soilCheckboxValues: {
              for (var element in [
                'NPK Values',
                'Moisture Level',
                'pH Value',
                'Electrical Conductivity',
                'Soil Temperature',
                'Salinity',
              ])
                element: false
            },
            devicesTypesList: ['Monitoring', 'Dosing', 'Conventional'],
            farmTypesList: {},
            areFarmsLoading: false,
          ),

        ){
    initializeFarms();
  }

  // Update methods for each field

  void initializeFarms()async{
    state = state.copyWith(areFarmsLoading: true);
    List<FarmModel> farms = await FarmService.fetchAllFarms();
    Map<int, String> farmTypesMap = {};
    for (FarmModel farm in farms) {
      farmTypesMap[farm.id] = farm.name;
    }
    state = state.copyWith(farmTypesList: farmTypesMap);
    state = state.copyWith(areFarmsLoading: false);
  }

  void updateAcquiredThroughUs(bool value) {
    state = state.copyWith(acquiredThroughUs: value);
  }

  void updateUserOwnDevice(bool value) {
    state = state.copyWith(userOwnDevice: value);
  }

  void updateAirParametersTypesList(List<String> value) {
    state = state.copyWith(airParametersTypesList: value);
  }

  void updateAirParametersIconsList(List<IconData> value) {
    state = state.copyWith(airParametersIconsList: value);
  }

  void updateAirCheckboxValues({required String parameter, required bool newValue}) {
    // Create a copy of the current map
    final updatedValues = Map<String, bool>.from(state.airCheckboxValues);

    // Update the specific checkbox value
    updatedValues[parameter] = newValue;

    // Update the state with the modified map
    state = state.copyWith(airCheckboxValues: updatedValues);
  }

  void updateSoilCheckboxValues({required String parameter, required bool newValue}) {
    // Create a copy of the current map
    final updatedValues = Map<String, bool>.from(state.soilCheckboxValues);

    // Update the specific checkbox value
    updatedValues[parameter] = newValue;

    // Update the state with the modified map
    state = state.copyWith(soilCheckboxValues: updatedValues);
  }

  void updateSoilParametersTypesList(List<String> value) {
    state = state.copyWith(soilParametersTypesList: value);
  }

  void updateSoilParametersIconsList(List<IconData> value) {
    state = state.copyWith(soilParametersIconsList: value);
  }

  void updateDevicesTypesList(List<String> value) {
    state = state.copyWith(devicesTypesList: value);
  }

  void updateIsEditing(bool newValue) {
    state = state.copyWith(isEditing: newValue);
  }

  void updateDeviceModelFull(DeviceModel newDeviceModel) {
    state = state.copyWith(deviceModel: newDeviceModel);
  }


  void updateDeviceModel({
    int? id,
    String? name,
    String? deviceType,
    String? imeiOrApiKey,
    int? farm,
    int? numFans,
    int? numCoolingPumps,
    int? numWaterSupplyPumps,
    int? numLights,
    int? numHumiditySensors,
    int? numTemperatureSensors,
    int? waterTankSize,
  }) {
    state = state.copyWith(
      deviceModel: state.deviceModel.copyWith(
        id: id ?? state.deviceModel.id,
        name: name ?? state.deviceModel.name,
        deviceType: deviceType ?? state.deviceModel.deviceType,
        imeiOrApiKey: imeiOrApiKey ?? state.deviceModel.imeiOrApiKey,
        farm: farm ?? state.deviceModel.farm,
        numFans: numFans ?? state.deviceModel.numFans,
        numCoolingPumps: numCoolingPumps ?? state.deviceModel.numCoolingPumps,
        numWaterSupplyPumps: numWaterSupplyPumps ?? state.deviceModel.numWaterSupplyPumps,
        numLights: numLights ?? state.deviceModel.numLights,
        numHumiditySensors: numHumiditySensors ?? state.deviceModel.numHumiditySensors,
        numTemperatureSensors: numTemperatureSensors ?? state.deviceModel.numTemperatureSensors,
        waterTankSize: waterTankSize ?? state.deviceModel.waterTankSize,
      ),
    );
  }



  void resetAddDeviceProvider() {
    // Dispose of the existing TextEditingController instances to free memory

    // Reset the state to its initial value
    state = AddDeviceModel(
      acquiredThroughUs: false,
      userOwnDevice: false,
      deviceModel: DeviceModel(
        deviceId: '',
        id: 0,
        name: '',
        deviceType: '',
        imeiOrApiKey: '',
        farm: 0,
        numFans: 0,
        numCoolingPumps: 0,
        numWaterSupplyPumps: 0,
        numLights: 0,
        numHumiditySensors: 0,
        numTemperatureSensors: 0,
        waterTankSize: 0,
      ),
      airParametersTypesList: [
        'Wind Direction',
        'Wind Speed',
        'Solar Radiation',
        'Air Humidity',
        'Barometric Pressure',
        'Rain Gauge',
        'Air Temperature',
      ],
      airParametersIconsList: [
        FontAwesomeIcons.locationArrow,
        FontAwesomeIcons.wind,
        FontAwesomeIcons.sun,
        FontAwesomeIcons.cloudRain,
        FontAwesomeIcons.minimize,
        FontAwesomeIcons.cloudShowersHeavy,
        FontAwesomeIcons.temperatureHalf,
      ],
      airCheckboxValues: {
        for (var element in [
          'Wind Direction',
          'Wind Speed',
          'Solar Radiation',
          'Air Humidity',
          'Barometric Pressure',
          'Rain Gauge',
          'Air Temperature',
        ])
          element: false
      },
      soilParametersTypesList: [
        'NPK Values',
        'Moisture Level',
        'pH Value',
        'Electrical Conductivity',
        'Soil Temperature',
        'Salinity',
      ],
      soilParametersIconsList: [
        FontAwesomeIcons.seedling,
        FontAwesomeIcons.droplet,
        FontAwesomeIcons.vial,
        FontAwesomeIcons.bolt,
        FontAwesomeIcons.temperatureHalf,
        FontAwesomeIcons.water,
      ],
      soilCheckboxValues: {
        for (var element in [
          'NPK Values',
          'Moisture Level',
          'pH Value',
          'Electrical Conductivity',
          'Soil Temperature',
          'Salinity',
        ])
          element: false
      },
      devicesTypesList: ['Monitoring', 'Dosing', 'Conventional'],
      farmTypesList: state.farmTypesList,
    );
  }
}

final addDeviceProvider = StateNotifierProvider<AddDeviceNotifier, AddDeviceModel>((ref) {
  return AddDeviceNotifier();
});
