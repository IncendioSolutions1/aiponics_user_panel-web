import 'package:aiponics_web_app/views/common/network_status.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/dashboard%20management/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/network controllers/network_controller.dart';
import '../../controllers/token controllers/access_and_refresh_token_controller.dart';
import '../../routes/route.dart';
import '../drawer_screen.dart';
import 'login_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: FutureBuilder<bool>(
        future: checkLoginWithFixedSplash(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.jpeg',
                    width: 250,
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(color: Colors.green),
                ],
              ),
            );
          }

          // Navigate to correct screen and remove splash screen from stack
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.data == true) {
              Get.offNamed(TRoutes.dashboard); // Removes splash screen and updates URL
            } else {
              Get.offNamed(TRoutes.login); // Removes splash screen and updates URL
            }
          });

          return const SizedBox.shrink(); // Return empty widget as navigation happens asynchronously
        },
      ),
    );
  }

  Future<bool> checkLoginWithFixedSplash() async {
    // Record the start time
    final startTime = DateTime.now();
    int secondForToShowSplashScreen = 1;

    bool isLoggedIn;
    try {
      // Attempt to get login status, but if it takes longer than 2 seconds, default to false
      isLoggedIn = await checkLoginStatus();
    } catch (e) {
      // In case of error, treat as not logged in
      isLoggedIn = false;
    }

    // Calculate elapsed time
    final elapsed = DateTime.now().difference(startTime);
    // Determine if we need to wait a bit more
    final remaining = Duration(seconds: secondForToShowSplashScreen) - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    return isLoggedIn;
  }

}
