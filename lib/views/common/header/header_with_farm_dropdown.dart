import 'package:aiponics_web_app/models/header%20model/header_model.dart';
import 'package:aiponics_web_app/models/user%20info%20model/user_info_model.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/provider/header%20provider/header_provider.dart';
import 'package:aiponics_web_app/provider/user%20info%20provider/user_info_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeaderWithFarmDropdown extends ConsumerWidget {
  final String mainPageHeading;
  final String subHeading;

  const CustomHeaderWithFarmDropdown({
    super.key,
    required this.mainPageHeading,
    required this.subHeading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double desktopMainFontSize = 25;
    double desktopSubFontSize = 15;
    double tabletMainFontSize = 20;
    double tabletSubFontSize = 12;
    double mobileMainFontSize = 20;
    double mobileSubFontSize = 12;
    double desktopButtonWidth = 100;
    double tabletButtonWidth = 80;
    double mobileButtonWidth = 80;
    double desktopFarmWidth = 150;
    double desktopFarmHeight = 45;
    double tabletFarmWidth = 150;
    double tabletFarmHeight = 45;
    double mobileFarmWidth = 150;
    double mobileFarmHeight = 47;

    // Access the current user state
    final userState = ref.watch(userAccountInfoProvider);
    final screenInfoState = ref.watch(dashboardScreenInfoProvider);
    final updateHeaderState = ref.read(headerInfoProvider.notifier);
    HeaderModel headerModel = ref.watch(headerInfoProvider);
    final fiveWidth = screenInfoState['fiveWidth'];
    final responsive = screenInfoState['screenResponsiveness'];

    ThemeColors themeColors = ThemeColors(context);

    // Update colors based on
    final boxHeadingColor = themeColors.boxHeadingColor;

    if (responsive == 'desktop') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header and dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeHeader(themeColors, fiveWidth, desktopMainFontSize,
                      desktopSubFontSize),
                  const SizedBox(height: 30),
                  // Share, print, and export button
                  accessibilityButtons(
                      desktopButtonWidth, fiveWidth, themeColors),
                ],
              ),
              // Use Expanded here to make the second column take up the remaining space
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile picture, name and role
                  userNameRoleAndPicture(userState, boxHeadingColor),
                  const SizedBox(height: 30),
                  // Dropdown for selecting farm
                  Row(
                    children: [
                      farmDropdown(updateHeaderState, themeColors, headerModel,
                          desktopFarmWidth, desktopFarmHeight),
                      const SizedBox(width: 10),
                      celsiusOrFahrenheitDropdown(updateHeaderState, themeColors, headerModel,
                          70, desktopFarmHeight),
                    ],
                  )
                ],
              ),
            ],
          ),
          divider(themeColors),
        ],
      );
    } else if (responsive == 'tablet') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header and dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeHeader(themeColors, fiveWidth, tabletMainFontSize,
                      tabletSubFontSize),
                  const SizedBox(height: 30),
                  // Share, print, and export button
                  accessibilityButtons(
                      tabletButtonWidth, fiveWidth, themeColors),
                ],
              ),
              Column(
                children: [
                  // Profile picture, name and role
                  userNameRoleAndPicture(userState, boxHeadingColor),
                  const SizedBox(height: 30),
                  // Dropdown for selecting farm
                  farmDropdown(updateHeaderState, themeColors, headerModel,
                      tabletFarmWidth, tabletFarmHeight)
                ],
              ),
            ],
          ),
          divider(themeColors),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userNameRoleAndPicture(userState, boxHeadingColor),
          const SizedBox(height: 20),
          welcomeHeader(
              themeColors, fiveWidth, mobileMainFontSize, mobileSubFontSize),
          const SizedBox(height: 30),
          // Dropdown for selecting farm
          farmDropdown(updateHeaderState, themeColors, headerModel, mobileFarmWidth,
              mobileFarmHeight),
          const SizedBox(height: 30),
          // Share, print, and export button
          accessibilityButtons(mobileButtonWidth, fiveWidth, themeColors),
          const SizedBox(height: 10),
          divider(themeColors),
        ],
      );
    }
  }

  Widget userNameRoleAndPicture(UserAccountInfoModel userState, Color boxHeadingColor) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              userState.profilePicture ?? "assets/images/logo.jpeg",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${userState.firstName} ${userState.lastName}",
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: boxHeadingColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              userState.role[0],
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: boxHeadingColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget farmDropdown(HeaderNotifier updateFarmState, ThemeColors themeColors,
      HeaderModel userState, double width, double height) {
    return SizedBox(
      width: userState.selectedFarm == "loading" ? 30 : width, // Sets the width of the dropdown
      height: userState.selectedFarm == "loading" ? 30 : height, // Sets the height of the dropdown
      child: userState.selectedFarm == "loading" ? const CircularProgressIndicator(color: Colors.green,) : DropdownSearch<String>(
        onChanged: (String? selectedFarm) {
          if (selectedFarm != null) {
            updateFarmState.updateFarm(selectedFarm); // Update the farm state
          }
        },
        items: (filter, infiniteScrollProps) =>
        userState.farmList, // Provides the list of farms and devices
        selectedItem: userState.selectedFarm, // Sets the default selected item
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Select Farm", // Label for the dropdown
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(5), // Rounded border for the input
                borderSide: BorderSide(
                  color: themeColors.borderColor,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(5), // Rounded border for the input
                borderSide: BorderSide(
                  color: themeColors.borderColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(5), // Rounded border for the input
                borderSide: BorderSide(
                  color: themeColors.borderColor,
                )),
          ),
        ),
        popupProps: PopupProps.menu(
          fit: FlexFit.loose, // Allows the popup to fit loosely
          constraints:
              const BoxConstraints(maxHeight: 300), // Limits popup height
          menuProps: MenuProps(
            backgroundColor:
                themeColors.boxColor, // Background color of the dropdown menu
            elevation: 8, // Shadow elevation for the dropdown menu
          ),
          itemBuilder: (context, item, isSelected, boolAgain) {
            return Container(
              padding: const EdgeInsets.all(10), // Padding for each item
              decoration: BoxDecoration(
                color:
                    themeColors.boxColor, // Background color based on selection
                borderRadius:
                    BorderRadius.circular(5), // Rounded corners for the item
              ),
              child: Text(
                item, // Displays the farm name
                style: TextStyle(
                  color: item == userState.selectedFarm
                      ? themeColors.borderColor
                      : themeColors
                          .boxHeadingColor, // Text color based on selection
                  fontWeight:
                      item == userState.selectedFarm ? FontWeight.w600 : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget celsiusOrFahrenheitDropdown(HeaderNotifier updateHeaderState, ThemeColors themeColors,
      HeaderModel headerState, double width, double height) {
    return SizedBox(
      width: width, // Sets the width of the dropdown
      height: height, // Sets the height of the dropdown
      child: DropdownSearch<String>(
        onChanged: (String? selectedTemperatureSign) {
          if (selectedTemperatureSign != null) {
            updateHeaderState.updateTemperatureSign(selectedTemperatureSign); // Update the farm state
          }
        },
        items: (filter, infiniteScrollProps) =>
        headerState.temperatureSignList, // Provides the list of farms and devices
        selectedItem: headerState.selectedTemperatureSign, // Sets the default selected item
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Temp", // Label for the dropdown
            border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(5), // Rounded border for the input
                borderSide: BorderSide(
                  color: themeColors.borderColor,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(5), // Rounded border for the input
                borderSide: BorderSide(
                  color: themeColors.borderColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(5), // Rounded border for the input
                borderSide: BorderSide(
                  color: themeColors.borderColor,
                )),
          ),
        ),
        popupProps: PopupProps.menu(
          fit: FlexFit.loose, // Allows the popup to fit loosely
          constraints:
          const BoxConstraints(maxHeight: 300), // Limits popup height
          menuProps: MenuProps(
            backgroundColor:
            themeColors.boxColor, // Background color of the dropdown menu
            elevation: 8, // Shadow elevation for the dropdown menu
          ),
          itemBuilder: (context, item, isSelected, boolAgain) {
            return Container(
              padding: const EdgeInsets.all(10), // Padding for each item
              decoration: BoxDecoration(
                color:
                themeColors.boxColor, // Background color based on selection
                borderRadius:
                BorderRadius.circular(5), // Rounded corners for the item
              ),
              child: Text(
                item, // Displays the farm name
                style: TextStyle(
                  color: item == headerState.selectedTemperatureSign
                      ? themeColors.borderColor
                      : themeColors
                      .boxHeadingColor, // Text color based on selection
                  fontWeight:
                  item == headerState.selectedTemperatureSign ? FontWeight.w600 : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget welcomeHeader(ThemeColors themeColors, double fiveWidth,
      double mainFontSize, double subFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Welcome Back",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: mainFontSize,
              color: themeColors.boxHeadingColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subHeading,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: subFontSize,
              color: themeColors.boxHeadingColor,
            ),
          ),
        ),
      ],
    );
  }

  // Function to create a row of accessibility buttons (Share, Print, Export)
  Widget accessibilityButtons(
      double width, double fiveWidth, ThemeColors themeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _accessibilityButton(Icons.share, "Share", width, themeColors,
            themeColors.boxColor, themeColors.accessibilityButtonsBorderColor),
        SizedBox(width: fiveWidth * 2),
        _accessibilityButton(Icons.print, "Print", width, themeColors,
            themeColors.boxColor, themeColors.accessibilityButtonsBorderColor),
        SizedBox(width: fiveWidth * 2),
        _accessibilityButton(Icons.save, "Export", width, themeColors,
            Colors.deepPurple, Colors.white),
      ],
    );
  }

  Widget _accessibilityButton(
      IconData icon, String label, double width, ThemeColors themeColors,
      [Color? backgroundColor, Color? textColor]) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: themeColors.accessibilityButtonsBorderColor, width: 1),
          borderRadius: BorderRadius.circular(5),
          color: backgroundColor ?? Colors.transparent,
        ),
        child: SizedBox(
          width: width,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: textColor ?? Colors.black),
              Text(
                label,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: textColor ?? Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create a divider with specific properties
  Widget divider(ThemeColors themeColors) {
    return Divider(
      color: themeColors.accessibilityButtonsBorderColor,
      height: 30,
      thickness: 0.3,
    );
  }
}
