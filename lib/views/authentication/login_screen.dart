import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:aiponics_web_app/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../drawer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Controllers for email and password fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ValueNotifier to toggle password visibility
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);

  // Remember me checkbox value
  bool _isRememberMeChecked = false;

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      String username = usernameController.text.trim();
      String password = passwordController.text;

      final url2 = Uri.parse("http://192.168.10.13:8000/api/users/login/");

      final registerResponse2 = await http.post(
        url2,
        headers: {
          "Content-Type": "application/json",
        },
        body: json
            .encode({'username': username, 'password': password,}),
      );

      if (registerResponse2.statusCode == 200) {
        log("Response send");
        log("Api Reply  ${registerResponse2.body}");
      } else {
        log("Response error ${registerResponse2.statusCode}");
        log("Response error ${registerResponse2.body}");
      }
    } else {}
  }

  void signInInSecured(){
    Get.to( () => const DrawerScreen(TRoutes.dashboard), routeName: TRoutes.dashboard);
  }


  @override
  Widget build(BuildContext context) {
    // Get the screen size to make the layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate dimensions for layout
    final fiveWidth = screenWidth * 0.003434;
    final fiveHeight = screenHeight * 0.005681;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Left side picture
              if (screenWidth > 700)
                SizedBox(
                  width: screenWidth < 850
                      ? screenWidth * 0.5
                      : screenWidth < 1000 ? screenWidth * 0.55 : screenWidth * 0.65, // Takes up to 65% of screen width
                  height: screenHeight * 1, // Full height
                  child: Container(
                    color: Colors.blueGrey[100],
                    child: Center(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/login_image.jpg', // Your background image
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.2), // Overlay for better contrast
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Right side form
              SizedBox(
                width: screenWidth < 700
                    ? screenWidth * 1
                    : screenWidth < 850
                    ? screenWidth * 0.5
                    : screenWidth < 1000
                    ? screenWidth * 0.45
                    : screenWidth * 0.35, // Takes up to 35% of screen width
                height: screenHeight * 1, // Full height
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 70.0, bottom: 45.0, left: 32.0, right: 32.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo and company name
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/logo.jpeg', // Your logo image
                                    width: screenWidth * 0.1, // Responsive logo width
                                    height: screenWidth * 0.1, // Responsive logo height
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'AI Ponics',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),

                            // Welcome message
                            Text(
                              'Nice to see you again!',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Email label and field
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Username',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your username',
                                hintStyle: GoogleFonts.poppins(
                                  textStyle: const TextStyle(),
                                ),
                                labelStyle: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Color(0xff000000),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Rounded corners
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(50, 242, 242, 242), // Light gray background
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                // Validate email input
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the username';
                                }
                                // final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                // if (!emailRegex.hasMatch(value)) {
                                //   return 'Please enter a valid email address';
                                // }
                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            // Password label and field with toggle
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Password',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _isPasswordVisible,
                              builder: (context, value, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: !value, // Show/hide password
                                      decoration: InputDecoration(
                                        hintText: 'Enter your password',
                                        hintStyle: GoogleFonts.poppins(),
                                        labelStyle: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                        ),
                                        filled: true,
                                        fillColor: const Color.fromARGB(50, 242, 242, 242), // Light gray background
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            value ? Icons.visibility : Icons.visibility_off, // Toggle visibility icon
                                          ),
                                          onPressed: () {
                                            // Toggle password visibility
                                            _isPasswordVisible.value = !_isPasswordVisible.value;
                                          },
                                        ),
                                      ),
                                      onChanged: (password) {
                                        // Trigger validation when password changes
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Remember me checkbox and forgot password link
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: const Color(0xff007aff),
                                        value: _isRememberMeChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _isRememberMeChecked = value!; // Update checkbox value
                                          });
                                        },
                                      ),
                                      const Flexible(
                                        child: Text(
                                          'Remember me',
                                          overflow: TextOverflow.ellipsis, // Prevent text overflow
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                    },
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Forgot password?',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Color(0xff007aff), // Link color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 60),

                            // Sign In button
                            SizedBox(
                              width: double.infinity, // Full width of the parent
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Handle login logic here
                                  final email = usernameController.text;
                                  final password = passwordController.text;

                                  // Example logic for saving login details
                                  if (_isRememberMeChecked) {
                                    // Save login details to local storage (SharedPreferences)
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('savedEmail', email);
                                    await prefs.setString('savedPassword', password);
                                  }

                                  signInInSecured();

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007AFF), // Button background color
                                  minimumSize: Size(
                                      fiveWidth * 0, screenWidth > 600 ? 50 : fiveHeight * 10), // Width and height based on conditions
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 18, // Button text size
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white, // Button text color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Sign Up link for new users
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t have an account?'),
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(TRoutes.register); // Navigate to signup screen
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Color(0xFF007AFF), // Link color
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
