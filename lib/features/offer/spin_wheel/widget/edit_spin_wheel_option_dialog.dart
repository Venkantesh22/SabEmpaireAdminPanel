import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';
import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:provider/provider.dart';

class EditSpinWheelOptionDialog extends StatefulWidget {
  final SpinWheelOptionModel option;

  const EditSpinWheelOptionDialog({
    super.key,
    required this.option,
  });

  @override
  State<EditSpinWheelOptionDialog> createState() =>
      _EditSpinWheelOptionDialogState();
}

class _EditSpinWheelOptionDialogState extends State<EditSpinWheelOptionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _timesController;late final TextEditingController _availableController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.option.title ?? '',
    );

    _timesController = TextEditingController(
      text: widget.option.howManyTimeComInMonth?.toString() ?? '',
    );

    _availableController = TextEditingController(
  text: widget.option.howAvailableInMonth?.toString() ?? '',
);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timesController.dispose();
    _availableController.dispose();
    super.dispose();
  }

  Future<void> _updateOption() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String title = _titleController.text.trim();

    final String timesText = _timesController.text.trim();

    final int? times = timesText.isEmpty ? null : int.tryParse(timesText);
    final int? available = _availableController.text.isEmpty ? null : int.tryParse(_availableController.text);
    
    if (times != null &&
      available != null &&
      available > times) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Available in month cannot be greater than Per month.',
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    return;
  }
    final SpinWheelOptionModel updatedOption = SpinWheelOptionModel(
      id: widget.option.id,
      title: title,
      isRewardCanCome: widget.option.isRewardCanCome ?? true,
      howManyTimeComInMonth: times,
      howAvailableInMonth: available
    );

    final bool success = await context
        .read<SpinWheelProvider>()
        .updateSpinWheelOption(updatedOption);

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
            'Edit Spin & Bling Option',
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
                  TextFormField(
                    controller: _titleController,
                    enabled: !provider.isLoading,
                    decoration: InputDecoration(
                      labelText: 'Reward Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter reward title';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _timesController,
                    enabled: !provider.isLoading,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'How Many Times in Month',
                      hintText: 'Leave empty for unlimited',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }

                      final int? number = int.tryParse(value.trim());

                      if (number == null) {
                        return 'Enter a valid number';
                      }

                      if (number <= 0) {
                        return 'Enter a number greater than 0';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _availableController,
                    enabled: !provider.isLoading,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Available This Month',
                      hintText: 'Example: 2',
                      helperText:
                          'Remaining times this reward can be won this month',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }

                      final int? number = int.tryParse(value.trim());

                      if (number == null) {
                        return 'Enter a valid number';
                      }

                      if (number < 0) {
                        return 'Cannot be negative';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18.r,
                          color: AppColor.spinWheelOffColor,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Use the Reward switch in the table to enable or disable this option.',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColor.spinWheelOffColor,
                            ),
                          ),
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
              onPressed: provider.isLoading ? null : _updateOption,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttonRedColor,
                foregroundColor: Colors.white,
              ),
              child: provider.isLoading
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
