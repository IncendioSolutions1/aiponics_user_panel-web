import 'dart:developer';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../common/header/header_without_farm_dropdown.dart';

class AddATeamMember extends StatefulWidget {
  final bool showHeader;

  const AddATeamMember({required this.showHeader, super.key});

  @override
  State<AddATeamMember> createState() => _AddATeamMemberState();
}

class _AddATeamMemberState extends State<AddATeamMember> {
  late Color boxColor;
  late Color borderColor;
  late Color boxHeadingColor;

  TextEditingController memberName = TextEditingController();
  TextEditingController memberEmail = TextEditingController();

  final List<String> memberRoleList = [
    'Select Member Role',
    'Manager',
    'Operator'
  ];
  final List<String> memberStatusList = [
    'Select Member Status',
    'Active',
    'Inactive'
  ];
  final List<String> teamsList = [
    'Team 1',
    'Team 2',
    'Team 3'
  ];

  String selectedMemberRole = "Select Member Role";
  String selectedMemberStatus = "Select Member Status";

  List<String> selectedMemberTeams = [];


  // variable to store uploaded image in Uint8List format (for web)
  Uint8List? uploadedImage;

  String imageMessage = "No image uploaded yet";

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      final fileSize = result.files.first.size;

      // Check if file size exceeds 5MB
      if (fileSize > 5 * 1024 * 1024) {
        setState(() {
          imageMessage = "Please upload image equal\nor smaller than 5MB.";
          uploadedImage = null;
        });
        return;
      }

      // Proceed with valid file
      final fileBytes = result.files.first.bytes!;

      setState(() {
        uploadedImage = fileBytes;
        imageMessage = "Image uploaded successfully.";
      });
    } else {
      imageMessage =  "Error while uploading image";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Disposing of all TextEditingController instances
    memberName.dispose();
    memberEmail.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define color variables based on the current theme
    boxColor = Theme.of(context).colorScheme.onSecondary; // Color for boxes
    borderColor = Theme.of(context)
        .colorScheme
        .onSecondaryFixed; // Border color for accessibility buttons
    boxHeadingColor = Theme.of(context)
        .textTheme
        .labelLarge!
        .color!; // Color for box headings

    // Get the screen size to make the layout responsive
    final screenWidth =
        MediaQuery.of(context).size.width; // Get the screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get the screen height

    // Calculate widths and heights for responsive design
    final fiveWidth = screenWidth * 0.003434; // Calculate width factor
    final fiveHeight = screenHeight * 0.005681; // Calculate height factor

    final width = MediaQuery.of(context)
        .size
        .width; // Get the current width of the screen

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40,
              bottom: 10,
              right: 50,
              left: 50), // Padding for desktop layout
          child: desktopDashboard(context, fiveWidth, fiveHeight,
              width), // Call desktop dashboard method
        ),
      ),
    );
  }

  desktopDashboard(
      BuildContext context, double fiveWidth, double fiveHeight, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.showHeader)
          const CustomHeaderWithoutFarmDropdown(
            subHeading: "See and Manage Your Devices",
            mainPageHeading: "Add, Edit or Delete Devices",
          ),
        if (!widget.showHeader)
          Row(
            children: [
              Text("Add A Team Member",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: boxHeadingColor,
                  ))),
            ],
          ),

        const SizedBox(
          height: 15,
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: boxHeadingColor
                          .withOpacity(0.1), // Shadow color with opacity
                      spreadRadius: 3, // How much the shadow spreads
                      blurRadius: 4, // How blurry the shadow is
                      offset:
                          const Offset(0, 3), // X and Y offset of the shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "General Information",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: boxHeadingColor,
                      )),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: memberNameTextField(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: memberEmailTextField(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40), // Spacing between text fields

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: assignedMultipleTeamsDropdown(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: memberStatusTextField(),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    addMemberButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Flexible(
              flex: 1,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: boxHeadingColor
                          .withOpacity(0.1), // Shadow color with opacity
                      spreadRadius: 3, // How much the shadow spreads
                      blurRadius: 4, // How blurry the shadow is
                      offset:
                      const Offset(0, 3), // X and Y offset of the shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 40,
                    ),

                    addMemberImage(),

                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column addMemberImage() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Member Gallery",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: boxHeadingColor,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Container with Dotted Border showing uploaded images
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 220,
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 1.5,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [6, 3],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: uploadedImage != null ?
                            Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: Image.memory(
                                      uploadedImage!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                          :
                            Center(
                              child: Text(
                                imageMessage,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Tooltip(
                        message: "Click to Add or Edit team's member image",
                        child: InkWell(
                            onTap: pickImage,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.purpleAccent
                                  ], // Gradient colors
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ],
            );
  }

  Widget addMemberButton() {
    return Center(
      child: SizedBox(
        height: 48,
        width: 250,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: borderColor, // Customize the button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Rounded edges
            ),
            padding: const EdgeInsets.only(
                top: 17,
                right: 16,
                left: 16,
                bottom: 17), // Adjust padding for size
          ),
          child: Text(
            'Add Member',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Colors.white, // White text
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  Column memberStatusTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Member Status",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: boxHeadingColor,
          )),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3), // Background fill color
            borderRadius: BorderRadius.circular(5), // Rounded corners
            border: Border.all(
              color: Colors.grey.shade400, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0), // Padding inside the container
            child: DropdownButton<String>(
              value: selectedMemberStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMemberStatus = newValue!;
                });
              },
              items: memberStatusList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true, // Ensures the dropdown takes up full width
              iconEnabledColor: boxHeadingColor,
              style: TextStyle(
                color: boxHeadingColor.withOpacity(0.8), // Text color
                fontSize: 14,
              ),
              underline: Container(), // Removes the default underline
            ),
          ),
        ),
      ],
    );
  }

  Column assignedMultipleTeamsDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Assigned Team",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: boxHeadingColor,
          )),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3), // Background fill color
            borderRadius: BorderRadius.circular(5), // Rounded corners
            border: Border.all(
              color: Colors.grey.shade400, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0), // Padding inside the container
            child: MultiSelectDialogField(
              buttonIcon: const Icon(Icons.arrow_drop_down_sharp),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent), // Removes the border
                borderRadius: BorderRadius.circular(8), // Optional: add rounded corners
              ),
              searchable: true,
              dialogWidth: 500,
              dialogHeight: 300,
              items: teamsList
                  .map((team) => MultiSelectItem<String>(team, team))
                  .toList(),
              title: const Text("Select Teams"),
              selectedColor: Colors.blue,
              buttonText: const Text("Choose Teams"),
              onConfirm: (values) {
                setState(() {
                  selectedMemberTeams = List<String>.from(values);
                });
              },
              initialValue: selectedMemberTeams,
            ),
          ),
        ),
      ],
    );
  }

  Column memberEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Member Email",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: boxHeadingColor,
          )),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: memberEmail,
          decoration: InputDecoration(
            hintText: 'Member Email',
            hintStyle: TextStyle(
                fontSize: 14,
                color:
                    boxHeadingColor.withOpacity(0.8)), // Custom hint text color
            fillColor: Colors.grey.withOpacity(0.3), // Background fill color
            filled: true, // Apply fill color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
              borderSide:
                  BorderSide.none, // Remove outline border for a cleaner look
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Colors.grey.shade400), // Border when not focused
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.5), // Border when focused
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a member email';
            }
            // Regular expression for email validation
            final emailRegex =
                RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null; // Return null if validation passes
          },
          onChanged: (value) {
            // Handle text changes here
            log('Owner: $value');
          },
        ),
      ],
    );
  }

  Column memberNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Member Name",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: boxHeadingColor,
          )),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: memberName,
          decoration: InputDecoration(
            hintText: 'Member Name',
            hintStyle: TextStyle(
                fontSize: 14,
                color:
                    boxHeadingColor.withOpacity(0.8)), // Custom hint text color
            fillColor: Colors.grey.withOpacity(0.3), // Background fill color
            filled: true, // Apply fill color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
              borderSide:
                  BorderSide.none, // Remove outline border for a cleaner look
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Colors.grey.shade400), // Border when not focused
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.5), // Border when focused
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a Member name';
            } else if (value.length < 3) {
              return 'Member name must be at least 3 characters';
            }
            return null; // Return null if validation passes
          },
          onChanged: (value) {
            // Handle text changes here
            log('Owner Name: $value');
          },
        ),
      ],
    );
  }
}
