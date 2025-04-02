import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  // colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainColor),
  scaffoldBackgroundColor: Colors.white,
  primaryColor: AppColor.primaryBlackColor,
  // canvasColor: AppColor.canvasColor,
  // scaffoldBackgroundColor: AppColor.scaffoldBackgroundColor,
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(
        color: Colors.black,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
  ),
);
