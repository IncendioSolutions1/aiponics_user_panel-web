class HeaderModel {
  final String selectedFarm;
  final String selectedTemperatureSign;
  final List<String> temperatureSignList;
  final List<String> farmList;

  HeaderModel({
    this.selectedFarm = "None", // Default value
    this.selectedTemperatureSign = "°C", // Default value
    required this.temperatureSignList, // Default value
    required this.farmList,
  });

  // Add copyWith method for immutability
  HeaderModel copyWith({
    String? selectedFarm,
    String? selectedTemperatureSign,
    List<String>? temperatureSignList,
    List<String>? farmList,
  }) {
    return HeaderModel(
      farmList: farmList ?? this.farmList,
      selectedTemperatureSign: selectedTemperatureSign ?? this.selectedTemperatureSign,
      temperatureSignList: temperatureSignList ?? this.temperatureSignList,
      selectedFarm: selectedFarm ?? this.selectedFarm,
    );
  }
}