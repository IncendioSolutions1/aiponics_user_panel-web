import 'package:aiponics_web_app/models/farm%20and%20devices%20models/add_device_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddDeviceNotifier extends StateNotifier<AddDeviceModel> {
  AddDeviceNotifier()
      : super(
    AddDeviceModel(
      acquiredThroughUs: false,
      userOwnDevice: false,
      deviceName: TextEditingController(),
      farm: TextEditingController(),
      noOfFans: TextEditingController(),
      noOfPumps: TextEditingController(),
      noOfLights: TextEditingController(),
      noOfCoolingPumps: TextEditingController(),
      noOfMistingPumps: TextEditingController(),
      waterTankSize: TextEditingController(),
      deviceEmei: TextEditingController(),
      parameter: TextEditingController(),
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
        element: false},
      soilParametersTypesList: [
        'NPK Values',
        'Moisture Level',
        'pH Value',
        'Electrical Conductivity',
        'Soil Temperature',
        'Salinity',
      ],
      soilParametersIconsList: [
        FontAwesomeIcons.seedling,         // NPK Values
        FontAwesomeIcons.droplet,              // Moisture Level
        FontAwesomeIcons.vial,              // pH Value
        FontAwesomeIcons.bolt,              // Electrical Conductivity
        FontAwesomeIcons.temperatureHalf,   // Soil Temperature
        FontAwesomeIcons.water,             // Salinity
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
        element: false},
      devicesTypesList: [
        'Climate Control System',
        'Dosing System',
        'Conventional System'
      ],
      farmTypesList: [
        'Farm 1',
        'Farm 2',
        'Farm 3',
        'Farm 4',
        'Farm 5',
        'Farm 6',
      ],
      climateControlSystem: 'Climate Control System',
      dosingSystem: 'Dosing System',
      conventionalSystem: 'Conventional System',
      farmType: "Open Farms",
      openFarm: "Open Farm",
      itemToDisable: "Climate Control System",
    ),
      // Initialize each checkbox as unchecked (false)

  );

  // Update methods for each field

  void updateAcquiredThroughUs(bool value) {
    state = state.copyWith(acquiredThroughUs: value);
  }

  void updateUserOwnDevice(bool value) {
    state = state.copyWith(userOwnDevice: value);
  }

  void updateDeviceName(String value) {
    state.deviceName.text = value;
    state = state.copyWith(deviceName: state.deviceName);
  }

  void updateFarm(String value) {
    state.farm.text = value;
    state = state.copyWith(farm: state.farm);
  }

  void updateNoOfFans(String value) {
    state.noOfFans.text = value;
    state = state.copyWith(noOfFans: state.noOfFans);
  }

  void updateNoOfPumps(String value) {
    state.noOfPumps.text = value;
    state = state.copyWith(noOfPumps: state.noOfPumps);
  }

  void updateNoOfLights(String value) {
    state.noOfLights.text = value;
    state = state.copyWith(noOfLights: state.noOfLights);
  }

  void updateNoOfCoolingPumps(String value) {
    state.noOfCoolingPumps.text = value;
    state = state.copyWith(noOfCoolingPumps: state.noOfCoolingPumps);
  }

  void updateNoOfMistingPumps(String value) {
    state.noOfMistingPumps.text = value;
    state = state.copyWith(noOfMistingPumps: state.noOfMistingPumps);
  }

  void updateWaterTankSize(String value) {
    state.waterTankSize.text = value;
    state = state.copyWith(waterTankSize: state.waterTankSize);
  }

  void updateDeviceEmei(String value) {
    state.deviceEmei.text = value;
    state = state.copyWith(deviceEmei: state.deviceEmei);
  }

  void updateParameter(String value) {
    state.parameter.text = value;
    state = state.copyWith(parameter: state.parameter);
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

  void updateFarmTypesList(List<String> value) {
    state = state.copyWith(farmTypesList: value);
  }

  void updateClimateControlSystem(String value) {
    state = state.copyWith(climateControlSystem: value);
  }

  void updateDosingSystem(String value) {
    state = state.copyWith(dosingSystem: value);
  }

  void updateConventionalSystem(String value) {
    state = state.copyWith(conventionalSystem: value);
  }

  void updateFarmType(String value) {
    state = state.copyWith(farmType: value);
  }

  void updateOpenFarm(String value) {
    state = state.copyWith(openFarm: value);
  }

  void updateItemToDisable(String value) {
    state = state.copyWith(itemToDisable: value);
  }

  void resetAddDeviceProvider() {
    // Dispose of the existing TextEditingController instances to free memory
    state.deviceName.dispose();
    state.farm.dispose();
    state.noOfFans.dispose();
    state.noOfPumps.dispose();
    state.noOfLights.dispose();
    state.noOfCoolingPumps.dispose();
    state.noOfMistingPumps.dispose();
    state.waterTankSize.dispose();
    state.deviceEmei.dispose();
    state.parameter.dispose();

    // Reset the state to its initial value
    state = AddDeviceModel(
      acquiredThroughUs: false,
      userOwnDevice: false,
      deviceName: TextEditingController(),
      farm: TextEditingController(),
      noOfFans: TextEditingController(),
      noOfPumps: TextEditingController(),
      noOfLights: TextEditingController(),
      noOfCoolingPumps: TextEditingController(),
      noOfMistingPumps: TextEditingController(),
      waterTankSize: TextEditingController(),
      deviceEmei: TextEditingController(),
      parameter: TextEditingController(),
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
      devicesTypesList: [
        'Climate Control System',
        'Dosing System',
        'Conventional System'
      ],
      farmTypesList: [
        'Farm 1',
        'Farm 2',
        'Farm 3',
        'Farm 4',
        'Farm 5',
        'Farm 6',
      ],
      climateControlSystem: 'Climate Control System',
      dosingSystem: 'Dosing System',
      conventionalSystem: 'Conventional System',
      farmType: "Open Farms",
      openFarm: "Open Farm",
      itemToDisable: "Climate Control System",
    );
  }

}

final addDeviceProvider =
StateNotifierProvider<AddDeviceNotifier, AddDeviceModel>((ref) {
  return AddDeviceNotifier();
});
