import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatergryButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const CatergryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<CatergryButton> createState() => _CatergryButtonState();
}

class _CatergryButtonState extends State<CatergryButton> {
  bool _isHovering = false;

  Color get _backgroundColor {
    if (widget.isSelected) {
      return const Color.fromARGB(255, 130, 128, 128).withOpacity(0.7);
    } else if (_isHovering) {
      return const Color.fromARGB(255, 209, 207, 207).withOpacity(0.1);
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
        ),
        margin: const EdgeInsets.all(3),
        child: ListTile(
          onTap: widget.onTap,
          // trailing: CupertinoButton(
          //   padding: EdgeInsets.zero,
          //   onPressed: () {},
          //   child: Container(
          //     width: Dimensions.dimenisonNo24,
          //     height: Dimensions.dimenisonNo24,
          //     decoration: BoxDecoration(
          //         borderRadius:
          //             BorderRadius.circular(Dimensions.dimenisonNo100),
          //         border: Border.all(color: Colors.red, width: 2)),
          //     child: Icon(Icons.add,
          //         color: Colors.red, size: Dimensions.dimenisonNo18),
          //   ),
          // ),
          title:
              // CupertinoButton(
              //   padding: EdgeInsets.zero,
              //   onPressed: widget.onTap,
              //   child:
              Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.dimenisonNo16,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
            // ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }
}
