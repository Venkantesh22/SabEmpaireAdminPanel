import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';

class DashBordAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DashBordAppBar({super.key});

  @override
  State<DashBordAppBar> createState() => _LoadAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _LoadAppBarState extends State<DashBordAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primaryBlackColor,
      iconTheme: IconThemeData(color: Colors.white),
      title: Padding(
        padding: EdgeInsets.all(Dimensions.dimenisonNo5),
        child: Image.asset(
          GlobalVariable.LogWithOutBeuText,

          height: Dimensions.dimenisonNo50,
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.high, // Ensures high-quality scaling
        ),
      ),
    );
  }
}
