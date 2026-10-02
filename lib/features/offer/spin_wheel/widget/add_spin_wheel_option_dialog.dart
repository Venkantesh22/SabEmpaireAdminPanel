import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';
import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:provider/provider.dart';

class AddSpinWheelOptionDialog extends StatefulWidget {
  const AddSpinWheelOptionDialog({
    super.key,
  });

  @override
  State<AddSpinWheelOptionDialog> createState() =>
      _AddSpinWheelOptionDialogState();
}

class _AddSpinWheelOptionDialogState
    extends State<AddSpinWheelOptionDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _timesController =
      TextEditingController();

  bool _isRewardCanCome = true;

  @override
  void dispose() {
    _titleController.dispose();
    _timesController.dispose();
    super.dispose();
  }

  Future<void> _addOption() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int? times = _timesController.text.trim().isEmpty
        ? null
        : int.tryParse(
            _timesController.text.trim(),
          );

    final SpinWheelOptionModel option =
        SpinWheelOptionModel(
      title: _titleController.text.trim(),
      howManyTimeComInMonth: times,
      isRewardCanCome: _isRewardCanCome,
    );

    final bool success = await context
        .read<SpinWheelProvider>()
        .addSpinWheelOption(option);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinWheelProvider>(
      builder: (context, provider, child) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add Spin & Bling Option',
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.spinWheelTitleColor,
            ),
          ),
          content: SizedBox(
            width: 430.w,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TITLE
                  TextFormField(
                    controller: _titleController,
                    enabled: !provider.isLoading,
                    decoration: InputDecoration(
                      labelText: 'Reward Title',
                      hintText: 'Example: 20% OFF',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter reward title';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // TIMES IN MONTH
                  TextFormField(
                    controller: _timesController,
                    enabled: !provider.isLoading,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'How Many Times in Month',
                      hintText: 'Example: 2',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return null;
                      }

                      final int? number =
                          int.tryParse(value.trim());

                      if (number == null) {
                        return 'Enter a valid number';
                      }

                      if (number <= 0) {
                        return 'Enter a number greater than 0';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // REWARD SWITCH
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius:
                          BorderRadius.circular(10.r),
                      border: Border.all(
                        color:
                            AppColor.spinWheelBorderColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reward Can Come',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight:
                                      FontWeight.w600,
                                  color:
                                      AppColor.spinWheelTitleColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Allow this option to be selected as a reward.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color:
                                      AppColor.spinWheelOffColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isRewardCanCome,
                          activeTrackColor:
                              AppColor.spinWheelOnTrackColor,
                          activeThumbColor:
                              AppColor.spinWheelOnColor,
                          onChanged: provider.isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _isRewardCanCome =
                                        value;
                                  });
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: provider.isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed:
                  provider.isLoading ? null : _addOption,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColor.buttonRedColor,
                foregroundColor: Colors.white,
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
                  : const Text('Add Option'),
            ),
          ],
        );
      },
    );
  }
}