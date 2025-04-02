import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final Color buttonColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.ontap,
    required this.buttonColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.dimenisonNo36,
      width: Dimensions.dimenisonNo200,
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsetsDirectional.symmetric(
              horizontal: Dimensions.dimenisonNo10),
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          // Text color
          side: const BorderSide(
            width: 1.5,
            // color: Colors.black,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            // color: Colors.black,
            fontSize: Dimensions.dimenisonNo14,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
        ),
      ),
    );
  }
}
