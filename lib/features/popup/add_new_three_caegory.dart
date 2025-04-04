import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/customauthbutton.dart';
import 'package:admin_panel_ak/widget/text_box/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddNewThreeCategory extends StatelessWidget {
  const AddNewThreeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final TextEditingController _categoryController = TextEditingController();
    final TextEditingController _orderAtController = TextEditingController();

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
                'Add New Three Category in ${serviceProvider.selectedCategory!.categoryName}',
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
        height: Dimensions.dimenisonNo60,
        child: Column(
          children: [
            FormCustomTextField(
                controller: _categoryController, title: "Category Name"),
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
                  print(
                      "select super category is ${serviceProvider.selectedCategory!.categoryName}");

                  bool isVaildated = addNewCategoryVaildation(
                    _categoryController.text,
                    int.parse(_orderAtController.text.trim()),
                    context,
                  );

                  if (isVaildated) {
                    showLoaderDialog(context);
                    serviceProvider.addNewCategoryPro(
                        _categoryController.text.trim(),
                        int.parse(_orderAtController.text.trim()),
                        serviceProvider.getSelectSuperCategoryModel!,
                        context);

                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();

                    showMessage("New three Category add Successfully");
                  }
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showMessage(
                      "Error create new three Category ${e.toString()}");
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
