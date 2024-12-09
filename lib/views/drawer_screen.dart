import 'dart:developer';
import 'package:aiponics_web_app/models/drawer%20info%20model/drawer_info_model.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/color_scheme_provider.dart';
import 'package:aiponics_web_app/provider/colors%20and%20theme%20provider/theme_provider.dart';
import 'package:aiponics_web_app/provider/drawer%20info%20provider/drawer_provider.dart';
import 'package:aiponics_web_app/provider/user%20info%20provide/user_info_provider.dart';
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

class DrawerScreenState extends ConsumerState<DrawerScreen> with RouteAware{

  late bool isCollapsedDesktop; // Control sidebar collapse state
  late int selectedIndex; // Track selected item index
  int? expandedIndex; // Track which item is expanded
  late int selectedSubIndex ;

  late String screenMode;

  late bool showDesktopData;

  late bool isCollapsedMobile; // Control sidebar collapse state
  late bool showMobileData;

  // Variable to hold the current selected route (defaults to the dashboard management)
  late String selectedRoute;

  late ThemeColors themeColors;

  late final DrawerInfoNotifier drawerNotifier;

  @override
  void initState() {
    super.initState();
    selectedRoute = widget.screenToGo;
    drawerNotifier = ref.read(drawerInfoProvider.notifier);
  }

  void _showDataWithDelay() async {
    drawerNotifier.updateIsDesktopCollapsed(!isCollapsedDesktop);
    drawerNotifier.updateIsMobileCollapsed(!isCollapsedMobile);
    await Future.delayed(const Duration(milliseconds: 300));
    drawerNotifier.updateShowDesktopData(!showDesktopData);
    drawerNotifier.updateShowMobileData(!showMobileData);
  }

  void _hideDataWithOutDelay() async {
    drawerNotifier.updateShowDesktopData(!showDesktopData);
    drawerNotifier.updateShowMobileData(!showMobileData);
    drawerNotifier.updateIsDesktopCollapsed(!isCollapsedDesktop);
    drawerNotifier.updateIsMobileCollapsed(!isCollapsedMobile);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeProvider);
    final screenData = ref.read(dashboardScreenInfoProvider.notifier);
    final screenNotifier = ref.watch(dashboardScreenInfoProvider);
    final userInfoNotifier = ref.watch(userInfoProvider);
    themeColors =  ThemeColors(context);

    DrawerInfo drawerState = ref.watch(drawerInfoProvider);

    isCollapsedDesktop = drawerState.isDesktopCollapsed;
    selectedIndex = drawerState.selectedIndex;
    expandedIndex = drawerState.expandedIndex;
    selectedSubIndex = drawerState.selectedSubIndex;
    showDesktopData = drawerState.showDesktopData;
    isCollapsedMobile = drawerState.isMobileCollapsed;
    showMobileData = drawerState.showMobileData;
    screenMode = screenNotifier['screenResponsiveness'];


    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive dimensions
    final fiveWidth = screenWidth * 0.003434;
    final fiveHeight = screenHeight * 0.005681;
    final width = MediaQuery.of(context).size.width;

    // Delay the provider update to avoid modification during the build phase
    Future.microtask(() {
      screenData.updateFiveHeight(fiveHeight);
      screenData.updateFiveWidth(fiveWidth);
      screenData.updateScreenFullWidth(width);
      screenData.updateScreenRemainingWidth(width);
    });

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          if (screenWidth > 1120) {
            // log("desktop");
            Future.microtask(() {
              screenData.updateScreenResponsiveness("desktop");
            });
          }
          // Check for tablet layout
          else if (screenWidth <= 1120 &&
              screenWidth >= 750) {
            // log("tablet");
            Future.microtask(() {
          screenData.updateScreenResponsiveness("tablet");
          });
          }
          // Mobile layout
          else {
            Future.microtask(() {
          screenData.updateScreenResponsiveness("mobile");
          });
          }

          if (screenWidth < 750) {
            // Mobile layout with overlay drawer
            return
              // Column(
              // children: [
                // if(userInfoNotifier.showAds)
                //   Container(
                //   height: 100,
                //   width: double.infinity,
                //   decoration: const BoxDecoration(
                //     color: Colors.red,
                //   ),
                // ),
                Stack(
                  children: [
                    Positioned.fill(
                      child: _buildContent(themeData),
                    ),
                    // Sidebar (overlay drawer)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: _buildSideBody(themeData),
                    ),
                  ],
                );
              // ],
            // );
          } else {
            // Desktop layout with permanent sidebar
            return Column(
              children: [
                if(userInfoNotifier.showAds)
                  Container(
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
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
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
                        // Decorative graphic
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
                        // Content
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
                                    )
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Unlock exclusive features and perks.",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    )
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle subscription functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade400,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  shadowColor: Colors.orangeAccent,
                                  elevation: 8,
                                ),
                                icon: const Icon(Icons.arrow_circle_up),
                                label: Text(
                                  "Upgrade",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            Expanded(
                  child: Row(
                    children: [
                      _buildSideBody(themeData), // Sidebar
                      Expanded(
                        child: Center(
                          child: _buildContent(themeData), // Content area
                        ),
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
    // For other routes, adjust width according to the sidebar
    return TRoutes.routesMap[selectedRoute] ??
        const Text('Select an option from the sidebar');
  }

  // Build the custom sidebar
  Widget _buildSideBody(ThemeData isDarkMode) {
      return _buildAnimatedContainer(isDarkMode);
  }

  Widget _buildAnimatedContainer(ThemeData isDarkMode) {
    bool isMobile = screenMode == "mobile";
    bool isCollapsed = isMobile ? isCollapsedMobile : isCollapsedDesktop;
    bool showData = isMobile ? showMobileData : showDesktopData;

    return Container(
      decoration: BoxDecoration(
        color: isCollapsed ? Colors.transparent : themeColors.backgroundColor,
      ),
      child: AnimatedContainer(
        width: isCollapsed ? (isMobile ? 70 : 65) : 220,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: isMobile ? const EdgeInsets.only(right: 10.0) : EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: isMobile
                    ? const EdgeInsets.only(top: 10.0, left: 10, bottom: 5)
                    : const EdgeInsets.only(top: 40.0, left: 20, bottom: 30),
                child: _buildSidebarHeader(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: isMobile
                      ? const EdgeInsets.only(left: 20)
                      : const EdgeInsets.only(left: 40, top: 10),
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
                child: !showData
                    ? _buildSidebarFooter(isDarkMode)
                    : Container(),
              ),
            ],
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
        if (!showData) ...[
          Expanded(
            child: Padding(
              padding: isMobile
                  ? const EdgeInsets.only(right: 10.0)
                  : const EdgeInsets.only(),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: isMobile ? 60 : 100, // Adjust height based on screen type
                ),
                child: Image.asset(
                  "assets/images/logo-bg.png",
                  fit: BoxFit.contain, // Adjust fit to avoid overflow
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _generateMenuItems() {
    bool isMobile = screenMode == 'mobile';
    DrawerInfoNotifier drawerNewState = ref.read(drawerInfoProvider.notifier);
    DrawerInfo drawerNewProvider = ref.watch(drawerInfoProvider);


    return TRoutes.sideMenuItems.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      if (item['isHeader'] == true) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: isMobile ? 10.0 : 12.0,
            top: 12.0,
          ),
          child: isMobile && showMobileData || !isMobile && showDesktopData
              ? null
              : Text(
            item['text'],
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: isMobile ? 10 : 13,
                fontWeight: FontWeight.bold,
                color: themeColors.boxHeadingColor,
              ),
            ),
          ),
        );
      } else {
        return Column(
          children: [
            Material(
              color: drawerNewProvider.selectedIndex == index ? themeColors.sidebarHighlightedColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10),
                onTap: () {
                  setState(() {
                    if (item['hasSubOptions'] == true) {
                      if(drawerNewProvider.expandedIndex == index){
                        drawerNewState.updateExpandedIndex(-1);
                      }else{
                        log("making down");
                        int? newExpandedIndex = expandedIndex == index ? null : index;
                        drawerNewState.updateExpandedIndex(newExpandedIndex);
                        drawerNewState.updateSelectedSubIndex(-1);
                      }

                    } else {
                      drawerNewState.updateSelectedIndex(index);
                      drawerNewState.updateSelectedSubIndex(-1);
                      drawerNewState.updateExpandedIndex(-1);
                      selectedRoute = item['route']; // Update selected route

                      // Update the URL with the new route
                      Navigator.pushNamed(context, selectedRoute);
                    }
                  });
                },
                leading: isMobile && showMobileData || !isMobile && showDesktopData
                    ? null
                    : Icon(
                  item['icon'],
                  size: isMobile ? 12 : 15,
                ),
                trailing: isMobile && showMobileData || !isMobile && showDesktopData
                    ? null
                    : item['hasSubOptions'] == true
                    ? (expandedIndex == index
                    ? const Icon(Icons.keyboard_arrow_down, size: 25)
                    : const Icon(Icons.arrow_forward_ios_outlined, size: 12))
                    : null,
                title: isMobile && showMobileData || !isMobile && showDesktopData
                    ? null
                    : Text(
                  item['text'],
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: isMobile ? 9 : 11,
                      fontWeight: FontWeight.w400,
                      color: themeColors.boxHeadingColor,
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
                        color: selectedSubIndex == subIndex && expandedIndex == index
                            ? themeColors.sidebarHighlightedColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: SizedBox(
                          width: isMobile ? 15 : 30,
                          child: isMobile && showMobileData || !isMobile && showDesktopData
                              ? null
                              : Icon(subItem['icon'], size: isMobile ? 11 : 13),
                        ),
                        title: Text(
                          subItem['text'],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: isMobile ? 9 : 11,
                              fontWeight: FontWeight.w400,
                              color: themeColors.boxHeadingColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            drawerNewState.updateSelectedSubIndex(subIndex);
                            drawerNewState.updateSelectedIndex(-1);
                            selectedRoute = subItem['action']; // Update the selected route

                            // Update the URL with the new route
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
        vertical: 20.0,
        horizontal: isMobile ? 5 : 10,
      ),
      child: Column(
        children: [
          if (isMobile)
            IconButton(
              icon: Icon(
                themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              iconSize: 50,
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
                Switch(
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
                const SizedBox(width: 8),
                const Icon(Icons.dark_mode, color: Colors.blueGrey),
              ],
            ),
          const Center(
            child: Text(
              'Version\n1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

}