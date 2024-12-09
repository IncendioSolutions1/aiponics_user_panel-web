import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/provider/farm%20and%20devices%20provider/add_farm_provider.dart';
import 'package:aiponics_web_app/provider/image%20controller%20provider/image_controller_provider.dart';
import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../provider/colors and theme provider/color_scheme_provider.dart';

class AddFarms extends ConsumerStatefulWidget {
  const AddFarms({super.key});

  @override
  ConsumerState<AddFarms> createState() => _AddFarmsState();
}

class _AddFarmsState extends ConsumerState<AddFarms> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Color boxColor;
  late Color borderColor;
  late Color imageBorderColor;
  late Color boxHeadingColor;
  late Color buttonColor;
  late Color dividerColor;

  late String screenResponsiveness;
  late double fiveWidth;
  late double fiveHeight;
  late double width;
  late BuildContext contexts;

  late ThemeColors themeColors;

  late bool imageSelectTextColorShow;
  late String imageSelectText;
  late List<String> cropChoices;
  late List<String> farmTypes;
  late List<String> operationalStatus;
  // Initially, no farm is selected
  late String selectedCropChoices;
  late String selectedFarmType;
  late String selectedOperationalStatusChoice;

  late TextEditingController _cropType;
  late TextEditingController _customCropType;
  late TextEditingController _farmTypes;
  late TextEditingController _farmName;
  late TextEditingController _location;
  late TextEditingController _farmArea;
  late TextEditingController _farmStatus;
  late TextEditingController _description;

  late bool showCustomCropTypeField;
  late String otherCropType;
  late bool isSqMeterSelected;
  late bool isSqFeetSelected;
  late bool isAcerSelected;
  late double _descriptionFieldHeight; // Initial height for text field

  final ScrollController _scrollController = ScrollController();

  double spaceBetweenLabelAndTextField = 15;
  double spaceBetweenTwoTextFields = 20;
  double spaceBetweenTwoTextFieldsRows = 30;

  late File? _image;
  late ImagePicker _picker;
  late Uint8List? _webImage;
  late Size? _imageSize;

  late final AddFarmNotifier addFarmNotifier;
  late final ImageControllerNotifier imageControllerNotifier;
  late dynamic addFarmProv;
  late dynamic imageControllerProv;

  Future<void> _pickImage() async {
    ImageControllerNotifier imageControllerNotifier = ref.read(imageControllerProvider.notifier);
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Load image as Uint8List for web
        final bytes = await pickedFile.readAsBytes();
        imageControllerNotifier.updateWebImage(bytes);
        _getImageSize(null, bytes);
      } else {
        // Save the selected image file for mobile
        imageControllerNotifier.updateImage(File(pickedFile.path));
        _getImageSize(File(pickedFile.path), null);
      }


    } else {
      debugPrint("No image selected"); // Changed to debugPrint for better logging
    }
  }

  void _getImageSize(File? mobileImage, Uint8List? webImage) {

    if (mobileImage != null) {
      final Image image = Image.file(mobileImage);
      final ImageStream stream =
          image.image.resolve(const ImageConfiguration());

      stream.addListener(ImageStreamListener((ImageInfo info, bool syncCall) {
        // Get the image dimensions
        final Size size =
            Size(info.image.width.toDouble(), info.image.height.toDouble());
        imageControllerNotifier.updateImageSize(size);
      }));
    } else if (webImage != null) {
      final Image image = Image.memory(webImage);
      final ImageStream stream =
          image.image.resolve(const ImageConfiguration());

      stream.addListener(ImageStreamListener((ImageInfo info, bool syncCall) {
        // Get the image dimensions
        final Size size =
            Size(info.image.width.toDouble(), info.image.height.toDouble());
        imageControllerNotifier.updateImageSize(size);
      }));
    }

  }

  _saveData() async {
    if (_formKey.currentState!.validate() &&
        (_image != null || _webImage != null)) {

      // final url2 = Uri.parse(
      //     "http://192.168.10.13:8000/api/users/create-farms and devices/");
      //
      // final registerResponse2 = await http.post(
      //   url2,
      //   headers: {
      //     "Content-Type": "application/json",
      //   },
      //   body: json.encode({
      //     'name': _farmName.text,
      //     'location': _location.text,
      //     'farm_area': _farmArea.text,
      //     'crops': _cropType.text,
      //     'description': _description.text,
      //     'operational_status': _farmStatus.text,
      //   }),
      // );
      //
      // if (registerResponse2.statusCode == 200) {
      //   dev.log("Response send to ADD FARM");
      //   dev.log("Api Reply  ${registerResponse2.body}");
      // } else {
      //   dev.log("Response error ${registerResponse2.statusCode}");
      //   dev.log("Response error ${registerResponse2.body}");
      // }

      dev.log("Farm name: ${_farmName.text}");
      dev.log("Farm Type: ${_farmTypes.text}");
      dev.log("Crop Type: ${_cropType.text}");
      dev.log("Location: ${_location.text}");
      dev.log("Farm Status: ${_farmStatus.text}");
      dev.log("Farm Area: ${_farmArea.text}");
      dev.log("Description: ${_description.text}");

      if(_cropType.text == otherCropType){
        dev.log("Custom Crop Type: ${_customCropType.text}");
      }

      if(isSqMeterSelected){
        dev.log("Sq Meter: $isSqMeterSelected");
      }else if(isSqFeetSelected){
        dev.log("Sq Feet: $isSqFeetSelected");
      }else if(isAcerSelected){
        dev.log("Acer: $isAcerSelected");
      }

    } else {
      // Validation failed, fields will be highlighted
      if (_image == null || _webImage == null) {
        addFarmNotifier.updateImageSelectText("Image is required to continue!");
        addFarmNotifier.toggleShowErrorTextColorOnImage(true);
      }
      dev.log("Validation failed");
    }
  }

  String unitConversion(String farmArea) {
    double sqFeet;

    if (isSqMeterSelected) {
      sqFeet = double.parse(farmArea) * 10.7639;
    } else if (isAcerSelected) {
      sqFeet = double.parse(farmArea) * 43560;
    } else {
      sqFeet = double.parse(farmArea);
    }
   return sqFeet.toStringAsFixed(3);
  }

  @override
  void initState() {
    addFarmNotifier = ref.read(addFarmProvider.notifier);
    imageControllerNotifier = ref.read(imageControllerProvider.notifier);
    super.initState();
  }

  @override
  void dispose() {
    dev.log("Disposed method called in Add Farm Screen");
    // Delay provider modification until after the widget tree builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addFarmNotifier.resetState();
      imageControllerNotifier.resetState();
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

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final displayNotifier = ref.watch(dashboardScreenInfoProvider);

    screenResponsiveness = displayNotifier['screenResponsiveness'];
    fiveWidth = displayNotifier['fiveWidth'];
    fiveHeight = displayNotifier['fiveHeight'];
    width = displayNotifier['screenFullWidth'];
    contexts = context;


      addFarmProv = ref.watch(addFarmProvider);
      imageControllerProv = ref.watch(imageControllerProvider);

      imageSelectTextColorShow = addFarmProv.showErrorTextColorOnImage;
      imageSelectText = addFarmProv.imageSelectText;
      cropChoices = addFarmProv.cropChoicesList;
      farmTypes = addFarmProv.farmTypesList;
      operationalStatus = addFarmProv.operationalStatusList;
      selectedCropChoices = addFarmProv.selectedCropChoices;
      selectedFarmType = addFarmProv.selectedFarmType;
      selectedOperationalStatusChoice = addFarmProv.selectedOperationalStatusChoice;
      _cropType = addFarmProv.cropType;
      _customCropType = addFarmProv.customCropType;
      _farmTypes = addFarmProv.farmType;
      _farmName = addFarmProv.farmName;
      _location = addFarmProv.farmLocation;
      _farmArea = addFarmProv.farmsArea;
      _farmStatus = addFarmProv.farmOperationalStatus;
      _description = addFarmProv.farmsDescription;
      _descriptionFieldHeight = addFarmProv.descriptionFieldHeight;
      showCustomCropTypeField = addFarmProv.showCustomCropTypeField;
      otherCropType = addFarmProv.otherCropType;
      isSqMeterSelected = addFarmProv.isSqMeterSelected;
      isSqFeetSelected = addFarmProv.isSqFeetSelected;
      isAcerSelected = addFarmProv.isAcerSelected;

      _image = ref.watch(imageControllerProvider).image;
      _webImage = ref.watch(imageControllerProvider).webImage;
      _picker = imageControllerProv.picker;
      _imageSize = imageControllerProv.imageSize;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Form(
            key: _formKey,
            child: screenResponsiveness == 'desktop'
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 40, bottom: 40, right: 50, left: 50),
                    child: desktopDashboard(),
                  )
                : screenResponsiveness == 'tablet'
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 40, bottom: 40, right: 50, left: 50),
                        child: tabletDashboard(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            top: 40, bottom: 40, right: 50, left: 50),
                        child: mobileDashboard(),
                      ),
          ),
        ),
      ),
    );
  }

  Widget desktopDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Add Farm"),
        const SizedBox(
          height: 10,
        ),
        Container(
          // height: 1200,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // Height Space
                const SizedBox(
                  height: 50,
                ),

                mainHeading("Add Farm", 30),

                // Height Space
                const SizedBox(
                  height: 30,
                ),

                // Farm name and Farm Type
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Farm name
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabels("Farm Name"),
                          SizedBox(
                            height: spaceBetweenLabelAndTextField,
                          ),
                          farmNameTextField(),
                        ],
                      ),
                    ),
                    // Width Space
                    SizedBox(
                      width: spaceBetweenTwoTextFields,
                    ),
                    // Farm type
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Farm Type"),
                            SizedBox(height: spaceBetweenLabelAndTextField),
                            farmTypeTextField(),
                          ]),
                    ),
                  ],
                ),

                // Height Space
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),

                // Crop Type and Farm Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Crop Type
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Select Crop Type"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            selectCropDropDown(),
                          ]),
                    ),
                    // Width Space
                    SizedBox(
                      width: spaceBetweenTwoTextFields,
                    ),
                    // Custom Crop Type
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Enter Crop Type"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            customCropTypeTextField(),
                          ]),
                    ),
                  ],
                ),

                // Height Space
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),

                // Farm Area and Operational Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Farm Location
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Farm's Location"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            locationTextField(),
                          ]),
                    ),
                    // Width Space
                    SizedBox(
                      width: spaceBetweenTwoTextFields,
                    ),
                    // Farm Operational Status
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Farm's Operational Status"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            operationalStatusDropDown(),
                          ]),
                    ),
                  ],
                ),

                // Height Space
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),

                // Farms Area
                farmAreaTextField(),

                // Height Space
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),

                // Farm Description
                textFieldsLabels("Farm's Description"),
                SizedBox(
                  height: spaceBetweenLabelAndTextField,
                ),
                descriptionTextField(),

                // Height Space
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),

                // Image select box and show box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Image Select box
                    Flexible(
                      flex: 1,
                      child: imageSelectBox(200, 300),
                    ),
                    // Image Shower box
                    Flexible(
                      flex: 1,
                      child: imageShowerBox(210, 300),
                    ),
                  ],
                ),

                // Height Space
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows * 2,
                ),

                // Submit Button
                Center(
                  child: saveDataButton(),
                ),

                // Height Space
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget tabletDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Add Farm"),
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 1050,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFieldsLabels("Farm Name"),
                          SizedBox(
                            height: spaceBetweenLabelAndTextField,
                          ),
                          farmNameTextField(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: spaceBetweenTwoTextFields,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Registration Date"),
                            SizedBox(height: spaceBetweenLabelAndTextField),
                            farmTypeTextField(),
                          ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Select Crop Type"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            selectCropDropDown(),
                          ]),
                    ),
                    SizedBox(
                      width: spaceBetweenTwoTextFields,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Farm's Location"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            locationTextField(),
                          ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Farm's Area"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            farmAreaTextField(),
                          ]),
                    ),
                    SizedBox(
                      width: spaceBetweenTwoTextFields,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textFieldsLabels("Farm's Operational Status"),
                            SizedBox(
                              height: spaceBetweenLabelAndTextField,
                            ),
                            operationalStatusDropDown(),
                          ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                textFieldsLabels("Farm's Description"),
                SizedBox(
                  height: spaceBetweenLabelAndTextField,
                ),
                descriptionTextField(),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: imageSelectBox(200, 250),
                    ),
                    Flexible(
                      flex: 1,
                      child: imageShowerBox(210, 250),
                    ),
                  ],
                ),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows * 2,
                ),
                Center(
                  child: saveDataButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget mobileDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Add Farm"),
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 1650,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textFieldsLabels("Farm Name"),
                    SizedBox(
                      height: spaceBetweenLabelAndTextField,
                    ),
                    farmNameTextField(),
                  ],
                ),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldsLabels("Registration Date"),
                      SizedBox(height: spaceBetweenLabelAndTextField),
                      farmTypeTextField(),
                    ]),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldsLabels("Select Crop Type"),
                      SizedBox(
                        height: spaceBetweenLabelAndTextField,
                      ),
                      selectCropDropDown(),
                    ]),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldsLabels("Farm's Location"),
                      SizedBox(
                        height: spaceBetweenLabelAndTextField,
                      ),
                      locationTextField(),
                    ]),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldsLabels("Farm's Area"),
                      SizedBox(
                        height: spaceBetweenLabelAndTextField,
                      ),
                      farmAreaTextField(),
                    ]),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldsLabels("Farm's Operational Status"),
                      SizedBox(
                        height: spaceBetweenLabelAndTextField,
                      ),
                      operationalStatusDropDown(),
                    ]),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                textFieldsLabels("Farm's Description"),
                SizedBox(
                  height: spaceBetweenLabelAndTextField,
                ),
                descriptionTextField(),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      imageSelectBox(200, 250),
                      SizedBox(
                        height: spaceBetweenTwoTextFieldsRows,
                      ),
                      imageShowerBox(210, 250),
                    ],
                  ),
                ),
                SizedBox(
                  height: spaceBetweenTwoTextFieldsRows * 2,
                ),
                Center(
                  child: saveDataButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget mainHeading(String label, double fontSize) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: fontSize,
          color: boxHeadingColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget farmNameTextField() {
    return TextFormField(
      controller: _farmName,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter Farm Name";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: "Farm name",
        hintText: "Enter Farm name here",
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
        prefixIcon: const Icon(Icons.eco), // Customize icon
        filled: true,
        fillColor: boxColor, // Background color of the text field
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 10.0,
        ),
      ),
      style: const TextStyle(fontSize: 16.0),
    );
  }

  Widget farmTypeTextField() {
    return DropdownSearch<String>(
      validator: (value) {
        if (value == "Select from here") {
          return "Please select Farm Type from here";
        }
        return null;
      },
      onChanged: (String? newValue) {
          if (newValue != null) {
            addFarmNotifier.updateSelectedFarmType(newValue);
            addFarmNotifier.updateFarmType(newValue);
          }
      },
      items: (filter, infiniteScrollProps) => farmTypes,
      selectedItem: selectedFarmType,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          filled: true,
          fillColor: boxColor,
          labelText: "Select Farm Type",
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
              vertical: 15.0,
              horizontal: 10.0), // Adjust padding to match TextField
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
    );
  }

  Widget selectCropDropDown() {
    return DropdownSearch<String>(
      validator: (value) {
        if (value == "Select from here") {
          return "Please select Crop Type from here";
        }
        return null;
      },
      onChanged: (String? newValue) {
        if (newValue != null) {
            selectedCropChoices = newValue;
            _cropType.text = newValue;
            addFarmNotifier.updateSelectedCropChoices(newValue);
            addFarmNotifier.updateCropType(newValue);
          if (newValue == otherCropType) {
              addFarmNotifier.toggleShowCustomCropTypeField(true);
          } else {
              addFarmNotifier.toggleShowCustomCropTypeField(false);
          }
        }
      },
      items: (filter, infiniteScrollProps) => cropChoices,
      selectedItem: selectedCropChoices,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          filled: true,
          fillColor: boxColor,
          labelText: "Select Crop Type",
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
              vertical: 15.0,
              horizontal: 10.0), // Adjust padding to match TextField
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
    );
  }

  Widget customCropTypeTextField() {
    return Tooltip(
      message: !showCustomCropTypeField
          ? "Only available when $otherCropType is\nselected as Crop Type"
          : "",
      textAlign: TextAlign.center,
      child: AbsorbPointer(
        absorbing: !showCustomCropTypeField,
        child: TextFormField(
          controller: _customCropType,
          validator: (value) {
            if ( _cropType.text == otherCropType && (value == null || value.isEmpty)) {
              return "Please enter Crop Type.";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "Custom Crop Type",
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
            prefixIcon: const Icon(Icons.grass), // Customize icon
            filled: true,
            fillColor: showCustomCropTypeField
                ? boxColor
                : Colors.grey
                    .withOpacity(0.3), // Background color of the text field
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 10.0), // Adjust padding to match Dropdown
          ),
          style: GoogleFonts.poppins(
            // Applying Google Font for label
            textStyle: const TextStyle(
              fontSize: 14, // Customize weight
            ),
          ),
        ),
      ),
    );
  }

  Widget locationTextField() {
    return TextFormField(
      controller: _location,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter Farm Location.";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: "Farm Location",
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
        prefixIcon: const Icon(Icons.location_on), // Customize icon
        filled: true,
        fillColor: boxColor, // Background color of the text field
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 10.0), // Adjust padding to match Dropdown
      ),
      style: GoogleFonts.poppins(
        // Applying Google Font for label
        textStyle: const TextStyle(
          fontSize: 14, // Customize weight
        ),
      ),
    );
  }

  Widget farmAreaTextField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 6,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                textFieldsLabels("Farm's Area"),
                SizedBox(
                  height: spaceBetweenLabelAndTextField,
                ),
                TextFormField(
                  controller: _farmArea,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Farm Area";
                    } else if (!isAcerSelected &&
                        !isSqMeterSelected &&
                        !isSqFeetSelected) {
                      return "Please select Area's unit";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Farm Area",
                    hintText: "Enter Farm Area here",
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
                    prefixIcon:
                        const Icon(Icons.map_outlined), // Customize icon
                    filled: true,
                    fillColor: boxColor, // Background color of the text field
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0), // Adjust padding to match Dropdown
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ]),
        ),
        // Width Space
        SizedBox(
          width: spaceBetweenTwoTextFields,
        ),
        // Area's unit checkbox
        Flexible(
          flex: 4,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textFieldsLabels("Sq Meter"),
                    Checkbox(
                      activeColor: borderColor,
                      value: isSqMeterSelected,
                      onChanged: (value) {
                          if (value != null) {
                            addFarmNotifier.toggleIsSqMeterSelected(value);
                          }
                          if (value == true) {
                            // Uncheck other checkbox
                            addFarmNotifier.toggleIsSqFeetSelected(false);
                            addFarmNotifier.toggleIsAcerSelected(false);
                          }
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textFieldsLabels("Sq Feet"),
                    Checkbox(
                      activeColor: borderColor,
                      value: isSqFeetSelected,
                      onChanged: (value) {
                          if (value != null) {
                            addFarmNotifier.toggleIsSqFeetSelected(value);
                          }
                          if (value == true) {
                            // Uncheck other checkbox
                            addFarmNotifier.toggleIsSqMeterSelected(false);
                            addFarmNotifier.toggleIsAcerSelected(false);
                          }
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textFieldsLabels("Acers"),
                    Checkbox(
                      activeColor: borderColor,
                      value: isAcerSelected,
                      onChanged: (value) {
                          if (value != null) {
                            addFarmNotifier.toggleIsAcerSelected(value);
                          }
                          if (value == true) {
                            // Uncheck other checkbox
                            addFarmNotifier.toggleIsSqMeterSelected(false);
                            addFarmNotifier.toggleIsSqFeetSelected(false);
                          }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget descriptionTextField() {
    return GestureDetector(
      onPanUpdate: (details) {
        addFarmNotifier.updateDescriptionFieldHeight(_descriptionFieldHeight += details.delta.dy);
      },
      child: Container(
        height: _descriptionFieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _description,
          maxLines: null, // Allows text field to grow
          expands: true, // Fills the available container height
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter your farm description here...',
            hintStyle: TextStyle(
              fontSize: 15,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget operationalStatusDropDown() {
    return DropdownSearch<String>(
      validator: (value) {
        if (value == "Select from here") {
          return "Please select Operational Status from here";
        }
        return null;
      },
      onChanged: (String? newValue) {
        if (newValue != null) {
            addFarmNotifier.updateSelectedOperationalStatusChoice(newValue);
            addFarmNotifier.updateFarmOperationalStatus(newValue);
        }
      },
      items: (filter, infiniteScrollProps) => operationalStatus,
      selectedItem: selectedOperationalStatusChoice,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          filled: true,
          fillColor: boxColor,
          labelText: "Select Farm Status",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor, // Green border color
              width: 1.0, // Ensure the border is visible
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor, // Green border color
              width: 1.0, // Ensure the border is visible
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor, // Green border color
              width: 1.0, // Ensure the border is visible
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0), // Adjust padding to match TextField
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
    );
  }

  Widget textFieldsLabels(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: 17,
          color: boxHeadingColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InkWell imageSelectBox(double height, double width) {
    return InkWell(
      onTap: () {
        // Add functionality here to open file picker or camera
        dev.log("Upload or choose image clicked!");
        _pickImage();
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [8, 4],
        color: borderColor, // Customize the dotted border color
        strokeWidth: 2,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: imageBorderColor, // Light background color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 50,
                color: boxHeadingColor, // Customize the icon color
              ),
              const SizedBox(height: 15),
              Text(
                "Drop your farm image here or\nclick here to upload",
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: boxHeadingColor, // Customize text color
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container imageShowerBox(double height, double width) {
    double finalHeight = _imageSize != null
        ? (300 / _imageSize!.width) *
            _imageSize!.height // Calculate height based on aspect ratio
        : height;

    finalHeight = finalHeight.clamp(0, height);

    return Container(
      height: finalHeight,
      width: width,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: imageBorderColor, // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(
          color: borderColor, // Border color
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Position of the shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            10), // Ensure the image fits within the rounded corners
        child: _image == null && _webImage == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 50, // Placeholder icon size
                      color: boxHeadingColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      imageSelectText,
                      style: TextStyle(
                          color: imageSelectTextColorShow
                              ? Colors.red
                              : boxHeadingColor),
                    ),
                  ],
                ),
              )
            : kIsWeb
                ? Image.memory(
                    _webImage!, // For web, show image from Uint8List
                    fit: BoxFit
                        .contain, // Adjust the image to fill the container
                  )
                : Image.file(
                    _image!, // Show the selected image for mobile
                    fit: BoxFit
                        .contain, // Adjust the image to fill the container
                  ),
      ),
    );
  }

  ElevatedButton saveDataButton() {
    return ElevatedButton(
      onPressed: () {
        _saveData(); // Call the save image method when the button is pressed
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Button color
        padding: const EdgeInsets.symmetric(
            horizontal: 100, vertical: 20), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Rounded corners
        ),
      ),
      child: const Text(
        "Save Farm", // Button text
        style: TextStyle(
          color: Colors.white, // Text color
          fontSize: 16, // Text size
        ),
      ),
    );
  }
}
