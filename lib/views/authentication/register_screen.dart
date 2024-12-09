import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../routes/route.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> _isConfirmPasswordVisible = ValueNotifier(false);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Validates if the password meets all the criteria:
// - At least one uppercase letter
// - At least one digit
// - At least one special character (!@#$%^&*)
// - Minimum length of 8 characters
  bool _isPasswordValid(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

// Checks if the password contains at least one uppercase letter
  bool _hasUpperCase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

// Checks if the password contains at least one numeric digit
  bool _hasNumber(String password) {
    return RegExp(r'\d').hasMatch(password);
  }

// Checks if the password contains at least one special character from the set (!@#$%^&*)
  bool _hasSpecialCharacter(String password) {
    return RegExp(r'[!@#$%^&*]').hasMatch(password);
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      final url2 = Uri.parse("http://192.168.10.13:8000/api/users/register/");

      final registerResponse2 = await http.post(
        url2,
        headers: {
          "Content-Type": "application/json",
        },
        body: json
            .encode({'username': name, 'email': email, 'password': password}),
      );

      if (registerResponse2.statusCode == 201) {
        log("Response send");
        log("Api Reply  ${registerResponse2.body}");
      } else {
        log("Response error ${registerResponse2.statusCode}");
        log("Response error ${registerResponse2.body}");
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (screenWidth > 700)
              SizedBox(
                width: screenWidth < 850
                    ? screenWidth * 0.5
                    : screenWidth < 1000
                        ? screenWidth * 0.55
                        : screenWidth * 0.65, // Takes 65% of the screen width
                height: screenHeight,
                child: Container(
                  color: Colors.blueGrey[100],
                  child: Center(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/register_image.jpg',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, bottom: 45.0, left: 32.0, right: 32.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/logo.jpeg', // Your logo image
                                      width: 80, // Adjust the size as needed
                                      height: 80, // Adjust the size as needed
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'AI Ponics',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  'Create your Free Account!',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF1A1A1A),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your name',
                                    hintStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    labelStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        const Color.fromARGB(50, 242, 242, 242),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 25),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Email',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email',
                                    hintStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    labelStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Color(0xff000000),
                                        fontSize: 14,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        const Color.fromARGB(50, 242, 242, 242),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email';
                                    }
                                    final emailRegex =
                                        RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 25),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: !value,
                                          decoration: InputDecoration(
                                            hintText: 'Enter your password',
                                            hintStyle: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            labelStyle: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 14,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            filled: true,
                                            fillColor: const Color.fromARGB(
                                                50, 242, 242, 242),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                _isPasswordVisible.value =
                                                    !_isPasswordVisible.value;
                                              },
                                            ),
                                          ),
                                          onChanged: (password) {
                                            setState(() {});
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            if (!_isPasswordValid(value)) {
                                              return 'Password must be at least 8 characters, include a special character, start with an uppercase letter, and contain a number';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Icon(
                                              _hasUpperCase(
                                                      _passwordController.text)
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: _hasUpperCase(
                                                      _passwordController.text)
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Uppercase letter',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              _hasSpecialCharacter(
                                                      _passwordController.text)
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: _hasSpecialCharacter(
                                                      _passwordController.text)
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Special character',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              _hasNumber(
                                                      _passwordController.text)
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: _hasNumber(
                                                      _passwordController.text)
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Contains number',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 25),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Confirm Password',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: _isConfirmPasswordVisible,
                                  builder: (context, value, child) {
                                    return TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: !value,
                                      decoration: InputDecoration(
                                        hintText: 'Re-enter your password',
                                        hintStyle: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        labelStyle: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 14,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            50, 242, 242, 242),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            _isConfirmPasswordVisible.value =
                                                !_isConfirmPasswordVisible
                                                    .value;
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        }
                                        if (_confirmPasswordController.text !=
                                            _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF007AFF), // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          registerUser();
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(fontSize: 14)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(
                              TRoutes.login); // Retained original screen name
                        },
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 35, left: 35, bottom: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/logo.jpeg', // Your logo image
                                width: 35, // Adjust the size as needed
                                height: 35, // Adjust the size as needed
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                'admin@gmail.com',
                                style: GoogleFonts.domine(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '© AIPONICS 2024',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
