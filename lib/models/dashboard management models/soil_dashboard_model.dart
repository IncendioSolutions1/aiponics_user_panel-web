class SoilInfoModel {

  final double? airTemperature;
  final double? windDirection;
  final double? windSpeed;
  final double? airHumidity;
  final double? solarRadiation;
  final double? barometricPressure;
  final double? rainGauge;

  final double? moistureLevel;
  final double? electricalConductivity;
  final double? pHLevel;
  final double? soilTemperature;
  final double? salinity;

  final List<List<double>?>? npkValues;
  final List<String>? gaugesNames;
  final Map<String, dynamic>? gaugesToShow;

  SoilInfoModel({
    this.airTemperature,
    this.windDirection,
    this.windSpeed,
    this.airHumidity,
    this.solarRadiation,
    this.barometricPressure,
    this.rainGauge,
    this.moistureLevel,
    this.electricalConductivity,
    this.pHLevel,
    this.soilTemperature,
    this.salinity,
    this.npkValues,
    required this.gaugesNames,
    this.gaugesToShow,
  });

  // Add copyWith method for immutability
  SoilInfoModel copyWith({
    double? airTemperature,
    double? windDirection,
    double? windSpeed,
    double? airHumidity,
    double? solarRadiation,
    double? barometricPressure,
    double? rainGauge,
    double? moistureLevel,
    double? electricalConductivity,
    double? pHLevel,
    double? soilTemperature,
    double? salinity,
    List<List<double>?>? npkValues,
    List<String>? gaugesNames,
    Map<String, dynamic>? gaugesToShow,
  }) {
    return SoilInfoModel(
      airTemperature: airTemperature ?? this.airTemperature,
      windDirection: windDirection ?? this.windDirection,
      windSpeed: windSpeed ?? this.windSpeed,
      airHumidity: airHumidity ?? this.airHumidity,
      solarRadiation: solarRadiation ?? this.solarRadiation,
      barometricPressure: barometricPressure ?? this.barometricPressure,
      rainGauge: rainGauge ?? this.rainGauge,
      moistureLevel: moistureLevel ?? this.moistureLevel,
      electricalConductivity: electricalConductivity ?? this.electricalConductivity,
      pHLevel: pHLevel ?? this.pHLevel,
      soilTemperature: soilTemperature ?? this.soilTemperature,
      salinity: salinity ?? this.salinity,
      npkValues: npkValues ?? this.npkValues,
      gaugesNames: gaugesNames ?? this.gaugesNames,
      gaugesToShow: gaugesToShow ?? this.gaugesToShow,
    );
  }
}
