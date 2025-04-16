import 'package:aiponics_web_app/models/drawer%20info%20model/drawer_info_model.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/theme_provider.dart';
import 'package:aiponics_web_app/provider/drawer%20info%20provider/drawer_provider.dart';
import 'package:aiponics_web_app/provider/user%20info%20provider/user_info_provider.dart';
import 'package:aiponics_web_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/dashboard management provider/dashboard_screen_info_provider.dart';
import '../routes/route.dart';

class DrawerScreen extends ConsumerStatefulWidget {
  final String screenToGo;

  const DrawerScreen(this.screenToGo, {super.key});

  @override
  DrawerScreenState createState() => DrawerScreenState();
}

class DrawerScreenState extends ConsumerState<DrawerScreen> with RouteAware {
  late bool isCollapsedDesktop;
  late int selectedIndex;
  int? expandedIndex;
  late int selectedSubIndex;

  late String screenMode;

  late bool showDesktopData;
  late bool isCollapsedMobile;
  late bool showMobileData;

  // This stores the currently selected route.
  late String selectedRoute;

  late ThemeColors themeColors;
  late final DrawerInfoNotifier drawerNotifier;

  @override
  void initState() {
    super.initState();
    selectedRoute = widget.screenToGo;
    drawerNotifier = ref.read(drawerInfoProvider.notifier);

    // Delay the update until after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final items = TRoutes.sideMenuItems;
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        if (item.containsKey('route') && item['route'] == selectedRoute) {
          drawerNotifier.updateSelectedIndex(i);
          break;
        }
        if (item['hasSubOptions'] == true) {
          for (var sub in item['subOptions']) {
            if (sub['action'] == selectedRoute) {
              drawerNotifier.updateSelectedIndex(i);
              drawerNotifier.updateExpandedIndex(i);
              drawerNotifier.updateSelectedSubIndex(item['subOptions'].indexOf(sub));
              break;
            }
          }
        }
      }
    });
  }


  void _showDataWithDelay() async {
    drawerNotifier.updateIsDesktopCollapsed(!isCollapsedDesktop);
    drawerNotifier.updateIsMobileCollapsed(!isCollapsedMobile);
    await Future.delayed(const Duration(milliseconds: 300));
    drawerNotifier.updateShowDesktopData(!showDesktopData);
    drawerNotifier.updateShowMobileData(!showMobileData);
  }

  void _hideDataWithOutDelay() async{
    drawerNotifier.updateShowDesktopData(!showDesktopData);
    drawerNotifier.updateShowMobileData(!showMobileData);
    await Future.delayed(const Duration(milliseconds: 300));
    drawerNotifier.updateIsDesktopCollapsed(!isCollapsedDesktop);
    drawerNotifier.updateIsMobileCollapsed(!isCollapsedMobile);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeProvider);
    final screenNotifier = ref.watch(dashboardScreenInfoProvider);
    final userInfoNotifier = ref.watch(userAccountInfoProvider);
    themeColors = ThemeColors(context);

    DrawerInfo drawerState = ref.watch(drawerInfoProvider);

    isCollapsedDesktop = drawerState.isDesktopCollapsed;
    selectedIndex = drawerState.selectedIndex;
    expandedIndex = drawerState.expandedIndex;
    selectedSubIndex = drawerState.selectedSubIndex;
    showDesktopData = drawerState.showDesktopData;
    isCollapsedMobile = drawerState.isMobileCollapsed;
    showMobileData = drawerState.showMobileData;
    screenMode = screenNotifier['screenResponsiveness'];

    // Calculate responsive dimensions only once.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fiveWidth = screenWidth * 0.003434;
    final fiveHeight = screenHeight * 0.005681;

    // Avoid frequent microtasks in build; update these from a dedicated listener or at app launch.
    Future.microtask(() {
      ref.read(dashboardScreenInfoProvider.notifier).updateFiveHeight(fiveHeight);
      ref.read(dashboardScreenInfoProvider.notifier).updateFiveWidth(fiveWidth);
      ref.read(dashboardScreenInfoProvider.notifier).updateScreenFullWidth(screenWidth);
      ref.read(dashboardScreenInfoProvider.notifier).updateScreenRemainingWidth(screenWidth);
    });

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Update responsiveness based on width only if necessary.
          if (constraints.maxWidth > 1120) {
            Future.microtask(() {
              ref.read(dashboardScreenInfoProvider.notifier).updateScreenResponsiveness("desktop");
            });
          } else if (constraints.maxWidth <= 1120 && constraints.maxWidth >= 750) {
            Future.microtask(() {
              ref.read(dashboardScreenInfoProvider.notifier).updateScreenResponsiveness("tablet");
            });
          } else {
            Future.microtask(() {
              ref.read(dashboardScreenInfoProvider.notifier).updateScreenResponsiveness("mobile");
            });
          }

          // For mobile layout, use an overlay drawer to avoid heavy rebuilds.
          if (constraints.maxWidth < 750) {
            return Stack(
              children: [
                Positioned.fill(child: _buildContent(themeData)),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: _buildSideBody(themeData),
                ),
              ],
            );
          } else {
            // Desktop layout: Permanent sidebar.
            return Column(
              children: [
                // Premium banner for certain user roles.
                if (userInfoNotifier.userAccountInfoModel.role[0] != "loading" &&
                    userInfoNotifier.userAccountInfoModel.role[0].toLowerCase() == "regular")
                  _buildPremiumBanner(themeColors),
                Expanded(
                  child: Row(
                    children: [
                      _buildSideBody(themeData),
                      Expanded(
                        child: Center(child: _buildContent(themeData)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(ThemeData isDarkMode) {
    // Use the route mapping to get the right content.
    return TRoutes.routesMap[selectedRoute] ??
        const Text('Select an option from the sidebar');
  }

  Widget _buildSideBody(ThemeData isDarkMode) {
    return _buildAnimatedContainer(isDarkMode);
  }

  Widget _buildAnimatedContainer(ThemeData isDarkMode) {
    bool isMobile = screenMode == "mobile";
    bool isCollapsed = isMobile ? isCollapsedMobile : isCollapsedDesktop;
    bool showData = isMobile ? showMobileData : showDesktopData;

    return Material(
      elevation: isCollapsed ? 0 : 6, // Elevation level (0 to 24)
      color: Colors.transparent, // Keeps your existing background in BoxDecoration
      shadowColor: Colors.black.withOpacity(0.2), // Optional: customize shadow
      child: Container(
        decoration: BoxDecoration(
          color: isCollapsed ? Colors.transparent : themeColors.backgroundColor,
          border: Border(
            // Use a softer, slightly thicker right border for a subtle divider.
            right: BorderSide(
              width: 1.5,
              color: Colors.grey.shade300,
            ),
            top: BorderSide(
              width: 1.5,
              color: Colors.grey.shade300,
            ),
            bottom: BorderSide(
              width: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          // Add a subtle shadow to lift the drawer off the main content.
          boxShadow: [
            if (!isCollapsed)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(2, 0),
              ),
          ],
          // Optionally, you can use a gradient background for a more modern look.
          // gradient: isCollapsed ? null : LinearGradient(
          //   colors: [themeColors.backgroundColor, themeColors.backgroundColor.withOpacity(0.95)],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: AnimatedContainer(
          width: isCollapsed ? (isMobile ? 70 : 55) : 240,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: isMobile ? const EdgeInsets.only(right: 10.0) : const EdgeInsets.only(right: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: isMobile
                      ? isCollapsed ? const EdgeInsets.only(top: 10.0, left: 10, bottom: 5) : const EdgeInsets.only(top: 10.0, left: 10, bottom: 5, right: 15)
                      : isCollapsed ? const EdgeInsets.only(top: 20.0, left: 10, bottom: 15) : const EdgeInsets.only(top: 20.0, left: 10, bottom: 15, right: 15),
                  child: _buildSidebarHeader(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: isMobile
                        ? isCollapsed ? const EdgeInsets.only(left: 20) : const EdgeInsets.only(left: 20, right: 15)
                        : isCollapsed ? const EdgeInsets.only(left: 40, top: 0) : const EdgeInsets.only(left: 40, top: 0, right: 15),
                    child: AnimatedOpacity(
                      opacity: showData ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 800),
                      child: ListView(
                        children: _generateMenuItems(),
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: showData ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 800),
                  child: !showData ? _buildSidebarFooter(isDarkMode) : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarHeader() {
    bool isMobile = screenMode == "mobile";
    bool showData = isMobile ? showMobileData : showDesktopData;
    bool isCollapsed = isMobile ? isCollapsedMobile : isCollapsedDesktop;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: showData
              ? const EdgeInsets.only(right: 0.0)
              : EdgeInsets.only(right: isMobile ? 3.0 : 10.0),
          child: IconButton(
            icon: Icon(Icons.menu, size: isMobile ? 17 : 25),
            onPressed: () {
              if (isCollapsed) {
                _showDataWithDelay();
              } else {
                _hideDataWithOutDelay();
              }
            },
          ),
        ),
        if (!showData)
          Expanded(
            child: Padding(
              padding: isMobile
                  ? const EdgeInsets.only(right: 10.0)
                  : const EdgeInsets.only(),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: isMobile ? 40 : 80,
                ),
                child: Image.asset(
                  "assets/images/logo-bg.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _generateMenuItems() {
    // Read user info for role-based item disabling.
    final userInfo = ref.watch(userAccountInfoProvider).userAccountInfoModel;
    final userRole = userInfo.role[0].toLowerCase();

    DrawerInfoNotifier drawerState = ref.read(drawerInfoProvider.notifier);
    DrawerInfo drawerProvider = ref.watch(drawerInfoProvider);

    return TRoutes.sideMenuItems.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      // If this is a header item, return a header widget (skip if user hasn't expanded data).
      if (item['isHeader'] == true) {
        // You can filter out header texts if you want them to be disabled for certain roles.
        return Padding(
          padding: EdgeInsets.only(bottom:  (screenMode == 'mobile' ? 10.0 : 12.0), top: 12.0),
          child: (screenMode == 'mobile' && showMobileData) || (screenMode != 'mobile' && showDesktopData)
              ? const SizedBox.shrink()
              : Text(
            item['text'],
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: screenMode == 'mobile' ? 10 : 12,
                fontWeight: FontWeight.bold,
                color: themeColors.boxHeadingColor,
              ),
            ),
          ),
        );
      } else {
        // For actionable items, optionally disable items for certain roles.
        bool disableItem = false;
        // For example, disable "Add a Team" and "Add a Team Member" for 'regular' and 'staff'

        if ((item['text'] == "Add a Team" || item['text'] == "Add a Team Member") &&
            (userRole == "regular" || userRole == "staff")) {
          disableItem = true;
        }

        return Column(
          children: [
            Material(
              color: drawerProvider.selectedIndex == index
                  ? (showMobileData || showDesktopData) ? themeColors.sidebarHighlightedColor : Colors.transparent
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10),
                onTap: disableItem
                    ? null // Disable onTap if the item is disabled.
                    : () {
                  setState(() {
                    if (item['hasSubOptions'] == true) {
                      if (drawerProvider.expandedIndex == index) {
                        drawerState.updateExpandedIndex(-1);
                      } else {
                        drawerState.updateExpandedIndex(index);
                        drawerState.updateSelectedSubIndex(-1);
                      }
                    } else {
                      drawerState.updateSelectedIndex(index);
                      drawerState.updateSelectedSubIndex(-1);
                      drawerState.updateExpandedIndex(-1);
                      selectedRoute = item['route'];
                      Navigator.pushNamed(context, selectedRoute);
                    }
                  });
                },
                leading: (screenMode == 'mobile' && showMobileData) || (screenMode != 'mobile' && showDesktopData)
                    ? null
                    : Icon(
                  item['icon'],
                  size: screenMode == 'mobile' ? 11 : 14,
                  color: disableItem ? Colors.grey : null,
                ),
                trailing: (screenMode == 'mobile' && showMobileData) || (screenMode != 'mobile' && showDesktopData)
                    ? null
                    : item['hasSubOptions'] == true
                    ? (expandedIndex == index
                    ? const Icon(Icons.keyboard_arrow_down, size: 25)
                    : const Icon(Icons.arrow_forward_ios_outlined, size: 12))
                    : null,
                title: (screenMode == 'mobile' && showMobileData) || (screenMode != 'mobile' && showDesktopData)
                    ? null
                    : Text(
                  item['text'] ?? "N/A",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: screenMode == 'mobile' ? 9 : 10,
                      fontWeight: FontWeight.w400,
                      color: disableItem ? Colors.grey : themeColors.boxHeadingColor,
                    ),
                  ),
                ),
              ),
            ),
            if (expandedIndex == index && item['hasSubOptions'] == true)
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  children: item['subOptions'].map<Widget>((subItem) {
                    int subIndex = item['subOptions'].indexOf(subItem);
                    return Container(
                      decoration: BoxDecoration(
                        color: (drawerProvider.selectedSubIndex == subIndex && expandedIndex == index)
                            ? (showMobileData || showDesktopData) ? themeColors.sidebarHighlightedColor : Colors.transparent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: SizedBox(
                          width: screenMode == 'mobile' ? 15 : 30,
                          child: (screenMode == 'mobile' && showMobileData) || (screenMode != 'mobile' && showDesktopData)
                              ? null
                              : Icon(subItem['icon'], size: screenMode == 'mobile' ? 11 : 13),
                        ),
                        title: Text(
                          subItem['text'],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: screenMode == 'mobile' ? 9 : 10,
                              fontWeight: FontWeight.w400,
                              color: themeColors.boxHeadingColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            drawerState.updateSelectedSubIndex(subIndex);
                            drawerState.updateSelectedIndex(-1);
                            selectedRoute = subItem['action'];
                            Navigator.pushNamed(context, selectedRoute);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      }
    }).toList();
  }

  Widget _buildSidebarFooter(ThemeData themeData) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final themeState = ref.read(themeProvider.notifier);
    bool isMobile = screenMode == "mobile";

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: isMobile ? 5 : 10,
      ),
      child: Column(
        children: [
          if (isMobile)
            IconButton(
              icon: Icon(themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              iconSize: 30,
              onPressed: () {
                themeState.toggleTheme();
              },
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.light_mode, color: Colors.yellow),
                const SizedBox(width: 8),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: themeData == darkMode,
                    onChanged: (value) {
                      themeState.toggleTheme();
                    },
                    activeColor: Colors.grey,
                    inactiveTrackColor: Colors.yellow,
                    inactiveThumbColor: Colors.white,
                    activeThumbImage: const AssetImage('assets/icons/moon.png'),
                    inactiveThumbImage: const AssetImage('assets/icons/sun.png'),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.dark_mode, color: Colors.blueGrey),
              ],
            ),
          const Center(
            child: Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  /// Optionally, build a premium banner for regular users.
  Widget _buildPremiumBanner(ThemeColors themeColors) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade300,
            Colors.purple.shade400,
            Colors.pink.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            left: -30,
            child: Icon(
              Icons.star,
              size: 120,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Positioned(
            bottom: -10,
            right: -20,
            child: Icon(
              Icons.star,
              size: 100,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Go Premium Today!",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Unlock exclusive features and perks.",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle subscription action.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    shadowColor: Colors.orangeAccent,
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.arrow_circle_up, color: Colors.white,),
                  label: Text(
                    "Upgrade",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
