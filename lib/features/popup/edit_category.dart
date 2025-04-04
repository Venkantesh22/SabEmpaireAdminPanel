import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/models/category_model/category_model.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/customauthbutton.dart';
import 'package:admin_panel_ak/widget/text_box/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

class EditCategoryPopup extends StatefulWidget {
  final CategoryModel? categoryModel;
  const EditCategoryPopup({
    super.key,
    required this.categoryModel,
  });

  @override
  State<EditCategoryPopup> createState() => _EditCategoryPopupState();
}

class _EditCategoryPopupState extends State<EditCategoryPopup> {
  @override
  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final TextEditingController _categoryController =
        TextEditingController(text: widget.categoryModel?.categoryName);

    final TextEditingController _orderAtController =
        TextEditingController(text: widget.categoryModel?.order.toString());

    return AlertDialog(
      titlePadding: EdgeInsets.only(
        left: Dimensions.dimenisonNo20,
        right: Dimensions.dimenisonNo20,
        top: Dimensions.dimenisonNo20,
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo20,
          vertical: Dimensions.dimenisonNo10),
      actionsPadding: EdgeInsets.symmetric(
        vertical: Dimensions.dimenisonNo10,
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Category',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          const Divider()
        ],
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormCustomTextField(
                controller: _categoryController, title: "Category Name"),
            SizedBox(height: Dimensions.dimenisonNo12),
            FormCustomTextField(
              controller: _orderAtController,
              title: "Order at",
            ),
            SizedBox(height: Dimensions.dimenisonNo12),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAuthButton(
              buttonWidth: Dimensions.dimenisonNo150,
              text: "Cancel",
              bgColor: Colors.red,
              ontap: () {
                Navigator.pop(context);
              },
            ),
            CustomAuthButton(
              buttonWidth: Dimensions.dimenisonNo150,
              text: "Save",
              bgColor: Colors.green,
              ontap: () {
                try {
                  showLoaderDialog(context);

                  bool isVaildated = addNewCategoryVaildation(
                    _categoryController.text,
                    int.parse(_orderAtController.text.trim()),
                    context,
                  );

                  if (isVaildated) {
                    CategoryModel categoryModel =
                        widget.categoryModel!.copyWith(
                      categoryName: _categoryController.text.trim(),
                      order: int.parse(_orderAtController.text.trim()),
                    );

                    serviceProvider.updateSingleCategoryPro(categoryModel);

                    Navigator.of(context, rootNavigator: true).pop();

                    // showMessage(
                    //     "New Category add Successfully Reload the Page");
                  }

                  Navigator.of(context, rootNavigator: true).pop();
                  showInforAlertDialog(
                      context,
                      "Successfully Edit the Category",
                      "Category is Edit Successfully reload the page to see changes.");
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showMessage("Error create new Category ${e.toString()}");
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
