import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_screen_info_provider.dart';
import 'package:aiponics_web_app/models/user%20info%20model/user_info_model.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/user%20info%20provider/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/token controllers/access_and_refresh_token_controller.dart';

class CustomHeaderWithoutFarmDropdown extends ConsumerWidget {
  final String mainPageHeading;
  final String subHeading;
  final double desktopMainFontSize;
  final double desktopSubFontSize;
  final double tabletMainFontSize;
  final double tabletSubFontSize;
  final double mobileMainFontSize;
  final double mobileSubFontSize;
  final double desktopButtonWidth;
  final double tabletButtonWidth;
  final double mobileButtonWidth;

  const CustomHeaderWithoutFarmDropdown({
    super.key,
    required this.mainPageHeading,
    required this.subHeading,
    this.desktopMainFontSize = 25,
    this.desktopSubFontSize = 15,
    this.tabletMainFontSize = 20,
    this.tabletSubFontSize = 12,
    this.mobileMainFontSize = 20,
    this.mobileSubFontSize = 12,
    this.desktopButtonWidth = 100,
    this.tabletButtonWidth = 80,
    this.mobileButtonWidth = 80,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the current user state and screen information.
    final userState = ref.watch(userAccountInfoProvider);
    final screenInfoState = ref.watch(dashboardScreenInfoProvider);
    final fiveWidth = screenInfoState['fiveWidth'];
    final responsive = screenInfoState['screenResponsiveness'];

    ThemeColors themeColors = ThemeColors(context);

    // Update colors based on theme.
    final boxHeadingColor = themeColors.boxHeadingColor;

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
                  accessibilityButtons(desktopButtonWidth, fiveWidth, themeColors),
                ],
              ),
              // Right side: Profile picture, name and role.
              Column(
                children: [
                  userNameRoleAndPicture(userState, boxHeadingColor),
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
              // Tablet layout: Welcome header and accessibility buttons.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeHeader(
                      themeColors, fiveWidth, tabletMainFontSize, tabletSubFontSize),
                  const SizedBox(height: 30),
                  accessibilityButtons(tabletButtonWidth, fiveWidth, themeColors),
                ],
              ),
              // Profile picture, name and role.
              Column(
                children: [
                  userNameRoleAndPicture(userState, boxHeadingColor),
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
          userNameRoleAndPicture(userState, boxHeadingColor),
          const SizedBox(height: 20),
          welcomeHeader(
              themeColors, fiveWidth, mobileMainFontSize, mobileSubFontSize),
          const SizedBox(height: 30),
          accessibilityButtons(mobileButtonWidth, fiveWidth, themeColors),
          const SizedBox(height: 10),
          divider(themeColors),
        ],
      );
    }
  }

  /// Displays the profile picture, first/last name and role.
  /// If the user data is loading, shimmer placeholders are shown.
  Widget userNameRoleAndPicture(UserAccount userState, Color boxHeadingColor) {
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
            child: userState.isLoading
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
              ),
            )
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
            // Display the user name, showing a shimmer placeholder when loading.
            userState.isLoading
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 150, // approximate width for name
                height: 20,
                color: Colors.grey[300],
              ),
            )
                : Text(
              "${userState.userAccountInfoModel.firstName} ${userState.userAccountInfoModel.lastName}",
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: boxHeadingColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            // Display the role, with a shimmer placeholder when loading.
            userState.isLoading
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 80, // approximate width for role text
                height: 15,
                color: Colors.grey[300],
              ),
            )
                : Text(
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
        ),
      ],
    );
  }

  /// Creates the welcome header with main and sub-headings.
  Widget welcomeHeader(
      ThemeColors themeColors, double fiveWidth, double mainFontSize, double subFontSize) {
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

  /// Creates a row of accessibility buttons for actions like Share, Print, and Export.
  Widget accessibilityButtons(double width, double fiveWidth, ThemeColors themeColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _accessibilityButton(
            Icons.share, "Share", width, themeColors, themeColors.boxColor, themeColors.accessibilityButtonsBorderColor),
        SizedBox(width: fiveWidth * 2),
        _accessibilityButton(
            Icons.print, "Print", width, themeColors, themeColors.boxColor, themeColors.accessibilityButtonsBorderColor),
        SizedBox(width: fiveWidth * 2),
        _accessibilityButton(Icons.save, "Export", width, themeColors, Colors.deepPurple, Colors.white),
        SizedBox(width: fiveWidth * 2),
        GestureDetector(
          onTap: () {
            logoutUser();
          },
          child: _accessibilityButton(
              Icons.exit_to_app, "Logout", width, themeColors, Colors.red, Colors.white),
        ),
      ],
    );
  }

  /// Helper widget to construct an accessibility button.
  Widget _accessibilityButton(
      IconData icon, String label, double width, ThemeColors themeColors, [Color? backgroundColor, Color? textColor]) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          border:
          Border.all(color: themeColors.accessibilityButtonsBorderColor, width: 1),
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

  /// A simple divider widget.
  Widget divider(ThemeColors themeColors) {
    return Divider(
      color: themeColors.accessibilityButtonsBorderColor,
      height: 30,
      thickness: 0.3,
    );
  }
}
