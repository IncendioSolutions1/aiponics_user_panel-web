import 'dart:developer';
import 'package:aiponics_web_app/models/dashboard%20management%20models/control_panel_model.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/control_panel_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/views/common/header/header_with_farm_dropdown.dart';
import 'package:aiponics_web_app/views/popup_screens/control_panel_monitoring_system_settings.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ControlPanel extends ConsumerStatefulWidget {
  const ControlPanel({super.key});

  @override
  ConsumerState<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends ConsumerState<ControlPanel>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String responsiveness;

  late int noOfFans;
  late int noOfWaterPumps;
  late int noOfMistingPumps;

  final TextEditingController _phLevelController = TextEditingController();
  final TextEditingController _tdsLevelController = TextEditingController();
  final TextEditingController _waterLevelController = TextEditingController();

  late double _phPreviousValue;
  late double _tdsPreviousValue;
  late double _waterLevelPreviousValue;

  late List<String> controlPanelGaugesLabels;
  late List<IconData> controlPanelGaugesIcons;
  late List<double> controlPanelGaugesValues;

  late bool isWaterLevelManual;
  late bool isMonitoringSystemManual;

  double spaceBetweenLabelAndItems = 20;
  double spaceBetweenTwoItems = 40;

  String currentValuesLabel = "Current Values";
  String monitoringSystemLabel = "Monitoring System Controller";
  String dosingSystemLabel = "Dosing System Controller";
  String pHAndTdsLabel = "ph Level and Tds Level Controller";
  String waterLevelLabel = "Water's Level Controller";
  String pHLevelLabel = "pH's Level Controller";
  String tdsLevelLabel = "TDS Level Controller";

  late int selectedTabButtonIndex; // 0: Fans, 1: Pumps, 2: Mist Pumps
  late List<String> tabButtonNamesList;

  late List<List<bool>> buttonLists;
  late List<int> monitoringSystemButtonCount;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _fanIconAnimationController;
  late AnimationController _pumpIconController;
  late AnimationController _mistIconController;
  late AnimationController _settingIconController;

  late ThemeColors themeColors;
  
  String remainingTime = ""; // Variable to hold the remaining time

  late double fiveWidth;
  late double fiveHeight;
  late double screenFullWidth;
  late double screenRemainingWidth;

  @override
  void initState() {

    // noOfFans = 20;
    // noOfWaterPumps = 30;
    // noOfMistingPumps = 40;
    //
    // late List<bool> fansList = List.generate(noOfFans, (index) => false);
    // late List<bool> waterPumpList =
    //     List.generate(noOfWaterPumps, (index) => false);
    // late List<bool> mistPumpList =
    //     List.generate(noOfMistingPumps, (index) => false);
    //
    // buttonLists = [fansList, waterPumpList, mistPumpList];
    // monitoringSystemButtonCount = [noOfFans, noOfWaterPumps, noOfMistingPumps];
    //
    // _phPreviousValue = 5;
    // _tdsPreviousValue = 700;
    // _waterLevelPreviousValue = 70;

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 300), // Duration for the zoom-in effect
    );

    _controller.forward(from: 0.0);

    _fanIconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of one full rotation
    )..repeat(); // Repeat the animation

    _settingIconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Duration of one full rotation
    )..repeat(); // Repeat the animation

    // Initialize the animation controller for the pumping effect
    _pumpIconController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500), // Duration for one pump cycle
    )..repeat(reverse: true); // Repeat and reverse for up and down effect

    // Initialize the animation controller for the misting effect
    _mistIconController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1000), // Duration for one mist cycle
    )..repeat(reverse: true); // Repeat and reverse for fading effect

    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pumpIconController.dispose();
    _fanIconAnimationController.dispose();
    _mistIconController.dispose();
    _settingIconController.dispose();

    _phLevelController.dispose();
    _tdsLevelController.dispose();
    _waterLevelController.dispose();

    super.dispose();
  }

  // Added a callback parameter in it
  void showMonitoringSystemSettingScreenDialog(BuildContext context, Function(bool) onSwitchChanged, Function(String) onTimeUpdate) {
    showGeneralDialog(
      context: context,
      barrierDismissible:
          true, // This allows the dialog to close when clicked outside
      barrierLabel: '',
      barrierColor:
          Colors.black.withOpacity(0.5), // Optional: Adds a background overlay
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const SizedBox
            .shrink(); // Needed to prevent blocking interaction with dialog
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
                decoration: BoxDecoration(
                  color: themeColors.boxColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.6,
                height: responsiveness == "mobile" ? MediaQuery.of(context).size.height * 0.8 : MediaQuery.of(context).size.height * 0.7,
                child: const ControlPanelMonitoringSystemSettings(),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ).then((_) {
      // This will ensure the state is updated once the dialog is dismissed
      // If needed, you can stop or restart any processes here
      onTimeUpdate(remainingTime); // Update time when dialog closes
    });
  }

  // Added a callback parameter in it
  void showWaterLevelToggleDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible:
      true, // This allows the dialog to close when clicked outside
      barrierLabel: '',
      barrierColor:
      Colors.black.withOpacity(0.5), // Optional: Adds a background overlay
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const SizedBox.shrink(); // Needed to prevent blocking interaction with dialog
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
              child: Consumer(
                builder: (context, ref, _) {
                  // Watch the reactive state
                  final isWaterLevelManual = ref.watch(
                    controlPanelInfoProvider.select((state) => state.isWaterLevelManual),
                  );

                  return Container(
                    decoration: BoxDecoration(
                      color: themeColors.boxColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        Text(
                          'Set Water Level System',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: themeColors.boxHeadingColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Auto',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: themeColors.boxHeadingColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Transform.scale(
                              scale: 1,
                              child: Switch(
                                trackOutlineColor:
                                WidgetStateProperty.all(themeColors.boxHeadingColor),
                                trackOutlineWidth: WidgetStateProperty.all(1),
                                thumbIcon: isWaterLevelManual
                                    ? WidgetStateProperty.all(const Icon(Icons.build))
                                    : WidgetStateProperty.all(const Icon(Icons.autorenew)),
                                value: isWaterLevelManual,
                                onChanged: (value) {
                                  ref
                                      .read(controlPanelInfoProvider.notifier)
                                      .toggleWaterLevelManual();
                                },
                                activeColor: themeColors.borderColor, // Color when the switch is ON
                                inactiveThumbColor:
                                Colors.black, // Color of the thumb when OFF
                                inactiveTrackColor:
                                Colors.grey, // Color of the track when OFF
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Manual',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: themeColors.boxHeadingColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }


  @override
  Widget build(BuildContext context) {

    fiveWidth = ref.watch(dashboardScreenInfoProvider.select((state) => state['fiveWidth']));
    fiveHeight = ref.watch(dashboardScreenInfoProvider.select((state) => state['fiveHeight']));
    screenFullWidth = ref.watch(dashboardScreenInfoProvider.select((state) => state['screenFullWidth']));
    screenRemainingWidth = ref.watch(dashboardScreenInfoProvider.select((state) => state['screenRemainingWidth']));

    // Watch the provider to access its current value
    responsiveness = ref.watch(dashboardScreenInfoProvider)['screenResponsiveness'];

    themeColors = ThemeColors(context);

    selectedTabButtonIndex = ref.watch(controlPanelInfoProvider).selectedTabButtonIndex;
    noOfFans =ref.watch(controlPanelInfoProvider).noOfFans;
    noOfWaterPumps =ref.watch(controlPanelInfoProvider).noOfWaterPumps;
    noOfMistingPumps =ref.watch(controlPanelInfoProvider).noOfMistingPumps;
    _phPreviousValue = ref.watch(controlPanelInfoProvider).phOldValue;
    _tdsPreviousValue = ref.watch(controlPanelInfoProvider).tdsOldValue;
    _waterLevelPreviousValue = ref.watch(controlPanelInfoProvider).waterLevelOldValue;


    isMonitoringSystemManual = ref.watch(controlPanelInfoProvider).isMonitoringSystemManual;
    isWaterLevelManual = ref.watch(controlPanelInfoProvider).isWaterLevelManual;

    tabButtonNamesList = ref.watch(controlPanelInfoProvider).tabButtonNamesList;
    monitoringSystemButtonCount = ref.watch(controlPanelInfoProvider).monitoringSystemButtonsCount;
    buttonLists = ref.watch(controlPanelInfoProvider).buttonsStateLists;

    controlPanelGaugesLabels = ref.watch(controlPanelInfoProvider).controlPanelGaugesLabels;
    controlPanelGaugesIcons = ref.watch(controlPanelInfoProvider).controlPanelGaugesIcons;
    controlPanelGaugesValues = ref.watch(controlPanelInfoProvider).controlPanelGaugesValues;

    log("$screenFullWidth");
    log("$fiveWidth");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: responsiveness == "desktop" ? Padding(
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 40, right: 50, left: 50),
                  child:
                      desktopDashboard(context),
                ) :
    responsiveness == "tablet" ?
            Padding(
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 40, right: 20, left: 50),
                  child: tabletDashboard(context),) :
            Padding(
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 40, right: 50, left: 50),
                  child: mobileDashboard(context),
                )
        ),
      ),
    );
  }

  desktopDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomHeaderWithFarmDropdown(mainPageHeading: "Welcome", subHeading: "Control your Farm"),
        mainLabels(currentValuesLabel, 20),
        const SizedBox(
          height: 10,
        ),
        liveValuesGrid(),
        SizedBox(
          height: spaceBetweenTwoItems,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mainLabels(monitoringSystemLabel, 20),
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: monitoringSystemSettingButton("desktop"),
            ),
          ],
        ),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        monitoringSystemDisplaySelectorButtons("desktop"),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        monitoringSystemGridView(7),
        SizedBox(
          height: spaceBetweenTwoItems,
        ),
        mainLabels(dosingSystemLabel, 20),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: phLevelController(),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: tdsLevelController(),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: waterLevelControllerDesktop(),
            ),
          ],
        ),
      ],
    );
  }

  tabletDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomHeaderWithFarmDropdown(mainPageHeading: "Welcome", subHeading: "Control your Farm"),

        mainLabels(currentValuesLabel, 18),
        const SizedBox(
          height: 5,
        ),
        liveValuesGrid(),
        SizedBox(
          height: spaceBetweenTwoItems,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mainLabels(monitoringSystemLabel, 18),
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: monitoringSystemSettingButton("tablet"),
            ),
          ],
        ),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        monitoringSystemDisplaySelectorButtons("tablet"),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        monitoringSystemGridView(4),
        SizedBox(
          height: spaceBetweenTwoItems,
        ),
        mainLabels(dosingSystemLabel, 18),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        phLevelController(),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        tdsLevelController(),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        waterLevelControllerTablet(),
      ],
    );
  }

  mobileDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

     
        CustomHeaderWithFarmDropdown(mainPageHeading: "Welcome", subHeading: "Control your Farm"),
        
        mainLabels(currentValuesLabel, 15),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        liveValuesGrid(),
        SizedBox(
          height: spaceBetweenTwoItems,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mainLabels(monitoringSystemLabel, 15),
            monitoringSystemSettingButton("mobile"),
          ],
        ),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        monitoringSystemDisplaySelectorButtons("mobile"),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        monitoringSystemGridView(2),
        SizedBox(
          height: spaceBetweenTwoItems,
        ),
        mainLabels(dosingSystemLabel, 15),

        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        phLevelControllerMobile(),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        tdsLevelControllerMobile(),
        SizedBox(
          height: spaceBetweenLabelAndItems,
        ),
        waterLevelControllerMobile(),
      ],
    );
  }

  Widget mainLabels(String label, double fontSize) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: fontSize,
          color: themeColors.boxHeadingColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget liveValuesGrid() {
    return Wrap(
      spacing: 0, // Horizontal spacing
      runSpacing: 0, // Vertical spacing
      children: List.generate(
        controlPanelGaugesValues.length,
            (index) => SizedBox(
              width: responsiveness == 'desktop'
                  ? fiveWidth * 54.5
                  : responsiveness == 'tablet'
                  // ? MediaQuery.of(context).size.width / 3.5 : 200, // Desired button width
                  ? (screenFullWidth < 820 ? fiveWidth * 83.5 : fiveWidth * 69 ) : fiveWidth * 40, // Desired button width
              height: 320, // Desired button height
              child: buildGaugeCard(controlPanelGaugesLabels[index], controlPanelGaugesValues[index], controlPanelGaugesIcons[index]),
        ),
      ),
    );
  }


  Widget buildGaugeCard(String label, double value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: themeColors.boxColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: themeColors.boxHeadingColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: responsiveness == 'desktop'
                  ? 250
                  : responsiveness == 'tablet'
                      ? 200
                      : 150,
              height: responsiveness == 'desktop'
                  ? 200
                  : responsiveness == 'tablet'
                      ? 200
                      : 150,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: label.contains('Temperature')
                        ? 80
                        : 100, // Different ranges
                    interval: label.contains('Temperature') ? 15 : 20,
                    minorTicksPerInterval:
                        label.contains('Temperature') ? 2 : 3,
                    ranges: label.contains('Temperature')
                        ? <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 20,
                                color: Colors.blue),
                            GaugeRange(
                                startValue: 20,
                                endValue: 30,
                                color: Colors.green),
                            GaugeRange(
                                startValue: 30,
                                endValue: 40,
                                color: Colors.yellow),
                      GaugeRange(
                          startValue: 40,
                          endValue: 45,
                          color: Colors.orange),
                      GaugeRange(
                          startValue: 45,
                          endValue: 80,
                          color: Colors.red),
                          ]
                        : <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 30,
                                color: Colors.green),
                            GaugeRange(
                                startValue: 30,
                                endValue: 60,
                                color: Colors.orange),
                            GaugeRange(
                                startValue: 60,
                                endValue: 100,
                                color: Colors.redAccent),
                          ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: value,
                        needleLength:
                            0.7, // Adjust the length (percentage of the radius)
                        needleStartWidth: 0.5,
                        needleEndWidth: 3, // Adjust the thickness of the needle
                        needleColor: themeColors.graphNeedleColor, // Color of the needle
                        knobStyle: KnobStyle(
                          color: themeColors.graphKnobColor,
                          sizeUnit: GaugeSizeUnit.factor,
                          knobRadius: 0.05, // Size of the knob at the center
                        ),
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          label.contains('Temperature')
                              ? "${value.toStringAsFixed(1)} °C"
                              : "${value.toStringAsFixed(1)} g/m3",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: themeColors.graphLabelColor,
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DefaultTabController monitoringSystemDisplaySelectorButtons(String responsiveness) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: ButtonsTabBar(
        backgroundColor: themeColors.borderColor,
        unselectedBackgroundColor: themeColors.boxColor,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        borderColor: themeColors.borderColor,
        borderWidth: 2,
        unselectedBorderColor: themeColors.boxHeadingColor,
        labelStyle: TextStyle(
            color: themeColors.boxHeadingColor,
            fontWeight: FontWeight.bold,
            fontSize: responsiveness == "desktop"
                ? 13
                : responsiveness == "tablet"
                    ? 12
                    : 11),
        radius: 10.0,
        buttonMargin: const EdgeInsets.symmetric(
            horizontal: 10.0), // Add margin between buttons
        tabs: [
          Tab(
            child: SizedBox(
              width: responsiveness == "desktop"
                  ? 150
                  : responsiveness == "tablet"
                      ? 120
                      : 100, // Set equal width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _fanIconAnimationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _fanIconAnimationController.value *
                            2.0 *
                            3.14159, // Convert the value to radians
                        child: Icon(
                          MdiIcons.fan, // Replace with the fan icon you want
                          color: selectedTabButtonIndex == 0
                              ? Colors.white
                              : themeColors.boxHeadingColor, // Set icon color
                          size: responsiveness == "desktop"
                              ? 25
                              : responsiveness == "tablet"
                                  ? 20
                                  : 15,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                  Text(
                    'Fans',
                    style: TextStyle(
                      color: selectedTabButtonIndex == 0
                          ? Colors.white
                          : themeColors.boxHeadingColor, // Set text color
                    ),
                  ),
                ],
              ),
            ),
          ),
          Tab(
            child: SizedBox(
              width: responsiveness == "desktop"
                  ? 150
                  : responsiveness == "tablet"
                      ? 120
                      : 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pumpIconController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 +
                            0.1 *
                                _pumpIconController
                                    .value, // Scale up to 10% larger
                        child: Icon(
                          // Replace with your custom water pump icon
                          Icons.local_drink,
                          color: selectedTabButtonIndex == 1
                              ? Colors.white
                              : themeColors.boxHeadingColor,
                          size: responsiveness == "desktop"
                              ? 25
                              : responsiveness == "tablet"
                                  ? 20
                                  : 15,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                  Text(
                    'Pumps',
                    style: TextStyle(
                      color:
                          selectedTabButtonIndex == 1 ? Colors.white : themeColors.boxHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Tab(
            child: SizedBox(
              width: responsiveness == "desktop"
                  ? 150
                  : responsiveness == "tablet"
                      ? 120
                      : 100, // Set equal width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _mistIconController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 0.5 +
                            0.5 * _mistIconController.value, // Fade in and out
                        child: Transform.scale(
                          scale: 1 +
                              0.1 *
                                  _mistIconController
                                      .value, // Scale up to 10% larger
                          child: Icon(
                            Icons.foggy, // Replace with your mist pump icon
                            color: selectedTabButtonIndex == 2
                                ? Colors.white
                                : themeColors.boxHeadingColor,
                            size: responsiveness == "desktop"
                                ? 25
                                : responsiveness == "tablet"
                                    ? 20
                                    : 15,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                  Text(
                    'Mist Pumps',
                    style: TextStyle(
                      color:
                          selectedTabButtonIndex == 2 ? Colors.white : themeColors.boxHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        onTap: (index) {
          onTabChanged(index);
        },
      ),
    );
  }

  void onTabChanged(int index) {
    ref.read(controlPanelInfoProvider.notifier).updateSelectedTabButtonIndex(index);
    _controller.forward(from: 0.0); // Restart the animation on tab change
  }

  // Method to build the animated icon based on index
  Widget buildAnimatedIcon(int iconIndex, int index, String responsiveness, bool isTurnedOn) {
    switch (iconIndex) {
      case 0: // Fan icon
        return isTurnedOn ? AnimatedBuilder(
          animation: _fanIconAnimationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _fanIconAnimationController.value *
                  2.0 *
                  3.14159, // Convert to radians
              child: Icon(
                MdiIcons.fan, // Fan icon
                size: responsiveness == "mobile" ? 12 :  17,
                color: isMonitoringSystemManual
                    ? buttonLists[selectedTabButtonIndex][index]
                        ? Colors.white
                        : Colors.black
                    : Colors.black54, // Set icon color
              ),
            );
          },
        ) : Icon(
          MdiIcons.fan, // Fan icon
          size: responsiveness == "mobile" ? 12 :  17,
          color: isMonitoringSystemManual
              ? buttonLists[selectedTabButtonIndex][index]
              ? Colors.white
              : Colors.black
              : Colors.black54, // Set icon color
        );

      case 1: // Water pump icon
        return isTurnedOn ? AnimatedBuilder(
          animation: _pumpIconController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + 0.1 * _pumpIconController.value, // Scale effect
              child: Icon(
                Icons.local_drink, // Water pump icon
                size: responsiveness == "mobile" ? 12 :  17,
                color: isMonitoringSystemManual
                    ? buttonLists[selectedTabButtonIndex][index]
                        ? Colors.white
                        : Colors.black
                    : Colors.black54,
              ),
            );
          },
        ) : Icon(
          Icons.local_drink, // Water pump icon
          size: responsiveness == "mobile" ? 15 :  20,
          color: isMonitoringSystemManual
              ? buttonLists[selectedTabButtonIndex][index]
              ? Colors.white
              : Colors.black
              : Colors.black54,
        );
      case 2: // Mist pump icon
        return isTurnedOn ? AnimatedBuilder(
          animation: _mistIconController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.5 + 0.5 * _mistIconController.value, // Fade effect
              child: Transform.scale(
                scale: 1 + 0.1 * _mistIconController.value, // Scale effect
                child: Icon(
                  Icons.foggy, // Mist pump icon
                  size: responsiveness == "mobile" ? 15 :  20,
                  color: isMonitoringSystemManual
                      ? buttonLists[selectedTabButtonIndex][index]
                          ? Colors.white
                          : Colors.black
                      : Colors.black54,
                ),
              ),
            );
          },
        ) : Icon(
          Icons.foggy, // Mist pump icon
          size: responsiveness == "mobile" ? 15 :  20,
          color: isMonitoringSystemManual
              ? buttonLists[selectedTabButtonIndex][index]
              ? Colors.white
              : Colors.black
              : Colors.black54,
        );
      default:
        return Container(); // Fallback in case of an unknown index
    }
  }

  Widget monitoringSystemGridView(int noOfItemsInARow) {
    final ControlPanelInfoModel controlPanelInfoState = ref.watch(controlPanelInfoProvider);
    final ControlPanelInfoNotifier controlPanelInfoNotifier = ref.read(controlPanelInfoProvider.notifier);

    return monitoringSystemButtonCount[selectedTabButtonIndex] <= 0
        ? const Center(child: Text("Nothing to show here"))
        : ScaleTransition(
            scale: _scaleAnimation,
            child: Tooltip(
              message: !isMonitoringSystemManual
                  ? "Monitoring System is currently operating in auto mode.\nTo make any adjustments, please switch it to manual mode."
                  : "",
              textAlign: TextAlign.center,
              child: AbsorbPointer(
                absorbing: !isMonitoringSystemManual,
                child: Wrap(
                  spacing: 15, // Horizontal spacing
                  runSpacing: 15, // Vertical spacing
                  children: List.generate(
                    monitoringSystemButtonCount[selectedTabButtonIndex],
                        (index) => SizedBox(
                      width: 130, // Desired button width
                      height: 40, // Desired button height
                      child: AnimatedScale(
                        scale: buttonLists[selectedTabButtonIndex][index]
                            ? 1.05
                            : 1.0, // Subtle scale animation when active
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: AnimatedOpacity(
                          opacity: isMonitoringSystemManual ? 1.0 : 0.5, // Opacity toggle
                          duration: const Duration(milliseconds: 300),
                          child: ElevatedButton(
                            onPressed: isMonitoringSystemManual
                                ? () {
                              controlPanelInfoNotifier.updateStatusOfMonitoringSystemButtonState(
                                  selectedTabButtonIndex, index);
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isMonitoringSystemManual
                                  ? buttonLists[selectedTabButtonIndex][index]
                                  ? themeColors.borderColor
                                  : Colors.grey[300]
                                  : Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: buttonLists[selectedTabButtonIndex][index] ? 8 : 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildAnimatedIcon(selectedTabButtonIndex, index, responsiveness,
                                    buttonLists[selectedTabButtonIndex][index]),
                                const SizedBox(width: 8),
                                Text(
                                  '${tabButtonNamesList[selectedTabButtonIndex]} ${index + 1}',
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      fontSize: responsiveness == "mobile" ? 11 : 12,
                                      color: isMonitoringSystemManual
                                          ? buttonLists[selectedTabButtonIndex][index]
                                          ? Colors.white
                                          : Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget monitoringSystemSettingButton(String responsiveness) {
    return InkWell(
      onTap: () {
        showMonitoringSystemSettingScreenDialog(
            context, _updateMonitoringSystemMode, _updateRemainingTime);
      },
      child: AnimatedBuilder(
        animation: _settingIconController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _settingIconController.value *
                2.0 *
                3.14159, // Convert to radians
            child: Icon(
              Icons.settings, // Fan icon
              size: responsiveness == "mobile" ? 20 : 28,
              color: themeColors.boxHeadingColor, // Set icon color
            ),
          );
        },
      ),
    );
  }

  void _updateMonitoringSystemMode(bool isManual) {
    ref.read(controlPanelInfoProvider.notifier).toggleMonitoringSystemManual();
  }

  void _updateRemainingTime(String time) {
    ref.read(controlPanelInfoProvider.notifier).updateRemainingTime(time);
  }

  Widget phLevelController() {
    return Container(
      decoration: BoxDecoration(
        color: themeColors.boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 20.0, horizontal: 20.0), // Adjust padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Set new pH Level",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: themeColors.boxHeadingColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: fiveWidth * 6),
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter only numbers';
                        } else {
                          if (double.parse(value) > 14 ||
                              double.parse(value) <= 0) {
                            return 'Enter value from 1 to 14';
                          }
                        }
                      }
                      return null;
                    },
                    controller: _phLevelController,
                    decoration: InputDecoration(
                      hintText:  _phPreviousValue.toString(),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      // label: Text('New Value Here'),
                      // labelStyle:
                      //     TextStyle(color: themeColors.boxHeadingColor, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0), // Adjust padding
                    ),
                    style: const TextStyle(
                        fontSize: 14), // Adjust font size for the text
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              height: 45,
              width: fiveWidth * 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_phLevelController.text.isNotEmpty) {
                      if (RegExp(r'^[0-9]+$').hasMatch(_phLevelController.text)) {
                        ref.read(controlPanelInfoProvider.notifier).updatePhValue(double.parse(_phLevelController.text));
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColors.borderColor, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Button corners
                  ),
                  textStyle: const TextStyle(fontSize: 14), // Text size
                ),
                child: Text(
                  'Set New Value',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ), // Change button text
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget phLevelControllerMobile() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeColors.boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 10), // Adjust padding
      child: Column(
        children: [
          Text(
            "Set New pH Level",
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0), // Adjust padding
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: themeColors.borderColor,
                    )),
                child: Text(
                  _phPreviousValue.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_forward,
                size: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 160, // Set the width of the text field
                child: TextFormField(
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter only numbers';
                      } else {
                        if (double.parse(value) > 14 ||
                            double.parse(value) <= 0) {
                          return 'Enter value between\n1 to 14';
                        }
                      }
                    }
                    return null;
                  },
                  controller: _phLevelController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    labelText: 'New Value Here',
                    labelStyle:
                        TextStyle(color: themeColors.boxHeadingColor, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0), // Adjust padding
                  ),
                  style: const TextStyle(
                      fontSize: 12), // Adjust font size for the text
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 45,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_phLevelController.text.isNotEmpty) {
                    if (RegExp(r'^[0-9]+$').hasMatch(_phLevelController.text)) {
                      ref.read(controlPanelInfoProvider.notifier).updatePhValue(double.parse(_phLevelController.text));
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColors.borderColor, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Button corners
                ),
                textStyle: const TextStyle(fontSize: 14), // Text size
              ),
              child: Text(
                'Set New Value',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: themeColors.boxHeadingColor,
                  ),
                ),
              ), // Change button text
            ),
          )
        ],
      ),
    );
  }

  Widget tdsLevelController() {
    return Container(
      decoration: BoxDecoration(
        color: themeColors.boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 20.0, horizontal: 20.0), // Adjust padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Set new TDS Level",
            style: GoogleFonts.poppins(
                fontSize: 18,
                color: themeColors.boxHeadingColor,
                fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: fiveWidth * 6),
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter only numbers';
                        }
                      }
                      return null;
                    },
                    controller: _tdsLevelController,
                    decoration: InputDecoration(
                      hintText: _tdsPreviousValue.toString(),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: themeColors.borderColor, width: 1)),
                      // labelText: 'New Value Here',
                      // labelStyle:
                      //     TextStyle(color: themeColors.boxHeadingColor, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0), // Adjust padding
                    ),
                    style: const TextStyle(
                        fontSize: 14), // Adjust font size for the text
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              height: 45,
              width: fiveWidth * 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_tdsLevelController.text.isNotEmpty) {
                      if (RegExp(r'^[0-9]+$')
                          .hasMatch(_tdsLevelController.text)) {
                        ref.read(controlPanelInfoProvider.notifier).updateTdsValue(double.parse(_tdsLevelController.text));
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColors.borderColor, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Button corners
                  ),
                  textStyle: const TextStyle(fontSize: 14), // Text size
                ),
                child: Text(
                  'Set New Value',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ), // Change button text
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tdsLevelControllerMobile() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeColors.boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 20.0, horizontal: 10.0), // Adjust padding
      child: Column(
        children: [
          Text(
            "Set New TDS Level",
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 12.0), // Adjust padding
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: themeColors.borderColor,
                    )),
                child: Text(
                  _tdsPreviousValue.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_forward,
                size: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 150, // Set the width of the text field
                child: TextFormField(
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter only numbers';
                      }
                    }
                    return null;
                  },
                  controller: _tdsLevelController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: themeColors.borderColor, width: 1)),
                    labelText: 'New Value Here',
                    labelStyle:
                        TextStyle(color: themeColors.boxHeadingColor, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0), // Adjust padding
                  ),
                  style: const TextStyle(
                      fontSize: 14), // Adjust font size for the text
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 45,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_tdsLevelController.text.isNotEmpty) {
                    if (RegExp(r'^[0-9]+$')
                        .hasMatch(_tdsLevelController.text)) {
                      ref.read(controlPanelInfoProvider.notifier).updateTdsValue(double.parse(_tdsLevelController.text));
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColors.borderColor, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Button corners
                ),
                textStyle: const TextStyle(fontSize: 14), // Text size
              ),
              child: Text(
                'Set New Value',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: themeColors.boxHeadingColor,
                  ),
                ),
              ), // Change button text
            ),
          ),
        ],
      ),
    );
  }

  Widget waterLevelControllerDesktop() {
    return Tooltip(
      message: isWaterLevelManual
          ? ""
          : "The water level is currently set to auto mode, and the tank will be filled to 100%.\nTo make any adjustments, please switch to manual mode.",
      textAlign: TextAlign.center,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 20.0, horizontal: 20.0), // Adjust padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set new Water Level",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: themeColors.boxHeadingColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: AbsorbPointer(
                    absorbing: !isWaterLevelManual,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: fiveWidth * 6),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Not a number!';
                            } else if (double.parse(value) > 100 || double.parse(value) < 1){
                              return 'Please enter value between 1 and 100';
                            }
                          }
                          return null;
                        },
                        controller: _waterLevelController,
                        decoration: InputDecoration(
                          hintText: _waterLevelPreviousValue.toString(),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isWaterLevelManual
                                      ? themeColors.borderColor
                                      : Colors.red,
                                  width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isWaterLevelManual
                                      ? themeColors.borderColor
                                      : Colors.red,
                                  width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isWaterLevelManual
                                      ? themeColors.borderColor
                                      : Colors.red,
                                  width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isWaterLevelManual
                                      ? themeColors.borderColor
                                      : Colors.red,
                                  width: 1)),
                          filled: true,
                          fillColor: isWaterLevelManual
                              ? Colors.transparent
                              : Colors.grey,
                          labelText: isWaterLevelManual
                              ? null
                              : "Unavailable in Auto Mode",
                          labelStyle: TextStyle(
                              color: isWaterLevelManual
                                  ? themeColors.boxHeadingColor
                                  : Colors.white,
                              fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0), // Adjust padding
                        ),
                        style: const TextStyle(fontSize: 14),
                        // Adjust font size for the text
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AbsorbPointer(
                absorbing: !isWaterLevelManual,
                child: SizedBox(
                  height: 45,
                  width: fiveWidth * 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_waterLevelController.text.isNotEmpty) {
                          if (RegExp(r'^[0-9]+$')
                              .hasMatch(_waterLevelController.text)) {
                            ref.read(controlPanelInfoProvider.notifier).updateWaterLevel(double.parse(_waterLevelController.text));
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWaterLevelManual
                          ? themeColors.borderColor
                          : Colors.grey, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0), // Button corners
                      ),
                      textStyle: const TextStyle(fontSize: 14), // Text size
                    ),
                    child: Text(
                      'Set New Value',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ), // Change button text
                  ),
                ),
              ),
                IconButton(
                  onPressed: (){
                  showWaterLevelToggleDialog(context);
                },
                  icon: const Icon(Icons.settings),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget waterLevelControllerTablet() {
    return Tooltip(
      message: isWaterLevelManual
          ? ""
          : "The water level is currently set to auto mode, and the tank will be filled to 100%.\nTo make any adjustments, please switch to manual mode.",
      textAlign: TextAlign.center,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 20.0, horizontal: 20.0), // Adjust padding
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Set new Water Level",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                AbsorbPointer(
                  absorbing: !isWaterLevelManual,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0), // Adjust padding
                        decoration: BoxDecoration(
                            color: isWaterLevelManual
                                ? Colors.transparent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  isWaterLevelManual ? themeColors.borderColor : Colors.red,
                            )),
                        child: Text(
                          _waterLevelPreviousValue.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isWaterLevelManual
                                ? themeColors.boxHeadingColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 220, // Set the width of the text field
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Not a number!';
                              }
                            }
                            return null;
                          },
                          controller: _waterLevelController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: isWaterLevelManual
                                        ? themeColors.borderColor
                                        : Colors.red,
                                    width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: isWaterLevelManual
                                        ? themeColors.borderColor
                                        : Colors.red,
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: isWaterLevelManual
                                        ? themeColors.borderColor
                                        : Colors.red,
                                    width: 1)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: isWaterLevelManual
                                        ? themeColors.borderColor
                                        : Colors.red,
                                    width: 1)),
                            filled: true,
                            fillColor: isWaterLevelManual
                                ? Colors.transparent
                                : Colors.grey,
                            labelText: isWaterLevelManual
                                ? 'New Value Here'
                                : "Unavailable in Auto Mode",
                            labelStyle: TextStyle(
                                color: isWaterLevelManual
                                    ? themeColors.boxHeadingColor
                                    : Colors.white,
                                fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0), // Adjust padding
                          ),
                          style: const TextStyle(
                              fontSize: 14), // Adjust font size for the text
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AbsorbPointer(
                  absorbing: !isWaterLevelManual,
                  child: SizedBox(
                    height: 45,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_waterLevelController.text.isNotEmpty) {
                            if (RegExp(r'^[0-9]+$')
                                .hasMatch(_waterLevelController.text)) {
                              ref.read(controlPanelInfoProvider.notifier).updateWaterLevel(double.parse(_waterLevelController.text));
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isWaterLevelManual
                            ? themeColors.borderColor
                            : Colors.grey, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Button corners
                        ),
                        textStyle: const TextStyle(fontSize: 14), // Text size
                      ),
                      child: Text(
                        'Set New Value',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: isWaterLevelManual
                                ? themeColors.boxHeadingColor
                                : Colors.white,
                          ),
                        ),
                      ), // Change button text
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Auto',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: themeColors.boxHeadingColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Switch(
                      value: isWaterLevelManual,
                      onChanged: (value) {
                        ref.read(controlPanelInfoProvider.notifier).toggleWaterLevelManual();
                      },
                      activeColor: themeColors.borderColor, // Color when the switch is ON
                      inactiveThumbColor:
                          Colors.black, // Color of the thumb when OFF
                      inactiveTrackColor:
                          Colors.grey, // Color of the track when OFF
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Manual',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: themeColors.boxHeadingColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget waterLevelControllerMobile() {
    return Tooltip(
      message: isWaterLevelManual
          ? ""
          : "The water level is currently set to auto mode, and the tank will be filled to 100%.\nTo make any adjustments, please switch to manual mode.",
      textAlign: TextAlign.center,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 20.0, horizontal: 10.0), // Adjust padding
        child: Column(
          children: [
            Text(
              "Set New Water Level",
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            AbsorbPointer(
              absorbing: !isWaterLevelManual,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 12.0), // Adjust padding
                    decoration: BoxDecoration(
                        color: isWaterLevelManual
                            ? Colors.transparent
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isWaterLevelManual ? themeColors.borderColor : Colors.red,
                        )),
                    child: Text(
                      _waterLevelPreviousValue.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isWaterLevelManual
                            ? themeColors.boxHeadingColor
                            : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 150, // Set the width of the text field
                    child: TextFormField(
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Not a number!';
                          }
                        }
                        return null;
                      },
                      controller: _waterLevelController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isWaterLevelManual
                                    ? themeColors.borderColor
                                    : Colors.red,
                                width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isWaterLevelManual
                                    ? themeColors.borderColor
                                    : Colors.red,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isWaterLevelManual
                                    ? themeColors.borderColor
                                    : Colors.red,
                                width: 1)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isWaterLevelManual
                                    ? themeColors.borderColor
                                    : Colors.red,
                                width: 1)),
                        filled: true,
                        fillColor: isWaterLevelManual
                            ? Colors.transparent
                            : Colors.grey,
                        labelText: isWaterLevelManual
                            ? 'New Value Here'
                            : "Unavailable",
                        labelStyle: TextStyle(
                            color: isWaterLevelManual
                                ? themeColors.boxHeadingColor
                                : Colors.white,
                            fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0), // Adjust padding
                      ),
                      style: const TextStyle(
                          fontSize: 14), // Adjust font size for the text
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            AbsorbPointer(
              absorbing: !isWaterLevelManual,
              child: SizedBox(
                height: 45,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_waterLevelController.text.isNotEmpty) {
                        if (RegExp(r'^[0-9]+$')
                            .hasMatch(_waterLevelController.text)) {
                          ref.read(controlPanelInfoProvider.notifier).updateWaterLevel(double.parse(_waterLevelController.text));
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWaterLevelManual
                        ? themeColors.borderColor
                        : Colors.grey, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Button corners
                    ),
                    textStyle: const TextStyle(fontSize: 14), // Text size
                  ),
                  child: Text(
                    'Set New Value',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 12,
                        color:
                            isWaterLevelManual ? themeColors.boxHeadingColor : Colors.white,
                      ),
                    ),
                  ), // Change button text
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Auto',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: themeColors.boxHeadingColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Switch(
                  value: isWaterLevelManual,
                  onChanged: (value) {
                    ref.read(controlPanelInfoProvider.notifier).toggleWaterLevelManual();
                  },
                  activeColor: themeColors.borderColor, // Color when the switch is ON
                  inactiveThumbColor:
                      Colors.black, // Color of the thumb when OFF
                  inactiveTrackColor:
                      Colors.grey, // Color of the track when OFF
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Manual',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: themeColors.boxHeadingColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
