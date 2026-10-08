import 'package:admin_panel_ak/features/offer/spin_wheel/widget/spin_wheel_appbar.dart';
import 'package:admin_panel_ak/features/offer/spin_wheel/widget/spin_wheel_code_section.dart';
import 'package:admin_panel_ak/features/offer/spin_wheel/widget/spin_wheel_option_section.dart';
import 'package:admin_panel_ak/features/offer/spin_wheel_winner_section/spin_wheel_winner_section.dart';
import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() =>
      _SpinWheelScreenState();
}

class _SpinWheelScreenState
    extends State<SpinWheelScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final SpinWheelProvider provider =
          context.read<SpinWheelProvider>();

      provider.loadSpinWheel();

      provider.loadSpinWheelWinners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:
          AppColor.spinWheelBackgroundColor,
      appBar: SpinWheelScreenAppbar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SpinWheelCodeSection(),

            SizedBox(height: 24),

            SpinWheelOptionSection(),

            SizedBox(height: 24),

            SpinWheelWinnerSection(),
          ],
        ),
      ),
    );
  }
}