import 'dart:convert';
import 'dart:developer';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:aiponics_web_app/controllers/network%20controllers/network_controller.dart';
import 'package:aiponics_web_app/controllers/token%20controllers/access_and_refresh_token_controller.dart';
import 'package:aiponics_web_app/models/team%20and%20members%20model/member_model.dart';
import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../api information/api_constants.dart';
import '../../../models/team and members model/team_model.dart';

class ViewTeamsAndMembers extends ConsumerStatefulWidget {
  const ViewTeamsAndMembers({super.key});

  @override
  ConsumerState<ViewTeamsAndMembers> createState() => _ViewTeamsAndMembersState();
}

class _ViewTeamsAndMembersState extends ConsumerState<ViewTeamsAndMembers> {
  late Color boxColor;
  late Color borderColor;
  late Color imageBorderColor;
  late Color boxHeadingColor;
  late Color buttonColor;
  late Color dividerColor;

  // Initially, no farm is selected
  String selectedTeam = "None";

  List<TeamModel> teamList = [];
  List<TeamMemberModel> teamMemberList = [];


  @override
  void initState() {
    fetchTeams();
    super.initState();
  }

  void fetchTeams() async {

    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      });
      return;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

        final response = await dio.get(
          viewTeamsApi,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("TEAM_FETCH_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("TEAM_FETCH_RESPONSE: Response Data: ${response.data}");

          // Ensure response.data is properly parsed
          if (response.data is String) {
            response.data = jsonDecode(response.data);
          }

          if (response.data is List) {
            setState(() {
              teamList.clear();
              teamList = (response.data as List<dynamic>)
                  .map((item) => TeamModel.fromJson(item as Map<String, dynamic>))
                  .toList();
            });

            Future.delayed(const Duration(milliseconds: 100), () {
              CommonMethods.showSnackBarWithoutContext(
                  "Success", "Team fetched successfully", "success");
            });
          } else {
            log("TEAM_FETCH_RESPONSE: Unexpected data format: ${response.data}");
            throw Exception("Unexpected response format");
          }


          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Success", "Team fetched successfully", "success");
          });
        } else {
          log("TEAM_FETCH_RESPONSE: Response error ${response.statusCode}");
          log("TEAM_FETCH_RESPONSE: Response error ${response.data}");
          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Error", "Error adding farm. Please try again.", "failure");
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Internet not available", "failure");
        });
      }
    } on DioException catch (e) {
      log("TEAM_FETCH_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      });
    }


  }

  void fetchTeamMembers(String value) async {

    String? bearerToken = await fetchAccessToken();

    if (bearerToken == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      });
      return;
    }

    try {
      if (await NetworkController.isInternetAvailable()) {
        final dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

        final response = await dio.get(
          "$viewMembersOfSingleTeamApi$value/members/",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $bearerToken",
            },
          ),
        );

        log("TEAM_MEMBER_FETCH_RESPONSE: Received response with status code ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          log("TEAM_MEMBER_FETCH_RESPONSE: Response Data: ${response.data}");



          setState(() {
            teamMemberList.clear();
            teamMemberList = (response.data as List)
                .map((item) => TeamMemberModel.fromJson(item as Map<String, dynamic>))
                .toList();
          });

          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Success", "Member fetched successfully", "success");
          });
        } else {
          log("TEAM_MEMBER_FETCH_RESPONSE: Response error ${response.statusCode}");
          log("TEAM_MEMBER_FETCH_RESPONSE: Response error ${response.data}");
          Future.delayed(const Duration(milliseconds: 100), () {
            CommonMethods.showSnackBarWithoutContext(
                "Error", "Error adding farm. Please try again.", "failure");
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          CommonMethods.showSnackBarWithoutContext(
              "Error", "Internet not available", "failure");
        });
      }
    } on DioException catch (e) {
      log("TEAM_MEMBER_FETCH_RESPONSE: Request failed: ${e.message} - ${e.response?.data}");
      Future.delayed(const Duration(milliseconds: 100), () {
        CommonMethods.showSnackBarWithoutContext(
            "Error", "An error occurred. Please try again later.", "failure");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fiveWidth = screenWidth * 0.003434;

    boxColor = Theme.of(context).colorScheme.onSecondary;
    borderColor = Theme.of(context).colorScheme.onSecondaryFixed;
    imageBorderColor = Theme.of(context).colorScheme.secondaryFixed;
    boxHeadingColor = Theme.of(context).textTheme.labelLarge!.color!;
    buttonColor = Theme.of(context).colorScheme.surfaceContainer;
    dividerColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          log("${constraints.maxWidth}");
          if (constraints.maxWidth >= 850) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: desktopView(
                fiveWidth,
                selectedTeam,
                _updateSelectedTeam,
                1,
                14,
                12,
                4,
                25,
                MainAxisAlignment.spaceAround,
              ),
            );
          } else if (constraints.maxWidth >= 750) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: tabletView(
                fiveWidth,
                selectedTeam,
                _updateSelectedTeam,
                0.8,
                13,
                11,
                3,
                25,
                MainAxisAlignment.spaceAround,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: mobileView(
                fiveWidth,
                selectedTeam,
                _updateSelectedTeam,
                0.7,
                13,
                10,
                2,
                20,
                MainAxisAlignment.spaceAround,
              ),
            );
          }
        },
      ),
    );
  }

  void _updateSelectedTeam(String farm) {
    setState(() {
      selectedTeam = farm;
    });
  }

  Widget teamGrid(
      final double fiveWidth,
      final double gridWidth,
      final int itemsPerRow,
      final double nameFontSize,
      final double typeFontSize,
      ) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / gridWidth,
      ),
      itemCount: teamList.length,
      itemBuilder: (context, index) {
        var teams = teamList[index];
        return teamCard(
          teams,
          fiveWidth,
          nameFontSize,
          typeFontSize,
        );
      },
    );
  }


  Widget teamCard(
      final TeamModel team,
      final double fiveWidth,
      final double nameFontSize,
      final double typeFontSize,
      ) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              width: fiveWidth * 12,
              height: fiveWidth * 12,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft:
                  Radius.circular(15), // Radius for bottom-left corner
                  bottomRight:
                  Radius.circular(15), // Radius for bottom-right corner
                ),
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft:
                  Radius.circular(15), // Radius for bottom-left corner
                  bottomRight:
                  Radius.circular(15), // Radius for bottom-right corner
                ),
                child: Image(
                  image: AssetImage("assets/images/login_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: fiveWidth * 2, vertical: fiveWidth * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team.name,
                  style: GoogleFonts.poppins(
                    fontSize: nameFontSize,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  team.id.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: typeFontSize,
                    fontWeight: FontWeight.w600,
                    color: borderColor
                        // == "active"
                        // ? borderColor
                        // : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<String>(
                  value: team.id.toString(), // Unique value for this radio button
                  groupValue: selectedTeam, // Current selected value
                  activeColor: borderColor,
                  toggleable: true,
                  onChanged: (String? value) {
                    if (value == null) {
                      setState(() {
                        selectedTeam = "None";
                      });
                    } else {
                      fetchTeamMembers(value);
                      setState(() {
                        selectedTeam = value; // Update the selected option
                      });
                    }
                  },
                ),
                // IconButton(
                //   onPressed: () {},
                //   padding: EdgeInsets.zero,
                //   constraints:
                //   const BoxConstraints(), // Remove default constraints
                //   icon: const Icon(
                //     Icons.settings,
                //     color: Colors.black,
                //     size: 20,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget memberGrid(
      final double fiveWidth,
      final double gridWidth,
      final int itemsPerRow,
      final double nameFontSize,
      final double typeFontSize,
      ) {
    if (selectedTeam == "None") {
      return Center(
        child: Text(
          'No Team selected right now!',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / gridWidth,
      ),
      itemCount: teamMemberList.length,
      itemBuilder: (context, index) {
        var member = teamMemberList[index];
        return memberCard(
          member,
          fiveWidth,
          nameFontSize,
          typeFontSize,
        );
      },
    );
  }

  Widget memberCard(
      final TeamMemberModel member,
      final double fiveWidth,
      final double nameFontSize,
      final double typeFontSize,
      ) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              width: fiveWidth * 12,
              height: fiveWidth * 12,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft:
                  Radius.circular(15), // Radius for bottom-left corner
                  bottomRight:
                  Radius.circular(15), // Radius for bottom-right corner
                ),
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft:
                  Radius.circular(15), // Radius for bottom-left corner
                  bottomRight:
                  Radius.circular(15), // Radius for bottom-right corner
                ),
                child: Image(
                  image: AssetImage("assets/images/login_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: fiveWidth * 2, vertical: fiveWidth * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.role,
                  style: GoogleFonts.poppins(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: fiveWidth * 1),
                Text(
                  "Status: ${member.isActive ? "Active" : "Inactive"}",
                  style: GoogleFonts.poppins(
                    fontSize: typeFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.online_prediction,
                    color: Colors.green,
                    size: 25,
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   padding: EdgeInsets.zero,
                  //   constraints:
                  //   const BoxConstraints(), // Remove default constraints
                  //   icon: const Icon(
                  //     Icons.settings,
                  //     color: Colors.black,
                  //     size: 20,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget desktopView(
      final double fiveWidth,
      final String selectedFarm,
      final Function(String) onFarmSelected,
      final double gridValue,
      final double nameFontSize,
      final double typeFontSize,
      final int itemsPerRow,
      final double mainHeadingSize,
      final MainAxisAlignment mainAxisAlignment,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
          mainPageHeading: 'Welcome',
          subHeading: 'View and Manage your Team & Members',
        ),
        const SizedBox(height: 25),
        Text(
          "Teams",
          style: GoogleFonts.inter(
            fontSize: mainHeadingSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
            height: 100 * (teamList.length / itemsPerRow).ceilToDouble(),
            child: teamGrid(
              fiveWidth,
              gridValue,
              itemsPerRow,
              nameFontSize,
              typeFontSize,
            )),
        const SizedBox(height: 40),
        Text(
          "Members",
          style: GoogleFonts.inter(
            fontSize: mainHeadingSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
            height: 100 * (teamList.length / itemsPerRow).ceilToDouble(),
            child: memberGrid(
              fiveWidth,
              gridValue,
              itemsPerRow,
              nameFontSize,
              typeFontSize,
            )),
      ],
    );
  }

  Widget tabletView(
      final double fiveWidth,
      final String selectedFarm,
      final Function(String) onFarmSelected,
      final double gridValue,
      final double nameFontSize,
      final double typeFontSize,
      final int itemsPerRow,
      final double mainHeadingSize,
      final MainAxisAlignment mainAxisAlignment,
      ) {
    return desktopView(
      fiveWidth,
      selectedFarm,
      onFarmSelected,
      gridValue,
      nameFontSize,
      typeFontSize,
      itemsPerRow,
      mainHeadingSize,
      mainAxisAlignment,
    );
  }

  Widget mobileView(
      final double fiveWidth,
      final String selectedFarm,
      final Function(String) onFarmSelected,
      final double gridValue,
      final double nameFontSize,
      final double typeFontSize,
      final int itemsPerRow,
      final double mainHeadingSize,
      final MainAxisAlignment mainAxisAlignment,
      ) {
    return desktopView(
      fiveWidth,
      selectedFarm,
      onFarmSelected,
      gridValue,
      nameFontSize,
      typeFontSize,
      itemsPerRow,
      mainHeadingSize,
      mainAxisAlignment,
    );
  }
}
