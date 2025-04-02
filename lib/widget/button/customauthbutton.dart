// ignore_for_file: must_be_immutable

import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAuthButton extends StatefulWidget {
  final String text;
  final VoidCallback ontap;
  Color? bgColor;
  double? buttonWidth;
  CustomAuthButton({
    Key? key,
    required this.text,
    required this.ontap,
    this.bgColor = AppColor.buttonRedColor,
    this.buttonWidth = double.infinity,
  }) : super(key: key);

  @override
  State<CustomAuthButton> createState() => _CustomAuthButtonState();
}

class _CustomAuthButtonState extends State<CustomAuthButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: widget.ontap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo20),
        decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo30)),
        height: Dimensions.dimenisonNo40,
        width: widget.buttonWidth,
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.dimenisonNo16,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.25,
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:admin_panel_ak/utility/color.dart';
// import 'package:admin_panel_ak/utility/dimenison.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomAuthButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? ontap;
//   final Color? bgColor;
//   final double? buttonWidth;
//   final bool isLoading; // Added loading state

//   CustomAuthButton({
//     Key? key,
//     required this.text,
//     required this.ontap,
//     this.bgColor = AppColor.buttonRedColor,
//     this.buttonWidth = double.infinity,
//     this.isLoading = false, // Default to false
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: buttonWidth,
//       height: Dimensions.dimenisonNo40,
//       child: CupertinoButton(
//         onPressed: isLoading ? null : ontap, // Disable button if loading
//         padding: EdgeInsets.zero, // Removes unwanted padding
//         color: bgColor, // Button background color
//         borderRadius: BorderRadius.circular(Dimensions.dimenisonNo30),
//         child: isLoading
//             ? const CupertinoActivityIndicator(
//                 color: Colors.white) // Loading indicator
//             : Text(
//                 text,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: Dimensions.dimenisonNo16,
//                   fontFamily: GoogleFonts.roboto().fontFamily,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 1.25,
//                 ),
//               ),
//       ),
//     );
//   }
// }
