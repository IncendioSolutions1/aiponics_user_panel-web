import 'package:aiponics_web_app/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900, // Dark background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated 404 icon
              Icon(
                Icons.error_outline,
                color: Colors.redAccent.shade200,
                size: 120,
              ),
              const SizedBox(height: 30),

              // Title Text
              Text(
                '404',
                style: GoogleFonts.poppins(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent.shade200,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle Text
              Text(
                'Oops! Page not found',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Description Text
              Text(
                'The page you are looking for might have been removed or temporarily unavailable.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              // Home Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade200,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(TRoutes.dashboard);
                },
                icon: const Icon(Icons.home, color: Colors.white),
                label: Text(
                  'Go to Home',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
