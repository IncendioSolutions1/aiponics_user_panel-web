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
import 'package:shimmer/shimmer.dart';

import '../../../controllers/token controllers/access_and_refresh_token_controller.dart';

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
    // Font & widget sizing based on responsive information.
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

    // Access state providers.
    final userState = ref.watch(userAccountInfoProvider);
    final screenInfoState = ref.watch(dashboardScreenInfoProvider);
    final updateHeaderState = ref.read(headerInfoProvider.notifier);
    HeaderModel headerModel = ref.watch(headerInfoProvider);
    final fiveWidth = screenInfoState['fiveWidth'];
    final responsive = screenInfoState['screenResponsiveness'];

    ThemeColors themeColors = ThemeColors(context);
    final boxHeadingColor = themeColors.boxHeadingColor;

    // Layout builds based on responsive flag.
    if (responsive == 'desktop') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Welcome header and accessibility buttons.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeHeader(
                      themeColors, fiveWidth, desktopMainFontSize, desktopSubFontSize),
                  const SizedBox(height: 30),
                  accessibilityButtons(
                      desktopButtonWidth, fiveWidth, themeColors),
                ],
              ),
              // Right side: User info and dropdowns.
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  userNameRoleAndPicture(userState, boxHeadingColor, context),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      // Farm dropdown widget with shimmer placeholder when loading.
                      _buildDropdown(
                        width: desktopFarmWidth,
                        height: desktopFarmHeight,
                        labelText: "Select Farm",
                        items: headerModel.farmList,
                        selectedItem: headerModel.selectedFarm,
                        onChanged: (String? selectedFarm) {
                          if (selectedFarm != null) {
                            updateHeaderState.updateFarm(selectedFarm);
                          }
                        },
                        themeColors: themeColors,
                        isLoading: headerModel.selectedFarm == "loading",
                      ),
                      const SizedBox(width: 10),
                      // Temperature unit dropdown widget.
                      _buildDropdown(
                        width: 80,
                        height: desktopFarmHeight,
                        labelText: "Temp",
                        items: headerModel.temperatureSignList,
                        selectedItem: headerModel.selectedTemperatureSign,
                        onChanged: (String? selectedTemp) {
                          if (selectedTemp != null) {
                            updateHeaderState.updateTemperatureSign(selectedTemp);
                          }
                        },
                        themeColors: themeColors,
                        isLoading: false,
                      ),
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
              // Tablet left: Welcome header and buttons.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeHeader(
                      themeColors, fiveWidth, tabletMainFontSize, tabletSubFontSize),
                  const SizedBox(height: 30),
                  accessibilityButtons(
                      tabletButtonWidth, fiveWidth, themeColors),
                ],
              ),
              // Tablet right: Profile info and farm dropdown.
              Column(
                children: [
                  userNameRoleAndPicture(userState, boxHeadingColor, context),
                  const SizedBox(height: 30),
                  _buildDropdown(
                    width: tabletFarmWidth,
                    height: tabletFarmHeight,
                    labelText: "Select Farm",
                    items: headerModel.farmList,
                    selectedItem: headerModel.selectedFarm,
                    onChanged: (String? selectedFarm) {
                      if (selectedFarm != null) {
                        updateHeaderState.updateFarm(selectedFarm);
                      }
                    },
                    themeColors: themeColors,
                    isLoading: headerModel.selectedFarm == "loading",
                  ),
                ],
              ),
            ],
          ),
          divider(themeColors),
        ],
      );
    } else {
      // Mobile layout.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userNameRoleAndPicture(userState, boxHeadingColor, context),
          const SizedBox(height: 20),
          welcomeHeader(
              themeColors, fiveWidth, mobileMainFontSize, mobileSubFontSize),
          const SizedBox(height: 30),
          _buildDropdown(
            width: mobileFarmWidth,
            height: mobileFarmHeight,
            labelText: "Select Farm",
            items: headerModel.farmList,
            selectedItem: headerModel.selectedFarm,
            onChanged: (String? selectedFarm) {
              if (selectedFarm != null) {
                updateHeaderState.updateFarm(selectedFarm);
              }
            },
            themeColors: themeColors,
            isLoading: headerModel.selectedFarm == "loading",
          ),
          const SizedBox(height: 30),
          accessibilityButtons(
              mobileButtonWidth, fiveWidth, themeColors),
          const SizedBox(height: 10),
          divider(themeColors),
        ],
      );
    }
  }

  /// Builds the dropdown widget using DropdownSearch package.
  Widget _buildDropdown({
    required double width,
    required double height,
    required String labelText,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onChanged,
    required ThemeColors themeColors,
    required bool isLoading,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: isLoading
          ? _buildShimmerPlaceholder(isLoading ? width : width, isLoading ? height : height, themeColors)
          : DropdownSearch<String>(
        onChanged: onChanged,
        items: (filter, infiniteScrollProps) => items,
        selectedItem: selectedItem,
        decoratorProps: DropDownDecoratorProps(
          decoration: _inputDecoration(themeColors, labelText),
        ),
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          constraints: const BoxConstraints(maxHeight: 300),
          menuProps: MenuProps(
            backgroundColor: themeColors.boxColor,
            elevation: 8,
          ),
          itemBuilder: (context, item, isSelected, _) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeColors.boxColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: item == selectedItem
                      ? themeColors.borderColor
                      : themeColors.boxHeadingColor,
                  fontWeight: item == selectedItem ? FontWeight.w600 : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Returns a common input decoration for dropdowns.
  InputDecoration _inputDecoration(ThemeColors themeColors, String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: themeColors.borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: themeColors.borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: themeColors.borderColor,
        ),
      ),
    );
  }

  /// Creates a shimmer placeholder widget.
  Widget _buildShimmerPlaceholder(double width, double height, ThemeColors themeColors) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  /// User profile widget with shimmer on the name if loading.
  Widget userNameRoleAndPicture(UserAccount userState, Color boxHeadingColor, BuildContext context) {
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
            child: userState.userAccountInfoModel.username == "loading"
                ? _buildShimmerPlaceholder(50, 50, ThemeColors(context))
                : userState.userAccountInfoModel.username == "error"
                ? IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
                : Image.asset(
              userState.userAccountInfoModel.profilePicture ??
                  "assets/images/logo.jpeg",
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
            if(userState.isLoading)...[
              Shimmer.fromColors(
                enabled: userState.isLoading,
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Text(
                  "${userState.userAccountInfoModel.firstName} ${userState.userAccountInfoModel.lastName}",
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: boxHeadingColor,
                    ),
                  ),
                ),
              ),
            ]
            else...[
              Text(
                "${userState.userAccountInfoModel.firstName} ${userState.userAccountInfoModel.lastName}",
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: boxHeadingColor,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 2),
            if(userState.isLoading)...[
              Shimmer.fromColors(
                enabled: userState.isLoading,
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Text(
                  userState.userAccountInfoModel.role[0],
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: boxHeadingColor,
                    ),
                  ),
                ),
              ),
            ]else...[
              Text(
                userState.userAccountInfoModel.role[0],
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: boxHeadingColor,
                  ),
                ),
              ),
            ],

          ],
        ),
      ],
    );
  }

  /// Welcome header with main and sub headings.
  Widget welcomeHeader(ThemeColors themeColors, double fiveWidth,
      double mainFontSize, double subFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  /// Row of accessibility buttons.
  Widget accessibilityButtons(
      double width, double fiveWidth, ThemeColors themeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _accessibilityButton(
          icon: Icons.share,
          label: "Share",
          width: width,
          themeColors: themeColors,
          backgroundColor: themeColors.boxColor,
          textColor: themeColors.accessibilityButtonsBorderColor,
        ),
        SizedBox(width: fiveWidth * 2),
        _accessibilityButton(
          icon: Icons.print,
          label: "Print",
          width: width,
          themeColors: themeColors,
          backgroundColor: themeColors.boxColor,
          textColor: themeColors.accessibilityButtonsBorderColor,
        ),
        SizedBox(width: fiveWidth * 2),
        _accessibilityButton(
          icon: Icons.save,
          label: "Export",
          width: width,
          themeColors: themeColors,
          backgroundColor: Colors.deepPurple,
          textColor: Colors.white,
        ),
        SizedBox(width: fiveWidth * 2),
        GestureDetector(
          onTap: () {
            logoutUser();
          },
          child: _accessibilityButton(
            icon: Icons.exit_to_app,
            label: "Logout",
            width: width,
            themeColors: themeColors,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Common button widget used in accessibilityButtons.
  Widget _accessibilityButton({
    required IconData icon,
    required String label,
    required double width,
    required ThemeColors themeColors,
    Color? backgroundColor,
    Color? textColor,
  }) {
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

  /// A simple divider widget.
  Widget divider(ThemeColors themeColors) {
    return Divider(
      color: themeColors.accessibilityButtonsBorderColor,
      height: 30,
      thickness: 0.3,
    );
  }
}
