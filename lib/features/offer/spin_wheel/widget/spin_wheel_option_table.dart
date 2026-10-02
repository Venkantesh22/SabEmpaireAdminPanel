import 'package:admin_panel_ak/features/offer/spin_wheel/widget/edit_spin_wheel_option_dialog.dart';
import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';
import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:provider/provider.dart';

class SpinWheelOptionTable extends StatelessWidget {
  final List<SpinWheelOptionModel> options;

  const SpinWheelOptionTable({
    super.key,
    required this.options,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.spinWheelCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.spinWheelBorderColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: DataTable(
                  headingRowHeight: 54.h,
                  dataRowMinHeight: 64.h,
                  dataRowMaxHeight: 72.h,
                  horizontalMargin: 20.w,
                  columnSpacing: 30.w,
                  headingTextStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.spinWheelTitleColor,
                  ),
                  columns: const [
                    DataColumn(
                      label: Text('Sr.No'),
                    ),
                    DataColumn(
                      label: Text('Title'),
                    ),
                    DataColumn(
                      label: Text('Per month'),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),
                    DataColumn(
                      label: Text('Delete'),
                    ),
                  ],
                  rows: List.generate(
                    options.length,
                    (index) {
                      final SpinWheelOptionModel option = options[index];

                      return DataRow(
                        cells: [
                          // Sr.No
                          DataCell(
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.serviceTapTextColor,
                              ),
                            ),
                          ),

                          // Title
                          DataCell(
                            GestureDetector(
                              onDoubleTap: () {
                                _showEditDialog(
                                  context,
                                  option,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      option.title?.isNotEmpty == true
                                          ? option.title!
                                          : '-',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.spinWheelTitleColor,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 14.r,
                                      color: AppColor.spinWheelOffColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Per month
                          DataCell(
                            GestureDetector(
                              onDoubleTap: () {
                                _showEditDialog(
                                  context,
                                  option,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 7.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  option.howManyTimeComInMonth?.toString() ??
                                      'Unlimited',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.serviceTapTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Active
                          DataCell(
                            Consumer<SpinWheelProvider>(
                              builder: (context, provider, child) {
                                final bool isReward =
                                    option.isRewardCanCome ?? true;

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isReward ? 'ON' : 'OFF',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isReward
                                            ? AppColor.spinWheelOnColor
                                            : AppColor.spinWheelOffColor,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Switch(
                                      value: isReward,
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
                                              final updatedOption =
                                                  SpinWheelOptionModel(
                                                id: option.id,
                                                title: option.title,
                                                isRewardCanCome: value,
                                                howManyTimeComInMonth: option
                                                    .howManyTimeComInMonth,
                                              );

                                              await provider
                                                  .updateSpinWheelOption(
                                                updatedOption,
                                              );
                                            },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          // Delete
                          DataCell(
                            IconButton(
                              tooltip: 'Delete option',
                              onPressed: () {
                                _showDeleteConfirmation(
                                  context,
                                  option,
                                );
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                size: 21.r,
                                color: AppColor.spinWheelErrorColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    SpinWheelOptionModel option,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditSpinWheelOptionDialog(
        option: option,
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    SpinWheelOptionModel option,
  ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Option'),
          content: Text(
            'Are you sure you want to delete '
            '"${option.title ?? 'this option'}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.spinWheelErrorColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    if (option.id == null || option.id!.isEmpty) {
      return;
    }

    if (!context.mounted) return;

    await context.read<SpinWheelProvider>().deleteSpinWheelOption(option.id!);
  }
}
