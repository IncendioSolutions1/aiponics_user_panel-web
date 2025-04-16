import 'package:aiponics_web_app/controllers/farm%20and%20device%20controller/farm_controller.dart';
import 'package:aiponics_web_app/models/farm%20and%20devices%20models/farm_model.dart';
import 'package:aiponics_web_app/models/header%20model/header_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderNotifier extends StateNotifier<HeaderModel> {
  HeaderNotifier()
      : super(HeaderModel(
    temperatureSignList: ["°C", "°F"],
    farmList: [],
    selectedFarm: "loading"
  )) { fetchFarms(); }

  void fetchFarms() async {
    List<FarmModel> farmModelList = await FarmService.fetchAllFarms();
    if(farmModelList.isNotEmpty) {
      List<String> farmNames = farmModelList.map((farm) => farm.name).toList();
      state = state.copyWith(
          farmList: farmNames,
          selectedFarm: farmNames[0],
          selectedTemperatureSign: "°C",
          temperatureSignList: ["°C", "°F"],
      );
    }else{
      List<String> farmNames = ["No Farms Found"];
      state = state.copyWith(
        farmList: farmNames,
        selectedFarm: farmNames[0],
        selectedTemperatureSign: "°C",
        temperatureSignList: ["°C", "°F"],
      );
    }
  }


  // Update the user's selected farm
  void updateFarm(String newFarm) {
    state = state.copyWith(selectedFarm: newFarm);
  }

  // Update the user's selected temperature choice
  void updateTemperatureSign(String temperatureSign) {
    state = state.copyWith(selectedTemperatureSign: temperatureSign);
  }

}

final headerInfoProvider =
StateNotifierProvider<HeaderNotifier, HeaderModel>((ref) {
  return HeaderNotifier();
});
