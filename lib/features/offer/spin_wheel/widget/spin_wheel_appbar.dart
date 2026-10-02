import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:provider/provider.dart';

class SpinWheelScreenAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const SpinWheelScreenAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.spinWheelAppBarColor,
      elevation: 0,
      surfaceTintColor: AppColor.spinWheelAppBarColor,

      title: Text(
        'Spin & Bling',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.spinWheelTitleColor,
        ),
      ),

      actions: [
        Consumer<SpinWheelProvider>(
          builder: (context, provider, child) {
            final bool isLive =
                provider.spinWheelModel?.isOfferIsLive ?? false;

            return Padding(
              padding: EdgeInsets.only(
                right: 20.w,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLive ? 'ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isLive
                          ? AppColor.spinWheelOnColor
                          : AppColor.spinWheelOffColor,
                    ),
                  ),

                  SizedBox(width: 8.w),

                  Switch(
                    value: isLive,
                    activeTrackColor:
                        AppColor.spinWheelOnTrackColor,
                    activeThumbColor:
                        AppColor.spinWheelOnColor,
                    inactiveTrackColor:
                        AppColor.spinWheelOffTrackColor,
                    inactiveThumbColor:
                        AppColor.spinWheelOffColor,

                    onChanged: provider.isLoading
                        ? null
                        : (value) async {
                            if (value) {
                              await provider.turnOnSpinWheel();
                            } else {
                              await provider.turnOffSpinWheel();
                            }
                          },
                  ),

                  if (provider.isLoading)
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.w,
                      ),
                      child: SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),

                  SizedBox(width: 4.w),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}