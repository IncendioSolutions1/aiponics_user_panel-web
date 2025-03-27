import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/farm and device controller/farm_controller.dart';
import '../../models/farm and devices models/add_farm_model.dart';
import '../../models/farm and devices models/farm_model.dart';

class AddFarmNotifier extends StateNotifier<AddFarmModel> {
  AddFarmNotifier()
      : super(
    AddFarmModel(
      farmModel: FarmModel(
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
      cropChoicesList: ['herbs', 'Vegetables', 'Fruits', 'Leafy Greens', 'Mix'],
      farmTypesList: ['Open Farm', 'Green House'],
      operationalChoicesList: ['active', 'inactive'],
      showErrorTextColorOnImage: false,
      imageSelectText: "No Image Selected!",
      descriptionFieldHeight: 200,
      isSqMeterSelected: false,
      isSqFeetSelected: false,
      isAcerSelected: false,
      isEditing: false,
    ),
  );

  // Update the entire FarmModel
  void updateFarmModel(FarmModel newFarmModel) {
    state = state.copyWith(farmModel: newFarmModel);
  }

  // Update single fields of FarmModel

  void updateFarmName(String newName) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(name: newName),
    );
  }

  void updateFarmType(String newType) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(farmType: newType),
    );
  }

  void updateCropType(String newCropType) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(crops: newCropType),
    );
  }

  void updateFarmLocation(String newLocation) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(location: newLocation),
    );
  }

  void updateFarmOperationalStatus(String newStatus) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(operationalStatus: newStatus),
    );
  }

  void updateFarmsArea(double newArea) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(farmsArea: newArea),
    );
  }

  void updateFarmsDescription(String newDescription) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(farmDescription: newDescription),
    );
  }

  void updateAreaUnit(String newAreaUnit) {
    state = state.copyWith(
      farmModel: state.farmModel.copyWith(areaUnit: newAreaUnit),
    );
  }


  // Update methods for AddFarmModel fields
  void updateImageSelectText(String newText) {
    state = state.copyWith(imageSelectText: newText);
  }

  void toggleShowErrorTextColorOnImage(bool newValue) {
    state = state.copyWith(showErrorTextColorOnImage: newValue);
  }

  void toggleIsSqMeterSelected(bool newValue) {
    state = state.copyWith(isSqMeterSelected: newValue);
  }

  void toggleIsSqFeetSelected(bool newValue) {
    state = state.copyWith(isSqFeetSelected: newValue);
  }

  void toggleIsAcerSelected(bool newValue) {
    state = state.copyWith(isAcerSelected: newValue);
  }

  void updateDescriptionFieldHeight(double newHeight) {
    state = state.copyWith(descriptionFieldHeight: newHeight);
  }

  void updateIsEditing(bool newValue) {
    state = state.copyWith(isEditing: newValue);
  }

  Future<bool> addFarmToServer() async {
    bool status = false;
    FarmModel farmModel = state.farmModel;
    FarmModel farm = await FarmService.addFarmToServer(farmModel);
    if(farm.id != 0){
      status = true;
      state = state.copyWith(farmModel: farm);
    }
    return status;
  }

  Future<bool> updateFarmToServer() async {
    bool status = false;
    FarmModel farmModel = state.farmModel;
    bool farmUpdateStatus = await FarmService.updateFarmToServer(farmModel);
    if(farmUpdateStatus){
      status = true;
      state = state.copyWith(farmModel: farmModel);
    }
    return status;
  }

  Future<bool> deleteFarmFromServer() async {
    bool status = false;
    FarmModel farmModel = state.farmModel;
    bool farmDeleteStatus = await FarmService.deleteFarmFromServer(farmModel.id);
    if(farmDeleteStatus){
      status = true;
      state = state.copyWith(
          farmModel: FarmModel(
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
          )
      );
    }
    return status;
  }

  // Reset state method to reinitialize default values
  void resetState() {
    state = AddFarmModel(
      cropChoicesList: ['herbs', 'Vegetables', 'Fruits', 'Leafy Greens', 'Mix', 'Custom'],
      farmTypesList: ['Open Farm', 'Greenhouse'],
      operationalChoicesList: ['active', 'inactive'],
      showErrorTextColorOnImage: false,
      imageSelectText: "No Image Selected!",
      descriptionFieldHeight: 200,
      isSqMeterSelected: false,
      isSqFeetSelected: false,
      isAcerSelected: false,
      isEditing: false,
      farmModel: FarmModel(
        name: '',
        farmType: '',
        crops: '',
        // customCropType: '',
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
    );
  }

  @override
  void dispose() {
    log("Disposed method called in Add Farm Provider");
    resetState(); // Ensure controllers are disposed
    super.dispose();
  }
}

final addFarmProvider = StateNotifierProvider<AddFarmNotifier, AddFarmModel>((ref) {
  return AddFarmNotifier();
});
