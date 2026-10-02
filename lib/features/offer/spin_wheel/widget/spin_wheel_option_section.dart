import 'package:admin_panel_ak/features/offer/spin_wheel/widget/add_spin_wheel_option_dialog.dart';
import 'package:admin_panel_ak/features/offer/spin_wheel/widget/spin_wheel_option_table.dart';
import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:provider/provider.dart';

class SpinWheelOptionSection extends StatelessWidget {
  const SpinWheelOptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinWheelProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading &&
            provider.spinWheelModel == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final options =
            provider.spinWheelModel?.spinWheelOptionModelList ?? [];

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Center(
                child: SizedBox
                (
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -----------------------------------------
                      // Header
                      // -----------------------------------------
                  
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Spin Wheel Options',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        AppColor.spinWheelTitleColor,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Manage rewards available on the Spin Wheel.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color:
                                        AppColor.spinWheelOffColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  
                          SizedBox(width: 20.w),
                  
                          ElevatedButton.icon(
                            onPressed: provider.isLoading
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) =>
                                          const AddSpinWheelOptionDialog(),
                                    );
                                  },
                            icon: Icon(
                              Icons.add,
                              size: 18.r,
                            ),
                            label: Text(
                              'Add Option',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColor.buttonRedColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 14.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                  
                      SizedBox(height: 24.h),
                  
                      // -----------------------------------------
                      // Error
                      // -----------------------------------------
                  
                      if (provider.errorMessage != null)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color:
                                AppColor.spinWheelLightRedColor,
                            borderRadius:
                                BorderRadius.circular(10.r),
                            border: Border.all(
                              color:
                                  const Color(0xFFFECACA),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color:
                                    AppColor.spinWheelErrorColor,
                                size: 20.r,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  provider.errorMessage!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF9F1239),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  
                      // -----------------------------------------
                      // Table
                      // -----------------------------------------
                  
                      if (options.isEmpty)
                        _EmptySpinWheelOptions()
                      else
                        SpinWheelOptionTable(
                          options: options,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptySpinWheelOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 60.h,
        horizontal: 24.w,
      ),
      decoration: BoxDecoration(
        color: AppColor.spinWheelCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.spinWheelBorderColor,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.casino_outlined,
              size: 30.r,
              color: AppColor.spinWheelOffColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Spin Wheel Options',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.spinWheelTitleColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Add your first reward option to the Spin Wheel.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColor.spinWheelOffColor,
            ),
          ),
        ],
      ),
    );
  }
}