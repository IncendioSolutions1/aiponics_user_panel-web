import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:another_flushbar/flushbar.dart' as fb;

class CommonMethods{

  static showSnackBarMessage(BuildContext context, String message, bool showError){
    // Use ScaffoldMessenger to show a cool and stylish SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            showError ? const Icon(Icons.warning, color: Colors.red) : const Icon(Icons.check_circle, color: Colors.white), // Icon for style
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent, // Custom background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        behavior: SnackBarBehavior.floating, // Floating appearance
        margin: const EdgeInsets.all(16), // Margin around the SnackBar
        duration: const Duration(seconds: 3), // Show for 3 seconds
      ),
    );
  }

  // Validates if the password meets all the criteria:
// - At least one uppercase letter
// - At least one digit
// - At least one special character (!@#$%^&*)
// - Minimum length of 8 characters

  static bool isPasswordValid(String password) {
    final passwordRegExp =
    RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

// Checks if the password contains at least one uppercase letter
  static bool hasUpperCase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

// Checks if the password contains at least one numeric digit
  static bool hasNumber(String password) {
    return RegExp(r'\d').hasMatch(password);
  }

// Checks if the password contains at least one special character from the set (!@#$%^&*)
  static bool hasSpecialCharacter(String password) {
    return RegExp(r'[!@#$%^&*]').hasMatch(password);
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void showSnackBarWithoutContext(
      String heading,
      String message,
      ContentType contentType,
      ) {
    final BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint("⚠️ No valid context found for showing Snackbar");
      return;
    }

    // Create a custom overlay entry for the Snackbar
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(contentType),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIcon(contentType),
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            heading,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message,
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Access the overlay directly from the navigator state
    final OverlayState? overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) {
      debugPrint("⚠️ No Overlay found for showing Snackbar");
      return;
    }

    // Insert the overlay entry
    overlayState.insert(overlayEntry);

    // Remove the overlay after a duration
    Future.delayed(const Duration(seconds: 4), () {
      overlayEntry.remove();
    });
  }


  static Color _getBackgroundColor(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return Colors.green;
      case ContentType.failure:
        return Colors.red;
      case ContentType.warning:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  static IconData _getIcon(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return Icons.check_circle;
      case ContentType.failure:
        return Icons.error;
      case ContentType.warning:
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

}