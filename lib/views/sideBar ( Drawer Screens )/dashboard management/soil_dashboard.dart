import 'dart:developer' as dev;
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SoilBasedDashboard extends StatefulWidget {
  const SoilBasedDashboard({super.key});

  @override
  State<SoilBasedDashboard> createState() => _SoilBasedDashboardState();
}

class _SoilBasedDashboardState extends State<SoilBasedDashboard>
    with SingleTickerProviderStateMixin {
  late Color boxColor;
  late Color accessibilityButtonsBorderColor;
  late Color boxHeadingColor;
  late Color graphLabelColor;
  late Color graphMajorTicksColor;
  late Color graphMinorTicksColor;
  late Color graphKnobColor;
  late Color graphNeedleColor;

  // List of farms and devices
  List<String> farms = ['Farm 1', 'Farm 2', 'Farm 3'];

  // Initially, no farm is selected
  String? selectedFarm;

  double airPressure = 25;
  double windDirection = 100;
  double windSpeed = 100; // Wind speed value to be displayed
  double solarRadiation = 100; // Solar radiation value
  final double _airHumidity = 30; // Air Humidity value
  double biometricPressure =
      1013; // Barometric pressure value in hPa (hectopascals)
  double rainFallValue = 10; // Rain fall value

  double? _airTemperature;
  double? _externalHumidity;
  double? _waterTemperature;
  double? _waterLevel;
  double? _pHLevel;
  double? _farmCo2Level;

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
      upperBound: 1,
    )..repeat(); // Repeat the animation continuously

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    boxColor = Theme.of(context).colorScheme.onSecondary;
    accessibilityButtonsBorderColor =
        Theme.of(context).inputDecorationTheme.border!.borderSide.color;
    boxHeadingColor = Theme.of(context).textTheme.labelLarge!.color!;
    graphLabelColor = Theme.of(context).colorScheme.onSurface;
    graphMajorTicksColor = Theme.of(context).colorScheme.onSurface;
    graphMinorTicksColor = Theme.of(context).colorScheme.onSurface;
    graphKnobColor = Theme.of(context).colorScheme.onSurface;
    graphNeedleColor = Theme.of(context).colorScheme.onSurface;

    // Get the screen size to make the layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final fiveWidth = screenWidth * 0.003434;
    final fiveHeight = screenHeight * 0.005681;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final width = MediaQuery.of(context).size.width;

            dev.log(" ${constraints.maxWidth}");
            dev.log("$width");
            if (constraints.maxWidth >= 1000) {
              dev.log("Desktop");
              return Padding(
                padding: const EdgeInsets.only(
                    top: 40, bottom: 40, right: 50, left: 50),
                child: desktopDashboard(context, fiveWidth, fiveHeight, width),
              );
            } else if ((constraints.maxWidth < 1000 &&
                    constraints.maxWidth >= 700) &&
                width >= 750) {
              dev.log("Tablet");
              return Padding(
                padding: const EdgeInsets.only(
                    top: 40, bottom: 40, right: 50, left: 50),
                child: tabletDashboard(context, fiveWidth, fiveHeight, width),
              );
            } else {
              dev.log("Mobile");
              return Padding(
                padding: const EdgeInsets.only(
                    top: 40, bottom: 40, right: 50, left: 50),
                child: mobileDashboard(context, fiveWidth, fiveHeight, width),
              );
            }
          },
        ),
      ),
    );
  }

  Widget desktopDashboard(
      BuildContext context, double fiveWidth, double fiveHeight, double width) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            welcomeHeader(20, 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                selectFarmDropDown(fiveWidth * 36, 40),
                SizedBox(
                  width: fiveWidth * 4,
                ),
                roundCompanyIcon(),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        accessibilityButtons(fiveWidth * 16, fiveWidth),
        divider(),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Air Temperature
            Flexible(
              flex: 1,
              child: fullGaugeTemperature(
                fiveWidth * 80,
                fiveWidth * 80,
                "Air Temperature",
                fiveWidth * 60,
                fiveWidth * 60,
                25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Wind Direction
            Flexible(
              flex: 1,
              child: windDirectionGauge(
                fiveWidth * 80,
                fiveWidth * 80,
                "Wind Direction",
                fiveWidth * 60,
                fiveWidth * 60,
                100,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Wind Speed
            Flexible(
              flex: 1,
              child: windSpeedGauge(
                fiveWidth * 80,
                fiveWidth * 80,
                "Wind Speed",
                fiveWidth * 45,
                fiveWidth * 45,
                "Wind Speed: 100.0 km/h",
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solar Radiation
            Flexible(
              flex: 1,
              child: solarRadiationGauge(
                fiveWidth * 80,
                fiveWidth * 80,
                fiveWidth * 60,
                fiveWidth * 60,
                100,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Air Humidity
            Flexible(
              flex: 1,
              child: fullBarRangeGauge(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Air Humidity",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  0,
                  100,
                  30,
                  _getHumidityColor),
            ),
            const SizedBox(
              width: 10,
            ),
            // Barometric Pressure
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Barometric Pressure",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  0,
                  1080,
                  135,
                  3,
                  300,
                  700,
                  "1013.0 hPa",
                  1013),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rain Gauge
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Rain Gauge",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  0,
                  100,
                  10,
                  2,
                  20,
                  50,
                  "10.0 mm",
                  10),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 2,
              child: graphMultipleLines(
                fiveWidth * 80, fiveWidth * 160, "NPK Values", fiveWidth * 60,
                fiveWidth * 120,
                [
                  const FlSpot(1, 50),
                  const FlSpot(2, 55),
                  const FlSpot(3, 60)
                ], // Nitrogen data
                [
                  const FlSpot(1, 40),
                  const FlSpot(2, 45),
                  const FlSpot(3, 50)
                ], // Phosphorus data
                [
                  const FlSpot(1, 30),
                  const FlSpot(2, 35),
                  const FlSpot(3, 45)
                ], // Potassium data
                "Current NPK Levels",
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rain Gauge
            Flexible(
              flex: 1,
              child: fullRoundedMoistureGauge(
                fiveWidth * 80,
                fiveWidth * 80,
                fiveWidth * 60,
                fiveWidth * 60,
                45,
                fiveWidth,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Electrical Conductivity",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  0,
                  100,
                  10,
                  2,
                  20,
                  50,
                  "10.0 µS/cm",
                  10),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: fullGaugeFullCustomizable(
                fiveWidth * 80,
                fiveWidth * 80,
                "pH Value",
                fiveWidth * 60,
                fiveWidth * 60,
                0,
                14,
                2,
                6,
                8,
                10,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soil Temperature
            Flexible(
              flex: 1,
              child: fullGaugeTemperature(
                fiveWidth * 80,
                fiveWidth * 80,
                "Soil Temperature",
                fiveWidth * 60,
                fiveWidth * 60,
                25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Wind Direction
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Salinity",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  0,
                  50,
                  5,
                  5,
                  10,
                  20,
                  "10.0 ppt",
                  10),
            ),
          ],
        ),
      ],
    );
  }

  Widget tabletDashboard(
      BuildContext context, double fiveWidth, double fiveHeight, double width) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            welcomeHeader(20, 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                selectFarmDropDown(fiveWidth * 36, 45),
                SizedBox(
                  width: fiveWidth * 4,
                ),
                roundCompanyIcon(),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        accessibilityButtons(80, fiveWidth),
        divider(),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Air Temperature
            Flexible(
              flex: 1,
              child: fullGaugeTemperature(
                fiveWidth * 100,
                width / 2,
                "Air Temperature",
                fiveWidth * 80,
                fiveWidth * 80,
                25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Wind Direction
            Flexible(
              flex: 1,
              child: windDirectionGauge(
                fiveWidth * 100,
                width / 2,
                "Wind Direction",
                fiveWidth * 75,
                fiveWidth * 75,
                100,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wind Speed
            Flexible(
              flex: 1,
              child: windSpeedGauge(
                fiveWidth * 100,
                width / 2,
                "Wind Speed",
                fiveWidth * 60,
                fiveWidth * 60,
                "Wind Speed: 100.0 km/h",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Solar Radiation
            Flexible(
              flex: 1,
              child: solarRadiationGauge(
                fiveWidth * 100,
                width / 2,
                fiveWidth * 75,
                fiveWidth * 75,
                100,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Air Humidity
            Flexible(
              flex: 1,
              child: fullBarRangeGauge(
                fiveWidth * 100,
                width / 2,
                "Air Humidity",
                fiveWidth * 80,
                fiveWidth * 80,
                0,
                100,
                30,
                _getHumidityColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Barometric Pressure
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                fiveWidth * 100,
                width / 2,
                "Barometric Pressure",
                fiveWidth * 75,
                fiveWidth * 75,
                0,
                1080,
                135,
                3,
                300,
                700,
                "1013.0 hPa",
                1013,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rain Gauge
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                fiveWidth * 100,
                width / 2,
                "Rain Gauge",
                fiveWidth * 75,
                fiveWidth * 75,
                0,
                100,
                10,
                2,
                20,
                50,
                "10.0 mm",
                10,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Rain Gauge
            Flexible(
              flex: 1,
              child: fullRoundedMoistureGauge(
                fiveWidth * 100,
                width / 2,
                fiveWidth * 75,
                fiveWidth * 75,
                45,
                fiveWidth,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        graphMultipleLines(
          fiveWidth * 100,
          width,
          "NPK Values",
          fiveWidth * 80,
          fiveWidth * 190,
          [
            const FlSpot(1, 50),
            const FlSpot(2, 55),
            const FlSpot(3, 60)
          ], // Nitrogen data
          [
            const FlSpot(1, 40),
            const FlSpot(2, 45),
            const FlSpot(3, 50)
          ], // Phosphorus data
          [
            const FlSpot(1, 30),
            const FlSpot(2, 35),
            const FlSpot(3, 45)
          ], // Potassium data
          "Current NPK Levels",
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                  fiveWidth * 100,
                  width / 2,
                  "Electrical Conductivity",
                  fiveWidth * 75,
                  fiveWidth * 75,
                  0,
                  100,
                  10,
                  2,
                  20,
                  50,
                  "10.0 µS/cm",
                  10),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: fullGaugeFullCustomizable(
                fiveWidth * 100,
                width / 2,
                "pH Value",
                fiveWidth * 80,
                fiveWidth * 80,
                0,
                14,
                2,
                6,
                8,
                25,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soil Temperature
            Flexible(
              flex: 1,
              child: fullGaugeTemperature(
                fiveWidth * 100,
                width / 2,
                "Soil Temperature",
                fiveWidth * 80,
                fiveWidth * 80,
                25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Wind Direction
            Flexible(
              flex: 1,
              child: fullRoundedGauge(
                  fiveWidth * 100,
                  width / 2,
                  "Salinity",
                  fiveWidth * 75,
                  fiveWidth * 75,
                  0,
                  50,
                  5,
                  5,
                  10,
                  20,
                  "10.0 ppt",
                  10),
            ),
          ],
        ),
      ],
    );
  }

  Widget mobileDashboard(
      BuildContext context, double fiveWidth, double fiveHeight, double width) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                welcomeHeader(20, 15),
                roundCompanyIcon(),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            selectFarmDropDown(120, 45),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        accessibilityButtons(80, fiveWidth),
        divider(),
        const SizedBox(
          height: 50,
        ),

        // Air Temperature
        fullGaugeTemperature(
          350,
          double.infinity,
          "Air Temperature",
          300,
          350,
          25,
        ),

        const SizedBox(
          height: 10,
        ),

        // Wind Direction
        windDirectionGauge(
          350,
          double.infinity,
          "Wind Direction",
          300,
          350,
          100,
        ),

        const SizedBox(
          height: 10,
        ),

        windSpeedGauge(
          350,
          double.infinity,
          "Wind Speed",
          200,
          200,
          "Wind Speed: 100.0 km/h",
        ),

        const SizedBox(
          height: 10,
        ),
        // Solar Radiation

        solarRadiationGauge(
          350,
          double.infinity,
          280,
          280,
          100,
        ),

        const SizedBox(
          height: 10,
        ),

        fullBarRangeGauge(
          350,
          double.infinity,
          "Air Humidity",
          300,
          350,
          0,
          100,
          30,
          _getHumidityColor,
        ),

        const SizedBox(
          height: 10,
        ),

        // Barometric Pressure
        fullRoundedGauge(
          350,
          double.infinity,
          "Barometric Pressure",
          280,
          280,
          0,
          1080,
          135,
          3,
          300,
          700,
          "1013.0 hPa",
          1013,
        ),

        const SizedBox(
          height: 10,
        ),

        fullRoundedGauge(
          350,
          double.infinity,
          "Rain Gauge",
          280,
          280,
          0,
          100,
          10,
          2,
          20,
          50,
          "10.0 mm",
          10,
        ),

        const SizedBox(
          height: 10,
        ),

        // Rain Gauge
        fullRoundedMoistureGauge(
          350,
          double.infinity,
          280,
          280,
          45,
          fiveWidth,
        ),

        const SizedBox(
          height: 10,
        ),

        graphMultipleLines(
          350,
          double.infinity,
          "NPK Values",
          300,
          350,
          [
            const FlSpot(1, 50),
            const FlSpot(2, 55),
            const FlSpot(3, 60)
          ], // Nitrogen data
          [
            const FlSpot(1, 40),
            const FlSpot(2, 45),
            const FlSpot(3, 50)
          ], // Phosphorus data
          [
            const FlSpot(1, 30),
            const FlSpot(2, 35),
            const FlSpot(3, 45)
          ], // Potassium data
          "Current NPK Levels",
        ),

        const SizedBox(
          height: 10,
        ),

        fullRoundedGauge(350, double.infinity, "Electrical Conductivity", 280,
            280, 0, 100, 10, 2, 20, 50, "10.0 µS/cm", 10),

        const SizedBox(
          height: 10,
        ),

        fullGaugeFullCustomizable(
          350,
          double.infinity,
          "pH Value",
          300,
          350,
          0,
          14,
          2,
          6,
          8,
          25,
        ),

        const SizedBox(
          height: 10,
        ),

        fullGaugeTemperature(
          350,
          double.infinity,
          "Soil Temperature",
          300,
          350,
          25,
        ),

        const SizedBox(
          height: 10,
        ),

        // Wind Direction
        fullRoundedGauge(350, double.infinity, "Salinity", 280, 280, 0, 50, 5,
            5, 10, 20, "10.0 ppt", 10),
      ],
    );
  }

  SizedBox fullRoundedMoistureGauge(
    double mainHeight,
    double mainWidth,
    double secondaryHeight,
    double secondaryWidth,
    double gaugeValue,
    double fiveWidth,
  ) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth, // Adjusted to mainWidth for better visibility
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Moisture Level",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: boxHeadingColor,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  startAngle: 270,
                                  interval: 10,
                                  endAngle: 270 + 360,
                                  showTicks: true,
                                  showLabels: true,
                                  minorTicksPerInterval: 4,
                                  ranges: <GaugeRange>[
                                    // Fill the range according to the moisture value
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: gaugeValue,
                                      color: gaugeValue <= 30
                                          ? Colors.green // Low moisture
                                          : gaugeValue <= 65
                                              ? Colors
                                                  .yellow // Moderate moisture
                                              : Colors.red, // High moisture
                                    ),
                                    GaugeRange(
                                      startValue: gaugeValue,
                                      endValue: 100,
                                      color: Colors
                                          .transparent, // Remaining part of the gauge
                                    ),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.water_drop, // Water drop icon
                                            size: fiveWidth *
                                                10, // Adjust size as needed
                                            color: Colors.blue, // Icon color
                                          ),
                                          const SizedBox(
                                              height:
                                                  5), // Space between icon and value
                                          Text(
                                            "$gaugeValue", // Display moisture value
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: boxHeadingColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      angle: 90,
                                      positionFactor: 0,
                                    ),
                                  ],
                                  majorTickStyle: MajorTickStyle(
                                      length: 10,
                                      thickness: 2,
                                      color: graphMajorTicksColor),
                                  minorTickStyle: MinorTickStyle(
                                      length: 5,
                                      thickness: 1,
                                      color: graphMinorTicksColor),
                                  axisLabelStyle: GaugeTextStyle(
                                      fontSize: 12, color: graphLabelColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fullGaugeTemperature(
      double mainHeight,
      double mainWidth,
      String mainTitle,
      double secondaryHeight,
      double secondaryWidth,
      double temperatureValue) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: boxHeadingColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              showLabels: true,
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text(
                                    "$mainTitle: $temperatureValue",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: boxHeadingColor),
                                  ),
                                  positionFactor:
                                      1, // Adjust to position in center
                                  angle: 90,
                                ),
                              ],
                              showTicks: true,
                              interval: 20, // Labels at 0, 20, 40, 60, 80, 100
                              axisLabelStyle: GaugeTextStyle(
                                fontSize: 12, // Adjust the font size as needed
                                color: graphLabelColor, // Color for labels
                              ),
                              labelOffset:
                                  10, // Adjust this to move the labels outside the gauge
                              minimum: 0,
                              maximum: 80, // Set max to 100
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 0,
                                  endValue: 20,
                                  color: Colors.blue,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 20,
                                  endValue: 30,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 30,
                                  endValue: 40,
                                  color: Colors.yellow,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 40,
                                  endValue: 45,
                                  color: Colors.red.shade200,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 45,
                                  endValue: 80,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                              ],
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1, // Thickness of the ring
                                thicknessUnit: GaugeSizeUnit.factor,
                                color: Colors
                                    .grey.shade300, // Color of the axis line
                              ),
                              majorTickStyle: MajorTickStyle(
                                length: 0.15, // Length of the major ticks
                                thickness: 2,
                                lengthUnit: GaugeSizeUnit.factor,
                                color:
                                    graphMajorTicksColor, // Color of major ticks
                              ),
                              minorTickStyle: MinorTickStyle(
                                length: 0.07, // Length of the minor ticks
                                thickness: 1,
                                lengthUnit: GaugeSizeUnit.factor,
                                color:
                                    graphMinorTicksColor, // Color of minor ticks
                              ),
                              minorTicksPerInterval:
                                  4, // Number of minor ticks between major ticks
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value:
                                      temperatureValue, // Set the temperature value
                                  enableAnimation: true,
                                  needleLength: 0.7,
                                  needleColor: graphNeedleColor,
                                  needleStartWidth: 0.1,
                                  needleEndWidth:
                                      3, // Thinner tip for the needle
                                  knobStyle: KnobStyle(
                                    color: graphKnobColor,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    knobRadius:
                                        0.06, // Size of the needle's knob
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fullGaugeFullCustomizable(
      double mainHeight,
      double mainWidth,
      String mainTitle,
      double secondaryHeight,
      double secondaryWidth,
      double minValue,
      double maxValue,
      double interval,
      double value1,
      double value2,
      double temperatureValue) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: boxHeadingColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              showLabels: true,
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text(
                                    "$mainTitle: $temperatureValue",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: boxHeadingColor),
                                  ),
                                  positionFactor:
                                      0.9, // Adjust to position in center
                                  angle: 90,
                                ),
                              ],
                              showTicks: true,
                              interval: interval,
                              axisLabelStyle: GaugeTextStyle(
                                fontSize: 12, // Adjust the font size as needed
                                color: graphLabelColor, // Color for labels
                              ),
                              labelOffset:
                                  10, // Adjust this to move the labels outside the gauge
                              minimum: minValue,
                              maximum: maxValue, // Set max to 100
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: minValue,
                                  endValue: value1,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: value1,
                                  endValue: value2,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: value2,
                                  endValue: maxValue,
                                  color: Colors.blue,
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                              ],
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1, // Thickness of the ring
                                thicknessUnit: GaugeSizeUnit.factor,
                                color: Colors
                                    .grey.shade300, // Color of the axis line
                              ),
                              majorTickStyle: MajorTickStyle(
                                length: 0.15, // Length of the major ticks
                                thickness: 2,
                                lengthUnit: GaugeSizeUnit.factor,
                                color:
                                    graphMajorTicksColor, // Color of major ticks
                              ),
                              minorTickStyle: MinorTickStyle(
                                length: 0.07, // Length of the minor ticks
                                thickness: 1,
                                lengthUnit: GaugeSizeUnit.factor,
                                color:
                                    graphMinorTicksColor, // Color of minor ticks
                              ),
                              minorTicksPerInterval:
                                  4, // Number of minor ticks between major ticks
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value:
                                      temperatureValue, // Set the temperature value
                                  enableAnimation: true,
                                  needleLength: 0.7,
                                  needleColor: graphNeedleColor,
                                  needleStartWidth: 0.1,
                                  needleEndWidth:
                                      3, // Thinner tip for the needle
                                  knobStyle: KnobStyle(
                                    color: graphKnobColor,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    knobRadius:
                                        0.06, // Size of the needle's knob
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox windDirectionGauge(
      double mainHeight,
      double mainWidth,
      String mainTitle,
      double secondaryHeight,
      double secondaryWidth,
      double windDirectionValue) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: boxHeadingColor)),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 25, left: 25, bottom: 25),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 360,
                            startAngle: 270, // Start at the top (North)
                            endAngle: 270 + 360,
                            interval: 45,
                            showLabels: true,
                            showTicks: true,
                            minorTicksPerInterval: 4,
                            axisLineStyle: AxisLineStyle(
                              thickness: 12,
                              color: Colors.blueGrey
                                  .withOpacity(0.2), // Background circle color
                            ),
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 90,
                                color: Colors.lightBlueAccent
                                    .withOpacity(0.5), // N to E
                              ),
                              GaugeRange(
                                startValue: 90,
                                endValue: 180,
                                color: Colors.yellow.withOpacity(0.5), // E to S
                              ),
                              GaugeRange(
                                startValue: 180,
                                endValue: 270,
                                color: Colors.orange.withOpacity(0.5), // S to W
                              ),
                              GaugeRange(
                                startValue: 270,
                                endValue: 360,
                                color: Colors.lightGreenAccent
                                    .withOpacity(0.5), // W to N
                              ),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value:
                                    windDirectionValue, // Needle points to the wind direction
                                enableAnimation: true,
                                needleColor: graphNeedleColor,
                                needleLength: 0.6,
                                needleEndWidth: 4,
                                needleStartWidth: 0.2,
                                knobStyle: KnobStyle(
                                  color: graphKnobColor,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  knobRadius: 0.06,
                                ),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  '${windDirectionValue.toStringAsFixed(0)}°',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: boxHeadingColor),
                                ),
                                angle: 90,
                                positionFactor: 0.3,
                              ),
                              // Compass Directions
                              GaugeAnnotation(
                                widget: Text(
                                  'N',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: boxHeadingColor),
                                ),
                                angle: 270,
                                positionFactor: 1.2,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  'E',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: boxHeadingColor),
                                ),
                                angle: 0,
                                positionFactor: 1.2,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  'S',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: boxHeadingColor),
                                ),
                                angle: 90,
                                positionFactor: 1.2,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  'W',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: boxHeadingColor),
                                ),
                                angle: 180,
                                positionFactor: 1.2,
                              ),
                              // Displaying the wind direction with 'N120'
                            ],
                            majorTickStyle: MajorTickStyle(
                              length: 10, // Length of major ticks
                              thickness: 2, // Thickness of major ticks
                              color:
                                  graphMajorTicksColor, // Color of major ticks
                            ),
                            minorTickStyle: MinorTickStyle(
                              length: 5, // Length of minor ticks
                              thickness: 1, // Thickness of minor ticks
                              color:
                                  graphMinorTicksColor, // Color of minor ticks
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox windSpeedGauge(
    double mainHeight,
    double mainWidth,
    String mainTitle,
    double secondaryHeight,
    double secondaryWidth,
    String gaugeText,
  ) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: boxHeadingColor)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: SizedBox(
                        height: secondaryHeight,
                        width: secondaryWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0, left: 20, top: 20, bottom: 10),
                            child: AnimatedBuilder(
                              animation: _rotationAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _rotationAnimation.value,
                                  child: SizedBox(
                                    width: 150, // Size of the fan
                                    height: 150,
                                    child: CustomPaint(
                                      painter: FanPainter(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      gaugeText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox solarRadiationGauge(
    double mainHeight,
    double mainWidth,
    double secondaryHeight,
    double secondaryWidth,
    double gaugeValue,
  ) {
    Color needleColor =
        _getSunIntensityColor(gaugeValue); // Get color for the needle
    Color iconColor =
        _getSunIntensityColor(gaugeValue); // Get color for the sun icon
    Color gaugeColor =
        _getSunIntensityGradientColor(gaugeValue); // Get color for the gauge

    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Solar Radiation",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: boxHeadingColor,
                )),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 30.0, left: 30, top: 30, bottom: 30),
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum:
                                  1000, // Maximum solar radiation value (e.g., 1000 W/m²)
                              showLabels: true,
                              showTicks: true,
                              axisLineStyle: AxisLineStyle(
                                thickness: 12,
                                color: gaugeColor, // Background circle color
                              ),
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value:
                                      gaugeValue, // Needle points to the solar radiation value
                                  enableAnimation: true,
                                  needleColor: needleColor,
                                  needleLength: 0.6,
                                  needleEndWidth: 4,
                                  needleStartWidth: 0.2,
                                  knobStyle: KnobStyle(
                                    color: needleColor,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    knobRadius: 0.07,
                                  ),
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.wb_sunny,
                                            size: 30,
                                            color: iconColor), // Sun icon
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '${gaugeValue.toStringAsFixed(0)} W/m²', // Display current solar radiation value
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 1.2,
                                ),
                              ],
                              majorTickStyle: MajorTickStyle(
                                  length: 10, color: graphMajorTicksColor),
                              minorTickStyle: MinorTickStyle(
                                  length: 5, color: graphMinorTicksColor),
                              axisLabelStyle: GaugeTextStyle(
                                fontSize: 12,
                                color: boxHeadingColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox fullBarRangeGauge(
    double mainHeight,
    double mainWidth,
    String mainTitle,
    double secondaryHeight,
    double secondaryWidth,
    double minValue,
    double maxValue,
    double gaugeValue,
    Color Function(double) getGaugeColor,
  ) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: boxHeadingColor)),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: minValue,
                              maximum: maxValue,
                              showTicks: false, // Hide ticks
                              showLabels: false, // Hide axis labels
                              radiusFactor: 0.9, // Keep the gauge within bounds
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 0,
                                  endValue:
                                      gaugeValue, // Fill according to humidity
                                  color: getGaugeColor(
                                      gaugeValue), // Dynamically get the color
                                  startWidth: 20,
                                  endWidth: 20,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text(
                                    '$gaugeValue%',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: boxHeadingColor,
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox fullRoundedGauge(
    double mainHeight,
    double mainWidth,
    String mainTitle,
    double secondaryHeight,
    double secondaryWidth,
    double minValue,
    double maxValue,
    double interval,
    double minorTicksPerInterval,
    double endValue1,
    double endValue2,
    String gaugeText,
    double gaugeValue,
  ) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: boxHeadingColor)),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 10, top: 0),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: minValue,
                            maximum:
                                maxValue, // Maximum barometric pressure value (in hPa)
                            interval: interval,
                            showTicks: true,
                            showLabels: true,
                            minorTicksPerInterval: minorTicksPerInterval,

                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: minValue,
                                endValue: endValue1,
                                color: Colors.green, // Color for low pressure
                              ),
                              GaugeRange(
                                startValue: endValue1,
                                endValue: endValue2,
                                color: Colors
                                    .yellow, // Color for moderate pressure
                              ),
                              GaugeRange(
                                startValue: endValue2,
                                endValue: maxValue,
                                color: Colors.red, // Color for high pressure
                              ),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value:
                                    gaugeValue, // Needle points to the barometric pressure value
                                enableAnimation: true,
                                needleColor: graphNeedleColor,
                                needleLength: 0.7,
                                needleEndWidth: 4,
                                needleStartWidth: 0.2,
                                knobStyle: KnobStyle(
                                  color: graphKnobColor,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  knobRadius: 0.08,
                                ),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  gaugeText, // Display current pressure value
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: boxHeadingColor),
                                ),
                                angle: 90,
                                positionFactor: 1.2,
                              ),
                            ],
                            majorTickStyle: MajorTickStyle(
                                length: 10,
                                thickness: 2,
                                color: graphMajorTicksColor),
                            minorTickStyle: MinorTickStyle(
                                length: 5,
                                thickness: 1,
                                color: graphMinorTicksColor),
                            axisLabelStyle: GaugeTextStyle(
                                fontSize: 12, color: graphLabelColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox graphMultipleLines(
    double mainHeight,
    double mainWidth,
    String mainTitle,
    double secondaryHeight,
    double secondaryWidth,
    List<FlSpot> nitrogenData, // Data for Nitrogen
    List<FlSpot> phosphorusData, // Data for Phosphorus
    List<FlSpot> potassiumData, // Data for Potassium
    String graphText, // Custom text to display
  ) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: boxHeadingColor,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval:
                                      20, // Control the interval on the left axis
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value
                                          .toInt()
                                          .toString(), // Show the values as integers
                                      style: TextStyle(
                                        color:
                                            graphLabelColor, // Customize text color
                                        fontSize: 12, // Set font size
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval:
                                      1, // Control the interval on the bottom axis
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value
                                          .toInt()
                                          .toString(), // Customize as per requirement
                                      style: TextStyle(
                                        color:
                                            graphLabelColor, // Customize text color
                                        fontSize: 12, // Set font size
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border(
                                left: BorderSide(
                                    color:
                                        accessibilityButtonsBorderColor), // Left border
                                bottom: BorderSide(
                                    color:
                                        accessibilityButtonsBorderColor), // Bottom border
                              ),
                            ),
                            minX: 0, // Start the bottom axis at 0
                            maxX: 10, // End the bottom axis at 100
                            minY: 0, // Start the left axis at 0
                            maxY: 100, // End the left axis at 100
                            lineBarsData: [
                              LineChartBarData(
                                spots: nitrogenData,
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 3,
                                belowBarData: BarAreaData(show: false),
                                dotData: const FlDotData(show: true),
                              ),
                              LineChartBarData(
                                spots: phosphorusData,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                belowBarData: BarAreaData(show: false),
                                dotData: const FlDotData(show: true),
                              ),
                              LineChartBarData(
                                spots: potassiumData,
                                isCurved: true,
                                color: Colors.red,
                                barWidth: 3,
                                belowBarData: BarAreaData(show: false),
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (value) => Colors
                                    .black54, // Set tooltip color using function
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine:
                                  true, // Show vertical grid lines
                              drawHorizontalLine:
                                  true, // Show horizontal grid lines
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  color: Colors.grey,
                                  strokeWidth: 0.8,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return const FlLine(
                                  color: Colors.grey,
                                  strokeWidth: 0.8,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LegendItem(color: Colors.green, label: 'N'),
                    SizedBox(width: 20), // Space between legend items
                    LegendItem(color: Colors.blue, label: 'P'),
                    SizedBox(width: 20), // Space between legend items
                    LegendItem(color: Colors.red, label: 'K'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget welcomeHeader(double mainFontSize, double subFontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: mainFontSize,
                  color: boxHeadingColor,
                ),
              ),
            ),
            Text(
              "Your Current performance",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: subFontSize,
                  color: boxHeadingColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox selectFarmDropDown(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: DropdownSearch<String>(
        onChanged: (String? newValue) {
          setState(() {
            selectedFarm = newValue; // Ensure this updates correctly
          });
        },
        items: (filter, infiniteScrollProps) => farms,
        selectedItem: farms.first,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Select Farm",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          constraints: const BoxConstraints(maxHeight: 300),
          menuProps: const MenuProps(
            backgroundColor: Colors.white,
            elevation: 8,
          ),
          itemBuilder: (context, item, isSelected, boolAgain) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container roundCompanyIcon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.asset(
          "assets/images/logo.jpeg",
          width: 40, // Set your desired width
          height: 40, // Set your desired height
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row accessibilityButtons(double width, double fiveWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click, // Change cursor to hand on hover
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: accessibilityButtonsBorderColor,
                  width: 1), // Black border
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
            child: SizedBox(
              width: width,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center items horizontally
                children: [
                  const Icon(Icons.share, size: 15),
                  Text(
                    "Share",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                      fontSize: 12,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: fiveWidth * 2.5,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click, // Change cursor to hand on hover
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: accessibilityButtonsBorderColor,
                  width: 1), // Black border
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
            child: SizedBox(
              width: width,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center items horizontally
                children: [
                  const Icon(Icons.print, size: 15),
                  Text(
                    "Print",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                      fontSize: 12,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: fiveWidth * 2.5,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click, // Change cursor to hand on hover
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: accessibilityButtonsBorderColor,
                    width: 1), // Black border
                borderRadius: BorderRadius.circular(5), // Rounded corners
                color: Colors.deepPurple),
            child: SizedBox(
              width: width,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center items horizontally
                children: [
                  const Icon(
                    Icons.save,
                    size: 15,
                    color: Colors.white,
                  ),
                  Text(
                    "Export",
                    style: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Divider divider() {
    return const Divider(
      color: Colors.black,
      height: 30,
      thickness: 0.3,
    );
  }
}

class FanPainter extends CustomPainter {
  final int numberOfBlades = 5; // Number of blades

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue // Color of the fan blades
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2; // Adjust blade length

    // Draw the fan blades
    for (int i = 0; i < numberOfBlades; i++) {
      double angle = i *
          (2 *
              pi /
              numberOfBlades); // Calculate angle based on number of blades
      canvas.drawPath(
        _createFanBlade(centerX, centerY, angle, radius),
        paint,
      );
    }
  }

  Path _createFanBlade(
      double centerX, double centerY, double angle, double radius) {
    Path path = Path();
    path.moveTo(centerX, centerY); // Start at the center

    // Create a more curved shape for the blades
    double controlPointX = centerX + radius * cos(angle + pi / 4);
    double controlPointY = centerY + radius * sin(angle + pi / 4);

    path.lineTo(centerX + radius * cos(angle), centerY + radius * sin(angle));
    path.lineTo(controlPointX, controlPointY);
    path.close(); // Close the path to create the blade shape
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Color _getHumidityColor(double humidity) {
  if (humidity < 20) {
    return Colors.lightBlueAccent; // Low Humidity
  } else if (humidity < 40) {
    return Colors.blue; // Moderate Humidity
  } else {
    return Colors.blueAccent; // High Humidity
  }
}

Color _getSunIntensityColor(double value) {
  // Define colors based on solar radiation intensity
  if (value < 200) {
    return Colors.green; // Low intensity
  } else if (value < 600) {
    return Colors.orange; // Moderate intensity
  } else {
    return Colors.red; // High intensity
  }
}

Color _getSunIntensityGradientColor(double value) {
  // Define gradient colors based on solar radiation intensity
  if (value < 200) {
    return Colors.green.withOpacity(0.3);
  } else if (value < 600) {
    return Colors.orange.withOpacity(0.3);
  } else {
    return Colors.red.withOpacity(0.3);
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30, // Width of the color box
          height: 10, // Height of the color box
          color: color,
        ),
        const SizedBox(width: 8), // Space between color box and label
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, color: Colors.black), // Style for legend text
        ),
      ],
    );
  }
}
