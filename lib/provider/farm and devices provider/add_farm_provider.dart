import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/farm and devices models/add_farm_model.dart';

class AddFarmNotifier extends StateNotifier<AddFarmModel> {
  AddFarmNotifier()
      : super(AddFarmModel(
            farmName: TextEditingController(),
            farmType: TextEditingController(),
            cropType: TextEditingController(),
            customCropType: TextEditingController(),
            farmLocation: TextEditingController(),
            farmOperationalStatus: TextEditingController(),
            farmsArea: TextEditingController(),
            farmsDescription: TextEditingController(),
            cropChoicesList: [
              'herbs',
              'Vegetables',
              'Fruits',
              'Leafy Greens',
              'Mix',
              'Custom'
            ],
            farmTypesList: [
              'Open Farm',
              'Green House',
            ],
            operationalStatusList: ['active', 'inactive'],
            selectedCropChoices: "Select from here",
            selectedFarmType: "Select from here",
            selectedOperationalStatusChoice: "Select from here",
            showErrorTextColorOnImage: false,
            imageSelectText: "No Image Selected!",
            descriptionFieldHeight: 200,
            showCustomCropTypeField: false,
            otherCropType: 'Custom',
            isSqMeterSelected: false,
            isSqFeetSelected: false,
            isAcerSelected: false));

  // Update methods for TextEditingController fields
  void updateFarmName(String newName) {
    state = state.copyWith(farmName: TextEditingController(text: newName));
  }

  void updateFarmType(String newType) {
    state = state.copyWith(farmType: TextEditingController(text: newType));
  }

  void updateCropType(String newCrop) {
    state = state.copyWith(cropType: TextEditingController(text: newCrop));
  }

  void updateCustomCropType(String newCrop) {
    state = state.copyWith(customCropType: TextEditingController(text: newCrop));
  }

  void updateFarmLocation(String newLocation) {
    state = state.copyWith(farmLocation: TextEditingController(text: newLocation));
  }

  void updateFarmOperationalStatus(String newStatus) {
    state = state.copyWith(farmOperationalStatus: TextEditingController(text: newStatus));
  }

  void updateFarmsArea(String newArea) {
    state = state.copyWith(farmsArea: TextEditingController(text: newArea));
  }


  void updateFarmsDescription(String newDescription) {
    state = state.copyWith(farmsDescription: TextEditingController(text: newDescription));
  }

  // Update methods for string fields
  void updateSelectedCropChoices(String newChoice) {
    state = state.copyWith(selectedCropChoices: newChoice);
  }

  void updateSelectedFarmType(String newType) {
    state = state.copyWith(selectedFarmType: newType);
  }

  void updateSelectedOperationalStatusChoice(String newStatus) {
    state = state.copyWith(selectedOperationalStatusChoice: newStatus);
  }

  void updateImageSelectText(String newText) {
    state = state.copyWith(imageSelectText: newText);
  }

  void updateOtherCropType(String newCropType) {
    state = state.copyWith(otherCropType: newCropType);
  }

  // Update methods for boolean fields
  void toggleShowErrorTextColorOnImage(bool newValue) {
    state = state.copyWith(showErrorTextColorOnImage: newValue);
  }

  void toggleShowCustomCropTypeField(bool newValue) {
    state = state.copyWith(showCustomCropTypeField: newValue);
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

  // Update method for numeric fields
  void updateDescriptionFieldHeight(double newHeight) {
    state = state.copyWith(descriptionFieldHeight: newHeight);
  }

  // Add the reset state method
  void resetState() {
    // Dispose existing controllers to free memory
    state.farmName.dispose();
    state.farmType.dispose();
    state.cropType.dispose();
    state.customCropType.dispose();
    state.farmLocation.dispose();
    state.farmOperationalStatus.dispose();
    state.farmsArea.dispose();
    state.farmsDescription.dispose();

    // Reinitialize the state with default values
    state = AddFarmModel(
      farmName: TextEditingController(),
      farmType: TextEditingController(),
      cropType: TextEditingController(),
      customCropType: TextEditingController(),
      farmLocation: TextEditingController(),
      farmOperationalStatus: TextEditingController(),
      farmsArea: TextEditingController(),
      farmsDescription: TextEditingController(),
      cropChoicesList: [
        'herbs',
        'Vegetables',
        'Fruits',
        'Leafy Greens',
        'Mix',
        'Custom'
      ],
      farmTypesList: [
        'Open Farm',
        'Green House',
      ],
      operationalStatusList: ['active', 'inactive'],
      selectedCropChoices: "Select from here",
      selectedFarmType: "Select from here",
      selectedOperationalStatusChoice: "Select from here",
      showErrorTextColorOnImage: false,
      imageSelectText: "No Image Selected!",
      descriptionFieldHeight: 200,
      showCustomCropTypeField: false,
      otherCropType: 'Custom',
      isSqMeterSelected: false,
      isSqFeetSelected: false,
      isAcerSelected: false,
    );
  }


  // Dispose controllers when no longer needed
  @override
  void dispose() {
    log("Disposed method called in Add Farm Provider");
    resetState(); // Ensure controllers are disposed
    super.dispose();
  }
}

final addFarmProvider =
    StateNotifierProvider<AddFarmNotifier, AddFarmModel>((ref) {
  return AddFarmNotifier();
});
