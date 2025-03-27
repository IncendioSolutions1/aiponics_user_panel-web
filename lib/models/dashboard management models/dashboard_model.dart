class DashboardInfoModel {

  final double? farmTemperature;
  final double? farmHumidity;
  final double? externalTemperature;
  final double? externalHumidity;
  final double? waterTemperature;
  final double? waterLevel;
  final double? pHLevel;
  final List<Map<int, double>?>? energyConsumption;
  final List<Map<int, double>?>? lightIntensity;
  final double? farmCoLevel;
  final String selectedGraphType;
  final List<String> graphTypes;
  final List<String> devices;
  final String? selectedDevice;
  final DateTime? selectedDate;
  final List<Map<double, double>?>? tdsValues;
  final List<String>? gaugesNames;
  final Map<String, dynamic>? gaugesToShow;

  DashboardInfoModel({
    this.farmTemperature,
    this.farmHumidity,
    this.externalTemperature,
    this.externalHumidity,
    this.waterTemperature,
    this.waterLevel,
    this.pHLevel,
    this.energyConsumption,
    this.lightIntensity,
    this.farmCoLevel,
    required this.selectedGraphType,
    required this.graphTypes,
    required this.devices,
    this.selectedDevice,
    this.selectedDate,
    this.tdsValues,
    required this.gaugesNames,
    this.gaugesToShow,
  });

  // Add copyWith method for immutability
  DashboardInfoModel copyWith({
    final double? farmTemperature,
    final double? farmHumidity,
    final double? externalTemperature,
    final double? externalHumidity,
    final double? waterTemperature,
    final double? waterLevel,
    final double? pHLevel,
    final List<Map<int, double>?>? energyConsumption,
    final List<Map<int, double>?>? lightIntensity,
    final double? farmCoLevel,
    final String? selectedGraphType,
    final List<String>? graphTypes,
    final List<String>? devices,
    final String? selectedDevice,
    final DateTime? selectedDate,
    final List<Map<double, double>?>? tdsValues,
    List<String>? gaugesNames,
    final Map<String, dynamic>? gaugesToShow,
  }) {
    return DashboardInfoModel(
      farmTemperature: farmTemperature ?? this.farmTemperature,
      externalTemperature: externalTemperature ?? this.externalTemperature,
      farmHumidity: farmHumidity ?? this.farmHumidity,
      externalHumidity: externalHumidity ?? this.externalHumidity,
      waterTemperature: waterTemperature ?? this.waterTemperature,
      waterLevel: waterLevel ?? this.waterLevel,
      pHLevel: pHLevel ?? this.pHLevel,
      energyConsumption: energyConsumption ?? this.energyConsumption,
      lightIntensity: lightIntensity ?? this.lightIntensity,
      farmCoLevel: farmCoLevel ?? this.farmCoLevel,
      selectedGraphType: selectedGraphType ?? this.selectedGraphType,
      graphTypes: graphTypes ?? this.graphTypes,
      devices: devices ?? this.devices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      selectedDate: selectedDate ?? this.selectedDate,
      tdsValues: tdsValues ?? this.tdsValues,
      gaugesNames: gaugesNames ?? this.gaugesNames,
      gaugesToShow: gaugesToShow ?? this.gaugesToShow,
    );
  }

}