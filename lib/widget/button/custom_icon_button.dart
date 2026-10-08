
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomIconButton extends StatelessWidget {
  final FaIconData? icon;
  final VoidCallback? ontap;
  final double iconSize;

  const CustomIconButton({
    super.key,
    this.icon,
    this.ontap,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: ontap,
      icon: FaIcon(
        icon,
        size: iconSize,
        color: Colors.black,
      ),
    );
  }
}