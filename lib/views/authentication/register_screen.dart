import 'package:aiponics_web_app/controllers/auth%20controller/register_controller.dart';
import 'package:aiponics_web_app/controllers/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> _isConfirmPasswordVisible = ValueNotifier(false);

  String? _apiEmailErrorMessage;
  String? _apiUserNameErrorMessage;

  // Create FocusNodes
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });
    final result = await RegisterController.registerUser(_formKey, _userNameController,
        _emailController, _passwordController, _firstNameController, _lastNameController, context);

    if (result.isNotEmpty) {
      if (result['message'] == "success") {
        Get.offAndToNamed(TRoutes.login);
        if (mounted) {
          CommonMethods.showSnackBarMessage(
            context,
            "Account created successfully",
            !result['success'], // Show error icon if not success
          );
        }
      } else if (result['message'].contains("username already exists")) {
        setState(() {
          _apiUserNameErrorMessage = "Username already exists!";
        });
      } else if (result['message'].contains("email already exists")) {
        setState(() {
          _apiUserNameErrorMessage = "Email already exists!";
        });
      }else{
        if (mounted) {
          CommonMethods.showSnackBarMessage(
            context,
            "Error! Please try again later.",
            !result['success'], // Show error icon if not success
          );
        }
      }
    }

    setState(() {
      isLoading = false;
    });
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
                          color: isLoading
                              ? Colors.black.withAlpha(179)
                              : Colors.black.withAlpha(51),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 32.0, right: 32.0),
                  child: Column(
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
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'UserName',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: _userNameController,
                            keyboardType: TextInputType.name,
                            focusNode: usernameFocusNode, // Assign the FocusNode
                            decoration: InputDecoration(
                              hintText: 'Enter your username',
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
                              errorText: _apiUserNameErrorMessage,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(50, 242, 242, 242),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              if (value.contains(" ")) {
                                return "Username cannot have spaces";
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              // Move to the password field
                              FocusScope.of(context).requestFocus(emailFocusNode);
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
                            focusNode: emailFocusNode,
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
                              errorText: _apiEmailErrorMessage,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(50, 242, 242, 242),
                            ),
                            onFieldSubmitted: (value) {
                              // Move to the password field
                              FocusScope.of(context).requestFocus(firstNameFocusNode);
                            },
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'First Name',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _firstNameController,
                                      focusNode: firstNameFocusNode,
                                      decoration: InputDecoration(
                                        hintText: 'First Name',
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
                                        fillColor: const Color.fromARGB(50, 242, 242, 242),
                                      ),
                                      onFieldSubmitted: (value) {
                                        // Move to the password field
                                        FocusScope.of(context).requestFocus(lastNameFocusNode);
                                      },
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your First name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Last Name',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _lastNameController,
                                      focusNode: lastNameFocusNode,
                                      decoration: InputDecoration(
                                        hintText: 'Last Name',
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
                                        fillColor: const Color.fromARGB(50, 242, 242, 242),
                                      ),
                                      onFieldSubmitted: (value) {
                                        // Move to the password field
                                        FocusScope.of(context).requestFocus(passwordFocusNode);
                                      },
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your Last name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: passwordFocusNode,
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
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: const Color.fromARGB(50, 242, 242, 242),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          value ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          _isPasswordVisible.value = !_isPasswordVisible.value;
                                        },
                                      ),
                                    ),
                                    onFieldSubmitted: (value) {
                                      // Move to the password field
                                      FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                                    },
                                    onChanged: (password) {
                                      setState(() {});
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (!CommonMethods.isPasswordValid(value)) {
                                        return 'Password must be at least 8 characters, include a special character,\nstart with an uppercase letter, and contain a number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Icon(
                                        CommonMethods.hasUpperCase(_passwordController.text)
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: CommonMethods.hasUpperCase(_passwordController.text)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Uppercase letter',
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        CommonMethods.hasSpecialCharacter(_passwordController.text)
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: CommonMethods.hasSpecialCharacter(
                                                _passwordController.text)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Special character',
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        CommonMethods.hasNumber(_passwordController.text)
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: CommonMethods.hasNumber(_passwordController.text)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Contains number',
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(fontSize: 13)),
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
                                focusNode: confirmPasswordFocusNode,
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
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(50, 242, 242, 242),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      value ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      _isConfirmPasswordVisible.value =
                                          !_isConfirmPasswordVisible.value;
                                    },
                                  ),
                                ),
                                onFieldSubmitted: (value) async {
                                  // Move to the password field
                                  await registerUser();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (_confirmPasswordController.text != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007AFF), // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                onPressed: registerUser,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Register',
                                        style: GoogleFonts.poppins(
                                          textStyle:
                                              const TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style:
                                    GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 14)),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.offNamed(TRoutes.login); // Retained original screen name
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
                          const SizedBox(height: 50),
                          Center(
                            child: Text(
                              '© AIPONICS 2024',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
