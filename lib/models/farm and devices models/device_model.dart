class DeviceModel {
  final int id;
  final String name;
  final String deviceType;
  final String imeiOrApiKey;
  final int farm;
  final String deviceId;
  final int? numFans;
  final int? numCoolingPumps;
  final int? numWaterSupplyPumps;
  final int? numLights;
  final int? numHumiditySensors;
  final int? numTemperatureSensors;
  final int? waterTankSize;

  DeviceModel({
    required this.id,
    required this.name,
    required this.deviceType,
    required this.imeiOrApiKey,
    required this.farm,
    required this.numFans,
    required this.numCoolingPumps,
    required this.numWaterSupplyPumps,
    required this.numLights,
    required this.numHumiditySensors,
    required this.numTemperatureSensors,
    required this.waterTankSize,
    required this.deviceId,
  });

  // Named constructor from JSON
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      deviceId: json['device_id'],
      farm: json['farm'],
      imeiOrApiKey: json['imei_or_api_key'],
      name: json['name'],
      deviceType: json['device_type'],
      numFans: json['num_fans'],
      numCoolingPumps: json['num_cooling_pumps'],
      numWaterSupplyPumps: json['num_water_supply_pumps'],
      numLights: json['num_lights'],
      numHumiditySensors: json['num_humidity_sensors'],
      numTemperatureSensors: json['num_temperature_sensors'],
      waterTankSize: json['water_tank_size'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'device_type': deviceType,
      'imei_or_api_key': imeiOrApiKey,
      'farm': farm,
      'num_fans': numFans,
      'num_cooling_pumps': numCoolingPumps,
      'num_water_supply_pumps': numWaterSupplyPumps,
      'num_lights': numLights,
      'num_humidity_sensors': numHumiditySensors,
      'num_temperature_sensors': numTemperatureSensors,
      'water_tank_size': waterTankSize,
    };
  }

  // Copy with method
  DeviceModel copyWith({
    int? id,
    String? name,
    String? deviceType,
    String? imeiOrApiKey,
    int? farm,
    int? numFans,
    int? numCoolingPumps,
    int? numWaterSupplyPumps,
    int? numLights,
    int? numHumiditySensors,
    int? numTemperatureSensors,
    int? waterTankSize,
    String? deviceId,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceType: deviceType ?? this.deviceType,
      imeiOrApiKey: imeiOrApiKey ?? this.imeiOrApiKey,
      farm: farm ?? this.farm,
      numFans: numFans ?? this.numFans,
      numCoolingPumps: numCoolingPumps ?? this.numCoolingPumps,
      numWaterSupplyPumps: numWaterSupplyPumps ?? this.numWaterSupplyPumps,
      numLights: numLights ?? this.numLights,
      numHumiditySensors: numHumiditySensors ?? this.numHumiditySensors,
      numTemperatureSensors: numTemperatureSensors ?? this.numTemperatureSensors,
      waterTankSize: waterTankSize ?? this.waterTankSize,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  String toString() {
    return "{id: $id, name: $name, deviceType: $deviceType, imeiOrApiKey: $imeiOrApiKey, farm: $farm, numFans: $numFans, numCoolingPumps: $numCoolingPumps, numWaterSupplyPumps: $numWaterSupplyPumps, numLights: $numLights, numHumiditySensors: $numHumiditySensors, numTemperatureSensors: $numTemperatureSensors, waterTankSize: $waterTankSize, deviceId: $deviceId}";
  }
}
