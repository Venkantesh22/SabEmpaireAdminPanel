import 'package:admin_panel_ak/utility/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

Widget ratingBar(
  String starNo,
  double rating,
  String percentage,
  BuildContext context,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      textStar(starNo, context),
      Padding(
        padding: ResponsiveLayout.isMobile(context)
            ? EdgeInsets.symmetric(horizontal: 4)
            : EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo5),
        child: Icon(
          Icons.star,
          color: Colors.yellow,
          size: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimenisonNo14
              : Dimensions.dimenisonNo20,
        ),
      ),
      Expanded(
        child: LinearProgressIndicator(
          value: rating,
          backgroundColor: Colors.grey[300],
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo20),
          minHeight:
              ResponsiveLayout.isMobile(context) ? 4 : Dimensions.dimenisonNo8,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ),
      SizedBox(
        width: ResponsiveLayout.isMobile(context)
            ? Dimensions.dimenisonNo8
            : Dimensions.dimenisonNo16,
      ),
      SizedBox(
          width: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimenisonNo30
              : Dimensions.dimenisonNo50,
          child: Align(
              alignment: Alignment.centerRight,
              child: textStar("$percentage %", context))),
    ],
  );
}

Text textStar(String text, BuildContext context) {
  return Text(text,
      style: TextStyle(
        fontSize: ResponsiveLayout.isMobile(context)
            ? Dimensions.dimenisonNo10
            : Dimensions.dimenisonNo18,
        fontWeight: ResponsiveLayout.isMobile(context)
            ? FontWeight.w400
            : FontWeight.bold,
        fontFamily: GoogleFonts.poppins().fontFamily,
        color: Colors.black,
      ));
}
