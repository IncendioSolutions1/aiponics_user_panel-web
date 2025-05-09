import 'dart:developer' as dev;
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/provider/farm%20and%20devices%20provider/add_device_provider.dart';
import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/farm and device controller/device_controller.dart';

class AddDevice extends ConsumerStatefulWidget {
  const AddDevice({super.key});

  @override
  ConsumerState<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends ConsumerState<AddDevice> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Color boxColor;
  late Color borderColor;
  late Color imageBorderColor;
  late Color boxHeadingColor;
  late Color buttonColor;
  late Color dividerColor;

  String screenResponsiveness = "tablet";
  double fiveWidth = 0.0;
  double fiveHeight = 0.0;
  double width = 0.0;
  late BuildContext contexts;

  late ThemeColors themeColors;

  final double _spaceBetweenTwoFields = 20;
  final double _spaceBetweenLabelAndTextField = 15;
  final double _spaceBetweenTwoTextFieldsRows = 30;

  // Labels for making scalable
  String deviceAcquisitionLabel = "Device Acquisition Method";
  String farmNameLabel = "Select Farm";
  String deviceNameLabel = "Device Name";
  String noOfFansLabel = "No Of Fans";
  String noOfPumpsLabel = "No Of Water Pumps";
  String noOfHumiditySensorsLabel = "No Of Humidity Sensors";
  String noOfCoolingPumpsLabel = "No Of Cooling Pumps";
  String noOfLightsLabel = "No Of Lights";
  String sizeOfWaterTankLabel = "Size Of Water Tank in ( liters )";
  String deviceEmeiNumberLabel = "Device Identification Number (DIN)";
  String deviceTypeLabel = "Device Type";
  String airParametersLabel = "Air Parameters";
  String soilParametersLabel = "Soil Parameters";

  final String climateControlSystem = 'Monitoring';
  final String dosingSystem = 'Dosing';
  final String conventionalSystem = 'Conventional';

  final String farmType = "Open Farms";
  final String openFarm = "Open Farm";
  final String itemToDisable = 'Monitoring';

  final TextEditingController _deviceName = TextEditingController();
  final TextEditingController _farm = TextEditingController();
  final TextEditingController _noOfFans = TextEditingController();
  final TextEditingController _noOfPumps = TextEditingController();
  final TextEditingController _noOfLights = TextEditingController();
  final TextEditingController _noOfCoolingPumps = TextEditingController();
  final TextEditingController _noOfHumiditySensors = TextEditingController();
  final TextEditingController _waterTankSize = TextEditingController();
  final TextEditingController _deviceEmei = TextEditingController();
  final TextEditingController _deviceType = TextEditingController();

  late List<String> _airParametersTypesList = [];
  late List<IconData> _airParametersIconsList = [];
  Map<String, bool> _airCheckboxValues = {};
  late List<String> _soilParametersTypesList = [];
  late List<IconData> _soilParametersIconsList = [];
  Map<String, bool> _soilCheckboxValues = {};
  late List<String> _devicesTypesList = [];
  late Map<int, String> _farmTypesList = {};

  late bool _acquiredThroughUs;
  late bool _userOwnDevice;

  bool isSaving = false;

  late AddDeviceNotifier addDeviceNotifier;

  void _saveData() async {
    if (_formKey.currentState!.validate() && (_acquiredThroughUs || _userOwnDevice)) {
      setState(() {
        isSaving = true;
      });
      if (ref.watch(addDeviceProvider).acquiredThroughUs) {
        ref.read(addDeviceProvider.notifier).updateDeviceModel(imeiOrApiKey: _deviceEmei.text);
      }

      ref.read(addDeviceProvider.notifier).updateDeviceModel(name: _deviceName.text);

      if (ref.watch(addDeviceProvider).deviceModel.deviceType == dosingSystem) {
        ref
            .read(addDeviceProvider.notifier)
            .updateDeviceModel(waterTankSize: int.tryParse(_waterTankSize.text));
      } else if (ref.watch(addDeviceProvider).deviceModel.deviceType == climateControlSystem) {
        ref
            .read(addDeviceProvider.notifier)
            .updateDeviceModel(numFans: int.tryParse(_noOfFans.text));
        ref
            .read(addDeviceProvider.notifier)
            .updateDeviceModel(numLights: int.tryParse(_noOfLights.text));
        ref
            .read(addDeviceProvider.notifier)
            .updateDeviceModel(numWaterSupplyPumps: int.tryParse(_noOfPumps.text));
        ref
            .read(addDeviceProvider.notifier)
            .updateDeviceModel(numHumiditySensors: int.tryParse(_noOfHumiditySensors.text));
        ref
            .read(addDeviceProvider.notifier)
            .updateDeviceModel(numCoolingPumps: int.tryParse(_noOfCoolingPumps.text));
      }

      if(ref.watch(addDeviceProvider).isEditing){
        bool status = await DeviceService.updateDeviceToServer(
            ref, dosingSystem, climateControlSystem, conventionalSystem);
      }else{
        bool status = await DeviceService.addDeviceToServer(
            ref, dosingSystem, climateControlSystem, conventionalSystem);
      }

      setState(() {
        isSaving = false;
      });
    } else {
      // Validation failed, fields will be highlighted
      dev.log("Validation failed");
    }

    dev.log("Exiting _saveData");
  }

  @override
  void initState() {
    addDeviceNotifier = ref.read(addDeviceProvider.notifier);
    _airParametersTypesList = ref.read(addDeviceProvider).airParametersTypesList;
    _airParametersIconsList = ref.read(addDeviceProvider).airParametersIconsList;
    _soilParametersTypesList = ref.read(addDeviceProvider).soilParametersTypesList;
    _soilParametersIconsList = ref.read(addDeviceProvider).soilParametersIconsList;
    _devicesTypesList = ref.read(addDeviceProvider).devicesTypesList;


    super.initState();
  }

  @override
  void dispose() {
    // Delay provider modification until after the widget tree builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addDeviceProvider.notifier).resetAddDeviceProvider();
    });
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeColors = ThemeColors(context);

    boxColor = themeColors.boxColor;
    borderColor = themeColors.borderColor;
    imageBorderColor = themeColors.imageBorderColor;
    boxHeadingColor = themeColors.boxHeadingColor;
    buttonColor = themeColors.buttonColor;
    dividerColor = themeColors.dividerColor;

    final displayNotifier = ref.watch(dashboardScreenInfoProvider);

    screenResponsiveness = displayNotifier['screenResponsiveness'];
    fiveWidth = displayNotifier['fiveWidth'];
    fiveHeight = displayNotifier['fiveHeight'];
    width = displayNotifier['screenFullWidth'];
    contexts = context;

    super.didChangeDependencies();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final displayNotifier = ref.watch(dashboardScreenInfoProvider);

    screenResponsiveness = displayNotifier['screenResponsiveness'];
    fiveWidth = displayNotifier['fiveWidth'];
    fiveHeight = displayNotifier['fiveHeight'];
    width = displayNotifier['screenFullWidth'];
    contexts = context;

      if (ref.read(addDeviceProvider).isEditing) {
        dev.log("inside if");
        _deviceName.text = ref.watch(addDeviceProvider).deviceModel.name;
        _deviceType.text = capitalizeFirstLetter(ref.watch(addDeviceProvider).deviceModel.deviceType);
        _deviceEmei.text = ref.watch(addDeviceProvider).deviceModel.imeiOrApiKey;
        _farm.text = ref.watch(addDeviceProvider).farmTypesList[ref.watch(addDeviceProvider).deviceModel.farm] ?? "";

        if (ref.watch(addDeviceProvider).deviceModel.imeiOrApiKey.isNotEmpty) {
          _acquiredThroughUs = true;
          _userOwnDevice = false;
        } else {
          _acquiredThroughUs = false;
          _userOwnDevice = true;
        }

        if(capitalizeFirstLetter(ref.watch(addDeviceProvider).deviceModel.deviceType) == conventionalSystem){
          _airCheckboxValues = ref.watch(addDeviceProvider).airCheckboxValues;
          _soilCheckboxValues = ref.watch(addDeviceProvider).soilCheckboxValues;
        }else{
        _noOfFans.text = ref.watch(addDeviceProvider).deviceModel.numFans.toString();
        _noOfPumps.text = ref.watch(addDeviceProvider).deviceModel.numWaterSupplyPumps.toString();
        _noOfHumiditySensors.text = ref.watch(addDeviceProvider).deviceModel.numHumiditySensors.toString();
        _noOfCoolingPumps.text = ref.watch(addDeviceProvider).deviceModel.numCoolingPumps.toString();
        _noOfLights.text = ref.watch(addDeviceProvider).deviceModel.numLights.toString();
        _waterTankSize.text = ref.watch(addDeviceProvider).deviceModel.waterTankSize.toString();
        }

      } else {
        _acquiredThroughUs = ref.watch(addDeviceProvider).acquiredThroughUs;
        _userOwnDevice = ref.watch(addDeviceProvider).userOwnDevice;
        _airCheckboxValues = ref.watch(addDeviceProvider).airCheckboxValues;
        _soilCheckboxValues = ref.watch(addDeviceProvider).soilCheckboxValues;
      }



    _farmTypesList = ref.watch(addDeviceProvider).farmTypesList;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: screenResponsiveness == 'desktop'
              ? Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40, right: 50, left: 50),
                  child: desktopDashboard(),
                )
              : screenResponsiveness == 'tablet'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 40, right: 50, left: 50),
                      child: tabletDashboard(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 40, right: 50, left: 50),
                      child: mobileDashboard(),
                    ),
        ),
      ),
    );
  }

  Widget desktopDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Add a Device"),
        Container(
          width: double.infinity, // Ensures it takes up available width
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              welcomeHeader(30),

              const SizedBox(
                height: 50,
              ),

              // Device Acquisition Method and Farm Number selection
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device Acquisition Method
                  Flexible(
                    flex: 1,
                    child: deviceGettingInformationCheckBoxes(),
                  ),
                  // Horizontal Space Between 2 input fields
                  SizedBox(
                    width: _spaceBetweenTwoFields,
                  ),
                  // Farm Type
                  Flexible(
                    flex: 1,
                    child: selectFarmDropDown(),
                  ),
                ],
              ),

              SizedBox(
                height: _spaceBetweenTwoTextFieldsRows,
              ),

              // If device is acquired by us then show Emei text field
              if (_acquiredThroughUs &&
                  _farm.text != "Select Farm here" &&
                  _farm.text.isNotEmpty) ...[
                // Device Emei and Device Type Fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Emei number
                    Flexible(
                      flex: 1,
                      child: deviceEmeiTextField(),
                    ),
                    // Width Spacer
                    SizedBox(
                      width: _spaceBetweenTwoFields,
                    ),
                    // Device name
                    Flexible(
                      flex: 1,
                      child: deviceNameTextField(),
                    ),
                  ],
                ),

                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device type
                    Flexible(
                      flex: 1,
                      child: selectDeviceTypesDropDown(),
                    ),

                    if (_deviceType.text == dosingSystem) ...[
                      // Width Spacer
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // Water Tank Size
                      Flexible(flex: 1, child: waterTankSizeTextField()),
                    ],

                    if (_deviceType.text == climateControlSystem) ...[
                      // Width Spacer
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // no of fans
                      Flexible(flex: 1, child: noOfFansTextField()),
                    ],
                  ],
                ),

                if (_deviceType.text == climateControlSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // no of lights
                      Flexible(flex: 1, child: noOfLightsTextField()),
                      // Width Spacer
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // no of water pumps
                      Flexible(flex: 1, child: noOfWaterPumpsTextField()),
                    ],
                  ),
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // no of misting pumps
                      Flexible(flex: 1, child: noOfHumiditySensorsTextField()),
                      // Width Spacer
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // no of cooling pumps
                      Flexible(flex: 1, child: noOfCoolingPumpsTextField()),
                    ],
                  ),
                ],

                if (_deviceType.text == conventionalSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  selectSoilAndAirParameterTypeGrid(),
                ],
              ],

              // If device is users own device then don't show Emei text field
              if (_userOwnDevice && _farm.text != "Select Farm here" && _farm.text.isNotEmpty) ...[
                // Device Name and Device Type Fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device name
                    Flexible(
                      flex: 1,
                      child: deviceNameTextField(),
                    ),
                    // Width Spacer
                    SizedBox(
                      width: _spaceBetweenTwoFields,
                    ),
                    // Device type
                    Flexible(
                      flex: 1,
                      child: selectDeviceTypesDropDown(),
                    ),
                  ],
                ),

                if (_deviceType.text == dosingSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  // Water Tank Size
                  waterTankSizeTextField(),
                ],

                if (_deviceType.text == climateControlSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // no of lights
                      Flexible(flex: 1, child: noOfLightsTextField()),
                      // Width Spacer
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // no of water pumps
                      Flexible(flex: 1, child: noOfWaterPumpsTextField()),
                    ],
                  ),
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // no of misting pumps
                      Flexible(flex: 1, child: noOfHumiditySensorsTextField()),
                      // Width Spacer
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // no of cooling pumps
                      Flexible(flex: 1, child: noOfCoolingPumpsTextField()),
                    ],
                  ),
                  // height Spacer
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  // no of fans
                  noOfFansTextField(),
                ],

                if (_deviceType.text == conventionalSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  selectSoilAndAirParameterTypeGrid(),
                ],
              ],

              SizedBox(
                height: _spaceBetweenTwoTextFieldsRows,
              ),
              Center(
                child: saveDataButton("mobile"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tabletDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Add a Device"),
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              welcomeHeader(25),
              const SizedBox(
                height: 50,
              ),
              // Device Acquisition Method and Device name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device Acquisition Method
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textFieldsLabelsRequired(deviceAcquisitionLabel, 17),
                        SizedBox(
                          height: _spaceBetweenLabelAndTextField,
                        ),
                        deviceGettingInformationCheckBoxes(),
                      ],
                    ),
                  ),
                  // Horizontal Space Between 2 input fields
                  SizedBox(
                    width: _spaceBetweenTwoFields,
                  ),
                  // Device name
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textFieldsLabelsRequired(deviceNameLabel, 17),
                        SizedBox(
                          height: _spaceBetweenLabelAndTextField,
                        ),
                        deviceNameTextField(),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: _spaceBetweenTwoTextFieldsRows,
              ),

              // If device is acquired by us then show Emei text field
              // and device type in single row
              if (_acquiredThroughUs) ...[
                // Device Emei and Device Type Fields
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Emei number
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabelsRequired(deviceEmeiNumberLabel, 17),
                          SizedBox(
                            height: _spaceBetweenLabelAndTextField,
                          ),
                          deviceEmeiTextField(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: _spaceBetweenTwoFields,
                    ),
                    // Device type
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabelsRequired(deviceTypeLabel, 17),
                          SizedBox(
                            height: _spaceBetweenLabelAndTextField,
                          ),
                          selectDeviceTypesDropDown(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              if (_userOwnDevice) ...[
                // Device Emei, Device Type and Device parameter
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if device is personal then only show device type and
                    // device parameter only if device type is conventional
                    // Device Type Selector  ( This will always be shown )
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabelsRequired(deviceTypeLabel, 17),
                          SizedBox(
                            height: _spaceBetweenLabelAndTextField,
                          ),
                          selectDeviceTypesDropDown(),
                        ],
                      ),
                    ),

                    // If device type is conventional only then show
                    // device parameter type dropdown field. ( only of the
                    // condition will be true at each time ).
                    if (_deviceType.text == dosingSystem) ...[
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // Water tank size in liters
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabelsRequired(sizeOfWaterTankLabel, 17),
                            SizedBox(
                              height: _spaceBetweenLabelAndTextField,
                            ),
                            waterTankSizeTextField(),
                          ],
                        ),
                      ),
                    ] else if (_deviceType.text == climateControlSystem) ...[
                      SizedBox(
                        width: _spaceBetweenTwoFields,
                      ),
                      // No of fans
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabelsRequired(noOfFansLabel, 17),
                            SizedBox(
                              height: _spaceBetweenLabelAndTextField,
                            ),
                            noOfFansTextField(),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),

                if (_deviceType.text == conventionalSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  // Parameter Selector ( Different Sensors DropDown )
                  selectSoilAndAirParameterTypeGrid(),
                ]
              ],

              if (_deviceType.text == climateControlSystem && _acquiredThroughUs == false) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // No of pumps
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabelsRequired(noOfPumpsLabel, 17),
                          SizedBox(
                            height: _spaceBetweenLabelAndTextField,
                          ),
                          noOfWaterPumpsTextField(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: _spaceBetweenTwoFields,
                    ),
                    // No of misting pumps
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabelsRequired(noOfHumiditySensorsLabel, 17),
                          SizedBox(
                            height: _spaceBetweenLabelAndTextField,
                          ),
                          noOfHumiditySensorsTextField(),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else if (_deviceType.text == climateControlSystem &&
                  _acquiredThroughUs == true) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // No of fans
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabelsRequired(noOfFansLabel, 17),
                          SizedBox(
                            height: _spaceBetweenLabelAndTextField,
                          ),
                          noOfFansTextField(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: _spaceBetweenTwoFields,
                    ),
                    // No of pumps
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabelsRequired(noOfPumpsLabel, 17),
                          SizedBox(
                            height: _spaceBetweenLabelAndTextField,
                          ),
                          noOfWaterPumpsTextField(),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),

                // No of misting pumps
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(noOfHumiditySensorsLabel, 17),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    noOfHumiditySensorsTextField(),
                  ],
                ),
              ] else if (_deviceType.text == dosingSystem && _acquiredThroughUs == true) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),

                // Water tank size in liters
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(sizeOfWaterTankLabel, 17),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    waterTankSizeTextField(),
                  ],
                ),
              ] else if (_deviceType.text == conventionalSystem && _acquiredThroughUs == true) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),
                selectSoilAndAirParameterTypeGrid(),
              ],

              SizedBox(
                height: _spaceBetweenTwoTextFieldsRows,
              ),
              Center(
                child: saveDataButton("tablet"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Add a Device"),
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              welcomeHeader(25),
              const SizedBox(
                height: 50,
              ),
              // Device Acquisition Method and Device name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textFieldsLabelsRequired(deviceAcquisitionLabel, 14),
                  SizedBox(
                    height: _spaceBetweenLabelAndTextField,
                  ),
                  deviceGettingInformationCheckBoxes(),
                ],
              ),
              // Vertical Space Between 2 input fields
              SizedBox(
                height: _spaceBetweenTwoTextFieldsRows,
              ),
              // Device name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textFieldsLabelsRequired(deviceNameLabel, 14),
                  SizedBox(
                    height: _spaceBetweenLabelAndTextField,
                  ),
                  deviceNameTextField(),
                ],
              ),

              SizedBox(
                height: _spaceBetweenTwoTextFieldsRows,
              ),

              // If device is acquired by us then show Emei text field
              // and device type in single row
              if (_acquiredThroughUs) ...[
                // Device Emei and Device Type Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(deviceEmeiNumberLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    deviceEmeiTextField(),
                  ],
                ),
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),
                // Device type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(deviceTypeLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    selectDeviceTypesDropDown(),
                  ],
                ),
              ],

              if (_userOwnDevice) ...[
                // Device Emei, Device Type and Device parameter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(deviceTypeLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    selectDeviceTypesDropDown(),
                  ],
                ),

                // If device type is conventional only then show
                // device parameter type dropdown field. ( only of the
                // condition will be true at each time ).
                if (_deviceType.text == conventionalSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  // Parameter Selector ( Different Sensors DropDown )
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: _spaceBetweenTwoTextFieldsRows,
                      ),
                      selectSoilAndAirParameterTypeGrid(),
                    ],
                  ),
                ] else if (_deviceType.text == dosingSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  // Water tank size in liters
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldsLabelsRequired(sizeOfWaterTankLabel, 14),
                      SizedBox(
                        height: _spaceBetweenLabelAndTextField,
                      ),
                      waterTankSizeTextField(),
                    ],
                  ),
                ] else if (_deviceType.text == climateControlSystem) ...[
                  SizedBox(
                    height: _spaceBetweenTwoTextFieldsRows,
                  ),
                  // No of fans
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldsLabelsRequired(noOfFansLabel, 14),
                      SizedBox(
                        height: _spaceBetweenLabelAndTextField,
                      ),
                      noOfFansTextField(),
                    ],
                  ),
                ],
              ],

              if (_deviceType.text == climateControlSystem && _acquiredThroughUs == false) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(noOfPumpsLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    noOfWaterPumpsTextField(),
                  ],
                ),
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),
                // No of misting pumps
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(noOfHumiditySensorsLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    noOfHumiditySensorsTextField(),
                  ],
                ),
              ] else if (_deviceType.text == climateControlSystem &&
                  _acquiredThroughUs == true) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(noOfFansLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    noOfFansTextField(),
                  ],
                ),
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),
                // No of pumps
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(noOfPumpsLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    noOfWaterPumpsTextField(),
                  ],
                ),

                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),

                // No of misting pumps
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(noOfHumiditySensorsLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    noOfHumiditySensorsTextField(),
                  ],
                ),
              ] else if (_deviceType.text == dosingSystem && _acquiredThroughUs == true) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),

                // Water tank size in liters
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabelsRequired(sizeOfWaterTankLabel, 14),
                    SizedBox(
                      height: _spaceBetweenLabelAndTextField,
                    ),
                    waterTankSizeTextField(),
                  ],
                ),
              ] else if (_deviceType.text == conventionalSystem && _acquiredThroughUs == true) ...[
                SizedBox(
                  height: _spaceBetweenTwoTextFieldsRows,
                ),
                selectSoilAndAirParameterTypeGrid(),
              ],

              SizedBox(
                height: _spaceBetweenTwoTextFieldsRows,
              ),
              Center(
                child: saveDataButton("mobile"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget welcomeHeader(double mainFontSize) {
    return Text(
      "Add Device",
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: mainFontSize,
          color: boxHeadingColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget textFieldsLabels(String label, double fontSize) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: fontSize,
              color: boxHeadingColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Tooltip(
          message: 'Optional field', // Message shown when hovering
          child: Icon(
            Icons.error_outline,
            color: Colors.blue,
            size: 16, // Adjust the size as needed
          ),
        )
      ],
    );
  }

  Widget textFieldsLabelsRequired(String label, double fontSize) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: fontSize,
              color: boxHeadingColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Tooltip(
          message: 'Required field', // Message shown when hovering
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 16, // Adjust the size as needed
          ),
        )
      ],
    );
  }

  Widget deviceGettingInformationCheckBoxes() {
    if (screenResponsiveness == "desktop") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          textFieldsLabelsRequired(deviceAcquisitionLabel, 18),
          SizedBox(
            height: _spaceBetweenLabelAndTextField,
          ),
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    activeColor: borderColor,
                    value: _acquiredThroughUs,
                    onChanged: (value) {
                      if (value != null) {
                        addDeviceNotifier.updateAcquiredThroughUs(value);
                      }
                      if (value == true) {
                        addDeviceNotifier.updateUserOwnDevice(false);
                      }
                    },
                  ),
                  Text(
                    'AiPonics Device',
                    style: TextStyle(fontSize: 16, color: boxHeadingColor),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Row(
                children: [
                  Checkbox(
                    activeColor: borderColor,
                    value: _userOwnDevice,
                    onChanged: (value) {
                      if (value != null) {
                        addDeviceNotifier.updateUserOwnDevice(value);
                      }
                      if (value == true) {
                        addDeviceNotifier.updateAcquiredThroughUs(false);
                      }
                    },
                  ),
                  Text(
                    "User's Device",
                    style: TextStyle(fontSize: 16, color: boxHeadingColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: borderColor,
                value: _acquiredThroughUs,
                onChanged: (value) {
                  if (value != null) {
                    addDeviceNotifier.updateAcquiredThroughUs(value);
                  }
                  if (value == true) {
                    addDeviceNotifier.updateUserOwnDevice(false);
                  }
                },
              ),
              Text(
                'AiPonics Device',
                style: TextStyle(fontSize: 16, color: boxHeadingColor),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Row(
            children: [
              Checkbox(
                activeColor: borderColor,
                value: _userOwnDevice,
                onChanged: (value) {
                  if (value != null) {
                    addDeviceNotifier.updateUserOwnDevice(value);
                  }
                  if (value == true) {
                    addDeviceNotifier.updateAcquiredThroughUs(false);
                  }
                },
              ),
              Text(
                "User's Device",
                style: TextStyle(fontSize: 16, color: boxHeadingColor),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget selectFarmDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(farmNameLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        ref.watch(addDeviceProvider).areFarmsLoading
            ? const Center(
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    )))
            : ref.watch(addDeviceProvider).farmTypesList.isEmpty
                ? const Text("No farms found. Add farms 1st to add device.")
                : DropdownSearch<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Select Farm from dropdown";
                      } else if (value == "Select Farm here" || value == "") {
                        return "Please Select Farm from dropdown";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        int farmId = _farmTypesList.keys
                            .firstWhere((key) => _farmTypesList[key] == newValue);
                        addDeviceNotifier.updateDeviceModel(farm: farmId);
                        _farm.text = newValue;
                      }
                    },
                    items: (filter, infiniteScrollProps) => _farmTypesList.values.toList(),
                    selectedItem: _farm.text.isNotEmpty ? _farm.text : "Select Farm here",
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: boxColor,
                        labelText: "Select Farm here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0), // Adjust padding to match TextField
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
      ],
    );
  }

  Widget deviceNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(deviceNameLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _deviceName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter Device Name";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "Device name here",
            hintText: "Enter Device name here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(Icons.device_hub), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget deviceEmeiTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(deviceEmeiNumberLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _deviceEmei,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter Device Emei";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "Device Emei",
            hintText: "Enter Device Emei here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(Icons.numbers), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget selectDeviceTypesDropDown() {
    bool isControlSystemDisable = farmType == openFarm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(deviceTypeLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        DropdownSearch<String>(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please Select Device Type from dropdown";
            } else if (value == "Select Device Type here" || value == "") {
              return "Please Select Device Type from dropdown";
            } else {
              return null;
            }
          },
          onChanged: (String? newValue) {
            if (newValue != null) {
              addDeviceNotifier.updateDeviceModel(deviceType: newValue);
              _deviceType.text = newValue;
            }
          },
          items: (filter, infiniteScrollProps) => _devicesTypesList,
          selectedItem: _deviceType.text.isNotEmpty ? _deviceType.text : "Select Device Type here",
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              filled: true,
              fillColor: boxColor,
              labelText: "Select Device Type",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 10.0), // Adjust padding to match TextField
            ),
          ),
          popupProps: PopupProps.menu(
            fit: FlexFit.loose,
            disabledItemFn: (String item) {
              if (isControlSystemDisable && item == itemToDisable) {
                return true;
              } else {
                return false;
              }
            },
            constraints: const BoxConstraints(maxHeight: 300),
            menuProps: const MenuProps(
              backgroundColor: Colors.white,
              elevation: 8,
            ),
            itemBuilder: (context, item, isSelected, boolAgain) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  isSelected ? "$item System ( Not available for Open Farm )" : item + " System",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget noOfFansTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(noOfFansLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _noOfFans,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter only numbers';
              }
            }
            return null; // No validation error for empty field
          },
          decoration: InputDecoration(
            labelText: "No of Fans here",
            hintText: "Enter No of Fans here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(CupertinoIcons.wind), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget noOfWaterPumpsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(noOfPumpsLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _noOfPumps,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter only numbers';
              }
            }
            return null; // No validation error for empty field
          },
          decoration: InputDecoration(
            labelText: "No of Pumps here",
            hintText: "Enter No of Pumps here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(CupertinoIcons.drop), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget noOfHumiditySensorsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(noOfHumiditySensorsLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _noOfHumiditySensors,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter only numbers';
              }
            }
            return null; // No validation error for empty field
          },
          decoration: InputDecoration(
            labelText: "No of Humidity Sensors here",
            hintText: "Enter No of Humidity Sensors here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(CupertinoIcons.cloud_drizzle), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget noOfLightsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(noOfLightsLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _noOfLights,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter No of Lights";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "No Of Lights",
            hintText: "Enter No Of Lights here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(Icons.light), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget noOfCoolingPumpsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(noOfCoolingPumpsLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _noOfCoolingPumps,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter No of Cooling Pumps";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "No of Cooling Pumps",
            hintText: "Enter No of Cooling Pumps here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(Icons.numbers), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget waterTankSizeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textFieldsLabelsRequired(sizeOfWaterTankLabel, 18),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        TextFormField(
          controller: _waterTankSize,
          validator: (value) {
            if (_deviceType.text == dosingSystem) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                  return 'Please enter a valid number';
                }
              } else {
                return 'Please enter a Water Tank Size';
              }
            }

            return null; // No validation error for empty field
          },
          decoration: InputDecoration(
            labelText: "Size of Water Tank here ( liters )",
            hintText: "Enter Size of Water Tank here",
            labelStyle: GoogleFonts.poppins(
              // Applying Google Font for label
              textStyle: TextStyle(
                color: boxHeadingColor, // Customize color
                fontSize: 14,
                fontWeight: FontWeight.w400, // Customize weight
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red, // Customize color
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: borderColor, // Customize color
              ),
            ),
            prefixIcon: const Icon(Icons.local_drink), // Customize icon
            filled: true,
            fillColor: boxColor, // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
          ),
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget selectSoilAndAirParameterTypeGrid() {
    return Column(
      children: [
        textFieldsLabelsRequired(airParametersLabel, 17),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        GridView.builder(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenResponsiveness == "desktop"
                ? 4
                : screenResponsiveness == "tablet"
                    ? 2
                    : 1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: screenResponsiveness == "desktop"
                ? 3 / 0.8
                : screenResponsiveness == "tablet"
                    ? 3 / 0.7
                    : 3 / 1,
          ),
          itemCount: _airParametersTypesList.length,
          itemBuilder: (context, index) {
            String parameter = _airParametersTypesList[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10, right: 20),
                    child: Icon(_airParametersIconsList[index], color: borderColor, size: 20),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        parameter,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: screenResponsiveness == "desktop"
                                ? 14
                                : screenResponsiveness == "tablet"
                                    ? 13
                                    : 11,
                            color: boxHeadingColor,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Checkbox(
                      activeColor: borderColor,
                      value: _airCheckboxValues[parameter],
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          addDeviceNotifier.updateAirCheckboxValues(
                              parameter: parameter, newValue: newValue);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: _spaceBetweenTwoTextFieldsRows,
        ),
        textFieldsLabelsRequired(soilParametersLabel, 17),
        SizedBox(
          height: _spaceBetweenLabelAndTextField,
        ),
        GridView.builder(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenResponsiveness == "desktop"
                ? 4
                : screenResponsiveness == "tablet"
                    ? 2
                    : 1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: screenResponsiveness == "desktop"
                ? 3 / 0.8
                : screenResponsiveness == "tablet"
                    ? 3 / 0.7
                    : 3 / 0.9,
          ),
          itemCount: _soilParametersTypesList.length,
          itemBuilder: (context, index) {
            String parameter = _soilParametersTypesList[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10, right: 20),
                    child: Icon(_soilParametersIconsList[index], color: borderColor, size: 20),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        parameter,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: screenResponsiveness == "desktop"
                                ? 14
                                : screenResponsiveness == "tablet"
                                    ? 13
                                    : 11,
                            color: boxHeadingColor,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Checkbox(
                      activeColor: borderColor,
                      value: _soilCheckboxValues[parameter],
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          addDeviceNotifier.updateSoilCheckboxValues(
                              parameter: parameter, newValue: newValue);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget saveDataButton(String responsive) {
    return SizedBox(
      width: 150, // Set a specific width for the button
      height: 48,
      child: Tooltip(
        message: ((_acquiredThroughUs || _userOwnDevice) && ! ref.watch(addDeviceProvider).areFarmsLoading)
            ? "Click to add Device with above information."
            : "Complete all fields and then\nclick on this button to add a device.",
        textAlign: TextAlign.center,
        child: ElevatedButton(
          onPressed: ((_acquiredThroughUs || _userOwnDevice) && ! ref.watch(addDeviceProvider).areFarmsLoading)
              ? () {
                  _saveData(); // Call the save image method when the button is pressed
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                ((_acquiredThroughUs || _userOwnDevice) && ! ref.watch(addDeviceProvider).areFarmsLoading) ? buttonColor : Colors.grey, // Button color
            // padding: EdgeInsets.symmetric(
            //     horizontal: 20,
            //     vertical: responsive == "mobile" ? 15 : 20), // Adjust padding as needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
          ),
          child: isSaving ? const CircularProgressIndicator(color: Colors.white,) : const Center(
            child: Text(
              "Save Device", // Button text
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 14, // Text size
              ),
              textAlign: TextAlign.center, // Center align text
            ),
          ),
        ),
      ),
    );
  }
}
