// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/auth/screen/signup.dart';
import 'package:admin_panel_ak/features/dastbord/dastbord.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:admin_panel_ak/features/footer_section/screen/footer.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LogingPage extends StatefulWidget {
  LogingPage({super.key});

  @override
  State<LogingPage> createState() => _LogingPageState();

  static const String homeDashBord = '/login';
}

class _LogingPageState extends State<LogingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDate();
  }

  bool isloading = false;
  bool saveloading = false;
  Future<void> getDate() async {
    setState(() {
      isloading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.fatchFooterInfor();

    setState(() {
      isloading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();

  String email = '';

  String password = '';

  bool _obscureText = true; // Add this state variable

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.primaryBlackColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryBlackColor,
        title: Padding(
          padding: EdgeInsets.all(Dimensions.dimenisonNo5),
          child: Image.asset(
            'assets/images/sabWithBea.jpg',
            height: Dimensions.dimenisonNo50,
            fit: BoxFit.fitWidth,
            filterQuality: FilterQuality.high, // Ensures high-quality scaling
          ),
        ),
      ),

      // You can adjust the background color or add an image as needed.
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
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
                                  Dimensions.dimenisonNo30),
                              child: SizedBox(
                                width: Dimensions.screenWidth / 2.5,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          height: Dimensions.dimenisonNo16),
                                      Text(
                                        'Admin Panel Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions.dimenisonNo30,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.20,
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimensions.dimenisonNo24),

                                      // Email field
                                      TextFormField(
                                        style: InputTextDec(),
                                        decoration: authTextBoxDec('Email'),
                                        onChanged: (value) => email = value,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          // Simple email validation
                                          if (!RegExp(r'\S+@\S+\.\S+')
                                              .hasMatch(value)) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                          height: Dimensions.dimenisonNo16),
                                      // Password field
                                      TextFormField(
                                        style: InputTextDec(),
                                        decoration:
                                            authTextBoxDec('Password').copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color:
                                                  Colors.white.withAlpha(128),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                        ),
                                        obscureText: _obscureText,
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
                                      SizedBox(
                                          height: Dimensions.dimenisonNo16),

                                      // Sign Up button
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: saveloading
                                              ? null
                                              : () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      saveloading = true;
                                                    });
                                                    try {
                                                      // If the form is valid, navigate to the home page.
                                                      bool isLogined =
                                                          await FirebaseAuthHelper
                                                              .instance
                                                              .login(
                                                                  email,
                                                                  password,
                                                                  context);

                                                      if (isLogined) {
                                                        print(
                                                            'login Successful for:  $email');
                                                        Routes.instance
                                                            .pushAndRemoveUntil(
                                                                widget:
                                                                    HomeDashBord(),
                                                                context:
                                                                    context);
                                                      }
                                                    } catch (e) {
                                                      if (!mounted) return;
                                                      showBottonMessageError(
                                                          "Error: ${e.toString()}",
                                                          context);
                                                    } finally {
                                                      setState(() {
                                                        saveloading = false;
                                                      });
                                                    }
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    Dimensions.dimenisonNo16),
                                            backgroundColor:
                                                AppColor.buttonRedColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.dimenisonNo12),
                                            ), // Match this with your Figma button color
                                          ),
                                          child: saveloading
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Dimensions
                                                        .dimenisonNo16,
                                                    fontFamily:
                                                        GoogleFonts.inter()
                                                            .fontFamily,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.50,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: Dimensions.dimenisonNo16),
                                      // Navigation to Login Page
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Don't have an account? ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  Dimensions.dimenisonNo16,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                              height: 1.50,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Routes.instance.push(
                                                  widget: SignupPage(),
                                                  context: context);
                                            },
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                color: AppColor.buttonRedColor,
                                                fontSize:
                                                    Dimensions.dimenisonNo16,
                                                fontFamily: GoogleFonts.inter()
                                                    .fontFamily,
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
                        Footer(footerModel: appProvider.getFooterModel)
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  TextStyle InputTextDec() {
    return TextStyle(
      color: Colors.white, // Sets the input text color to white
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
      fillColor: Color(0xFF262626),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo8),
        borderSide: BorderSide(color: Color(0xFF404040), width: 1.0),
      ),
    );
  }
}
