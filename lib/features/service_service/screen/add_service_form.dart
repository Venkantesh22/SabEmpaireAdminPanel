import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/models/category_model/category_model.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/customauthbutton.dart';
import 'package:admin_panel_ak/widget/text_box/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddServiceForm extends StatefulWidget {
  final CategoryModel categoryModel;
  const AddServiceForm({
    Key? key,
    required this.categoryModel,
  }) : super(key: key);

  @override
  State<AddServiceForm> createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  // TextEditingControllers for form fields
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _priceController =
      TextEditingController(); // Final price after discount

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add listeners to recalculate final price when original price or discount percentage changes.
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _priceController.dispose();
    _hoursController.dispose();
    _minController.dispose();
    super.dispose();
  }

  // Function to update final price based on original price and discount percentage.
  // void _updateFinalPrice() {
  //   double originalPrice =
  //       double.tryParse(_originalPriceController.text) ?? 0.0;
  //   double discountPercentage = double.tryParse(_discountInPer.text) ?? 0.0;
  //   double finalPrice =
  //       originalPrice - (originalPrice * discountPercentage / 100);
  //   // Update the final price controller's text (formatted to two decimals).
  //   _priceController.text = finalPrice.toStringAsFixed(2);
  // }

  // void discountAmountFun() {
  //   discountAmount = double.tryParse(_originalPriceController.text)! -
  //       double.tryParse(_priceController.text)!;
  // }

  @override
  Widget build(BuildContext context) {
    // Retrieve providers if needed
    // final appProvider = Provider.of<AppProvider>(context);
    // final serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        child: Container(
          width: Dimensions.screenWidth / 1.5,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.dimenisonNo30,
            vertical: Dimensions.dimenisonNo30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and close button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add New Service in ${widget.categoryModel.categoryName} Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo24,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: Dimensions.dimenisonNo20),
              // Service Name field
              FormCustomTextField(
                controller: _serviceController,
                title: "Service name",
              ),
              SizedBox(height: Dimensions.dimenisonNo20),
              // Service Code field

              // Price fields: Original Price, Discount Percentage, and Final Price.
              SizedBox(
                width: Dimensions.dimenisonNo200,
                child: FormCustomTextField(
                  controller: _priceController,
                  title: "Price",
                ),
              ),
              SizedBox(
                height: Dimensions.dimenisonNo20,
              ),
              // Time duration and Service For fields
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
                  // SizedBox(width: Dimensions.dimenisonNo30),
                  // Service For Dropdown Column
                ],
              ),
              SizedBox(height: Dimensions.dimenisonNo10),

              // Service Description field

              // Save Button with error handling and loader management
              CustomAuthButton(
                text: "Save",
                ontap: () async {
                  // Show loader dialog
                  showLoaderDialog(context);
                  try {
                    // Validate form fields
                    bool isValidated = addNewServiceVaildation(
                      _serviceController.text,
                      _priceController.text,
                      _hoursController.text,
                      _minController.text,
                    );

                    if (!isValidated) {
                      showMessage("Please fill all required fields correctly.");
                      return;
                    }

                    // Retrieve provider data
                    // final appProvider =
                    //     Provider.of<AppProvider>(context, listen: false);
                    final serviceProvider =
                        Provider.of<ServiceProvider>(context, listen: false);

                    // Add new service via provider method
                    await serviceProvider.addSingleServicePro(
                      widget.categoryModel.id,
                      widget.categoryModel.categoryName,
                      _serviceController.text.trim(),
                      double.parse(_priceController.text.trim()),
                      int.parse(_hoursController.text.trim()),
                      int.parse(_minController.text.trim()),
                    );

                    // Update category status if required
                    if (widget.categoryModel.haveData == false) {
                      final updatedCategory =
                          widget.categoryModel.copyWith(haveData: true);
                      serviceProvider.updateSingleCategoryPro(updatedCategory);
                      final updateSuperCate = serviceProvider
                          .getSelectSuperCategoryModel!
                          .copyWith(haveData: true);
                      serviceProvider
                          .updateSingleSuperCategoryPro(updateSuperCate);
                    }

                    // Show success message and close form
                    showMessage("New Service added Successfully");

                    Navigator.of(context).pop(); // Close the form screen
                  } catch (e) {
                    debugPrint("Error adding service: ${e.toString()}");
                    showMessage("Error adding service: ${e.toString()}");
                  } finally {
                    // Ensure loader dialog is dismissed
                    if (Navigator.of(context, rootNavigator: true).canPop()) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }
                },
              ),
            ],
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
