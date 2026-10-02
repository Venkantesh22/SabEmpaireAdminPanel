import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:provider/provider.dart';

class SpinWheelCodeSection extends StatefulWidget {
  const SpinWheelCodeSection({super.key});

  @override
  State<SpinWheelCodeSection> createState() =>
      _SpinWheelCodeSectionState();
}

class _SpinWheelCodeSectionState
    extends State<SpinWheelCodeSection> {
  final TextEditingController _codeController =
      TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinWheelProvider>(
      builder: (context, provider, child) {
        // Load current code into textbox.
        if (_codeController.text.isEmpty &&
            provider.spinWheelModel != null) {
          _codeController.text =
              provider.spinWheelModel!.code;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColor.spinWheelCardColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColor.spinWheelBorderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spin & Bling Code',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.spinWheelTitleColor,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                'Users will need this code to participate in the Spin & Bling offer.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.spinWheelOffColor,
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      textCapitalization:
                          TextCapitalization.characters,
                      enabled: !provider.isLoading,
                      decoration: InputDecoration(
                        labelText: 'Offer Code',
                        hintText: 'Enter offer code',
                        prefixIcon: Icon(
                          Icons.confirmation_number_outlined,
                          size: 21.r,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color:
                                AppColor.spinWheelBorderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.r),
                          borderSide: const BorderSide(
                            color:
                                AppColor.buttonRedColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final String code =
                                  _codeController.text.trim();

                              if (code.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter offer code',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Call provider method here.
                              await provider.updateSpinWheelCode(
                                code,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColor.buttonRedColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.r),
                        ),
                      ),
                      child: provider.isLoading
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child:
                                  const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}