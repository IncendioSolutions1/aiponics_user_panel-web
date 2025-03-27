import 'dart:developer' as dev;
import 'dart:math';
import 'package:aiponics_web_app/models/header%20model/header_model.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/theme_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/provider/header%20provider/header_provider.dart';
import 'package:aiponics_web_app/provider/user%20info%20provider/user_info_provider.dart';
import 'package:aiponics_web_app/views/common/dashboard%20management/dashboards_gauges_and_graphs.dart';
import 'package:aiponics_web_app/views/common/header/header_with_farm_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoilBasedDashboard extends ConsumerStatefulWidget {
  const SoilBasedDashboard({super.key});

  @override
  ConsumerState<SoilBasedDashboard> createState() => _SoilBasedDashboardState();
}

class _SoilBasedDashboardState extends ConsumerState<SoilBasedDashboard>
    with SingleTickerProviderStateMixin {


  late DashboardCommonGauges dashboardCommonGauges;

  late double fiveWidth;
  late double fullWidth;
  late double remainingWidth;

  late bool showAds;
  late bool areValueInitialized;

  double? windDirection;
  double? windSpeed; // Wind speed value to be displayed
  double? solarRadiation; // Solar radiation value
  double? airHumidity; // Air Humidity value
  double? barometricPressure; // Barometric pressure value in hPa
  double? electricalConductivity; // Barometric pressure value in hPa
  double? salinity; // Barometric pressure value in hPa
  double? rainFallValue; // Rain fall value
  double? airTemperature;
  double? soilTemperature;
  double? pHLevel;
  double? moistureLevel;


  late AnimationController _controller;
  late Animation<double> rotationAnimation;

  late List<List<double>?>? npkData = [];

  late Map<String, Widget> gaugesFunctions = {};
  late Widget npkGraph;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
      upperBound: 1,
    )..repeat(); // Repeat the animation continuously

    rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    areValueInitialized = false;

    windDirection = 0;
    windSpeed = 0;
    solarRadiation = 0;
    airHumidity = 0;
    barometricPressure = 0;
    electricalConductivity = 0;
    salinity = 0;
    rainFallValue = 0;
    airTemperature = 0;
    soilTemperature = 0;
    pHLevel = 0;
    moistureLevel = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initializeValues() {
    final screenNotifier = ref.watch(dashboardScreenInfoProvider);

    fiveWidth = screenNotifier['fiveWidth'];
    remainingWidth = screenNotifier['screenRemainingWidth'];
    fullWidth = screenNotifier['screenFullWidth'];
    showAds = ref.watch(userAccountInfoProvider).role[0] == 'regular';


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
    final Map<String,Widget> gaugesFunctionsOriginal = {
      "airTemperature": dashboardCommonGauges.gaugeForTemperature("Air Temperature", airTemperature!),
      "windDirection": dashboardCommonGauges.windDirectionGauge(windDirection!),
      "windSpeed": dashboardCommonGauges.windSpeedGauge("Wind Speed: $windSpeed km/h", rotationAnimation),
      "airHumidity":  dashboardCommonGauges.gaugeForHumidity("Air Humidity", airHumidity!),
      "solarRadiation": dashboardCommonGauges.solarRadiationGauge(solarRadiation!),
      "barometricPressure": dashboardCommonGauges.soilGaugeForMultipleDevices("Barometric Pressure", barometricPressure!),
      "rainGauge": dashboardCommonGauges.soilGaugeForMultipleDevices("Rain Gauge", rainFallValue!),
      "moistureLevel": dashboardCommonGauges.fullRoundedMoistureGauge(moistureLevel!),
      "electricalConductivity": dashboardCommonGauges.soilGaugeForMultipleDevices("Electrical Conductivity", electricalConductivity!),
      "pHLevel": dashboardCommonGauges.gaugeForPhLevel(pHLevel!),
      "soilTemperature": dashboardCommonGauges.gaugeForTemperature("Soil Temperature", soilTemperature!),
      "salinity": dashboardCommonGauges.soilGaugeForMultipleDevices("Salinity", salinity!),
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
        gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(1)] = gaugesFunctionsOriginal.values.elementAt(1);
      } else if (gaugesFunctionsOriginal.length == 3) {
        gaugesFunctions["add1"] = dashboardCommonGauges.adsWidget();
        gaugesFunctions[gaugesFunctionsOriginal.keys.first] = gaugesFunctionsOriginal.values.first;
        gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(1)] = gaugesFunctionsOriginal.values.elementAt(1);
        gaugesFunctions["add2"] = dashboardCommonGauges.adsWidget();
        gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(2)] = gaugesFunctionsOriginal.values.elementAt(2);
      } else {
        // General case for more than 3 gauges
        final List<int> potentialPositions = List.generate(
            gaugesFunctionsOriginal.length + adsToShow, (index) => index);
        potentialPositions.removeAt(0);
        potentialPositions.add(gaugesFunctionsOriginal.length + adsToShow);

        potentialPositions.shuffle(); // Shuffle for randomness

        final Set<int> adPositions = {}; // To store indices for ads
        final Set<int> restrictedPositions =
        {}; // To avoid ads in the same column

        restrictedPositions
            .add((gaugesFunctionsOriginal.length + adsToShow) - 4);
        restrictedPositions
            .add((gaugesFunctionsOriginal.length + adsToShow) - 1);
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

        for (int i = 1, j = 0;
        i <= gaugesFunctionsOriginal.length + adsToShow;
        i++) {
          if (adPositions.contains(i)) {
            gaugesFunctions["add$i"] = dashboardCommonGauges.adsWidget(); // Add an ad
          } else if (j < gaugesFunctionsOriginal.length) {
            gaugesFunctions[gaugesFunctionsOriginal.keys.elementAt(j)] = gaugesFunctionsOriginal.values.elementAt(j); // Add a gauge
            j++;
          }
        }
      }
    } else {
      gaugesFunctions = gaugesFunctionsOriginal;
    }

    npkGraph = dashboardCommonGauges.npkGraph(320);
  }

  @override
  Widget build(BuildContext context) {
    initializeValues();
    dashboardCommonGauges = DashboardCommonGauges(context: context, ref: ref);

    if (!areValueInitialized) {
      // Call initialize functions once during the first build
      _initializeGauges();
      areValueInitialized = true;

    }

    ref.listen<HeaderModel>(headerInfoProvider, (previous, next) {
      if(previous?.selectedTemperatureSign != next.selectedTemperatureSign){
        // gaugesFunctions["airTemperature"] = gaugeForTemperature("Farm Temperature", _farmTemperature!, next.selectedTemperatureSign);
        // gaugesFunctions["soilTemperature"] = gaugeForTemperature("External Temperature", _externalTemperature!, next.selectedTemperatureSign);
      }
    });


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (_, constraints) {
            remainingWidth = constraints.maxWidth;

            // Delay the provider update to avoid modification during the build phase
            Future.microtask(() {
              ref
                  .read(dashboardScreenInfoProvider.notifier)
                  .updateScreenRemainingWidth(remainingWidth);
            });

              return Padding(
                padding: const EdgeInsets.only(
                    top: 40, bottom: 40, right: 20, left: 20),
                child: desktopDashboard(),
              );
          },
        ),
      ),
    );
  }

  Widget desktopDashboard() {
    return Column(
      children: [

        const CustomHeaderWithFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Your current performance"),


        if (gaugesFunctions.isNotEmpty) ...[
          SizedBox(
              width: fullWidth,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {

                  // Define the number of items per row
                  int itemsPerRow = ((remainingWidth - 40 - 20) /
                      (fiveWidth * 55 > 230 ? fiveWidth * 55 : 230))
                      .floor();

                  // Calculate the width of each item
                  double itemWidth =
                      (remainingWidth - 40 - (itemsPerRow - 1) * 5.0) /
                          itemsPerRow;

                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 5.0, // Horizontal space between items
                    runSpacing: 5.0, // Vertical space between rows
                    children: gaugesFunctions.entries.map((function) {
                      return SizedBox(
                          width: itemWidth > 230 ? itemWidth : 230,
                          child: function.value);
                    }).toList(),
                  );
                },
              )),
        ],
          const SizedBox(
            height: 5,
          ),
        dashboardCommonGauges.npkGraph(320),
        if (showAds)...[
          const SizedBox(
            height: 5,
          ),
          dashboardCommonGauges.longAds(),
        ],


      ],
    );
  }

}



// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Air Temperature
// Flexible(
// flex: 1,
// child: fullGaugeTemperature(
// fiveWidth * 80,
// fiveWidth * 80,
// "Air Temperature",
// fiveWidth * 60,
// fiveWidth * 60,
// 25,
// ),
// ),
// const SizedBox(
// width: 10,
// ),
// // Wind Direction
// Flexible(
// flex: 1,
// child: windDirectionGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// "Wind Direction",
// fiveWidth * 60,
// fiveWidth * 60,
// 100,
// ),
// ),
// const SizedBox(
// width: 10,
// ),
// // Wind Speed
// Flexible(
// flex: 1,
// child: windSpeedGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// "Wind Speed",
// fiveWidth * 45,
// fiveWidth * 45,
// "Wind Speed: 100.0 km/h",
// ),
// ),
// ],
// ),
// const SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Solar Radiation
// Flexible(
// flex: 1,
// child: solarRadiationGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// fiveWidth * 60,
// fiveWidth * 60,
// 100,
// ),
// ),
// const SizedBox(
// width: 10,
// ),
// // Air Humidity
// Flexible(
// flex: 1,
// child: fullBarRangeGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// "Air Humidity",
// fiveWidth * 60,
// fiveWidth * 60,
// 0,
// 100,
// 30,
// DashboardCommonMethods.getHumidityColor),
// ),
// const SizedBox(
// width: 10,
// ),
// // Barometric Pressure
// Flexible(
// flex: 1,
// child: fullRoundedGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// "Barometric Pressure",
// fiveWidth * 60,
// fiveWidth * 60,
// 0,
// 1080,
// 135,
// 3,
// 300,
// 700,
// "1013.0 hPa",
// 1013),
// ),
// ],
// ),
// const SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Rain Gauge
// Flexible(
// flex: 1,
// child: fullRoundedGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// "Rain Gauge",
// fiveWidth * 60,
// fiveWidth * 60,
// 0,
// 100,
// 10,
// 2,
// 20,
// 50,
// "10.0 mm",
// 10),
// ),
// const SizedBox(
// width: 10,
// ),
// Flexible(
// flex: 2,
// child: npkGraph(
// fiveWidth * 80, fiveWidth * 160, "NPK Values", fiveWidth * 60,
// fiveWidth * 120,
// [
// const FlSpot(1, 50),
// const FlSpot(2, 55),
// const FlSpot(3, 60)
// ], // Nitrogen data
// [
// const FlSpot(1, 40),
// const FlSpot(2, 45),
// const FlSpot(3, 50)
// ], // Phosphorus data
// [
// const FlSpot(1, 30),
// const FlSpot(2, 35),
// const FlSpot(3, 45)
// ], // Potassium data
// "Current NPK Levels",
// ),
// ),
// ],
// ),
// const SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Rain Gauge
// Flexible(
// flex: 1,
// child: fullRoundedMoistureGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// fiveWidth * 60,
// fiveWidth * 60,
// 45,
// fiveWidth,
// ),
// ),
// const SizedBox(
// width: 10,
// ),
// Flexible(
// flex: 1,
// child: fullRoundedGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// "Electrical Conductivity",
// fiveWidth * 60,
// fiveWidth * 60,
// 0,
// 100,
// 10,
// 2,
// 20,
// 50,
// "10.0 µS/cm",
// 10),
// ),
// const SizedBox(
// width: 10,
// ),
// Flexible(
// flex: 1,
// child: fullGaugeFullCustomizable(
// fiveWidth * 80,
// fiveWidth * 80,
// "pH Value",
// fiveWidth * 60,
// fiveWidth * 60,
// 0,
// 14,
// 2,
// 6,
// 8,
// 10,
// ),
// ),
// ],
// ),
// const SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Soil Temperature
// Flexible(
// flex: 1,
// child: fullGaugeTemperature(
// fiveWidth * 80,
// fiveWidth * 80,
// "Soil Temperature",
// fiveWidth * 60,
// fiveWidth * 60,
// 25,
// ),
// ),
// const SizedBox(
// width: 10,
// ),
// // Wind Direction
// Flexible(
// flex: 1,
// child: fullRoundedGauge(
// fiveWidth * 80,
// fiveWidth * 80,
// "Salinity",
// fiveWidth * 60,
// fiveWidth * 60,
// 0,
// 50,
// 5,
// 5,
// 10,
// 20,
// "10.0 ppt",
// 10),
// ),
// ],
// ),