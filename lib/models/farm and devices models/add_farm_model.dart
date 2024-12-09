import 'package:flutter/material.dart';

class AddFarmModel {
  final TextEditingController farmName;
  final TextEditingController farmType;
  final TextEditingController cropType;
  final TextEditingController customCropType;
  final TextEditingController farmLocation;
  final TextEditingController farmOperationalStatus;
  final TextEditingController farmsArea;
  final TextEditingController farmsDescription;
  final List<String> cropChoicesList;
  final List<String> farmTypesList;
  final List<String> operationalStatusList;
  final String selectedCropChoices;
  final String selectedFarmType;
  final String selectedOperationalStatusChoice;
  final bool showErrorTextColorOnImage;
  final String imageSelectText;
  final double descriptionFieldHeight;
  final bool showCustomCropTypeField;
  final String otherCropType;
  final bool isSqMeterSelected;
  final bool isSqFeetSelected;
  final bool isAcerSelected;



  AddFarmModel({
    required this.farmName,
    required this.farmType,
    required this.cropType,
    required this.customCropType,
    required this.farmLocation,
    required this.farmOperationalStatus,
    required this.farmsArea,
    required this.farmsDescription,
    required this.cropChoicesList,
    required this.farmTypesList,
    required this.operationalStatusList,
    required this.selectedCropChoices,
    required this.selectedFarmType,
    required this.selectedOperationalStatusChoice,
    required this.showErrorTextColorOnImage,
    required this.imageSelectText,
    required this.descriptionFieldHeight,
    required this.showCustomCropTypeField,
    required this.otherCropType,
    required this.isSqMeterSelected,
    required this.isSqFeetSelected,
    required this.isAcerSelected,
  });

  // Add copyWith method for immutability
  AddFarmModel copyWith({
    TextEditingController? farmName,
    TextEditingController? farmType,
    TextEditingController? cropType,
    TextEditingController? customCropType,
    TextEditingController? farmLocation,
    TextEditingController? farmOperationalStatus,
    TextEditingController? farmsArea,
    TextEditingController? farmsDescription,
    List<String>? cropChoicesList,
    List<String>? farmTypesList,
    List<String>? operationalStatusList,
    String? selectedCropChoices,
    String? selectedFarmType,
    String? selectedOperationalStatusChoice,
    bool? showErrorTextColorOnImage,
    String? imageSelectText,
    double? descriptionFieldHeight,
    bool? showCustomCropTypeField,
    String? otherCropType,
    bool? isSqMeterSelected,
    bool? isSqFeetSelected,
    bool? isAcerSelected,
  }) {
    return AddFarmModel(
      farmName: farmName ?? this.farmName,
      farmType: farmType ?? this.farmType,
      cropType: cropType ?? this.cropType,
      customCropType: customCropType ?? this.customCropType,
      farmLocation: farmLocation ?? this.farmLocation,
      farmOperationalStatus: farmOperationalStatus ?? this.farmOperationalStatus,
      farmsArea: farmsArea ?? this.farmsArea,
      farmsDescription: farmsDescription ?? this.farmsDescription,
      cropChoicesList: cropChoicesList ?? this.cropChoicesList,
      farmTypesList: farmTypesList ?? this.farmTypesList,
      operationalStatusList: operationalStatusList ?? this.operationalStatusList,
      selectedCropChoices: selectedCropChoices ?? this.selectedCropChoices,
      selectedFarmType: selectedFarmType ?? this.selectedFarmType,
      selectedOperationalStatusChoice: selectedOperationalStatusChoice ?? this.selectedOperationalStatusChoice,
      showErrorTextColorOnImage: showErrorTextColorOnImage ?? this.showErrorTextColorOnImage,
      imageSelectText: imageSelectText ?? this.imageSelectText,
      descriptionFieldHeight: descriptionFieldHeight ?? this.descriptionFieldHeight,
      showCustomCropTypeField: showCustomCropTypeField ?? this.showCustomCropTypeField,
      otherCropType: otherCropType ?? this.otherCropType,
      isSqMeterSelected: isSqMeterSelected ?? this.isSqMeterSelected,
      isSqFeetSelected: isSqFeetSelected ?? this.isSqFeetSelected,
      isAcerSelected: isAcerSelected ?? this.isAcerSelected,
    );
  }
}