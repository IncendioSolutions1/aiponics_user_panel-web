import 'dart:developer';
import 'dart:typed_data';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:aiponics_web_app/models/farm%20and%20devices%20models/farm_model.dart';
import 'package:aiponics_web_app/provider/farm%20and%20devices%20provider/view_farms_and_devices_provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../api information/api_constants.dart';
import '../../../controllers/network controllers/network_controller.dart';
import '../../../controllers/token controllers/access_and_refresh_token_controller.dart';
import '../../common/header/header_without_farm_dropdown.dart';

class AddATeamMember extends ConsumerStatefulWidget {
  final bool showHeader;

  const AddATeamMember({required this.showHeader, super.key});

  @override
  ConsumerState<AddATeamMember> createState() => _AddATeamMemberState();
}

class _AddATeamMemberState extends ConsumerState<AddATeamMember> {
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
  final Map<int, String> teamsList =  {};

  String selectedFarmList = "Select Farm";
  String selectedMemberStatus = "Select Member Status";

  int selectedFarmId = 0;


  Map<int, String> selectedMemberTeams = {};


  // variable to store uploaded image in Uint8List format (for web)
  Uint8List? uploadedImage;

  String imageMessage = "No image uploaded yet";

  int userId = 0;
  int selectedTeamId = 0;
  String userCheckStatus = "unchecked";
  bool isEmailLoading = false;

  bool isLoading = false;
  bool isTeamLoading = false;

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
  void dispose() {
    // Disposing of all TextEditingController instances
    memberName.dispose();
    memberEmail.dispose();

    super.dispose();
  }

  void checkIfUserExists() async {
    setState(() {
      isEmailLoading = true;
    });

    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      });
      setState(() {
        isEmailLoading = false;
      });
      return;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          // Do not override validateStatus globally here.
        ));

        // Use validateStatus in the Options to let 404 go to the exception block if needed.
        final response = await dio.post(
          checkIfUserExistsApi,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
          data: {
            "email": memberEmail.text,
          },
        );

        log("CHECK_USER_RESPONSE: Received response with status code ${response.statusCode}");
        log("CHECK_USER_RESPONSE: Response Data: ${response.data}");

        // If we get here, the response was successful (2xx).
        if (response.data.containsKey("user_id")) {
          int userId = response.data["user_id"];
          log("CHECK_USER_RESPONSE: User found with ID: $userId");
          CommonMethods.showSnackBarWithoutContext(
              "User Found", "User exists with id: $userId", "success");
          setState(() {
            userCheckStatus = "found";
            this.userId = userId;
          });
        } else {
          // Unexpected structure on success response.
          log("CHECK_USER_RESPONSE: Unexpected response structure: ${response.data}");
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Unexpected response from server.", "failure");
        }
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Internet not available", "failure");
        });
      }
    } on DioException catch (e) {
      log("CHECK_USER_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
      // Here we check if the error response contains our expected "error" key.
      if (e.response?.data != null &&
          e.response?.data is Map &&
          (e.response?.data as Map).containsKey("error")) {
        String errorMsg = (e.response?.data as Map)["error"];
        log("CHECK_USER_RESPONSE: User not found. Error: $errorMsg");
        CommonMethods.showSnackBarWithoutContext(
            "User Not Found", errorMsg, "failure");
        setState(() {
          userCheckStatus = "not-found";
        });
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Failed", "Failed to fetch member's details from server.", "failure");
        });
      }
    }

    setState(() {
      isEmailLoading = false;
    });
  }

  void sendInvitation() async {
    setState(() {
      isEmailLoading = true;
    });

    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      });
      setState(() {
        isEmailLoading = false;
      });
      return;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          // Do not override validateStatus globally here.
        ));

        // Use validateStatus in the Options to let 404 go to the exception block if needed.
        final response = await dio.post(
          sendInvitationApi,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
          data: {
            "email": memberEmail.text,
          },
        );

        log("CHECK_INVITE_RESPONSE: Received response with status code ${response.statusCode}");
        log("CHECK_INVITE_RESPONSE: Response Data: ${response.data}");


      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Internet not available", "failure");
        });
      }
    } on DioException catch (e) {
      log("CHECK_INVITE_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
      // Here we check if the error response contains our expected "error" key.
      if (e.response?.data != null &&
          e.response?.data is Map &&
          (e.response?.data as Map).containsKey("detail")) {
        String errorMsg = (e.response?.data as Map)["detail"];
        log("CHECK_INVITE_RESPONSE: User not found. Error: $errorMsg");
        CommonMethods.showSnackBarWithoutContext(
            "Invitation not sent", errorMsg, "failure");
        setState(() {
          userCheckStatus = "not-found";
        });
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Failed", "Failed to send invitation to member.", "failure");
        });
      }
    }

    setState(() {
      isEmailLoading = false;
    });
  }

  void _saveTeamMember() async {
      setState(() {
        isLoading = true;
      });

      // Ensure that the required IDs are available.
      // For example, these can be set after checking user existence or team selection.
      // Replace selectedUserId and selectedTeamId with your actual variable names.
      if (userId == 0 || selectedTeamId == 0) {
        CommonMethods.showSnackBarWithoutContext(
            "Missing Information", "User or Team ID is missing.", "failure");
        setState(() {
          isLoading = false;
        });
        return;
      }

      String? bearerToken = await fetchAccessToken();
      if (bearerToken == null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "An error occurred. Please try again later.", "failure");
        });
        setState(() {
          isLoading = false;
        });
        return;
      }

      try {
        if (await NetworkController.isInternetAvailable()) {
          final dio = Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
          ));

          final response = await dio.post(
            "$addTeamMemberApi$selectedTeamId/members/",
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $bearerToken",
              },
            ),
            data: {
              "user": userId, // e.g., 3
              "team": selectedTeamId, // e.g., 2
              "role": 'operator',
              "profile_photo": null,
            },
          );

          log("TEAM_MEMBER_ADD_RESPONSE: Received response with status code ${response.statusCode}");
          if (response.statusCode == 201) {
            log("TEAM_MEMBER_ADD_RESPONSE: Success: ${response.data}");
            Future.delayed(const Duration(milliseconds: 100), () {
              CommonMethods.showSnackBarWithoutContext(
                  "Team Member Added Successfully",
                  "The team member has been added successfully.",
                  "success");
            });
            // Clear or reset fields if necessary
            setState(() {
              // For example:
              // memberEmail.clear();
              // selectedUserId = null;
            });
          } else {
            log("TEAM_MEMBER_ADD_RESPONSE: Error ${response.statusCode}");
            log("TEAM_MEMBER_ADD_RESPONSE: Response Data: ${response.data}");
            CommonMethods.showSnackBarWithoutContext(
                "Failed to add Team Member",
                "Failed to add team member to the server.",
                "failure");
          }
        } else {
          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Error", "Internet not available", "failure");
          });
        }
      } on DioException catch (e) {
        log("TEAM_MEMBER_ADD_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
        Future.delayed(const Duration(milliseconds: 100), () {
          if (e.response?.statusCode == 403 &&
              e.response?.data["detail"].contains(
                  "One or more farms in the list are already being managed by other teams.")) {
            // If you expect a similar error here for team members (or adjust accordingly)
            CommonMethods.showSnackBarWithoutContext(
                "Failed to add Team Member", "${e.response?.data["detail"]}", "failure");
          } else if (e.response?.data != null &&
              e.response?.data is Map &&
              (e.response?.data as Map).containsKey("error")) {
            // This block handles the case when the API returns an error in the response payload.
            String errorMsg = (e.response?.data as Map)["error"];
            log("TEAM_MEMBER_ADD_RESPONSE: Error: $errorMsg");
            CommonMethods.showSnackBarWithoutContext(
                "Failed to add Team Member", errorMsg, "failure");
          } else {
            CommonMethods.showSnackBarWithoutContext(
                "Failed to add Team Member", "Failed to add team member to the server.", "failure");
          }
        });
      }

      setState(() {
        isLoading = false;
      });

    log("Exiting _saveTeamMember");
  }

  void fetchTeams() async {

    setState(() {
      isTeamLoading = true;
    });
      String? bearerToken = await fetchAccessToken();

      if (bearerToken == null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "An error occurred. Please try again later.", "failure");
        });
        return ;
      }

      try {
        if (await NetworkController.isInternetAvailable()) {
          final dio = Dio(BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
          ));

          final response = await dio.get(
            "$addTeamApi$selectedFarmId/",
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $bearerToken",
              },
            ),
          );

          log("TEAMS_FETCH_RESPONSE: Received response with status code ${response.statusCode}");

          if (response.statusCode == 200 || response.statusCode == 201) {
            log("TEAMS_FETCH_RESPONSE: Response Data: ${response.data}");

            setState(() {
              teamsList[response.data['id']] = response.data['name'];
            });


            Future.delayed(const Duration(milliseconds: 100), () {
              CommonMethods.showSnackBarWithoutContext(
                  "Success", "${teamsList.length} Teams fetched successfully", "success");
            });
          } else {
            log("TEAMS_FETCH_RESPONSE: Response error ${response.statusCode}");
            log("TEAMS_FETCH_RESPONSE: Response error ${response.data}");
            Future.delayed(const Duration(milliseconds: 100), () {
              CommonMethods.showSnackBarWithoutContext(
                  "Error", "Error fetching teams. Please try again.", "failure");
            });
          }
        } else {
          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Error", "Internet not available", "failure");
          });
        }
      } on DioException catch (e) {
        log("TEAMS_FETCH_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "An error occurred. Please try again later.", "failure");
        });
      }

    setState(() {
      isTeamLoading = false;
    });

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

                    memberEmailTextField(),

                    const SizedBox(
                      height: 40,
                    ),

                    if(userCheckStatus == "found")...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: farmsDropdown(),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            flex: 1,
                            child: assignedMultipleTeamsDropdown(),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      addMemberButton(),
                    ],



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
          onPressed: () {
            _saveTeamMember();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: borderColor, // Customize the button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Rounded edges
            ),

          ),
          child: isLoading ? const CircularProgressIndicator(color: Colors.white,) : Text(
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

  Column farmsDropdown() {
    // Create a fresh list each time the widget builds.
    final List<FarmModel> farms = [
      FarmModel(
        id: 0,
        name: "Select Farm",
        regDate: '',
        owner: '',
        images: null,
        cropDescription: '',
        areaUnit: '',
        crops: '',
        farmDescription: '',
        farmType: '',
        location: '',
        operationalStatus: '',
        farmsArea: 0,
      ),
    ];

    // Get the latest farms from the provider and add them
    final List<FarmModel> fetchedFarms = ref.watch(viewFarmsAndDevicesProvider).farmModelList;
    if (fetchedFarms.isNotEmpty) {
      farms.addAll(fetchedFarms);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Farm",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: boxHeadingColor,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ref.watch(viewFarmsAndDevicesProvider).areFarmsLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.green,))
            : farms.isEmpty
            ? const Text("No Farms found")
            : Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3), // Background fill color
            borderRadius: BorderRadius.circular(5), // Rounded corners
            border: Border.all(
              color: Colors.grey.shade400, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButton<String>(
              value: selectedFarmList,
              onChanged: (String? newValue) {
                log("farm check 1: $farms");
                log("farm check 2: $newValue");
                if (newValue != null) {
                  setState(() {
                    selectedFarmList = newValue;
                    selectedFarmId = farms.firstWhere((farm) => farm.name == newValue).id;
                  });
                  if (newValue != "Select Farm") {
                    fetchTeams();
                  }
                }
              },
              items: farms.map<DropdownMenuItem<String>>((FarmModel value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name),
                );
              }).toList(),
              isExpanded: true,
              iconEnabledColor: boxHeadingColor,
              style: TextStyle(
                color: boxHeadingColor.withOpacity(0.8),
                fontSize: 14,
              ),
              underline: Container(),
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
        ref.watch(viewFarmsAndDevicesProvider).areFarmsLoading ?
        const Center(child: Text("Please wait."),) : selectedFarmId == 0 ?
        const Center(child: Text("Please select or add farm!"),) :
        isTeamLoading ? const Center(child: CircularProgressIndicator(color: Colors.green,),) :
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
              items: teamsList.entries
                  .map((entry) => MultiSelectItem<String>(entry.value, entry.value))
                  .toList(),
              title: const Text("Select Teams"),
              selectedColor: Colors.blue,
              buttonText: const Text("Choose Teams"),
              onConfirm: (values) {
                setState(() {
                  selectedTeamId = teamsList.entries
                      .where((entry) => values.contains(entry.value))
                      .map((entry) => entry.key).first;

                  // Rebuild the map with keys from teamsList for the selected team names.
                  selectedMemberTeams = {
                    for (var entry in teamsList.entries)
                      if (values.contains(entry.value)) entry.key: entry.value,
                  };
                });
              },
              // initialValue must be a list of team names, not the map itself.
              initialValue: selectedMemberTeams.values.toList(),
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
        Row(
          children: [
            Flexible(
              flex: 8,
              child: TextFormField(
                controller: memberEmail,
                decoration: InputDecoration(
                  hintText: 'Member Email',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: boxHeadingColor.withAlpha(200),
                  ),
                  fillColor: Colors.grey.withAlpha(75),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a member email';
                  }
                  final emailRegex =
                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    userCheckStatus = "unchecked";
                  });
                },
              ),
            ),
            if(userCheckStatus != "found")...[
              const SizedBox(width: 10,),
              Flexible(
                flex: 2,
                child: SizedBox(
                  height: 46,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      if(userCheckStatus == "unchecked"){
                        checkIfUserExists();
                      }else if (userCheckStatus == "not-found"){
                        log("NOT FOUND");
                        sendInvitation();
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: borderColor, // Customize the button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Rounded edges
                      ),
                    ),
                    child: isEmailLoading ? const CircularProgressIndicator(color: Colors.white,) : Text(
                      userCheckStatus == "unchecked" ? 'Check User' : 'Send Invitation',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.white, // White text
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
              )
            ]

          ],
        ),
      ],
    );
  }

}
