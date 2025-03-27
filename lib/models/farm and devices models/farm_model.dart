class FarmModel {
  final int id;
  final String owner;
  final String name;
  final String regDate;
  final String location;
  final double farmsArea;
  final String areaUnit;
  final String farmType;
  final String crops;
  final String farmDescription;
  final String? cropDescription;
  final String operationalStatus;
  final String? images;

  FarmModel({
    required this.id,
    required this.owner,
    required this.name,
    required this.farmType,
    required this.crops,
    required this.location,
    required this.operationalStatus,
    required this.farmsArea,
    required this.farmDescription,
    required this.areaUnit,
    required this.images,
    required this.cropDescription,
    required this.regDate,
  });

  FarmModel copyWith({
    String? name,
    String? farmType,
    String? crops,
    String? location,
    String? operationalStatus,
    double? farmsArea,
    String? farmDescription,
    String? areaUnit,
    String? images,
    String? cropDescription,
    String? regDate,
    int? id,
    String? owner,
  }) {
    return FarmModel(
      name: name ?? this.name,
      farmType: farmType ?? this.farmType,
      crops: crops ?? this.crops,
      location: location ?? this.location,
      operationalStatus: operationalStatus ?? this.operationalStatus,
      farmsArea: farmsArea ?? this.farmsArea,
      farmDescription: farmDescription ?? this.farmDescription,
      areaUnit: areaUnit ?? this.areaUnit,
      images: images ?? this.images,
      cropDescription: cropDescription ?? this.cropDescription,
      regDate: regDate ?? this.regDate,
      id: id ?? this.id,
      owner: owner ?? this.owner,
    );
  }

  // Factory constructor to create a FarmModel from JSON
  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      id: json['id'],
      owner: json['owner'],
      name: json['name'],
      regDate: json['reg_date'],
      location: json['location'],
      farmsArea: double.parse(json['farm_area']),
      areaUnit: json['area_unit'],
      farmType: json['farm_type'],
      crops: json['crops'],
      farmDescription: json['farm_description'],
      cropDescription: json['crop_description'],
      images: json['images'],
      operationalStatus: json['operational_status'],
    );
  }

  // Method to convert a FarmModel into JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'farm_type': farmType,
      'crops': crops,
      'location': location,
      'operational_status': operationalStatus,
      'farm_area': farmsArea,
      'farm_description': farmDescription,
      'area_unit': areaUnit,
    };
  }

  @override
  toString() {
    return "Farm Name: $name, Farm Type: $farmType, Crop Type: $crops, Farm Location: $location, Farm Operational Status: $operationalStatus, Farms Area: $farmsArea, Farms Description: $farmDescription, Area Unit: $areaUnit";
  }
}