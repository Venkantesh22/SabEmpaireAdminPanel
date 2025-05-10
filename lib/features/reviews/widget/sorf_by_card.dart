import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/utility/responsive_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoButton sortByCard(String sortText, VoidCallback ontap, bool isSelected,
    BuildContext context) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: ontap,
    child: Card(
      margin: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo12,
              vertical: Dimensions.dimenisonNo8)
          : EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo16,
              vertical: Dimensions.dimenisonNo8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(Dimensions.dimenisonNo8), // Border radius
        side: BorderSide(
          color: isSelected ? Colors.red : Colors.grey, // Border color
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo16, // Horizontal padding
          vertical: Dimensions.dimenisonNo8, // Vertical padding
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimenisonNo16
                  : Dimensions.dimenisonNo18,
              color: isSelected ? Colors.red : Colors.grey, // Icon color
            ),
            SizedBox(
              width: Dimensions.dimenisonNo5,
            ),
            Text(
              sortText,
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimenisonNo14
                    : Dimensions.dimenisonNo16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.red : Colors.grey, // Text color
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
