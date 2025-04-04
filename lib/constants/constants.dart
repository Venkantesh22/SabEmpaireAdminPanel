import 'dart:typed_data';

import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

// final bool emailValid =
// RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//   .hasMatch(email);

void showBottonMessageError(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

void showBottonMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}

void showMessage(String message) {
  Fluttertoast.showToast(
    webPosition: "center",
    msg: message,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    fontSize: Dimensions.dimenisonNo16,
  );
}

// Function to show a message Delete
void showDeleteAlertDialog(
    BuildContext context, String title, message, VoidCallback ontap) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
              fontSize: Dimensions.dimenisonNo24, fontWeight: FontWeight.w600),
        ),
        // content:  Text('The salon is closed on the selected date.'),
        content: Text(
          message,
          style: TextStyle(
              fontSize: Dimensions.dimenisonNo16, color: Colors.black),
        ),
        actions: [
          SizedBox(
            height: Dimensions.dimenisonNo20,
          ),
          SizedBox(
            height: Dimensions.dimenisonNo36,
            child: Row(
              children: [
                CustomButton(
                  buttonColor: Colors.white,
                  text: "No",
                  ontap: () {
                    Navigator.pop(context);
                  },
                  textColor: Colors.black,
                ),
                Spacer(),
                CustomButton(buttonColor: Colors.red, text: "Yes", ontap: ontap)
              ],
            ),
          )
        ],
      );
    },
  );
}

showLoaderDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevent dismissing the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColor.whiteColor,
        content: SizedBox(
          height: Dimensions.dimenisonNo40,
          width: Dimensions.dimenisonNo200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: Dimensions.dimenisonNo20),
              const CircularProgressIndicator(
                color: Color(0xffe16555),
              ),
              SizedBox(width: Dimensions.dimenisonNo18),
              Container(
                margin: EdgeInsets.only(left: Dimensions.dimenisonNo10),
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Function to show a message
void showInforAlertDialog(
  BuildContext context,
  String title,
  message,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
              fontSize: Dimensions.dimenisonNo24, fontWeight: FontWeight.w600),
        ),
        // content:  Text('The salon is closed on the selected date.'),
        content: Text(
          message,
          style: TextStyle(
              fontSize: Dimensions.dimenisonNo16, color: Colors.black),
        ),
        actions: [
          CustomButton(
            buttonColor: Colors.green,
            text: "OK",
            ontap: () {
              Navigator.pop(context);
            },
            textColor: Colors.white,
          )
        ],
      );
    },
  );
}

// Add new Super Category popup Text Field Validation.
bool addNewSuperCategoryVaildation(
  String superCategoryName,
  int order,
  BuildContext context,
) {
  if (superCategoryName.isEmpty) {
    showBottonMessageError("Enter a Super-Category Name", context);
    return false;
  } else if (order is! int) {
    showBottonMessageError("Order must be an integer", context);
    return false;
  } else if (order <= 0) {
    showBottonMessageError("Order must be a positive integer", context);
    return false;
  } else {
    return true;
  }
}

// Add new Category popup Text Field Validation.

bool addNewCategoryVaildation(
  String categoryName,
  int order,
  BuildContext context,
) {
  if (categoryName.isEmpty) {
    showMessage("Enter a Category Name");
    return false;
  } else if (order is! int) {
    showBottonMessageError("Order must be an integer", context);
    return false;
  } else if (order <= 0) {
    showBottonMessageError("Order must be a positive integer", context);
    return false;
  } else {
    return true;
  }
}

// Add new Service popup Text Field Validation.
bool addNewServiceVaildation(
  final String servicesName,
  final String price,
  final String hours,
  final String minutes,
  int order,
  BuildContext context,
) {
  final double? min = double.tryParse(minutes);
  final double? hr = double.tryParse(minutes);
  final double? pr = double.tryParse(price);

  if (servicesName.isEmpty &&
      price.isEmpty &&
      hours.isEmpty &&
      minutes.isEmpty) {
    showMessage("All Fields are empty");
    return false;
  } else if (servicesName.isEmpty) {
    showMessage("Enter a Service Name");
    return false;
  } else if (price.isEmpty) {
    showMessage("Enter a Price");
    return false;
  } else if (pr == null || pr < 0) {
    showMessage("Enter a Price");
    return false;
  } else if (hours.isEmpty) {
    showMessage("Enter a Hours");
    return false;
  } else if (hr == null || hr < 0) {
    showMessage("Enter a correct hours.");
    return false;
  } else if (minutes.isEmpty) {
    showMessage("Enter a Minutes");
    return false;
  } else if (min == null || min < 0 || min > 59) {
    showMessage("Enter a correct minute.");
    return false;
  } else if (order is! int) {
    showBottonMessageError("Order must be an integer", context);
    return false;
  } else if (order <= 0) {
    showBottonMessageError("Order must be a positive integer", context);
    return false;
  } else {
    return true;
  }
}

//! Add new Category popup Text Field Validation.
bool imageAndNameValidation(
  String imageName,
  Uint8List image,
) {
  if (imageName.isEmpty && image.isEmpty) {
    showMessage("Both Fields are empty");
    return false;
  } else if (imageName.isEmpty) {
    showMessage("Enter a Category Name");
    return false;
  } else {
    return true;
  }
}

// Add new Appointment Text Field Validation.
bool addNewAppointmentVaildation(
  final String name,
  final String lastName,
  final String number,
) {
  if (name.isEmpty && lastName.isEmpty && number.isEmpty) {
    showMessage("All Fields are empty");
    return false;
  } else if (name.isEmpty) {
    showMessage("Enter First Name");
    return false;
  } else if (lastName.isEmpty) {
    showMessage("Enter Last Name");
    return false;
  } else if (number.isEmpty) {
    showMessage("Enter Phone Number");
    return false;
  } else if (number.length != 10) {
    showMessage("Enter 10 digit mobile number.");
    return false;
  } else if (!RegExp(r'^\d+$').hasMatch(number)) {
    showMessage('Please enter only digits in Mobile');
    return false;
  } else {
    return true;
  }
}
