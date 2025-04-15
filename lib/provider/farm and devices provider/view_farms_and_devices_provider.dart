import 'dart:developer';

import 'package:aiponics_web_app/models/farm%20and%20devices%20models/device_model.dart';
import 'package:aiponics_web_app/models/farm%20and%20devices%20models/view_farm_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/farm and device controller/device_controller.dart';
import '../../controllers/farm and device controller/farm_controller.dart';
import '../../models/farm and devices models/farm_model.dart';

class ViewFarmsAndDevicesNotifier extends StateNotifier<ViewFarmModel> {
  final Ref ref;
  ViewFarmsAndDevicesNotifier(this.ref)
      : super(
          ViewFarmModel(
            farmModelList: [],
            areFarmsLoading: false,
            areDevicesLoading: false,
            deviceModelList: [],
            selectedDevice: DeviceModel(
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
            selectedFarm: FarmModel(
              name: '',
              farmType: '',
              crops: '',
              location: '',
              operationalStatus: '',
              farmsArea: 0.0,
              farmDescription: '',
              areaUnit: '',
              id: 0,
              cropDescription: '',
              images: null,
              owner: '',
              regDate: '',
            ),
          ),
        ) {
    _init();
  }

  // Initialize asynchronously by fetching the farms.
  Future<void> _init() async {
    await fetchFarms();
  }

  Future<int> fetchFarmIdByName(String farmName) async {
    List<FarmModel> farmModelList = state.farmModelList;
    for (FarmModel farm in farmModelList) {
      if (farm.name == farmName) {
        return farm.id;
      }
    }
    return 0;
  }

  Future<void> fetchFarms() async {
    try {
      state = state.copyWith(areFarmsLoading:true);
      // Call your service method to get the list of farms.
      // Ensure that FarmService.fetchAllFarms() is refactored to not need a BuildContext.
      log("API call: fetchAllFarms started.");
      List<FarmModel> farms = await FarmService.fetchAllFarms();
      state = state.copyWith(farmModelList: farms, areFarmsLoading: false, selectedFarm: farms[0]);
    } catch (error) {
      // Handle error appropriately (you might log the error or update state with an error flag)
      state = state.copyWith(areFarmsLoading: false);
    }
  }

  Future<bool> updateSelectedFarm(FarmModel newFarm) async {
    bool status = true;
    try {
      state = state.copyWith(areDevicesLoading: true);
      // Call your service method to get the list of farms.
      // Ensure that FarmService.fetchAllFarms() is refactored to not need a BuildContext.
      log("API call: fetchAllFarms started.");
      Map<bool, List<DeviceModel>> device = await DeviceService.fetchDevices(newFarm.id);
      if(device.keys.first){
        log("API call: fetchAllFarms finished. ${device.toString()}");
        state = state.copyWith(deviceModelList: device.values.first, areDevicesLoading: false);
        status = true;
      }else{
        log("API call: fetchAllFarms finished in else. ${device.toString()}");
        state = state.copyWith(areDevicesLoading: false, deviceModelList: []);
        status = false;
      }

    } catch (error) {
      // Handle error appropriately (you might log the error or update state with an error flag)
      state = state.copyWith(areDevicesLoading: false);
    }
    return status;
  }
}

// Riverpod provider that creates and exposes the ViewFarmNotifier
final viewFarmsAndDevicesProvider = StateNotifierProvider<ViewFarmsAndDevicesNotifier, ViewFarmModel>((ref) {
  return ViewFarmsAndDevicesNotifier(ref);
});
