import 'dart:developer';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/soil_dashboard_provider.dart';
import 'package:aiponics_web_app/provider/header%20provider/header_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'dashboard_common_methods.dart';

class DashboardCommonGauges {
  final BuildContext context;
  final WidgetRef ref;

  late ThemeColors themeColors;
  late final String responsiveness;
  late final double fiveWidth;

  DashboardCommonGauges({
    required this.context,
    required this.ref,
  }) {
    themeColors = ThemeColors(context);
    responsiveness = ref.watch(dashboardScreenInfoProvider)['screenResponsiveness'];
    fiveWidth = ref.watch(dashboardScreenInfoProvider)['fiveWidth'];
  }

  Widget gaugeForTemperature(String mainTitle, double temperatureValue) {
    temperatureValue = ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
        ? temperatureValue
        : (temperatureValue * 9 / 5) + 32;
    double minValue = ref.watch(headerInfoProvider).selectedTemperatureSign == "°C" ? 0 : 32;
    double maxValue = ref.watch(headerInfoProvider).selectedTemperatureSign == "°C" ? 80 : 176;
    double interval = ref.watch(headerInfoProvider).selectedTemperatureSign == "°C" ? 10 : 15;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 320,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor, // Background color of the gauge container
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Title of the gauge
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: themeColors.boxHeadingColor, // Color of the title
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: themeColors.boxColor, // Inner gauge color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.9,
                        minimum: minValue,
                        maximum: maxValue,
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.1,
                          thicknessUnit: GaugeSizeUnit.factor,
                          color: Colors.grey.shade200, // Background for the secondary bar
                        ),
                        pointers: <GaugePointer>[
                          // Range for 0 to 20
                          RangePointer(
                              value: ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                  ? (temperatureValue < 0
                                      ? 0
                                      : (temperatureValue > 80 ? 80 : temperatureValue))
                                  : (temperatureValue < 32
                                      ? 32
                                      : (temperatureValue > 176 ? 176 : temperatureValue)),
                              cornerStyle: gauges.CornerStyle.startCurve,
                              enableAnimation: true,
                              animationDuration: 1200,
                              width: 0.1,
                              sizeUnit: GaugeSizeUnit.factor,
                              color: ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                  ? (temperatureValue >= 0 && temperatureValue <= 20
                                      ? Colors.blue
                                      : (temperatureValue > 20 && temperatureValue <= 30
                                          ? Colors.green
                                          : (temperatureValue > 30 && temperatureValue <= 40
                                              ? Colors.yellow
                                              : (temperatureValue > 40 && temperatureValue <= 45
                                                  ? Colors.red.shade200
                                                  : (temperatureValue > 45 && temperatureValue <= 80
                                                      ? Colors.red
                                                      : Colors.black)))))
                                  : (temperatureValue >= 32 && temperatureValue <= 68
                                      ? Colors.blue
                                      : (temperatureValue > 68 && temperatureValue <= 86
                                          ? Colors.green
                                          : (temperatureValue > 86 && temperatureValue <= 104
                                              ? Colors.yellow
                                              : (temperatureValue > 104 && temperatureValue <= 113
                                                  ? Colors.red.shade200
                                                  : (temperatureValue > 113 &&
                                                          temperatureValue <= 176
                                                      ? Colors.red
                                                      : Colors.transparent)))))),
                        ],
                      ),
                      RadialAxis(
                        showLabels: true,
                        annotations: <GaugeAnnotation>[
                          // Display temperature value in the center
                          GaugeAnnotation(
                            widget: Text(
                              "$mainTitle: $temperatureValue ${ref.watch(headerInfoProvider).selectedTemperatureSign}",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: themeColors.boxHeadingColor)), // Color of annotation
                            ),
                            positionFactor: 1.02, // Center position
                            angle: 90,
                          ),
                        ],
                        showTicks: true,
                        interval: interval,
                        // Interval for tick marks
                        labelOffset: 12,
                        // Offset for labels
                        minimum: minValue,
                        maximum: maxValue,
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue:
                                ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                    ? 0
                                    : 32,
                            endValue: ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                ? 20
                                : 68,
                            color: Colors.blue,
                            // Color for the first range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue:
                                ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                    ? 20
                                    : 68,
                            endValue: ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                ? 30
                                : 86,
                            color: Colors.green,
                            // Color for the second range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue:
                                ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                    ? 30
                                    : 86,
                            endValue: ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                ? 40
                                : 104,
                            color: Colors.yellow,
                            // Color for the third range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue:
                                ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                    ? 40
                                    : 104,
                            endValue: ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                ? 45
                                : 113,
                            color: Colors.red.shade200,
                            // Color for the final range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue:
                                ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                    ? 45
                                    : 113,
                            endValue: ref.watch(headerInfoProvider).selectedTemperatureSign == "°C"
                                ? 80
                                : 176,
                            color: Colors.red,
                            // Color for the final range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                        ],
                        majorTickStyle: MajorTickStyle(
                            length: 12, thickness: 2, color: themeColors.graphMajorTicksColor),
                        minorTickStyle: MinorTickStyle(
                            length: 6, thickness: 1, color: themeColors.graphMinorTicksColor),
                        axisLabelStyle:
                            GaugeTextStyle(fontSize: 12, color: themeColors.graphLabelColor),
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.1,
                          thicknessUnit: GaugeSizeUnit.factor,
                          color: Colors.grey.shade300, // Color of the axis line
                        ),
                        minorTicksPerInterval: 2,
                        // Minor ticks between major ticks
                        tickOffset: 7,
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: temperatureValue,
                            // Set the current temperature
                            enableAnimation: true,
                            needleLength: 0.7,
                            // Length of the needle
                            needleColor: themeColors.graphNeedleColor,
                            // Color of the needle
                            needleStartWidth: 0.1,
                            needleEndWidth: 3,
                            // Thinner tip for the needle
                            knobStyle: KnobStyle(
                              color: themeColors.graphKnobColor, // Color of the knob
                              sizeUnit: GaugeSizeUnit.factor,
                              knobRadius: 0.06, // Size of the knob
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display a half bar range gauge
  Widget gaugeForHumidity(String mainTitle, double humidityValue) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 320,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor, // Background color of the gauge container
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Title of the gauge
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: themeColors.boxHeadingColor)), // Color of the title
              ),
              Expanded(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          // Minimum value for the gauge
                          maximum: 100,
                          // Maximum value for the gauge
                          // startAngle: 180, // Start at the bottom
                          // endAngle: 180, // End at the top
                          showTicks: false,
                          // Hide ticks
                          showLabels: false,
                          // Hide axis labels
                          radiusFactor: 0.9,
                          // Keep the gauge within bounds
                          ranges: <GaugeRange>[
                            // Define the range for the gauge
                            GaugeRange(
                              startValue: 0,
                              endValue: humidityValue,
                              // Fill according to gauge value
                              color: DashboardCommonMethods.getHumidityColor(humidityValue),
                              // Get color dynamically
                              startWidth: 13,
                              endWidth: 13,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            // Display gauge value in the center
                            GaugeAnnotation(
                              widget: Text('$humidityValue%', // Show percentage
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeColors.boxHeadingColor, // Color of the annotation
                                    ),
                                  )),
                              angle: 90,
                              positionFactor: 0.0, // Position of the annotation
                            ),
                          ],
                        ),
                      ],
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

  // Widget for displaying water level with a circular progress indicator
  Widget waterLevel() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 320,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Water Level",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: themeColors.boxHeadingColor,
                )),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: LiquidCircularProgressIndicator(
                      value: ref.watch(dashboardInfoProvider).waterLevel! / 100,
                      // Set the water level (0.0 to 1.0)
                      valueColor: const AlwaysStoppedAnimation(Colors.blue),
                      backgroundColor: Colors.white,
                      borderColor: Colors.blue,
                      borderWidth: 5.0,
                      direction: Axis.vertical,
                      center: Text(
                          '${(ref.watch(dashboardInfoProvider).waterLevel)?.toStringAsFixed(0)}%', // Display percentage
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )),
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

  // Enhanced Ad Widget
  Widget adsWidget() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 320,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFff7e5f), // Warm coral
              Color(0xFFfeb47b), // Soft peach
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_offer_rounded,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 15),
              Text(
                "Special Offer!",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Don't miss out on our latest deals.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Learn More",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFff7e5f), // Match the gradient start color
                      fontSize: 16,
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

  Widget longAds() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade300,
            Colors.purple.shade400,
            Colors.pink.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative graphic
          Positioned(
            top: -10,
            left: -30,
            child: Icon(
              Icons.star,
              size: 120,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Positioned(
            bottom: -10,
            right: -20,
            child: Icon(
              Icons.star,
              size: 100,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Go Premium Today!",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                    const SizedBox(height: 5),
                    Text("Unlock exclusive features and perks.",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        )),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle subscription functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    shadowColor: Colors.orangeAccent,
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.arrow_circle_up),
                  label: Text(
                    "Upgrade",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Customizable half gauge widget for displaying various values
  Widget gaugeForPhLevel(double phValue) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 320,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "pH Value",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: themeColors.boxHeadingColor,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeColors.boxColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            showLabels: false,
                            showTicks: false,
                            radiusFactor: 0.9,
                            minimum: 0,
                            maximum: 14,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.1,
                              thicknessUnit: GaugeSizeUnit.factor,
                              color: Colors.grey.shade200, // Background for the secondary bar
                            ),
                            pointers: <GaugePointer>[
                              // Range for 0 to 20
                              RangePointer(
                                value: phValue,
                                cornerStyle: gauges.CornerStyle.startCurve,
                                enableAnimation: true,
                                animationDuration: 1200,
                                width: 0.1,
                                sizeUnit: GaugeSizeUnit.factor,
                                color: (phValue >= 0 && phValue < 5.5)
                                    ? Colors.red
                                    : (phValue >= 5.5 && phValue < 6.5)
                                        ? Colors.green
                                        : Colors.blue,
                              ),
                            ],
                          ),
                          RadialAxis(
                            showLabels: true,
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget:
                                    Text("pH Value: $phValue", // Display the main title and value
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: themeColors.boxHeadingColor),
                                        )),
                                positionFactor: 1.02, // Center position
                                angle: 90,
                              ),
                            ],
                            showTicks: true,
                            interval: 2,
                            labelOffset: 10,
                            // Move labels outside the gauge
                            minimum: 0,
                            maximum: 14,
                            // Set max value
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 5.5,
                                color: Colors.red,
                                // First range color
                                startWidth: 10,
                                endWidth: 10,
                              ),
                              GaugeRange(
                                startValue: 5.5,
                                endValue: 6.5,
                                color: Colors.green,
                                // Second range color
                                startWidth: 10,
                                endWidth: 10,
                              ),
                              GaugeRange(
                                startValue: 6.5,
                                endValue: 14,
                                color: Colors.blue,
                                // Third range color
                                startWidth: 10,
                                endWidth: 10,
                              ),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: phValue,
                                // Needle points to the barometric pressure value
                                enableAnimation: true,
                                needleColor: themeColors.graphNeedleColor,
                                needleLength: 0.7,
                                needleEndWidth: 3,
                                needleStartWidth: 0.2,
                                knobStyle: KnobStyle(
                                  color: themeColors.graphKnobColor,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  knobRadius: 0.06,
                                ),
                              ),
                            ],
                            tickOffset: 6,
                            majorTickStyle: MajorTickStyle(
                                length: 12, thickness: 2, color: themeColors.graphMajorTicksColor),
                            minorTickStyle: MinorTickStyle(
                                length: 6, thickness: 1, color: themeColors.graphMinorTicksColor),
                            axisLabelStyle:
                                GaugeTextStyle(fontSize: 12, color: themeColors.graphLabelColor),
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.1, // Thickness of the gauge ring
                              thicknessUnit: GaugeSizeUnit.factor,
                              color: Colors.grey.shade300, // Color of the axis line
                            ),
                            minorTicksPerInterval: 2,
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

  Widget coLevelsGauge(String title, double coLevel) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 320,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: themeColors.boxHeadingColor,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            showLabels: false,
                            showTicks: false,
                            radiusFactor: 0.9,
                            minimum: 0,
                            maximum: 1000,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.1,
                              thicknessUnit: GaugeSizeUnit.factor,
                              color: Colors.grey.shade200, // Background for the secondary bar
                            ),
                            pointers: <GaugePointer>[
                              // Range for 0 to 20
                              RangePointer(
                                value: coLevel,
                                cornerStyle: gauges.CornerStyle.startCurve,
                                enableAnimation: true,
                                animationDuration: 1200,
                                width: 0.1,
                                sizeUnit: GaugeSizeUnit.factor,
                                color: (coLevel >= 0 && coLevel < 350)
                                    ? Colors.green
                                    : (coLevel >= 350 && coLevel < 600)
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ],
                          ),
                          RadialAxis(
                            minimum: 0,
                            maximum: 1000,
                            // Max value for CO₂ (adjust as needed)
                            showTicks: true,
                            // Hide ticks
                            showLabels: true,
                            // Hide axis labels
                            labelOffset: 12,
                            interval: 150,
                            tickOffset: 7,
                            // Move the minor ticks outward (negative values move inw
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 350,
                                color: Colors.green,
                                // Safe CO₂ level
                                startWidth: 10,
                                endWidth: 10,
                              ),
                              GaugeRange(
                                startValue: 350,
                                endValue: 600,
                                color: Colors.orange,
                                // Moderate CO₂ level
                                startWidth: 10,
                                endWidth: 10,
                              ),
                              GaugeRange(
                                startValue: 600,
                                endValue: 1000,
                                color: Colors.red,
                                // High CO₂ level
                                startWidth: 10,
                                endWidth: 10,
                              ),
                            ],
                            majorTickStyle: MajorTickStyle(
                              length: 12, // Length of the major ticks
                              thickness: 2,
                              color: themeColors.graphMajorTicksColor, // Color of major ticks
                            ),
                            minorTickStyle: MinorTickStyle(
                              length: 6, // Length of the minor ticks
                              thickness: 1,
                              color: themeColors.graphMinorTicksColor, // Color of minor ticks
                            ),
                            minorTicksPerInterval: 3,
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: coLevel,
                                // The current CO₂ value
                                needleColor: themeColors.graphNeedleColor,
                                needleStartWidth: 0.1,
                                needleEndWidth: 4,
                                knobStyle: KnobStyle(
                                  knobRadius: 0.05,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: themeColors.graphKnobColor,
                                ),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text('$coLevel ppm', // Display CO₂ value inside the gauge
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: themeColors.boxHeadingColor,
                                      ),
                                    )),
                                angle: 90,
                                positionFactor: 1,
                              ),
                            ],
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

  // Widget for displaying a Todos list with a header and a placeholder message
  Widget todos(double mainHeight) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: mainHeight,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Todo List",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: themeColors.boxHeadingColor,
                    )),
                  ),
                  InkWell(
                    onTap: () {
                      DashboardCommonMethods.showAddTodoDialog(context);
                    },
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.blueAccent,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Nothing to do!",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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

  // Widget for TDS graph display with dropdowns for device selection and graph type
  SizedBox tdsGraph(double mainHeight) {
    return SizedBox(
      height: mainHeight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Values",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "TDS",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                )),
                              ),
                            ],
                          ),
                          const SizedBox(width: 40),
                          // Date picker dropdown
                          dateSelectorDropDown(),
                        ],
                      ),

                      // Conditional rendering for graph type dropdown
                      if (responsiveness == "tablet" || responsiveness == "mobile") ...[
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            graphTypeDropDown(),
                            const SizedBox(
                              width: 20,
                            ),
                            selectDeviceDropDown(),
                          ],
                        ),
                      ],
                    ],
                  ),
                  // Graph type dropdown for desktop view
                  if (responsiveness == "desktop") graphTypeDropDown(),
                ],
              ),
              const SizedBox(height: 20), // Space between elements
              // Legend for the graph
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: fiveWidth * 6,
                    height: 10,
                    color: Colors.blue, // Match this color with the graph color
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'TDS', // Customize this text as needed
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              // Graph
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 20, right: 20.0),
                  child: _buildGraph(), // Method to build the actual graph
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox lightIntensityAndEnergyConsumptionGraph(
      String title,
      String xTitle,
      String yTitle,
      double minValue,
      double maxValue,
      double interval,
      List<Map<int, double>?>? graphIntensityData,
      ) {
    return SizedBox(
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: themeColors.boxHeadingColor,
                    )),
              ),
              Expanded(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SfCartesianChart(
                          primaryXAxis: NumericAxis(
                            title: AxisTitle(
                              text: xTitle,
                              textStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 11,
                                  color: themeColors.boxHeadingColor,
                                ),
                              ),
                            ),
                            majorGridLines: const MajorGridLines(
                              width: 0, // Set to 0 to hide vertical gridlines
                            ),
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(
                              text: yTitle,
                              textStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 11,
                                  color: themeColors.boxHeadingColor,
                                ),
                              ),
                            ),
                            minimum: minValue,
                            maximum: maxValue,
                            interval: interval,
                            majorGridLines: MajorGridLines(
                              width: 0.1, // Set to 0 to hide vertical gridlines
                              color: themeColors.boxHeadingColor,
                            ),
                          ),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            format: 'Point X: point.x\nPoint Y: point.y',
                            canShowMarker: true,
                          ),
                          series: <CartesianSeries<dynamic, dynamic>>[
                            LineSeries<Map<int, double>?, int>(
                              dataSource: graphIntensityData,
                              xValueMapper: (Map<int, double>? intensity, _) =>
                              intensity!.keys.first,
                              yValueMapper: (Map<int, double>? intensity, _) =>
                              intensity!.values.first,
                              color: title.contains("Light")
                                  ? Colors.orangeAccent
                                  : Colors.greenAccent.shade400,
                              width: 3,
                              markerSettings: MarkerSettings(
                                isVisible: true,
                                shape: DataMarkerType.circle,
                                color: title.contains("Light")
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                              enableTooltip: true,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: false, // Disable data labels
                              ),
                            ),
                          ],
                        );
                      },
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


  SizedBox dateSelectorDropDown() {
    return SizedBox(
      width: 130,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff4f5f7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: () {
            DashboardCommonMethods.selectDate(
                context, ref, ref.watch(dashboardInfoProvider).selectedDate);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.grey,
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 13,
                ),
              ),
              SizedBox(
                width: fiveWidth * 2,
              ),
              Text(
                ref.watch(dashboardInfoProvider).selectedDate == null
                    ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                    : DateFormat.yMd().format(ref.watch(dashboardInfoProvider).selectedDate!),
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox selectDeviceDropDown() {
    return SizedBox(
      width: 130,
      height: 40,
      child: DropdownSearch<String>(
        onChanged: (String? newValue) {
          if (newValue != null) {
            ref.read(dashboardInfoProvider.notifier).updateSelectedDevice(newValue);
          }
        },
        items: (filter, infiniteScrollProps) => ref.watch(dashboardInfoProvider).devices,
        selectedItem: ref.watch(dashboardInfoProvider).selectedDevice,
        dropdownBuilder: (context, selectedItem) {
          return Text(
            selectedItem ?? '',
            style: TextStyle(
              fontSize: 12, // Set font size for the selected item
              color: themeColors.boxHeadingColor, // Set color for the selected item
            ),
          );
        },
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12, color: themeColors.boxHeadingColor),
            labelText: "Select Device",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.black, // Set the border color
                width: 1, // Set the border width
              ),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          constraints: const BoxConstraints(
            maxHeight: 300,
          ),
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
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SizedBox graphTypeDropDown() {
    return SizedBox(
      width: 130,
      height: 40,
      child: DropdownSearch<String>(
        onChanged: (String? newValue) {
          if (newValue != null) {
            ref.read(dashboardInfoProvider.notifier).updateSelectedGraphType(newValue);
          }
        },
        items: (filter, infiniteScrollProps) => ref.watch(dashboardInfoProvider).graphTypes,
        selectedItem: ref.watch(dashboardInfoProvider).graphTypes.first,
        dropdownBuilder: (context, selectedItem) {
          return Text(
            selectedItem ?? '',
            style: TextStyle(
              fontSize: 12, // Set font size for the selected item
              color: themeColors.boxHeadingColor, // Set color for the selected item
            ),
          );
        },
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 11, color: themeColors.boxHeadingColor),
            labelText: "Select Graph Type",
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
          itemBuilder: (context, item, isSelected, _) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGraph() {
    switch (ref.watch(dashboardInfoProvider).selectedGraphType) {
      case 'Line Graph':
        return LineChart(
          LineChartData(
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey, width: 0.5), // Left border
                bottom: BorderSide(color: Colors.grey, width: 0.5), // Bottom border
                right: BorderSide.none, // No right border
                top: BorderSide.none, // No top border
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1,
              // Set interval between grid lines
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey, // Color of the dashed lines
                  strokeWidth: 0.5,
                );
              },
              drawVerticalLine:
                  false, // Disable vertical lines if you only want horizontal dashed lines
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35, // Adjust the space reserved for the x-axis labels
                  interval: 1, // Adjust distance between the x-axis labels and the graph
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 12),
                      ), // Customize the label text
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35, // Reserve space for the y-axis labels
                  interval: 0.1, // Show labels with an interval of 0.1
                  getTitlesWidget: (value, meta) {
                    if (value >= 0.0 && value <= 1.0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          value.toStringAsFixed(1), // Display up to 1 decimal place
                          style: const TextStyle(fontSize: 12), // Customize the text style
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for values outside the range
                    }
                  },
                ),
              ),
            ),
            minX: 0,
            maxX: 10,
            minY: 0.0,
            maxY: 1.0,
            lineBarsData: [
              LineChartBarData(
                spots: ref.watch(dashboardInfoProvider).tdsValues != null
                    ? ref
                        .watch(dashboardInfoProvider)
                        .tdsValues!
                        .where((map) => map != null) // Ensure non-null maps
                        .expand((map) => map!.entries) // Get all entries
                        .map((entry) => FlSpot(entry.key, entry.value)) // Map to FlSpot
                        .toList()
                    : [],
                isCurved: true,
                color: Colors.blue,
                barWidth: 1,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true),
              ),
            ],
            backgroundColor: Colors.transparent,
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                tooltipMargin: 16,
                getTooltipColor: (spot) => Colors.white,
                // Set tooltip background color
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      'Time: ${spot.x.toStringAsFixed(1)}\nTDS: ${spot.y.toStringAsFixed(2)}',
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        );

      case 'Histogram':
        return BarChart(
          BarChartData(
            barGroups: ref.watch(dashboardInfoProvider).tdsValues != null
                ? ref
                    .watch(dashboardInfoProvider)
                    .tdsValues!
                    .asMap() // Access the index for x-value
                    .entries
                    .where((entry) => entry.value != null) // Ensure non-null maps
                    .map((entry) {
                    int x = entry.key; // Use index as x-value
                    double? toY =
                        entry.value?.values.first; // Use the first value in the map as toY

                    // Define colors based on index
                    List<Color> colors = [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.yellow,
                      Colors.purple
                    ];
                    Color color =
                        colors[x % colors.length]; // Cycle through colors if x exceeds length

                    return BarChartGroupData(
                      x: x,
                      barRods: [
                        BarChartRodData(
                          toY: toY ?? 0.0, // Default to 0.0 if toY is null
                          color: color, // Assign color dynamically
                          width: 25,
                          borderRadius: const BorderRadius.all(Radius.zero),
                        ),
                      ],
                    );
                  }).toList()
                : [],
            maxY: 1,
            minY: 0,
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: themeColors.boxHeadingColor, width: 0.5), // Left border
                bottom: BorderSide(color: themeColors.boxHeadingColor, width: 0.5), // Bottom border
                right: BorderSide.none, // No right border
                top: BorderSide.none, // No top border
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1,
              // Set interval between grid lines
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey, // Color of the dashed lines
                  strokeWidth: 0.5,
                );
              },
              drawVerticalLine:
                  false, // Disable vertical lines if you only want horizontal dashed lines
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30, // Adjust the space reserved for the x-axis labels
                  interval: 1, // Adjust distance between the x-axis labels and the graph
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(value.toString()), // Customize the label text
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42, // Reserve space for the y-axis labels
                  interval: 0.1, // Show labels with an interval of 0.1
                  getTitlesWidget: (value, meta) {
                    if (value >= 0.0 && value <= 1.0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          value.toStringAsFixed(1), // Display up to 1 decimal place
                          style: const TextStyle(fontSize: 12), // Customize the text style
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for values outside the range
                    }
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (spot) =>
                    themeColors.backgroundColor, // Set tooltip background color
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  // Customize the tooltip content
                  return BarTooltipItem(
                    'Time: ${group.x}\nTDS: ${rod.toY.toStringAsFixed(2)}',
                    TextStyle(
                      color: themeColors.boxHeadingColor,
                      fontSize: 12,
                    ),
                  );
                },
              ),
              touchCallback: (event, response) {
                // Handle touch interactions if needed
              },
              allowTouchBarBackDraw: true, // Allows bar hovering effect
            ),
          ),
        );

      case 'Scatter Graph':
        return ScatterChart(
          ScatterChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1,
              // Set interval between grid lines
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey, // Color of the dashed lines
                  strokeWidth: 0.5,
                );
              },
              drawVerticalLine:
                  false, // Disable vertical lines if you only want horizontal dashed lines
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey, width: 0.5), // Left border
                bottom: BorderSide(color: Colors.grey, width: 0.5), // Bottom border
                right: BorderSide.none, // No right border
                top: BorderSide.none, // No top border
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30, // Adjust the space reserved for the x-axis labels
                  interval: 1, // Adjust distance between the x-axis labels and the graph
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(value.toString()), // Customize the label text
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42, // Reserve space for the y-axis labels
                  interval: 0.1, // Show labels with an interval of 0.1
                  getTitlesWidget: (value, meta) {
                    if (value >= 0.0 && value <= 1.0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          value.toStringAsFixed(1), // Display up to 1 decimal place
                          style: const TextStyle(fontSize: 12), // Customize the text style
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for values outside the range
                    }
                  },
                ),
              ),
            ),
            scatterSpots: ref.watch(dashboardInfoProvider).tdsValues != null
                ? ref
                    .watch(dashboardInfoProvider)
                    .tdsValues!
                    .asMap()
                    .entries
                    .where((entry) => entry.value != null)
                    .map((entry) {
                    int x = entry.key;
                    double? y = entry.value?.values.first;

                    // Define colors based on index
                    List<Color> colors = [Colors.blue, Colors.green, Colors.red, Colors.yellow];
                    Color color = colors[x % colors.length];

                    return ScatterSpot(
                      x.toDouble(),
                      y ?? 0.0,
                      dotPainter: FlDotCirclePainter(
                        radius: 5,
                        color: color,
                      ),
                    );
                  }).toList()
                : [],
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 1,
            // Add ScatterTouchData for hover functionality
            scatterTouchData: ScatterTouchData(
              enabled: true, // Enable touch interactions
              touchTooltipData: ScatterTouchTooltipData(
                getTooltipColor: (spot) => themeColors.backgroundColor,
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tooltipRoundedRadius: 8,
                getTooltipItems: (ScatterSpot touchedSpot) {
                  return ScatterTooltipItem(
                    'Time: ${touchedSpot.x.toStringAsFixed(2)}\nTds: ${touchedSpot.y.toStringAsFixed(2)}',
                    textStyle: TextStyle(
                      color: themeColors.boxHeadingColor,
                      fontSize: 12,
                    ),
                  );
                },
              ),
              touchCallback: (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
                if (event.isInterestedForInteractions && touchResponse?.touchedSpot != null) {
                  log('Touched spot: ${touchResponse!.touchedSpot}');
                }
              },
            ),
          ),
        );

      default:
        return const Center(child: Text('Select a graph type'));
    }
  }

  SizedBox fullRoundedMoistureGauge(double gaugeValue) {
    return SizedBox(
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Moisture Level",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: themeColors.boxHeadingColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: themeColors.boxColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
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
                                        ? Colors.yellow // Moderate moisture
                                        : Colors.red, // High moisture
                              ),
                              GaugeRange(
                                startValue: gaugeValue,
                                endValue: 100,
                                color: Colors.transparent, // Remaining part of the gauge
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.water_drop, // Water drop icon
                                      size: fiveWidth * 10, // Adjust size as needed
                                      color: Colors.blue, // Icon color
                                    ),
                                    const SizedBox(height: 5), // Space between icon and value
                                    Text(
                                      "$gaugeValue", // Display moisture value
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: themeColors.boxHeadingColor,
                                      ),
                                    ),
                                  ],
                                ),
                                angle: 90,
                                positionFactor: 0,
                              ),
                            ],
                            majorTickStyle: MajorTickStyle(
                                length: 10, thickness: 2, color: themeColors.graphMajorTicksColor),
                            minorTickStyle: MinorTickStyle(
                                length: 5, thickness: 1, color: themeColors.graphMinorTicksColor),
                            axisLabelStyle:
                                GaugeTextStyle(fontSize: 12, color: themeColors.graphLabelColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox windDirectionGauge(double windDirectionValue) {
    return SizedBox(
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Wind Direction',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: themeColors.boxHeadingColor)),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  decoration: BoxDecoration(
                    color: themeColors.boxColor, // Inner gauge color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 360,
                        startAngle: 270,
                        // Start at the top (North)
                        endAngle: 270 + 360,
                        interval: 45,
                        showLabels: true,
                        showTicks: true,
                        minorTicksPerInterval: 4,
                        axisLineStyle: AxisLineStyle(
                          thickness: 12,
                          color: Colors.blueGrey.withOpacity(0.2), // Background circle color
                        ),
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: 90,
                            color: Colors.lightBlueAccent.withOpacity(0.5), // N to E
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
                            color: Colors.lightGreenAccent.withOpacity(0.5), // W to N
                          ),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: windDirectionValue,
                            // Needle points to the wind direction
                            enableAnimation: true,
                            needleColor: themeColors.graphNeedleColor,
                            needleLength: 0.6,
                            needleEndWidth: 4,
                            needleStartWidth: 0.2,
                            knobStyle: KnobStyle(
                              color: themeColors.graphKnobColor,
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
                                  color: themeColors.boxHeadingColor),
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
                                  color: themeColors.boxHeadingColor),
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
                                  color: themeColors.boxHeadingColor),
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
                                  color: themeColors.boxHeadingColor),
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
                                  color: themeColors.boxHeadingColor),
                            ),
                            angle: 180,
                            positionFactor: 1.2,
                          ),
                          // Displaying the wind direction with 'N120'
                        ],
                        majorTickStyle: MajorTickStyle(
                          length: 10, // Length of major ticks
                          thickness: 2, // Thickness of major ticks
                          color: themeColors.graphMajorTicksColor, // Color of major ticks
                        ),
                        minorTickStyle: MinorTickStyle(
                          length: 5, // Length of minor ticks
                          thickness: 1, // Thickness of minor ticks
                          color: themeColors.graphMinorTicksColor, // Color of minor ticks
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox windSpeedGauge(String gaugeText, Animation<double> rotationAnimation) {
    return SizedBox(
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wind Speed",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: themeColors.boxHeadingColor)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeColors.boxColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
                          child: AnimatedBuilder(
                            animation: rotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: rotationAnimation.value,
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
                    Text(
                      gaugeText,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  SizedBox solarRadiationGauge(double gaugeValue) {
    Color iconColor = DashboardCommonMethods.getSunIntensityColor(gaugeValue);
    Color gaugeColor = DashboardCommonMethods.getSunIntensityGradientColor(gaugeValue);

    return SizedBox(
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Solar Radiation",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: themeColors.boxHeadingColor,
                )),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: themeColors.boxColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.9,
                        minimum: 0,
                        maximum: 1000,
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.1,
                          thicknessUnit: GaugeSizeUnit.factor,
                          color: Colors.grey.shade200, // Background for the secondary bar
                        ),
                        pointers: <GaugePointer>[
                          // Range for 0 to 20
                          RangePointer(
                            value: gaugeValue,
                            cornerStyle: gauges.CornerStyle.startCurve,
                            enableAnimation: true,
                            animationDuration: 1200,
                            width: 0.1,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: gaugeColor,
                          ),
                        ],
                      ),
                      RadialAxis(
                        minimum: 0,
                        maximum: 1000,
                        // Maximum solar radiation value (e.g., 1000 W/m²)
                        showLabels: true,
                        showTicks: true,
                        tickOffset: 8,
                        labelOffset: 14,
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: 200,
                            color: DashboardCommonMethods.getSunIntensityColor(100),
                            // Color for the first range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue: 200,
                            endValue: 600,
                            color: DashboardCommonMethods.getSunIntensityColor(300),
                            // Color for the first range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue: 600,
                            endValue: 1000,
                            color: DashboardCommonMethods.getSunIntensityColor(700),
                            // Color for the first range
                            startWidth: 10,
                            endWidth: 10,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wb_sunny, size: 20, color: iconColor), // Sun icon
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${gaugeValue.toStringAsFixed(0)} W/m²',
                                    // Display current solar radiation value
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: themeColors.boxHeadingColor)),
                                  ),
                                ],
                              ),
                            ),
                            angle: 90,
                            positionFactor: 1,
                          ),
                        ],
                        minorTicksPerInterval: 3,
                        majorTickStyle: MajorTickStyle(
                          length: 12, // Length of the major ticks
                          thickness: 2,
                          color: themeColors.graphMajorTicksColor, // Color of major ticks
                        ),
                        minorTickStyle: MinorTickStyle(
                          length: 6, // Length of the minor ticks
                          thickness: 1,
                          color: themeColors.graphMinorTicksColor, // Color of minor ticks
                        ),
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: gaugeValue,
                            // Set the current temperature
                            enableAnimation: true,
                            needleLength: 0.7,
                            // Length of the needle
                            needleColor: themeColors.graphNeedleColor,
                            // Color of the needle
                            needleStartWidth: 0.1,
                            needleEndWidth: 3,
                            // Thinner tip for the needle
                            knobStyle: KnobStyle(
                              color: themeColors.graphKnobColor, // Color of the knob
                              sizeUnit: GaugeSizeUnit.factor,
                              knobRadius: 0.06, // Size of the knob
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox soilGaugeForMultipleDevices(String mainTitle, double gaugeValue) {
    return SizedBox(
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: themeColors.boxHeadingColor)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.9,
                        minimum: 0,
                        maximum: mainTitle.contains('Barometric')
                            ? 1080
                            : mainTitle.contains('Rain')
                                ? 100
                                : mainTitle.contains('Electrical')
                                    ? 100
                                    : 50,
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.1,
                          thicknessUnit: GaugeSizeUnit.factor,
                          color: Colors.grey.shade200, // Background for the secondary bar
                        ),
                        pointers: <GaugePointer>[
                          // Range for 0 to 20
                          RangePointer(
                              value: gaugeValue,
                              cornerStyle: gauges.CornerStyle.startCurve,
                              enableAnimation: true,
                              animationDuration: 1200,
                              width: 0.1,
                              sizeUnit: GaugeSizeUnit.factor,
                              color: Colors.blue),
                        ],
                      ),
                      RadialAxis(
                        minimum: 0,
                        maximum: mainTitle.contains('Barometric')
                            ? 1080
                            : mainTitle.contains('Rain')
                                ? 100
                                : mainTitle.contains('Electrical')
                                    ? 100
                                    : 50,
                        interval: mainTitle.contains('Barometric')
                            ? 180
                            : mainTitle.contains('Rain')
                                ? 15
                                : mainTitle.contains('Electrical')
                                    ? 15
                                    : 10,
                        showTicks: true,
                        showLabels: true,
                        minorTicksPerInterval: mainTitle.contains('Barometric')
                            ? 3
                            : mainTitle.contains('Rain')
                                ? 2
                                : mainTitle.contains('Electrical')
                                    ? 2
                                    : 3,
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: mainTitle.contains('Barometric')
                                ? 300
                                : mainTitle.contains('Rain')
                                    ? 20
                                    : mainTitle.contains('Electrical')
                                        ? 20
                                        : 10,
                            color: Colors.green,
                            // Color for low pressure
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue: mainTitle.contains('Barometric')
                                ? 300
                                : mainTitle.contains('Rain')
                                    ? 20
                                    : mainTitle.contains('Electrical')
                                        ? 20
                                        : 10,
                            endValue: mainTitle.contains('Barometric')
                                ? 700
                                : mainTitle.contains('Rain')
                                    ? 50
                                    : mainTitle.contains('Electrical')
                                        ? 50
                                        : 20,
                            color: Colors.yellow,
                            // Color for moderate pressure
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue: mainTitle.contains('Barometric')
                                ? 700
                                : mainTitle.contains('Rain')
                                    ? 50
                                    : mainTitle.contains('Electrical')
                                        ? 50
                                        : 20,
                            endValue: mainTitle.contains('Barometric')
                                ? 1080
                                : mainTitle.contains('Rain')
                                    ? 100
                                    : mainTitle.contains('Electrical')
                                        ? 100
                                        : 50,
                            color: Colors.red,
                            // Color for high pressure
                            startWidth: 10,
                            endWidth: 10,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text(
                              mainTitle.contains('Barometric')
                                  ? "$gaugeValue hPa"
                                  : mainTitle.contains('Rain')
                                      ? "$gaugeValue mm"
                                      : mainTitle.contains('Electrical')
                                          ? "$gaugeValue µS/cm"
                                          : "$gaugeValue ppt",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: themeColors.boxHeadingColor),
                            ),
                            angle: 90,
                            positionFactor: 1,
                          ),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: gaugeValue,
                            // Needle points to the barometric pressure value
                            enableAnimation: true,
                            needleColor: themeColors.graphNeedleColor,
                            needleLength: 0.7,
                            needleEndWidth: 3,
                            needleStartWidth: 0.2,
                            knobStyle: KnobStyle(
                              color: themeColors.graphKnobColor,
                              sizeUnit: GaugeSizeUnit.factor,
                              knobRadius: 0.06,
                            ),
                          ),
                        ],
                        tickOffset: 8,
                        labelOffset: 14,
                        majorTickStyle: MajorTickStyle(
                            length: 12, thickness: 2, color: themeColors.graphMajorTicksColor),
                        minorTickStyle: MinorTickStyle(
                            length: 6, thickness: 1, color: themeColors.graphMinorTicksColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget npkGraph(double mainHeight) {
    return Container(
      height: mainHeight,
      decoration: BoxDecoration(
        color: themeColors.boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "NPK Values",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: themeColors.boxHeadingColor,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeColors.boxColor,
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
                              interval: 20, // Control the interval on the left axis
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(), // Show the values as integers
                                  style: TextStyle(
                                    color: themeColors.graphLabelColor, // Customize text color
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
                              interval: 1, // Control the interval on the bottom axis
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(), // Customize as per requirement
                                  style: TextStyle(
                                    color: themeColors.graphLabelColor, // Customize text color
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
                                color: themeColors.accessibilityButtonsBorderColor), // Left border
                            bottom: BorderSide(
                                color:
                                    themeColors.accessibilityButtonsBorderColor), // Bottom border
                          ),
                        ),
                        minX: 0,
                        // Start the bottom axis at 0
                        maxX: 10,
                        // End the bottom axis at 100
                        minY: 0,
                        // Start the left axis at 0
                        maxY: 100,
                        // End the left axis at 100
                        lineBarsData: [
                          LineChartBarData(
                            spots: ref.watch(soilDashboardInfoProvider).npkValues != null
                                ? ref
                                    .watch(soilDashboardInfoProvider)
                                    .npkValues!
                                    .asMap()
                                    .entries
                                    .map((entry) => FlSpot(
                                        entry.key.toDouble(), entry.value![0])) // Map to FlSpot
                                    .toList()
                                : [],
                            isCurved: true,
                            color: Colors.green,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: false),
                            dotData: const FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: ref.watch(soilDashboardInfoProvider).npkValues != null
                                ? ref
                                    .watch(soilDashboardInfoProvider)
                                    .npkValues!
                                    .asMap()
                                    .entries
                                    .map((entry) => FlSpot(
                                        entry.key.toDouble(), entry.value![1])) // Map to FlSpot
                                    .toList()
                                : [],
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: false),
                            dotData: const FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: ref.watch(soilDashboardInfoProvider).npkValues != null
                                ? ref
                                    .watch(soilDashboardInfoProvider)
                                    .npkValues!
                                    .asMap()
                                    .entries
                                    .map((entry) => FlSpot(
                                        entry.key.toDouble(), entry.value![2])) // Map to FlSpot
                                    .toList()
                                : [],
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            belowBarData: BarAreaData(show: false),
                            dotData: const FlDotData(show: true),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (value) =>
                                Colors.black54, // Set tooltip color using function
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          // Show vertical grid lines
                          drawHorizontalLine: true,
                          // Show horizontal grid lines
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
    );
  }
}
