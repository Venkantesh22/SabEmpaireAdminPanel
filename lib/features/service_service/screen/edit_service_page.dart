// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/models/category_model/category_model.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/customauthbutton.dart';
import 'package:admin_panel_ak/widget/text_box/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditServicePage extends StatefulWidget {
  final int index;
  final ServiceModel serviceModel;
  final CategoryModel categoryModel;
  const EditServicePage({
    Key? key,
    required this.index,
    required this.serviceModel,
    required this.categoryModel,
  }) : super(key: key);

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  String? _serviceFor;
  @override
  // void initState() {
  //   super.initState();
  //   _serviceFor = widget.serviceModel.serviceFor;
  // }

  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = Provider.of<AppProvider>(context);
    Duration? serviceDuration =
        Duration(minutes: widget.serviceModel.serviceDurationMin);
    int _serviceDurationInHr = serviceDuration.inHours;
    int _serviceDurationInMin = serviceDuration.inMinutes % 60;

    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    final TextEditingController _serviceController =
        TextEditingController(text: widget.serviceModel.servicesName);

    final TextEditingController _priceController =
        TextEditingController(text: widget.serviceModel.price.toString());

    final TextEditingController _hoursController =
        TextEditingController(text: _serviceDurationInHr.toString());
    final TextEditingController _minController =
        TextEditingController(text: _serviceDurationInMin.toString());
    final TextEditingController _orderAtController =
        TextEditingController(text: widget.serviceModel.order.toString());

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          // color: Colors.grey,
          color: AppColor.whiteColor,
          child: Container(
            alignment: Alignment.topLeft,
            width: Dimensions.screenWidth / 1.5,
            // margin: EdgeInsets.only(top: Dimensions.dimenisonNo30),
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimenisonNo30,
                vertical: Dimensions.dimenisonNo30),
            decoration: const BoxDecoration(
              // color: Colors.green,
              color: Colors.white,
              // borderRadius: BorderRadius.circular(Dimensions.dimenisonNo20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Update ${widget.serviceModel.servicesName} Service ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo24,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),
                FormCustomTextField(
                    controller: _serviceController, title: "Service name"),
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),

                // Price fields: Original Price, Discount Percentage, and Final Price.
                SizedBox(
                  width: Dimensions.dimenisonNo200,
                  child: FormCustomTextField(
                    requiredField: false,
                    controller: _priceController,
                    title: "Final Price",
                  ),
                ),
                SizedBox(height: Dimensions.dimenisonNo10),
                SizedBox(
                  width: Dimensions.dimenisonNo200,
                  child: FormCustomTextField(
                    controller: _orderAtController,
                    title: "Order",
                  ),
                ),
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time Duration Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time duration',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: Dimensions.dimenisonNo10),
                            HeadingText('Timing'),
                            SizedBox(width: Dimensions.dimenisonNo10),
                            SizedBox(
                              height: Dimensions.dimenisonNo30,
                              width: Dimensions.dimenisonNo50,
                              child: _TextFormTime(" HH ", _hoursController),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo10),
                              child: Text(
                                ':',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimenisonNo20,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.dimenisonNo30,
                              width: Dimensions.dimenisonNo50,
                              child: _TextFormTime(" MM ", _minController),
                            ),
                            SizedBox(width: Dimensions.dimenisonNo10),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimenisonNo10),

                CustomAuthButton(
                  text: "Save",
                  ontap: () async {
                    try {
                      showLoaderDialog(context);
                      bool isVaildated = addNewServiceVaildation(
                          _serviceController.text.trim(),
                          _priceController.text.trim(),
                          _hoursController.text.trim(),
                          _minController.text.trim(),
                          int.parse(_orderAtController.text.trim()),
                          context);

                      if (isVaildated) {
                        Duration? _serviceDurationMin = Duration(
                            hours: int.parse(_hoursController.text.trim()),
                            minutes: int.parse(_minController.text.trim()));
                        ServiceModel serviceModel =
                            widget.serviceModel.copyWith(
                          servicesName: _serviceController.text.trim(),
                          price: double.parse(_priceController.text.trim()),
                          serviceDurationMin: _serviceDurationMin.inMinutes,
                          order: int.parse(_orderAtController.text.trim()),
                        );

                        serviceProvider.updateSingleServicePro(
                            serviceModel, widget.categoryModel.id);
                      }
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();

                      showMessage(
                          "Successfully updated ${widget.serviceModel.servicesName} service");
                    } catch (e) {
                      showMessage("Error not updated  service");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom heading text widget for consistency
  Text HeadingText(String heading) {
    return Text(
      heading,
      style: TextStyle(
        color: Colors.black,
        fontSize: Dimensions.dimenisonNo18,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
    );
  }

  // Custom TextFormField for time input
  TextFormField _TextFormTime(
      String hintText, TextEditingController controller) {
    return TextFormField(
      cursorHeight: Dimensions.dimenisonNo16,
      style: TextStyle(
        fontSize: Dimensions.dimenisonNo12,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: Dimensions.dimenisonNo12,
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontWeight: FontWeight.bold,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo10,
          vertical: Dimensions.dimenisonNo10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
        ),
      ),
    );
  }
}
