import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/views/common/header/header_with_farm_dropdown.dart';
import 'package:aiponics_web_app/views/sideBar ( Drawer Screens )/data/todos/add_todo.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  late ThemeColors themeColors;
  late double fiveWidth;
  late double fiveHeight;
  late String responsiveness;
  late double width;
  late BuildContext contexts;

  late String _selectedGraphType;
  String? _selectedDevice;
  DateTime? _selectedDate;

  double? _farmTemperature;
  double? _externalTemperature;
  double? _farmHumidity;
  double? _externalHumidity;
  double? _waterTemperature;
  double? _waterLevel;
  double? _pHLevel;
  double? _farmCo2Level;

  late List<String> _devices = [];
  late List<String> _graphTypes = [];
  late List<Map<int, double>?>? lightIntensityData = [];
  late List<Map<int, double>?>? energyConsumptionData = [];
  late List<Map<double, double>?>? tdsData = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      ref.read(dashboardInfoProvider.notifier).updateSelectedDate(picked);
    }
  }

  void showAddTodoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.7,
                child: const AddTodo(), // Embed AddToDo screen here
              ),
            ),
          ),
        );
      },
      transitionDuration:
          const Duration(milliseconds: 500), // Control the animation duration
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void initializeValues(){
    final screenNotifier = ref.watch(dashboardScreenInfoProvider);
    themeColors = ThemeColors(context);

    fiveWidth = screenNotifier['fiveWidth'];
    fiveHeight = screenNotifier['fiveHeight'];
    responsiveness = screenNotifier['screenResponsiveness'];
    width = screenNotifier['screenFullWidth'];
    contexts = context;


    _selectedGraphType = ref.watch(dashboardInfoProvider).selectedGraphType;
    _selectedDevice = ref.watch(dashboardInfoProvider).selectedDevice;
    _selectedDate = ref.watch(dashboardInfoProvider).selectedDate;

    _farmTemperature = ref.watch(dashboardInfoProvider).farmTemperature;
    _externalTemperature = ref.watch(dashboardInfoProvider).externalTemperature;
    _farmHumidity = ref.watch(dashboardInfoProvider).farmHumidity;
    _externalHumidity = ref.watch(dashboardInfoProvider).externalHumidity;
    _waterTemperature = ref.watch(dashboardInfoProvider).waterTemperature;
    _waterLevel = ref.watch(dashboardInfoProvider).waterLevel;
    _pHLevel = ref.watch(dashboardInfoProvider).pHLevel;
    _farmCo2Level = ref.watch(dashboardInfoProvider).farmCoLevel;

    _devices = ref.watch(dashboardInfoProvider).devices;
    _graphTypes = ref.watch(dashboardInfoProvider).graphTypes;
    lightIntensityData = ref.watch(dashboardInfoProvider).lightIntensity;
    energyConsumptionData = ref.watch(dashboardInfoProvider).energyConsumption;
    tdsData = ref.watch(dashboardInfoProvider).tdsValues;
  }

  @override
  Widget build(BuildContext context) {


    initializeValues();

    return Scaffold(
      body: SingleChildScrollView(
        child: responsiveness == "desktop"
            ? Padding(
                padding: const EdgeInsets.only(
                    top: 40,
                    bottom: 40,
                    right: 50,
                    left: 50), // Padding for desktop layout
                child: desktopDashboard(), // Call desktop dashboard management method
              )
            : responsiveness == "tablet"
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 40,
                        right: 50,
                        left: 50), // Padding for desktop layout
                    child: tabletDashboard(), // Call desktop dashboard management method
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 60,
                        bottom: 40,
                        right: 30,
                        left: 30), // Padding for mobile layout
                    child: mobileDashboard(), // Call mobile dashboard management method
                  ),
      ),
    );
  }

  // Responsive Version of Desktop
  Widget desktopDashboard() {
    return Column(
      children: [
        // Header
        CustomHeaderWithFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Your current performance"),

        // Farm Temperature,  External Temperature, Farm Humidity, External Humidity and Todos List
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farm Temperature and External Temperature
            Flexible(
              flex: 1,
              child: Column(children: [
                // Farm Temperature
                gaugeForTemperature(
                    fiveWidth * 80,
                    fiveWidth * 80,
                    "Farm Temperature",
                    fiveWidth * 60,
                    fiveWidth * 60,
                    _farmTemperature!),
                const SizedBox(
                  height: 10,
                ),
                // External Temperature
                gaugeForTemperature(
                    fiveWidth * 80,
                    fiveWidth * 80,
                    "External Temperature",
                    fiveWidth * 60,
                    fiveWidth * 60,
                    _externalTemperature!),
              ]),
            ),
            const SizedBox(
              width: 10,
            ),
            // Farm Humidity and External Humidity
            Flexible(
              flex: 1,
              child: Column(children: [
                // Farm Humidity
                gaugeForHumidity(
                    fiveWidth * 80,
                    fiveWidth * 80,
                    "Farm Humidity",
                    fiveWidth * 60,
                    fiveWidth * 60,
                    0,
                    100,
                    _farmHumidity!,
                    _getHumidityColor),
                const SizedBox(
                  height: 10,
                ),
                // External Humidity
                gaugeForHumidity(
                    fiveWidth * 80,
                    fiveWidth * 80,
                    "External Humidity",
                    fiveWidth * 60,
                    fiveWidth * 60,
                    0,
                    100,
                    _externalHumidity!,
                    _getHumidityColor),
              ]),
            ),
            const SizedBox(
              width: 10,
            ),
            // Todos List
            Flexible(
              flex: 1,
              child: Column(children: [
                // Todos
                todos(fiveWidth * 80, fiveWidth * 80),
                const SizedBox(
                  height: 10,
                ),
                // Water Temperature
                gaugeForTemperature(
                    fiveWidth * 80,
                    fiveWidth * 80,
                    "Water Temperature",
                    fiveWidth * 60,
                    fiveWidth * 60,
                    _waterTemperature!),
              ]),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // TDS, Water Level and pH Level
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TDS
            Flexible(
              flex: 2,
              child: tdsGraph(
                  2 * (fiveWidth * 80) + 10),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Water Level
                  waterLevel(fiveWidth * 80, fiveWidth * 80, fiveWidth * 50,
                      fiveWidth * 50, _waterLevel!),
                  const SizedBox(
                    height: 10,
                  ),
                  // PH Level
                  gaugeForPhLevel(
                    fiveWidth * 80,
                    fiveWidth * 80,
                    "pH Value",
                    fiveWidth * 60,
                    fiveWidth * 60,
                    0,
                    14,
                    2,
                    5.5,
                    6.5,
                    _pHLevel!,
                  ),
                ],
              ),
            )
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // Energy Consumption, Light Intensity and Co2 Levels
        Row(
          children: [
            // Energy Consumption
            Flexible(
              flex: 1,
              child: lightIntensityAndEnergyConsumptionGraph(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Energy Consumption",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  "Time (seconds)",
                  "Energy (kWh)",
                  0,
                  150,
                  30,
                  energyConsumptionData),
            ),
            const SizedBox(
              width: 10,
            ),
            // Light Intensity
            Flexible(
              flex: 1,
              child: lightIntensityAndEnergyConsumptionGraph(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Light Intensity",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  'Time (seconds)',
                  'Light Intensity (lx)',
                  0,
                  100,
                  20,
              lightIntensityData),
            ),
            const SizedBox(
              width: 10,
            ),
            // Co2 Levels
            Flexible(
              flex: 1,
              child: coLevelsGauge(
                  fiveWidth * 80,
                  fiveWidth * 80,
                  "Farm Co2 Levels",
                  fiveWidth * 60,
                  fiveWidth * 60,
                  _farmCo2Level!),
            ),
          ],
        ),
      ],
    );
  }

  // Responsive Version of Tablet
  Column tabletDashboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        CustomHeaderWithFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Your current performance"),

        // Farm Temperature,  External Temperature, Farm Humidity and External Humidity
        Row(
          children: [
            // Farm Temperature
            Flexible(
              flex: 1,
              child: Column(children: [
                // Farm Temperature
                gaugeForTemperature(fiveWidth * 100, width / 2,
                    "Farm Temperature", fiveWidth * 80, fiveWidth * 80, 25),
                const SizedBox(
                  height: 10,
                ),
                // External Temperature
                gaugeForTemperature(fiveWidth * 100, width / 2,
                    "External Temperature", fiveWidth * 75, fiveWidth * 75, 35),
              ]),
            ),
            const SizedBox(
              width: 10,
            ),
            // Farm Humidity
            Flexible(
              flex: 1,
              child: Column(children: [
                // Farm Humidity
                gaugeForHumidity(
                    fiveWidth * 100,
                    width / 2,
                    "Farm Humidity",
                    fiveWidth * 75,
                    fiveWidth * 75,
                    0,
                    100,
                    45,
                    _getHumidityColor),
                const SizedBox(
                  height: 10,
                ),
                // External Humidity
                gaugeForHumidity(
                    fiveWidth * 100,
                    width / 2,
                    "External Humidity",
                    fiveWidth * 75,
                    fiveWidth * 75,
                    0,
                    100,
                    55,
                    _getHumidityColor),
              ]),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),

        // Todos List
        todos(fiveWidth * 60, width),

        const SizedBox(
          height: 10,
        ),

        // TDS
        tdsGraph(570),

        const SizedBox(
          height: 10,
        ),

        // Water Level and pH Level
        Row(
          children: [
            // Water Level
            Flexible(
              flex: 1,
              child: waterLevel(fiveWidth * 100, width / 2, fiveWidth * 60,
                  fiveWidth * 60, 0.35),
            ),
            const SizedBox(
              width: 10,
            ),
            // PH Level
            Flexible(
              flex: 1,
              child: gaugeForPhLevel(
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
                10,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // Water Temperature and Energy Consumption
        Row(
          children: [
            // Water Temperature
            Flexible(
              flex: 1,
              child: gaugeForTemperature(fiveWidth * 100, width / 2,
                  "Water Temperature", fiveWidth * 80, fiveWidth * 80, 45),
            ),
            const SizedBox(
              width: 10,
            ),
            // Energy Consumption
            Flexible(
              flex: 1,
              child: lightIntensityAndEnergyConsumptionGraph(
                  fiveWidth * 100,
                  width / 2,
                  "Energy Consumption",
                  fiveWidth * 75,
                  fiveWidth * 75,
                  "Time (seconds)",
                  "Energy (kWh)",
                  0,
                  150,
                  30,
              energyConsumptionData),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // Light Intensity and Co2 Levels
        Row(
          children: [
            // Light Intensity
            Flexible(
              flex: 1,
              child: lightIntensityAndEnergyConsumptionGraph(
                  fiveWidth * 100,
                  width / 2,
                  "Light Intensity",
                  fiveWidth * 75,
                  fiveWidth * 75,
                  'Time (seconds)',
                  'Light Intensity (lx)',
                  0,
                  100,
                  20,
              lightIntensityData),
            ),
            const SizedBox(
              width: 10,
            ),
            // Co2 Levels
            Flexible(
              flex: 1,
              child: coLevelsGauge(fiveWidth * 100, width / 2,
                  "Farm Co2 Levels", fiveWidth * 75, fiveWidth * 75, 400),
            ),
          ],
        ),
      ],
    );
  }

  // Responsive Version of Mobile
  Widget mobileDashboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        CustomHeaderWithFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Your current performance"),

        // Farm Temperature
        gaugeForTemperature(250, width, "Farm Temperature", double.infinity,
            double.infinity, 25),

        const SizedBox(
          height: 10,
        ),

        // External Temperature
        gaugeForTemperature(250, width, "External Temperature",
            double.infinity, double.infinity, 35),

        const SizedBox(
          height: 10,
        ),

        // Farm Humidity
        gaugeForHumidity(250, width, "Farm Humidity", double.infinity,
            double.infinity, 0, 100, 45, _getHumidityColor),

        const SizedBox(
          height: 10,
        ),

        // External Humidity
        gaugeForHumidity(250, width, "External Humidity", double.infinity,
            double.infinity, 0, 100, 55, _getHumidityColor),

        const SizedBox(
          height: 10,
        ),

        // Todos List
        todos(250, width),

        const SizedBox(
          height: 10,
        ),

        // TDS
        tdsGraph(500),

        const SizedBox(
          height: 10,
        ),

        // Water Level
        waterLevel(250, width, fiveWidth * 80, fiveWidth * 80, 0.35),

        const SizedBox(
          height: 10,
        ),

        // PH Level
        gaugeForPhLevel(
          250,
          width,
          "pH Value",
          double.infinity,
          double.infinity,
          0,
          14,
          2,
          5.5,
          6.5,
          10,
        ),

        const SizedBox(
          height: 10,
        ),

        // Water Temperature
        gaugeForTemperature(250, width, "Water Temperature", double.infinity,
            double.infinity, 45),

        const SizedBox(
          height: 10,
        ),

        // Energy Consumption
        lightIntensityAndEnergyConsumptionGraph(
            250,
            width,
            "Energy Consumption",
            double.infinity,
            double.infinity,
            "Time (seconds)",
            "Energy (kWh)",
            0,
            150,
            30,
          energyConsumptionData
        ),

        const SizedBox(
          height: 10,
        ),

        // Light Intensity
        lightIntensityAndEnergyConsumptionGraph(
            250,
            width,
            "Light Intensity",
            double.infinity,
            double.infinity,
            'Time (seconds)',
            'Light Intensity (%)',
            0,
            100,
            20,
        lightIntensityData,),

        const SizedBox(
          height: 10,
        ),

        // Co2 Levels
        coLevelsGauge(250, width, "Farm Co2 Levels", double.infinity,
            double.infinity, 300),
      ],
    );
  }

  Widget gaugeForTemperature(
    double mainHeight,
    double mainWidth,
    String mainTitle,
    double secondaryHeight,
    double secondaryWidth,
    double temperatureValue,
  ) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color:
              themeColors.boxColor, // Background color of the gauge container
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeColors.boxColor, // Inner gauge color
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              showLabels: false,
                              showTicks: false,
                              minimum: 0,
                              maximum: 80,
                              radiusFactor: 0.9,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.15,
                                thicknessUnit: GaugeSizeUnit.factor,
                                color: Colors.grey
                                    .shade200, // Background for the secondary bar
                              ),
                              pointers: <GaugePointer>[
                                // Range for 0 to 20
                                RangePointer(
                                  value: temperatureValue >= 0
                                      ? (temperatureValue <= 20
                                          ? temperatureValue
                                          : 20)
                                      : 0,
                                  cornerStyle: gauges.CornerStyle.startCurve,
                                  enableAnimation: true,
                                  animationDuration: 1200,
                                  width: 0.15,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.blue,
                                ),
                                RangePointer(
                                  value: temperatureValue > 20
                                      ? (temperatureValue <= 40
                                          ? temperatureValue
                                          : 40)
                                      : 0,
                                  cornerStyle: gauges.CornerStyle.startCurve,
                                  enableAnimation: true,
                                  animationDuration: 1200,
                                  width: 0.15,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.yellow,
                                ),
                                RangePointer(
                                  value: temperatureValue > 40
                                      ? (temperatureValue <= 60
                                          ? temperatureValue
                                          : 60)
                                      : 0,
                                  cornerStyle: gauges.CornerStyle.startCurve,
                                  enableAnimation: true,
                                  animationDuration: 1200,
                                  width: 0.15,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.red.shade200,
                                ),
                                RangePointer(
                                  value: temperatureValue > 60
                                      ? (temperatureValue <= 100
                                          ? temperatureValue
                                          : 100)
                                      : 0,
                                  cornerStyle: gauges.CornerStyle.startCurve,
                                  enableAnimation: true,
                                  animationDuration: 1200,
                                  width: 0.15,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            RadialAxis(
                              showLabels: true,
                              annotations: <GaugeAnnotation>[
                                // Display temperature value in the center
                                GaugeAnnotation(
                                  widget: Text(
                                    "$mainTitle: $temperatureValue",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: themeColors
                                            .boxHeadingColor), // Color of annotation
                                  ),
                                  positionFactor: 0.9, // Center position
                                  angle: 90,
                                ),
                              ],
                              showTicks: true,
                              interval: 10, // Interval for tick marks
                              axisLabelStyle: GaugeTextStyle(
                                fontSize: 12, // Font size for labels
                                color: themeColors
                                    .graphLabelColor, // Color for labels
                              ),
                              labelOffset: 10, // Offset for labels
                              minimum: 0,
                              maximum: 80, // Max temperature value
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 0,
                                  endValue: 20,
                                  color:
                                      Colors.blue, // Color for the first range
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 20,
                                  endValue: 30,
                                  color: Colors
                                      .green, // Color for the second range
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 30,
                                  endValue: 40,
                                  color: Colors
                                      .yellow, // Color for the third range
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 40,
                                  endValue: 45,
                                  color: Colors.red
                                      .shade200, // Color for the final range
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: 45,
                                  endValue: 80,
                                  color:
                                      Colors.red, // Color for the final range
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                              ],
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1,
                                thicknessUnit: GaugeSizeUnit.factor,
                                color: Colors
                                    .grey.shade300, // Color of the axis line
                              ),
                              majorTickStyle: MajorTickStyle(
                                length: 0.15, // Length of major ticks
                                thickness: 2,
                                lengthUnit: GaugeSizeUnit.factor,
                                color: themeColors
                                    .graphMajorTicksColor, // Color of major ticks
                              ),
                              minorTickStyle: MinorTickStyle(
                                length: 0.07, // Length of minor ticks
                                thickness: 1,
                                lengthUnit: GaugeSizeUnit.factor,
                                color: themeColors
                                    .graphMinorTicksColor, // Color of minor ticks
                              ),
                              minorTicksPerInterval:
                                  4, // Minor ticks between major ticks
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value:
                                      temperatureValue, // Set the current temperature
                                  enableAnimation: true,
                                  needleLength: 0.7, // Length of the needle
                                  needleColor: themeColors
                                      .graphNeedleColor, // Color of the needle
                                  needleStartWidth: 0.1,
                                  needleEndWidth:
                                      3, // Thinner tip for the needle
                                  knobStyle: KnobStyle(
                                    color: themeColors
                                        .graphKnobColor, // Color of the knob
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
  SizedBox gaugeForHumidity(
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
          color:
              themeColors.boxColor, // Background color of the gauge container
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title of the gauge
              Text(
                mainTitle,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color:
                            themeColors.boxHeadingColor)), // Color of the title
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: minValue, // Minimum value for the gauge
                            maximum: maxValue, // Maximum value for the gauge
                            // startAngle: 180, // Start at the bottom
                            // endAngle: 180, // End at the top
                            showTicks: false, // Hide ticks
                            showLabels: false, // Hide axis labels
                            radiusFactor: 0.9, // Keep the gauge within bounds
                            ranges: <GaugeRange>[
                              // Define the range for the gauge
                              GaugeRange(
                                startValue: 0,
                                endValue:
                                    gaugeValue, // Fill according to gauge value
                                color: getGaugeColor(
                                    gaugeValue), // Get color dynamically
                                startWidth: 13,
                                endWidth: 13,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              // Display gauge value in the center
                              GaugeAnnotation(
                                widget: Text(
                                  '$gaugeValue%', // Show percentage
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: themeColors
                                        .boxHeadingColor, // Color of the annotation
                                  ),
                                ),
                                angle: 90,
                                positionFactor:
                                    0.1, // Position of the annotation
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
  SizedBox todos(double mainHeight, double mainWidth) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
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
                      showAddTodoDialog(context);
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 40, left: 20, right: 20.0),
                  child: _buildGraph(), // Method to build the actual graph
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for displaying water level with a circular progress indicator
  SizedBox waterLevel(double mainHeight, double mainWidth,
      double secondaryHeight, double secondaryWidth, double waterLevel) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
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
                    height: secondaryHeight,
                    width: secondaryWidth,
                    child: LiquidCircularProgressIndicator(
                      value: waterLevel / 100, // Set the water level (0.0 to 1.0)
                      valueColor: const AlwaysStoppedAnimation(Colors.blue),
                      backgroundColor: Colors.white,
                      borderColor: Colors.blue,
                      borderWidth: 5.0,
                      direction: Axis.vertical,
                      center: Text(
                        '${(waterLevel).toStringAsFixed(0)}%', // Display percentage
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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

  // Customizable half gauge widget for displaying various values
  Widget gaugeForPhLevel(
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
          color: themeColors.boxColor,
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
                    color: themeColors.boxHeadingColor,
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
                        color: themeColors.boxColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              showLabels: true,
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Text(
                                    "$mainTitle: $temperatureValue", // Display the main title and value
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: themeColors.boxHeadingColor),
                                  ),
                                  positionFactor: 0.5, // Center position
                                  angle: 90,
                                ),
                              ],
                              showTicks: true,
                              interval: interval,
                              axisLabelStyle: GaugeTextStyle(
                                fontSize: 12, // Font size for labels
                                color: themeColors
                                    .graphLabelColor, // Color for labels
                              ),
                              labelOffset: 10, // Move labels outside the gauge
                              // startAngle: 180,
                              // endAngle: 180,
                              minimum: minValue,
                              maximum: maxValue, // Set max value
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: minValue,
                                  endValue: value1,
                                  color: Colors.red, // First range color
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: value1,
                                  endValue: value2,
                                  color: Colors.green, // Second range color
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                                GaugeRange(
                                  startValue: value2,
                                  endValue: maxValue,
                                  color: Colors.blue, // Third range color
                                  startWidth: 10,
                                  endWidth: 10,
                                ),
                              ],
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1, // Thickness of the gauge ring
                                thicknessUnit: GaugeSizeUnit.factor,
                                color: Colors
                                    .grey.shade300, // Color of the axis line
                              ),
                              majorTickStyle: MajorTickStyle(
                                length: 0.15, // Length of major ticks
                                thickness: 2,
                                lengthUnit: GaugeSizeUnit.factor,
                                color: themeColors
                                    .graphMajorTicksColor, // Major ticks color
                              ),
                              minorTickStyle: MinorTickStyle(
                                length: 0.1, // Length of minor ticks
                                thickness: 1,
                                lengthUnit: GaugeSizeUnit.factor,
                                color: themeColors
                                    .graphMinorTicksColor, // Minor ticks color
                              ),
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: temperatureValue,
                                  needleColor: Colors.black,
                                  knobStyle: const KnobStyle(
                                    color: Colors.black,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    knobRadius: 0.07,
                                  ),
                                  needleLength: 0.6,
                                  needleEndWidth: 3,
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

  SizedBox lightIntensityAndEnergyConsumptionGraph(
      double mainHeight,
      double mainWidth,
      String title,
      double secondaryHeight,
      double secondaryWidth,
      String xTitle,
      String yTitle,
      double minValue,
      double maxValue,
      double interval,
      List<Map<int, double>?>? graphIntensityData,
      ) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
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
                  width: secondaryHeight,
                  height: secondaryWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                        title: AxisTitle(text: xTitle),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: yTitle),
                        minimum: minValue,
                        maximum: maxValue,
                        interval: interval,
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<dynamic, dynamic>>[
                        LineSeries<Map<int, double>?, int>(
                          dataSource: graphIntensityData,
                          xValueMapper: (Map<int, double>? intensity, _) =>
                              intensity!.keys.first,
                          yValueMapper: (Map<int, double>? intensity, _) =>
                              intensity!.values.first,
                          color: title.contains("Light") ? Colors.orangeAccent : Colors.greenAccent.shade400,
                          width: 3,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            color: title.contains("Light") ? Colors.orange : Colors.green,
                          ),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: themeColors.graphLabelColor,
                            ),
                          ),
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


  SizedBox coLevelsGauge(double mainHeight, double mainWidth, String title,
      double secondaryHeight, double secondaryWidth, double coLevel) {
    return SizedBox(
      height: mainHeight,
      width: mainWidth,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
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
                  height: secondaryHeight,
                  width: secondaryWidth,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum:
                                1000, // Max value for CO₂ (adjust as needed)
                            showTicks: true, // Hide ticks
                            showLabels: true, // Hide axis labels
                            interval: 150,
                            tickOffset:
                                5, // Move the minor ticks outward (negative values move inw
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 350,
                                color: Colors.green, // Safe CO₂ level
                                startWidth: 15,
                                endWidth: 15,
                              ),
                              GaugeRange(
                                startValue: 350,
                                endValue: 600,
                                color: Colors.orange, // Moderate CO₂ level
                                startWidth: 15,
                                endWidth: 15,
                              ),
                              GaugeRange(
                                startValue: 600,
                                endValue: 1000,
                                color: Colors.red, // High CO₂ level
                                startWidth: 15,
                                endWidth: 15,
                              ),
                            ],
                            majorTickStyle: MajorTickStyle(
                              length: 0.1, // Length of the major ticks
                              thickness: 2,
                              lengthUnit: GaugeSizeUnit.factor,
                              color: themeColors
                                  .graphMajorTicksColor, // Color of major ticks
                            ),
                            minorTickStyle: MinorTickStyle(
                              length: 0.05, // Length of the minor ticks
                              thickness: 1,
                              lengthUnit: GaugeSizeUnit.factor,
                              color: themeColors
                                  .graphMinorTicksColor, // Color of minor ticks
                            ),
                            minorTicksPerInterval: 4,
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: coLevel, // The current CO₂ value
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
                                widget: Text(
                                  '$coLevel ppm', // Display CO₂ value inside the gauge
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: themeColors.boxHeadingColor,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.5,
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
            _selectDate(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                width: fiveWidth * 3,
              ),
              Text(
                _selectedDate == null
                    ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                    : DateFormat.yMd().format(_selectedDate!),
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                  fontSize: 13,
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
      width: 140,
      height: 50,
      child: DropdownSearch<String>(
        onChanged: (String? newValue) {
          if(newValue != null) {
            ref.read(dashboardInfoProvider.notifier).updateSelectedDevice(newValue);
          }
        },
        items: (filter, infiniteScrollProps) => _devices,
        selectedItem: _selectedDevice,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelStyle:
                TextStyle(fontSize: 12, color: themeColors.boxHeadingColor),
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

  SizedBox graphTypeDropDown() {
    return SizedBox(
      width: 130,
      height: 50,
      child: DropdownSearch<String>(
        onChanged: (String? newValue) {
          if(newValue != null){
            ref.read(dashboardInfoProvider.notifier).updateSelectedGraphType(newValue);
          }

        },
        items: (filter, infiniteScrollProps) => _graphTypes,
        selectedItem: _graphTypes.first,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelStyle:
                TextStyle(fontSize: 12, color: themeColors.boxHeadingColor),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGraph() {
    switch (_selectedGraphType) {
      case 'Line Graph':
        return LineChart(
          LineChartData(
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey, width: 0.5), // Left border
                bottom:
                    BorderSide(color: Colors.grey, width: 0.5), // Bottom border
                right: BorderSide.none, // No right border
                top: BorderSide.none, // No top border
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1, // Set interval between grid lines
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
                  reservedSize:
                      35, // Adjust the space reserved for the x-axis labels
                  interval:
                      1, // Adjust distance between the x-axis labels and the graph
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
                          value.toStringAsFixed(
                              1), // Display up to 1 decimal place
                          style: const TextStyle(
                              fontSize: 12), // Customize the text style
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
                spots: tdsData != null
                    ? tdsData!
                        .where((map) => map != null) // Ensure non-null maps
                        .expand((map) => map!.entries) // Get all entries
                        .map((entry) =>
                            FlSpot(entry.key, entry.value)) // Map to FlSpot
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
            lineTouchData: const LineTouchData(enabled: false),
          ),
        );

      case 'Histogram':
        return BarChart(
          BarChartData(
            barGroups: tdsData != null
                ? tdsData!
                    .asMap() // Access the index for x-value
                    .entries
                    .where(
                        (entry) => entry.value != null) // Ensure non-null maps
                    .map((entry) {
                    int x = entry.key; // Use index as x-value
                    double? toY = entry.value?.values
                        .first; // Use the first value in the map as toY

                    // Define colors based on index
                    List<Color> colors = [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.yellow,
                      Colors.purple
                    ];
                    Color color = colors[x %
                        colors
                            .length]; // Cycle through colors if x exceeds length

                    return BarChartGroupData(
                      x: x,
                      barRods: [
                        BarChartRodData(
                          toY: toY ?? 0.0, // Default to 0.0 if toY is null
                          color: color, // Assign color dynamically
                        ),
                      ],
                    );
                  }).toList()
                : [],
            maxY: 1,
            minY: 0,
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey, width: 0.5), // Left border
                bottom:
                    BorderSide(color: Colors.grey, width: 0.5), // Bottom border
                right: BorderSide.none, // No right border
                top: BorderSide.none, // No top border
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1, // Set interval between grid lines
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
                  reservedSize:
                      30, // Adjust the space reserved for the x-axis labels
                  interval:
                      1, // Adjust distance between the x-axis labels and the graph
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
                          value.toStringAsFixed(
                              1), // Display up to 1 decimal place
                          style: const TextStyle(
                              fontSize: 12), // Customize the text style
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for values outside the range
                    }
                  },
                ),
              ),
            ),
          ),
        );

      case 'Scatter Graph':
        return ScatterChart(
          ScatterChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1, // Set interval between grid lines
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
                bottom:
                    BorderSide(color: Colors.grey, width: 0.5), // Bottom border
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
                  reservedSize:
                      30, // Adjust the space reserved for the x-axis labels
                  interval:
                      1, // Adjust distance between the x-axis labels and the graph
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
                          value.toStringAsFixed(
                              1), // Display up to 1 decimal place
                          style: const TextStyle(
                              fontSize: 12), // Customize the text style
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for values outside the range
                    }
                  },
                ),
              ),
            ),
            scatterSpots: tdsData != null
                ? tdsData!
                    .asMap()
                    .entries
                    .where((entry) => entry.value != null)
                    .map((entry) {
                    int x = entry.key;
                    double? y = entry.value?.values.first;

                    // Define colors based on index
                    List<Color> colors = [
                      Colors.blue,
                      Colors.green,
                      Colors.red,
                      Colors.yellow
                    ];
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
          ),
        );

      case 'Box Graph':
        return BarChart(
          BarChartData(
            barGroups: tdsData != null
                ? tdsData!
                    .asMap()
                    .entries
                    .where((entry) => entry.value != null)
                    .map((entry) {
                    int x = entry.key;
                    double? y = entry.value?.values.first;

                    // Define colors based on index
                    List<Color> colors = [
                      Colors.blue,
                      Colors.green,
                      Colors.red,
                      Colors.yellow
                    ];
                    Color color = colors[x % colors.length];

                    return BarChartGroupData(x: x.toInt(), barRods: [
                      BarChartRodData(toY: y ?? 0.0, color: color),
                    ]);
                  }).toList()
                : [],
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey, width: 0.5), // Left border
                bottom:
                    BorderSide(color: Colors.grey, width: 0.5), // Bottom border
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
                  reservedSize:
                      30, // Adjust the space reserved for the x-axis labels
                  interval:
                      1, // Adjust distance between the x-axis labels and the graph
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
                          value.toStringAsFixed(
                              1), // Display up to 1 decimal place
                          style: const TextStyle(
                              fontSize: 12), // Customize the text style
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for values outside the range
                    }
                  },
                ),
              ),
            ),
            maxY: 1,
            minY: 0,
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1, // Set interval between grid lines
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey, // Color of the dashed lines
                  strokeWidth: 0.5,
                );
              },
              drawVerticalLine:
                  false, // Disable vertical lines if you only want horizontal dashed lines
            ),
          ),
        );

      case 'Bubble Graph':
        return ScatterChart(
          ScatterChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 0.1, // Set interval between grid lines
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.grey, // Color of the dashed lines
                  strokeWidth:
                      0.5, // Create dashed effect (8 pixels line, 8 pixels gap)
                );
              },
              drawVerticalLine:
                  false, // Disable vertical lines if you only want horizontal dashed lines
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey, width: 0.5), // Left border
                bottom:
                    BorderSide(color: Colors.grey, width: 0.5), // Bottom border
                right: BorderSide.none, // No right border
                top: BorderSide.none, // No top border
              ),
            ),
            minY: 0,
            maxY: 1,
            minX: 0,
            maxX: 10,
            scatterSpots: tdsData != null
                ? tdsData!
                .asMap()
                .entries
                .where((entry) => entry.value != null)
                .map((entry) {
              int x = entry.key;
              double? y = entry.value?.values.first;

              // Define colors based on index
              List<Color> colors = [
                Colors.blue,
                Colors.green,
                Colors.red,
                Colors.yellow
              ];
              Color color = colors[x % colors.length];

              return ScatterSpot(x.toDouble(), y ?? 0.0,
                  dotPainter: FlDotCirclePainter(radius: 5, color: color),
              );
            }).toList()
                : [],
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
                  reservedSize:
                      30, // Adjust the space reserved for the x-axis labels
                  interval:
                      1, // Adjust distance between the x-axis labels and the graph
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
                          value.toStringAsFixed(
                              1), // Display up to 1 decimal place
                          style: const TextStyle(
                              fontSize: 12), // Customize the text style
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for values outside the range
                    }
                  },
                ),
              ),
            ),
          ),
        );

      default:
        return const Center(child: Text('Select a graph type'));
    }
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
