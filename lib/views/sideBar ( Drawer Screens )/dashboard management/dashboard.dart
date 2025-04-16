import 'dart:convert';
import 'dart:developer';
import 'package:aiponics_web_app/controllers/farm%20and%20device%20controller/device_controller.dart';
import 'package:aiponics_web_app/models/dashboard%20management%20models/dashboard_model.dart';
import 'package:aiponics_web_app/models/farm%20and%20devices%20models/farm_model.dart';
import 'package:aiponics_web_app/models/header%20model/header_model.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/provider/farm%20and%20devices%20provider/view_farms_and_devices_provider.dart';
import 'package:aiponics_web_app/provider/header%20provider/header_provider.dart';
import 'package:aiponics_web_app/provider/user%20info%20provider/user_info_provider.dart';
import 'package:aiponics_web_app/views/common/dashboard%20management/dashboards_gauges_and_graphs.dart';
import 'package:aiponics_web_app/views/common/header/header_with_farm_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../controllers/common_methods.dart';
import '../../../controllers/token controllers/access_and_refresh_token_controller.dart';
import '../../../models/farm and devices models/device_model.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  late DashboardCommonGauges dashboardCommonGauges;

  late double fiveWidth;
  late double fullWidth;
  late double remainingWidth;

  late bool showAds;

  late bool areValueInitialized;

  double? _farmTemperature = 0;
  double? _externalTemperature = 0;
  double? _waterTemperature = 0;

  double? _farmHumidity = 0;
  double? _externalHumidity = 0;

  double? _pHLevel = 0;
  double? _farmCo2Level = 0;

  late List<Map<int, double>?>? lightIntensityData = [];
  late List<Map<int, double>?>? energyConsumptionData = [];
  late List<Map<double, double>?>? tdsData = [];

  late Map<String, Widget> gaugesFunctions = {};
  late List<Widget> graphFunctions = [];
  late List<Widget> tdsAndTodoFunctions = [];

  @override
  void initState() {
    areValueInitialized = false;
    super.initState();
  }

  void initializeValues() {
    final screenNotifier = ref.watch(dashboardScreenInfoProvider);

    fiveWidth = screenNotifier['fiveWidth'];
    remainingWidth = screenNotifier['screenRemainingWidth'];
    fullWidth = screenNotifier['screenFullWidth'];
    showAds = ref.watch(userAccountInfoProvider).userAccountInfoModel.role[0] == 'regular';


    _farmTemperature = ref.watch(dashboardInfoProvider).farmTemperature;
    _externalTemperature = ref.watch(dashboardInfoProvider).externalTemperature;
    _farmHumidity = ref.watch(dashboardInfoProvider).farmHumidity;
    _externalHumidity = ref.watch(dashboardInfoProvider).externalHumidity;
    _waterTemperature = ref.watch(dashboardInfoProvider).waterTemperature;
    _pHLevel = ref.watch(dashboardInfoProvider).pHLevel;
    _farmCo2Level = ref.watch(dashboardInfoProvider).farmCoLevel;

    lightIntensityData = ref.watch(dashboardInfoProvider).lightIntensity;
    energyConsumptionData = ref.watch(dashboardInfoProvider).energyConsumption;
    tdsData = ref.watch(dashboardInfoProvider).tdsValues;
  }

  void _initializeGauges() {
    // no of Gauges ,  no of Ads
    //  8           ,     4
    //  7           ,     3
    //  6           ,     2
    //  5           ,     1
    //  4           ,     4 or 3
    //  3           ,     2
    //  2           ,     2
    //  1           ,     2

    final Map<String, Widget> gaugesFunctionsOriginal = {
      "farmTemperature":
          dashboardCommonGauges.gaugeForTemperature("Farm Temperature", _farmTemperature!),
      "farmHumidity": dashboardCommonGauges.gaugeForHumidity("Farm Humidity", _farmHumidity!),
      "waterTemperature":
          dashboardCommonGauges.gaugeForTemperature("Water Temperature", _waterTemperature!),
      "pHLevel": dashboardCommonGauges.gaugeForPhLevel(_pHLevel!),
      "externalTemperature":
          dashboardCommonGauges.gaugeForTemperature("External Temperature", _externalTemperature!),
      "externalHumidity":
          dashboardCommonGauges.gaugeForHumidity("External Humidity", _externalHumidity!),
      "waterLevel": dashboardCommonGauges.waterLevel(),
      "coLevel": dashboardCommonGauges.coLevelsGauge("Farm Co2 Levels", _farmCo2Level!),
    };

    int adsToShow = gaugesFunctionsOriginal.length % 4 == 0
        ? 4
        : gaugesFunctionsOriginal.length % 4; // Fixed number of ads to show

    gaugesFunctions.clear();

    if (showAds) {
      // Handle cases based on the number of gauges
      if (gaugesFunctionsOriginal.length == 1) {
        gaugesFunctions["add1"] = dashboardCommonGauges.adsWidget();
        gaugesFunctions[gaugesFunctionsOriginal.keys.first] = gaugesFunctionsOriginal.values.first;
        gaugesFunctions["add2"] = dashboardCommonGauges.adsWidget();
      } else if (gaugesFunctionsOriginal.length == 2) {
        gaugesFunctions["add1"] = dashboardCommonGauges.adsWidget();
        gaugesFunctions[gaugesFunctionsOriginal.keys.first] = gaugesFunctionsOriginal.values.first;
        gaugesFunctions["add2"] = dashboardCommonGauges.adsWidget();
        gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(1)] =
            gaugesFunctionsOriginal.values.elementAt(1);
      } else if (gaugesFunctionsOriginal.length == 3) {
        gaugesFunctions["add1"] = dashboardCommonGauges.adsWidget();
        gaugesFunctions[gaugesFunctionsOriginal.keys.first] = gaugesFunctionsOriginal.values.first;
        gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(1)] =
            gaugesFunctionsOriginal.values.elementAt(1);
        gaugesFunctions["add2"] = dashboardCommonGauges.adsWidget();
        gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(2)] =
            gaugesFunctionsOriginal.values.elementAt(2);
      } else {
        // General case for more than 3 gauges
        final List<int> potentialPositions =
            List.generate(gaugesFunctionsOriginal.length + adsToShow, (index) => index);
        potentialPositions.removeAt(0);
        potentialPositions.add(gaugesFunctionsOriginal.length + adsToShow);

        potentialPositions.shuffle(); // Shuffle for randomness

        final Set<int> adPositions = {}; // To store indices for ads
        final Set<int> restrictedPositions = {}; // To avoid ads in the same column

        restrictedPositions.add((gaugesFunctionsOriginal.length + adsToShow) - 4);
        restrictedPositions.add((gaugesFunctionsOriginal.length + adsToShow) - 1);
        restrictedPositions.add((gaugesFunctionsOriginal.length + adsToShow));

        int adPositionCounter = 1;
        // Place the first random ad
        for (int pos in potentialPositions) {
          if (adPositionCounter == adsToShow) {
            break;
          }
          int column = pos % 4;

          if (!adPositions.contains(pos - 1) &&
              !adPositions.contains(pos + 1) &&
              !adPositions.contains(pos) &&
              !restrictedPositions.contains(column) &&
              !restrictedPositions.contains(pos)) {
            if (restrictedPositions.contains(column) ||
                adPositions.contains(pos - 4) ||
                adPositions.contains(pos + 4)) {
              restrictedPositions.add(column);
            } else {
              adPositions.add(pos);
              adPositionCounter++;
            }
          }
        }

        // Place the last ad at the end
        adPositions.add((gaugesFunctionsOriginal.length + adsToShow));

        for (int i = 1, j = 0; i <= gaugesFunctionsOriginal.length + adsToShow; i++) {
          if (adPositions.contains(i)) {
            gaugesFunctions["add$i"] = dashboardCommonGauges.adsWidget(); // Add an ad
          } else if (j < gaugesFunctionsOriginal.length) {
            gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(j)] =
                gaugesFunctionsOriginal.values.elementAt(j); // Add a gauge
            j++;
          }
        }
      }
    } else {
      gaugesFunctions = gaugesFunctionsOriginal;
    }

    graphFunctions = [
      dashboardCommonGauges.lightIntensityAndEnergyConsumptionGraph("Energy Consumption",
          "Time (seconds)", "Energy (kWh)", 0, 150, 30, energyConsumptionData),
      dashboardCommonGauges.lightIntensityAndEnergyConsumptionGraph("Light Intensity",
          'Time (seconds)', 'Light Intensity (lx)', 0, 100, 20, lightIntensityData),
    ];

    tdsAndTodoFunctions = [
      dashboardCommonGauges.tdsGraph(450),
      dashboardCommonGauges.todos(450),
    ];
  }


  List<String> devicesId = [];
  Map<String, WebSocketChannel> deviceChannels = {}; // Storing active channels

  Future<void> fetchDevices() async {
    // Clear any previously stored device IDs.
    devicesId.clear();

    // Disconnect existing WebSocket connections and clear the map.
    deviceChannels.forEach((_, wsChannel) {
      wsChannel.sink.close();
    });
    deviceChannels.clear();

    // Get the selected farm from your provider.
    FarmModel farmModel = ref.watch(viewFarmsAndDevicesProvider).selectedFarm;

    if (farmModel.id != 0) {
      // Fetch devices for the given farm id.
      Map<bool, List<DeviceModel>> devices =
      await DeviceService.fetchDevices(farmModel.id);

      for (var deviceList in devices.values) {
        for (var device in deviceList) {
          if (device.deviceId.isNotEmpty) {
            final deviceId = device.deviceId;
            devicesId.add(deviceId);
            log("🔌 Connecting WebSocket for Device ID: $deviceId");

            // Retrieve the Bearer token.
            String? bearerToken = await fetchAccessToken();
            if (bearerToken == null) {
              CommonMethods.showSnackBarWithoutContext(
                "Error",
                "An error occurred. Please try again later.",
                "failure",
              );
              return;
            }

            // Encode token to safely pass in URL (in case of special characters)
            final encodedToken = Uri.encodeComponent(bearerToken);

            // Build the WebSocket URL like deviceId/token in the path
            final String url = 'ws://control-panel.ai-ponics.com/ws/live-data/$deviceId/$encodedToken/';

            log("connecting to : $url");

            final channel = WebSocketChannel.connect(Uri.parse(url));

            log("✅ WebSocket connected: $deviceId");

            // Set up listeners for the WebSocket connection.
            channel.stream.listen(
                  (message) {
                log("📡 [$deviceId] Message: $message");
                handleWebSocketMessage(message);
              },
              onError: (error) {
                log("⚠️ [$deviceId] WebSocket error: $error");
              },
              onDone: () {
                log("❌ WebSocket disconnected: $deviceId");
              },
            );

            // Store channel for future control (disconnect, reconnect etc.)
            deviceChannels[deviceId] = channel;
          }
        }
      }
    }
  }


  // Example function to handle an incoming WebSocket message.
  void handleWebSocketMessage(String rawMessage) {
    try {
      // Parse the JSON message.
      final Map<String, dynamic> messageMap = jsonDecode(rawMessage);

      // Check if the 'model' is MonitoringSystem.
      if (messageMap['model'] == 'MonitoringSystem') {
        // Extract the 'data' map.
        final Map<String, dynamic> data = messageMap['data'];

        // Extract values for average and external measurements.
        final double averageHumidity = (data['average_humidity'] as num).toDouble();
        final double averageTemperature = (data['average_temperature'] as num).toDouble();
        final double averageLight = (data['average_light'] as num).toDouble();
        final double externalTemperature = (data['external_temperature'] as num).toDouble();
        final double externalHumidity = (data['external_humidity'] as num).toDouble();

        // Now update your UI/state variables accordingly.
        // For example, if you're in a StatefulWidget you might do:
        // setState(() {
        //   _averageHumidity = averageHumidity;
        //   _averageTemperature = averageTemperature;
        //   _averageLight = averageLight;
        //   _externalTemperature = externalTemperature;
        //   _externalHumidity = externalHumidity;
        // });

        // For demonstration purposes, we print the values.
        log('Average Humidity: $averageHumidity');
        log('Average Temperature: $averageTemperature');
        log('Average Light: $averageLight');
        log('External Temperature: $externalTemperature');
        log('External Humidity: $externalHumidity');
      } else {
        log('Received message with unsupported model: ${messageMap['model']}');
      }
    } catch (e) {
      // Handle any parsing errors.
      log('Error parsing JSON message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    dashboardCommonGauges = DashboardCommonGauges(context: context, ref: ref);
    initializeValues();
    // fetchDevices();

    if (!areValueInitialized && !ref.watch(userAccountInfoProvider).isLoading) {
      // Call initialize functions once during the first build
      _initializeGauges();
      // fetchDevices();
      areValueInitialized = true;
    }

    ref.listen<HeaderModel>(headerInfoProvider, (previous, next) {
      if (previous?.selectedTemperatureSign != next.selectedTemperatureSign) {
        gaugesFunctions["farmTemperature"] =
            dashboardCommonGauges.gaugeForTemperature("Farm Temperature", _farmTemperature!);
        gaugesFunctions["externalTemperature"] = dashboardCommonGauges.gaugeForTemperature(
          "External Temperature",
          _externalTemperature!,
        );
        gaugesFunctions["waterTemperature"] =
            dashboardCommonGauges.gaugeForTemperature("Water Temperature", _waterTemperature!);
      }
    });

    ref.listen<DashboardInfoModel>(dashboardInfoProvider, (previous, next) {});

    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
          remainingWidth = constraints.maxWidth;

          // Delay the provider update to avoid modification during the build phase
          Future.microtask(() {
            ref
                .read(dashboardScreenInfoProvider.notifier)
                .updateScreenRemainingWidth(remainingWidth);
          });

          return Container(
            padding: const EdgeInsets.only(
                top: 40, bottom: 40, right: 20, left: 20), // Padding for desktop layout
            child: responsiveUniversalDashboard(), // Call desktop dashboard management method
          );
        }),
      ),
    );
  }

  // Responsive Version of Desktop
  Widget responsiveUniversalDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const CustomHeaderWithFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Your current performance"),

        if (gaugesFunctions.isNotEmpty) ...[
          SizedBox(
              width: fullWidth,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Define the number of items per row
                  int itemsPerRow =
                      ((remainingWidth - 40 - 20) / (fiveWidth * 55 > 230 ? fiveWidth * 55 : 230))
                          .floor();

                  // Calculate the width of each item
                  double itemWidth = (remainingWidth - 40 - (itemsPerRow - 1) * 5.0) / itemsPerRow;

                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5.0, // Horizontal space between items
                    runSpacing: 5.0, // Vertical space between rows
                    children: gaugesFunctions.entries.map((function) {
                      return SizedBox(
                          width: itemWidth > 230 ? itemWidth : 230, child: function.value);
                    }).toList(),
                  );
                },
              )),
        ],
        if (tdsAndTodoFunctions.isNotEmpty) ...[
          const SizedBox(
            height: 5,
          ),
          SizedBox(
              width: fullWidth,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  int itemsPerRow =
                      ((remainingWidth - 40 - 20) / (fiveWidth * 55 > 230 ? fiveWidth * 55 : 230))
                          .floor();

                  double widthPerItem = (((remainingWidth - 40) / itemsPerRow));
                  int tdsItemsPerRow = itemsPerRow > 2 ? itemsPerRow - 1 : itemsPerRow;
                  int todoItemPerRow = itemsPerRow > 2 ? 1 : itemsPerRow;
                  int spaceDetection = itemsPerRow > 2 ? 5 : 0;

                  double tdsWidth = (widthPerItem * tdsItemsPerRow) > fiveWidth * 110
                      ? (widthPerItem * tdsItemsPerRow)
                      : fiveWidth * 110;
                  double todoWidth = (widthPerItem * todoItemPerRow) - spaceDetection > 230
                      ? (widthPerItem * todoItemPerRow) - spaceDetection
                      : 230;

                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5.0, // Horizontal space between items
                    runSpacing: 5.0, // Vertical space between rows
                    children: tdsAndTodoFunctions.asMap().entries.map((entry) {
                      final Widget function = entry.value; // Current function or widget

                      return SizedBox(
                        width: function.toStringShort() == "SizedBox" ? tdsWidth : todoWidth,
                        child: function,
                      );
                    }).toList(),
                  );
                },
              )),
        ],
        if (showAds) ...[
          const SizedBox(
            height: 5,
          ),
          dashboardCommonGauges.longAds(),
        ],
        if (graphFunctions.isNotEmpty) ...[
          const SizedBox(
            height: 5,
          ),
          SizedBox(
              width: fullWidth,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Define the number of items per row
                  int itemsPerRow =
                      ((remainingWidth - 40 - 20) / (fiveWidth * 110 > 350 ? fiveWidth * 110 : 350))
                          .floor();

                  // Calculate the width of each item
                  double itemWidth = (remainingWidth - 40 - (itemsPerRow - 1) * 5.0) / itemsPerRow;

                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5.0, // Horizontal space between items
                    runSpacing: 5.0, // Vertical space between rows
                    children: graphFunctions.map((function) {
                      return SizedBox(width: itemWidth, child: function);
                    }).toList(),
                  );
                },
              )),
        ],
      ],
    );
  }
}
