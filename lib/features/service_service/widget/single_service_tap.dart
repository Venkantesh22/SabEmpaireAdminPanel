import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/service_service/screen/edit_service_page.dart';
import 'package:admin_panel_ak/models/category_model/category_model.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SingleServiceTap extends StatelessWidget {
  final ServiceModel serviceModel;
  final CategoryModel categoryModel;
  final int index;
  const SingleServiceTap({
    Key? key,
    required this.serviceModel,
    required this.categoryModel,
    required this.index,
  }) : super(key: key);

  /// Navigates to the edit service page.
  void _navigateToEditService(BuildContext context) {
    Routes.instance.push(
      widget: EditServicePage(
        index: index,
        serviceModel: serviceModel,
        categoryModel: categoryModel,
      ),
      context: context,
    );
  }

  /// Shows a delete confirmation dialog and, if confirmed, deletes the service.
  void _confirmDelete(BuildContext context, ServiceProvider serviceProvider) {
    showDeleteAlertDialog(
      context,
      "Delete Service",
      "Do you want to delete ${serviceModel.servicesName} Service?",
      () async {
        try {
          await serviceProvider.deletelSingleServicePro(
            serviceModel,
            categoryModel.id,
          );
          Navigator.of(context, rootNavigator: true).pop();
          showMessage("Successfully deleted ${serviceModel.servicesName}");
        } catch (e) {
          Navigator.of(context, rootNavigator: true).pop();
          showMessage(
              "Error deleting ${serviceModel.servicesName}: ${e.toString()}");
          print("Error deleting ${serviceModel.servicesName}: ${e.toString()}");
        }
      },
    );
  }

  /// Builds the service information column.
  Widget _buildServiceInfo(Duration serviceDuration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Shrink wrap content vertically
      children: [
        Text(
          "${serviceModel.order}.${serviceModel.servicesName}",
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.dimenisonNo20,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.04,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: Dimensions.dimenisonNo10, top: Dimensions.dimenisonNo5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "₹${serviceModel.price}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo16,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
              SizedBox(width: Dimensions.dimenisonNo20),
              Icon(
                Icons.watch_later_outlined,
                size: Dimensions.dimenisonNo16,
              ),
              SizedBox(width: Dimensions.dimenisonNo10),
              Text(
                "${serviceDuration.inHours}h: ${(serviceDuration.inMinutes % 60).toString().padLeft(2, '0')}min",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo16,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final serviceDuration = Duration(minutes: serviceModel.serviceDurationMin);

    return Container(
      padding: EdgeInsets.all(Dimensions.dimenisonNo10),
      // No fixed width specified; container will shrink to fit its content.
      child: Container(
        margin: EdgeInsets.only(right: Dimensions.dimenisonNo10),
        padding: EdgeInsets.all(Dimensions.dimenisonNo10),
        decoration: ShapeDecoration(
          color: AppColor.whiteColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Shrink wrap content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with service info and action buttons.
            Column(
              children: [
                Row(
                  children: [
                    _buildServiceInfo(serviceDuration),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _navigateToEditService(context),
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _confirmDelete(context, serviceProvider),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                serviceModel.description != null
                    ? SizedBox(
                        height: Dimensions.dimenisonNo5,
                      )
                    : const SizedBox(),
                serviceModel.description != null
                    ? const Divider()
                    : const SizedBox(),
                serviceModel.description != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.dimenisonNo8),
                        child: Text(
                          serviceModel.description!,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo14,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
