// ignore_for_file: must_be_immutable

import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  bool obscureForPassword = false;
  final TextInputType? keyboardType;
  int? maxline;
  String? label;
  CustomTextField({
    Key? key,
    required this.controller,
    required this.obscureForPassword,
    this.keyboardType,
    this.maxline = 1,
    this.label,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxline,
      cursorHeight: Dimensions.dimenisonNo16,
      obscureText: widget.obscureForPassword,
      style: const TextStyle(fontSize: 12),
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixIcon: widget.label == "Password"
            ? InkWell(
                onTap: () {
                  setState(() {
                    widget.obscureForPassword = !widget.obscureForPassword;
                  });
                },
                child: Icon(widget.obscureForPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
              )
            : null,
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your ${widget.label}';
        }
        return null;
      },
    );
  }
}

// Text field for Profile form
class FormCustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool requiredField;
  final bool readOnly;
  int? maxline;
  final String title;
  final String? hintText;

  FormCustomTextField({
    super.key,
    required this.controller,
    this.requiredField = true,
    this.maxline = 1,
    required this.title,
    this.readOnly = false,
    this.hintText,
  });

  @override
  State<FormCustomTextField> createState() => _FormCustomTextFieldState();
}

class _FormCustomTextFieldState extends State<FormCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.90,
                ),
              ),
              if (widget.requiredField)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: const Color(0xFFFC0000),
                    fontSize: Dimensions.dimenisonNo18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: Dimensions.dimenisonNo5,
        ),
        SizedBox(
          //salon description textbox has. max line.

          height: widget.maxline! < 2 ? Dimensions.dimenisonNo30 : null,
          child: TextFormField(
            readOnly: widget.readOnly,
            maxLines: widget.maxline,
            cursorHeight: Dimensions.dimenisonNo16,
            style: TextStyle(
                fontSize: Dimensions.dimenisonNo12,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  fontSize: Dimensions.dimenisonNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Dimensions.dimenisonNo10,
                  vertical: Dimensions.dimenisonNo10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Enter your ${widget.title}';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

// Text field for Profile form
class CustomTextFieldForWeekTime extends StatelessWidget {
  final TextEditingController controller;
  final bool requiredField;
  final bool readOnly;
  int? maxline;
  final String title;
  final String? hintText;

  CustomTextFieldForWeekTime({
    super.key,
    required this.controller,
    this.requiredField = true,
    this.maxline = 1,
    required this.title,
    this.readOnly = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //salon description textbox has. max line.

      height: maxline! < 2 ? Dimensions.dimenisonNo30 : null,
      child: TextFormField(
        readOnly: readOnly,
        maxLines: maxline,
        cursorHeight: Dimensions.dimenisonNo16,
        style: TextStyle(
            fontSize: Dimensions.dimenisonNo12,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: Dimensions.dimenisonNo12,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w200,
              color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo10,
              vertical: Dimensions.dimenisonNo10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
          ),
        ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Enter your $title';
          }
          return null;
        },
      ),
    );
  }
}
