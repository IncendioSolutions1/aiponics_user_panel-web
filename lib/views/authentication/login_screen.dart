import 'package:aiponics_web_app/controllers/auth%20controller/login_controller.dart';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:aiponics_web_app/routes/route.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // Remember me checkbox value
  bool _isRememberMeChecked = false;
  String? passwordFieldErrorText;
  String? usernameErrorText;
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final result = await LoginController.signInInSecured(
      _formKey,
      usernameController,
      passwordController,
      _isRememberMeChecked,
      context
    );

    if (result.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      // Get.toNamed(TRoutes.dashboard);
      if (mounted) {
        CommonMethods.showSnackBarWithoutContext(result['success'] ? "Success" : "Failed",
            result['message'], result['success'] ? "success" : "failure");
      }
    }else{
      usernameController.text = usernameController.text;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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
                      : screenWidth < 1000
                          ? screenWidth * 0.55
                          : screenWidth * 0.65, // Takes up to 65% of screen width
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
                            color: Colors.black.withAlpha(51), // Overlay for better contrast
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
                  padding: const EdgeInsets.only(top: 70.0, bottom: 45.0, left: 32.0, right: 32.0),
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

                            // Username label and field
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Username',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            TextFormField(
                              controller: usernameController,
                              focusNode: usernameFocusNode,
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
                                errorText: usernameErrorText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                    50, 242, 242, 242), // Light gray background
                              ),
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (value) {
                                // Move to the password field
                                FocusScope.of(context).requestFocus(passwordFocusNode);
                              },
                              validator: (value) {
                                // Validate email input
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the username';
                                }
                                // Check if the username contains spaces
                                if (value.contains(' ')) {
                                  return 'Username cannot contain spaces';
                                }
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
                                      focusNode: passwordFocusNode,
                                      controller: passwordController,
                                      obscureText: !value, // Show/hide password
                                      textInputAction:
                                          TextInputAction.done, // Display "Done" on the keyboard
                                      onFieldSubmitted: (value) async {
                                        // Trigger the sign-in function when "Enter" is pressed
                                        await _login();
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter your password',
                                        hintStyle: GoogleFonts.poppins(),
                                        labelStyle: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        errorText: passwordFieldErrorText,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0), // Rounded corners
                                        ),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            50, 242, 242, 242), // Light gray background
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            value
                                                ? Icons.visibility
                                                : Icons.visibility_off, // Toggle visibility icon
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
                                    onPressed: () {},
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
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF007AFF), // Button background color
                                  minimumSize: Size(
                                      fiveWidth * 0,
                                      screenWidth > 600
                                          ? 50
                                          : fiveHeight *
                                              10), // Width and height based on conditions
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
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
                                    Get.offNamed(TRoutes.register); // Navigate to signup screen
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
