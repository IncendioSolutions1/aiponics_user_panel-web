import 'dart:developer';
import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewTeamsAndMembers extends StatefulWidget {
  const ViewTeamsAndMembers({super.key});

  @override
  State<ViewTeamsAndMembers> createState() => _ViewTeamsAndMembersState();
}

class _ViewTeamsAndMembersState extends State<ViewTeamsAndMembers> {
  late Color boxColor;
  late Color borderColor;
  late Color imageBorderColor;
  late Color boxHeadingColor;
  late Color buttonColor;
  late Color dividerColor;

  // Initially, no farm is selected
  String selectedTeam = "None";

  Map<String, Map<String, dynamic>> teamsWithTheirMembers = {
    'Team 1': {
      'status':
      'Active', // Status can be 'Active', 'Inactive', 'Under Maintenance', etc.
      'members': [
        {'name': 'Member 1', 'assigned_farms': ['1', '2', '3']},
        {'name': 'Member 2', 'assigned_farms': ['4', '5']},
        {'name': 'Member 3', 'assigned_farms': ['6', '7']},
      ],
    },
    'Team 2': {
      'status': 'Inactive',
      'members': [
        {'name': 'Member A', 'assigned_farms': ['8', '9', '10']},
        {'name': 'Member B', 'assigned_farms':[]},
      ],
    },
    'Team 3': {
      'status': 'Inactive',
      'members': [
        {'name': 'Member X', 'assigned_farms': ['11', '12', '13']},
        {'name': 'Member Y', 'assigned_farms': ['14']},
        {'name': 'Member Z', 'assigned_farms':['15']},
      ],
    },
    'Team 4': {
      'status': 'Active',
      'members': [
        {'name': 'Member X', 'assigned_farms': ['16', '17', '18']},
        {'name': 'Member Y', 'assigned_farms': ['19', '20']},
        {'name': 'Member Z', 'assigned_farms':['21', '22', '23']},
      ],
    },
  };

  late List<String> farms;

  @override
  void initState() {
    farms = teamsWithTheirMembers.keys.toList();
    super.initState();
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
      itemCount: farms.length,
      itemBuilder: (context, index) {
        var farm = farms[index];
        return teamCard(
          farm,
          fiveWidth,
          nameFontSize,
          typeFontSize,
        );
      },
    );
  }

  Widget teamCard(
      final String farm,
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
                  farm,
                  style: GoogleFonts.poppins(
                    fontSize: nameFontSize,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  teamsWithTheirMembers[farm]?["status"],
                  style: GoogleFonts.poppins(
                    fontSize: typeFontSize,
                    fontWeight: FontWeight.w600,
                    color: teamsWithTheirMembers[farm]?["status"] == "Active"
                        ? borderColor
                        : Colors.red,
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
                  value: farm, // Unique value for this radio button
                  groupValue: selectedTeam, // Current selected value
                  activeColor: borderColor,
                  toggleable: true,
                  onChanged: (String? value) {
                    if (value == null) {
                      setState(() {
                        selectedTeam = "None";
                      });
                    } else {
                      setState(() {
                        selectedTeam = value; // Update the selected option
                      });
                    }
                  },
                ),
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints:
                  const BoxConstraints(), // Remove default constraints
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
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
      itemCount: teamsWithTheirMembers[selectedTeam]!['members'].length,
      itemBuilder: (context, index) {
        var members = teamsWithTheirMembers[selectedTeam]!['members'] as List;
        var member = members[index] as Map<String, dynamic>;
        return memberCard(
          member,
          member, // Pass the same `member` map for simplicity.
          fiveWidth,
          nameFontSize,
          typeFontSize,
        );
      },
    );
  }

  Widget memberCard(
      final Map<String, dynamic> member,
      final Map<String, dynamic> assignedFarm,
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
                  member["name"]!,
                  style: GoogleFonts.poppins(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: fiveWidth * 1),
                Text(
                  "Farms:",
                  style: GoogleFonts.poppins(
                    fontSize: typeFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: fiveWidth * 1),
                Text(
                  "    ${(member["assigned_farms"] as List).join(", ")}",
                  style: GoogleFonts.poppins(
                      fontSize: typeFontSize,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.online_prediction,
                    color: Colors.green,
                    size: 25,
                  ),
                  IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints:
                    const BoxConstraints(), // Remove default constraints
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
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
            height: 100 * (farms.length / itemsPerRow).ceilToDouble(),
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
            height: 100 * (farms.length / itemsPerRow).ceilToDouble(),
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
