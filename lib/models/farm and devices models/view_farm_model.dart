import 'device_model.dart';
import 'farm_model.dart';

class ViewFarmModel {
  final List<FarmModel> farmModelList;
  final List<DeviceModel> deviceModelList;
  final bool areFarmsLoading;
  final bool areDevicesLoading;
  final FarmModel selectedFarm;
  final DeviceModel selectedDevice;

  ViewFarmModel({
    required this.farmModelList,
    required this.areFarmsLoading,
    required this.selectedFarm,
    required this.deviceModelList,
    required this.areDevicesLoading,
    required this.selectedDevice,
  });

  ViewFarmModel copyWith({
    List<FarmModel>? farmModelList,
    List<DeviceModel>? deviceModelList,
    bool? areFarmsLoading,
    bool? areDevicesLoading,
    FarmModel? selectedFarm,
    DeviceModel? selectedDevice,
  }) {
    return ViewFarmModel(
      farmModelList: farmModelList ?? this.farmModelList,
      areFarmsLoading: areFarmsLoading ?? this.areFarmsLoading,
      selectedFarm: selectedFarm ?? this.selectedFarm,
      deviceModelList: deviceModelList ?? this.deviceModelList,
      areDevicesLoading: areDevicesLoading ?? this.areDevicesLoading,
      selectedDevice: selectedDevice ?? this.selectedDevice,
    );
  }
}
