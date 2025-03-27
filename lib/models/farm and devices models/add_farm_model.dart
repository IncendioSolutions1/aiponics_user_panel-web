

import 'farm_model.dart';

class AddFarmModel {
  FarmModel farmModel;
  bool isEditing;

  final List<String> cropChoicesList;
  final List<String> farmTypesList;
  final List<String> operationalChoicesList;

  final bool showErrorTextColorOnImage;
  final String imageSelectText;
  final double descriptionFieldHeight;

  final bool isSqMeterSelected;
  final bool isSqFeetSelected;
  final bool isAcerSelected;

  AddFarmModel({
    required this.farmModel,
    required this.isEditing,
    required this.cropChoicesList,
    required this.farmTypesList,
    required this.operationalChoicesList,
    required this.showErrorTextColorOnImage,
    required this.imageSelectText,
    required this.descriptionFieldHeight,
    required this.isSqMeterSelected,
    required this.isSqFeetSelected,
    required this.isAcerSelected,
  });

  // Add copyWith method for immutability
  AddFarmModel copyWith({
    FarmModel? farmModel,
    List<String>? cropChoicesList,
    List<String>? farmTypesList,
    List<String>? operationalChoicesList,
    bool? showErrorTextColorOnImage,
    String? imageSelectText,
    double? descriptionFieldHeight,
    bool? isSqMeterSelected,
    bool? isSqFeetSelected,
    bool? isAcerSelected,
    bool? isEditing,
  }) {
    return AddFarmModel(
      farmModel: farmModel ?? this.farmModel,
      cropChoicesList: cropChoicesList ?? this.cropChoicesList,
      farmTypesList: farmTypesList ?? this.farmTypesList,
      operationalChoicesList: operationalChoicesList ?? this.operationalChoicesList,
      showErrorTextColorOnImage: showErrorTextColorOnImage ?? this.showErrorTextColorOnImage,
      imageSelectText: imageSelectText ?? this.imageSelectText,
      descriptionFieldHeight: descriptionFieldHeight ?? this.descriptionFieldHeight,
      isSqMeterSelected: isSqMeterSelected ?? this.isSqMeterSelected,
      isSqFeetSelected: isSqFeetSelected ?? this.isSqFeetSelected,
      isAcerSelected: isAcerSelected ?? this.isAcerSelected,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
