import 'dart:convert';
import 'dart:developer';
import 'package:aiponics_web_app/controllers/token%20controllers/access_and_refresh_token_controller.dart';
import 'package:http/http.dart' as http;
import 'package:aiponics_web_app/api%20information/api_constants.dart';
import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/teams%20and%20permissions/add_a_team_member.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddATeam extends StatefulWidget {
  const AddATeam({super.key});

  @override
  State<AddATeam> createState() => _AddATeamState();
}

class _AddATeamState extends State<AddATeam> {
  late Color boxColor;
  late Color borderColor;
  late Color boxHeadingColor;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController teamManagerName = TextEditingController();
  TextEditingController managerEmail = TextEditingController();
  TextEditingController teamName = TextEditingController();
  TextEditingController teamDescription = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final List<String> teamStatusList = [
    'Select Member Status',
    'Active',
    'Inactive'
  ];

  String selectedTeamStatus = "Select Member Status";
  String selectedManager = "Select Manager";

  final List<String> _farmsList = [
    'Long text for debugging',
    'Farm 2',
    'Farm 3',
    'Farm 4',
    'Farm 5',
    'Farm 6',
    'Farm 7',
    'Farm 8',
    'Farm 9',
    'Farm 10',
    'Farm 11',
    'Farm 12',
  ];

  late List<String> _managersList = [];

  // A map to store checkbox states
  final Map<String, bool> _farmsCheckboxValues = {};

  String userLevel = "Owner";
  String owner = "Owner";

  void showAddTeamMemberPopUp(BuildContext context) {
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
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.8,
                child: const AddATeamMember(
                    showHeader: false), // Embed AddToDo screen here
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
    // Initialize each checkbox as unchecked (false)
    for (var element in _farmsList) {
      _farmsCheckboxValues[element] = false;
    }

    _managersList = [
      "Select Manager",
      'Manager 1',
      'Manager 2',
      'Manager 3',
      'Manager 4',
      'Manager 5',
    ];

    if(userLevel == owner){
      _managersList.insert(1, owner);
    }

    _managersList.add("Add a new Manager");

    super.initState();
  }

  @override
  void dispose() {
    // Disposing of all TextEditingController instances
    teamManagerName.dispose();
    managerEmail.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {


      final url2 = Uri.parse(addTeamApi);
      String? bearerToken = await fetchAccessToken();  // Replace with your token

      try {
        final response = await http.post(
          url2,
          headers: {
            'Content-Type': 'application/json',  // Specify that you're sending JSON
            'Authorization': 'Bearer $bearerToken',  // Adding the Bearer token to the header
          },
          body: jsonEncode({
            "name": teamName.text,
            "description": teamDescription.text,
            "farms": [5, 6],
            "manager": 12
          }),  // Convert the payload map to a JSON string
        );

        if (response.statusCode == 201) {
          // Success
          log('API Call Success: ${response.body}');
        } else {
          // Handle API errors
          log('Failed to call API: ${response.statusCode}');
          log('Response Body: ${response.body}');
        }
      } catch (e) {
        log('Request Error: $e');
      }


    } else {
      // Validation failed, fields will be highlighted
      log("Validation failed");
    }

    log("Exiting _saveData");
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

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (_, constraints) {
              final width = MediaQuery.of(context)
                  .size
                  .width; // Get the current width of the screen

              // Check for desktop layout
              if (constraints.maxWidth >= 900) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 40,
                      right: 50,
                      left: 50), // Padding for desktop layout
                  child: desktopDashboard(context, fiveWidth,
                      fiveHeight), // Call desktop dashboard management method
                );
              }
              // Check for tablet layout
              else if ((constraints.maxWidth < 900 &&
                      constraints.maxWidth >= 750) ||
                  width >= 750) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 40,
                      right: 50,
                      left: 50), // Padding for tablet layout
                  child: tabletDashboard(
                      context,
                      fiveWidth,
                      fiveHeight,
                      constraints
                          .maxWidth), // Call tablet dashboard management method
                );
              }
              // Mobile layout
              else {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 60,
                      bottom: 40,
                      right: 30,
                      left: 30), // Padding for mobile layout
                  child: mobileDashboard(
                      context,
                      fiveWidth,
                      fiveHeight,
                      constraints
                          .maxWidth), // Call mobile dashboard management method
                );
              }
            },
          ),
        ),
      ),
    );
  }

  desktopDashboard(BuildContext context, double fiveWidth, double fiveHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CustomHeaderWithoutFarmDropdown(
            mainPageHeading: "Welcome", subHeading: "Add a Team Member"),

        addATeamMemberButton(context),
        const SizedBox(
          height: 25,
        ),
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Create A New Team",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: boxHeadingColor,
                      ))),
                  addTeamAvatarSection()
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: teamNameTextField(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: teamStatusDropDown(),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: selectManagersOrOwnerDropDown(),
                  ),
                  if(selectedManager == "Add a new Manager")...[
                    const SizedBox(
                    width: 10,
                  ),
                    Flexible(
                    flex: 1,
                    child: managerEmailTextField(),
                  ),
                  ]
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              if(selectedManager == "Add a new Manager")
                managerNameTextField(),

              const SizedBox(
                height: 20,
              ),

              farmAssignmentGrid(),

              const SizedBox(
                height: 20,
              ),
              teamDescriptionTextField(),
              const SizedBox(
                height: 50,
              ),
              addTeamButton(),
            ],
          ),
        ),
      ],
    );
  }

  tabletDashboard(BuildContext context, double fiveWidth, double fiveHeight,
      double maxWidth) {}

  mobileDashboard(BuildContext context, double fiveWidth, double fiveHeight,
      double maxWidth) {}

  SizedBox addATeamMemberButton(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          showAddTeamMemberPopUp(context);
        },
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
          'Add a new Team Member',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: Colors.white, // White text
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
      ),
    );
  }

  Column teamNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Team Name",
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
          controller: teamName,
          decoration: InputDecoration(
            hintText: 'Enter Team Name',
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
              return 'Please enter a Team name';
            } else if (value.length < 3) {
              return 'Team name must be at least 3 characters';
            }
            return null; // Return null if validation passes
          },
          onFieldSubmitted: (value) {
            setState(() {
              teamName.text = value;
            });
          },
          onEditingComplete: () {
            setState(() {
              teamName.text = teamName.text;
            });
          },
        ),
      ],
    );
  }

  Column teamStatusDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Team Status",
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
              value: selectedTeamStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTeamStatus = newValue!;
                });
              },
              items:
              teamStatusList.map<DropdownMenuItem<String>>((String value) {
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

  Column selectManagersOrOwnerDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Manager",
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
              value: selectedManager,
              onChanged: (String? newValue) {
                if(newValue != null) {
                  setState(() {
                    selectedManager = newValue;
                  });
                }
              },
              items: _managersList.map<DropdownMenuItem<String>>((String value) {
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

  Column managerNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter new Manager's Name",
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
          controller: teamManagerName,
          decoration: InputDecoration(
            hintText: "Enter new Manager's Name",
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
              return 'Please enter a managers name';
            }
            return null; // Return null if validation passes
          },
          onChanged: (value) {
            // Handle text changes here
            log('Manager name: $value');
          },
        ),
      ],
    );
  }

  Widget managerEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Manager Email",
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
          controller: managerEmail,
          decoration: InputDecoration(
            hintText: 'Enter Manager email',
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
            log('Manager Email: $value');
          },
        ),
      ],
    );
  }

  Column teamDescriptionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Team Description",
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
          controller: teamDescription,
          decoration: InputDecoration(
            hintText: 'Team Description',
            hintStyle: TextStyle(
                fontSize: 14,
                color:
                boxHeadingColor.withOpacity(0.8)), // Custom hint text color
            fillColor: Colors.grey.withOpacity(0.3), // Background fill color
            filled: true, // Enables fill color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
              borderSide: BorderSide.none, // No outline for default border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Colors.grey.shade400), // Border color when not focused
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.5), // Border color when focused
            ),
          ),
          maxLines: 5, // Allows for more lines for a longer description
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a team description';
            } else if (value.length < 10) {
              return 'Description must be at least 10 characters';
            }
            return null; // Return null if validation passes
          },
          onChanged: (value) {
            // Handle text changes here
            log('Team Description: $value');
          },
        ),
      ],
    );
  }

  SizedBox addTeamButton() {
    return SizedBox(
      height: 48,
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          _saveData();
        },
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
          'Add Team',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: Colors.white, // White text
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget addTeamAvatarSection() {
    String initials;
    if(teamName.text.isNotEmpty){
      // Extract the first two characters from the text
      initials = teamName.text.length >= 2 ? teamName.text.substring(0, 2).toUpperCase() : teamName.text.toUpperCase();
    }else{
      initials = 'TE';
    }

    return Center(
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.blue, // Background color,
          borderRadius: BorderRadius.circular(50)
        ),
        child: Center(
          child: Text(
            initials,
            style: GoogleFonts.audiowide(
              color: Colors.white, // Text color
              letterSpacing: 5,
              fontSize: 15, // Adjust font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget farmAssignmentGrid() {
    return Align(
      alignment: Alignment.topLeft, // Align to the top-left
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Farms to Assign",
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
          Wrap(
        spacing: 15, // Horizontal space between items
        runSpacing: 15, // Vertical space between rows
        children: _farmsList.map((parameter) {
          return Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Add padding to the text
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Makes the row's width match its content
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    parameter,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: boxHeadingColor,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 10), // Space between text and checkbox
                Checkbox(
                  activeColor: borderColor,
                  value: _farmsCheckboxValues[parameter],
                  onChanged: (bool? newValue) {
                    setState(() {
                      _farmsCheckboxValues[parameter] = newValue!;
                    });
                  },
                ),
                const SizedBox(width: 3),
              ],
            ),
          );
        }).toList(),
      ),

        ],
      ),
    );
  }

}
