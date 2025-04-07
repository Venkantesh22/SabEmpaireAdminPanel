import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/auth/screen/login.dart';
import 'package:admin_panel_ak/features/dastbord/dastbord.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:admin_panel_ak/features/footer_section/screen/footer.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String number = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool isLoading = false;
  bool _obscurePassword = true; // Add this state variable

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.primaryBlackColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.primaryBlackColor,
          title: Padding(
            padding: EdgeInsets.all(Dimensions.dimenisonNo5),
            child: Image.asset(
              GlobalVariable.LogWithOutBeuText,
              height: Dimensions.dimenisonNo50,
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.dimenisonNo24),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dimensions.dimenisonNo40,
                        Dimensions.dimenisonNo30,
                        Dimensions.dimenisonNo30,
                        Dimensions.dimenisonNo30,
                      ),
                      child: SizedBox(
                        width: Dimensions.screenWidth / 2.5,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: Dimensions.dimenisonNo16),
                              Text(
                                'Admin Panel Sign-Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.dimenisonNo30,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1.20,
                                ),
                              ),
                              SizedBox(height: Dimensions.dimenisonNo24),
                              // Full Name field
                              TextFormField(
                                style: InputTextDec(),
                                decoration: authTextBoxDec('Full Name'),
                                onChanged: (value) => fullName = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: Dimensions.dimenisonNo16),
                              // Number field with 10-digit validation.
                              TextFormField(
                                style: InputTextDec(),
                                decoration: authTextBoxDec('Number'),
                                onChanged: (value) => number = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your number';
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return 'Please enter a valid 10-digit number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: Dimensions.dimenisonNo16),
                              // Email field with format validation.
                              TextFormField(
                                style: InputTextDec(),
                                decoration: authTextBoxDec('Email'),
                                onChanged: (value) => email = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: Dimensions.dimenisonNo16),
                              // Password field
                              TextFormField(
                                style: InputTextDec(),
                                decoration: authTextBoxDec('Password').copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white.withAlpha(128),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                onChanged: (value) => password = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: Dimensions.dimenisonNo16),
                              // Confirm Password field
                              TextFormField(
                                style: InputTextDec(),
                                decoration: authTextBoxDec('Confirm Password'),
                                obscureText: true,
                                onChanged: (value) => confirmPassword = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != password) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: Dimensions.dimenisonNo24),
                              // Sign Up button with loading state.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              // Show a loader dialog.
                                              showLoaderDialog(context);
                                              bool isLogined =
                                                  await FirebaseAuthHelper
                                                      .instance
                                                      .signUp(
                                                          fullName,
                                                          number,
                                                          email,
                                                          password,
                                                          context);

                                              // Ensure widget is still mounted.
                                              if (!mounted) return;
                                              Navigator.pop(
                                                  context); // dismiss loader
                                              if (isLogined) {
                                                print(
                                                    'Signup Successful for: $fullName, $email');
                                                Navigator.pop(context);
                                                Routes.instance
                                                    .pushAndRemoveUntil(
                                                        widget: HomeDashBord(),
                                                        context: context);
                                                showBottonMessage(
                                                    "Signup Successful",
                                                    context);
                                              } else {
                                                showBottonMessageError(
                                                    "Signup failed. Please try again.",
                                                    context);
                                              }
                                            } catch (e) {
                                              if (!mounted) return;
                                              showBottonMessageError(
                                                  "Error: ${e.toString()}",
                                                  context);
                                            } finally {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.dimenisonNo16),
                                    backgroundColor: AppColor.buttonRedColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.dimenisonNo12),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimensions.dimenisonNo16,
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                            fontWeight: FontWeight.w600,
                                            height: 1.50,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: Dimensions.dimenisonNo16),
                              // Navigation to Login Page.
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimensions.dimenisonNo16,
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Routes.instance.push(
                                          widget: LogingPage(),
                                          context: context);
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: AppColor.buttonRedColor,
                                        fontSize: Dimensions.dimenisonNo16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // For larger screens, display a side image and a separator.
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo30),
                      child: Container(
                        height: Dimensions.screenHeight / 1.5,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Colors.white.withAlpha(128),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo30),
                      child: Image.asset(
                        "assets/images/sabWithBea.jpg",
                        width: Dimensions.screenWidth / 2.5,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Dimensions.dimenisonNo12,
                ),
                Footer(
                  footerModel: appProvider.getFooterModel,
                  email: appProvider.getFooterModel.emailOfCustCare,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle InputTextDec() {
    return TextStyle(
      color: Colors.white, // Sets the input text color to white.
      fontSize: Dimensions.dimenisonNo16,
      fontFamily: GoogleFonts.inter().fontFamily,
      fontWeight: FontWeight.w400,
    );
  }

  InputDecoration authTextBoxDec(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.white.withAlpha(128),
        fontSize: Dimensions.dimenisonNo16,
        fontFamily: GoogleFonts.inter().fontFamily,
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
      fillColor: const Color(0xFF262626),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo8),
        borderSide: const BorderSide(color: Color(0xFF404040), width: 1.0),
      ),
    );
  }
}
