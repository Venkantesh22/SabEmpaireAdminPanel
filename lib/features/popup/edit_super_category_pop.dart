// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:typed_data';
import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/models/super_cate/super_cate.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/customauthbutton.dart';
import 'package:admin_panel_ak/widget/text_box/customtextfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditSuperCategoryPopup extends StatefulWidget {
  final SuperCategoryModel superCategoryModel;
  EditSuperCategoryPopup({
    Key? key,
    required this.superCategoryModel,
  }) : super(key: key);

  @override
  State<EditSuperCategoryPopup> createState() => _EditSuperCategoryPopupState();
}

class _EditSuperCategoryPopupState extends State<EditSuperCategoryPopup> {
  final TextEditingController _superCategoryController =
      TextEditingController();

  // Moved selectedImage to a state variable so it persists across rebuilds.
  Uint8List? selectedImage;

  // Function to choose an image using FilePicker.
  Future<void> chooseImages() async {
    FilePickerResult? chosenImageFile = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (chosenImageFile != null) {
      setState(() {
        selectedImage = chosenImageFile.files.single.bytes;
      });
    }
  }

  void getData() {
    _superCategoryController.text = widget.superCategoryModel.superCategoryName;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

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
                'Edit Super-Category',
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
        height: Dimensions.dimenisonNo230,
        child: Column(
          children: [
            FormCustomTextField(
              controller: _superCategoryController,
              title: "Super Category",
            ),
            SizedBox(height: Dimensions.dimenisonNo12),
            GestureDetector(
              onTap: chooseImages,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Dimensions.dimenisonNo140,
                    width: Dimensions.dimenisonNo150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      border: Border.all(
                        color: Colors.grey.shade800,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: selectedImage != null
                          ? Image.memory(
                              selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : widget.superCategoryModel.imgUrl != null
                              ? Image.network(
                                  widget.superCategoryModel.imgUrl!,
                                  fit: BoxFit.cover,
                                )
                              : const Text('Logo Images'),
                    ),
                  )
                ],
              ),
            ),
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
              bgColor: Colors.green,
              text: "Save",
              ontap: () async {
                try {
                  // Validate text field.
                  bool isValidated = addNewSuperCategoryVaildation(
                      _superCategoryController.text, context);

                  if (!isValidated) return;

                  // Check if image is selected.
                  // if (selectedImage == null) {
                  //   Navigator.of(context, rootNavigator: true).pop();
                  //   showBottonMessageError("Please select an image.", context);
                  //   return;
                  // }
                  showAboutDialog(context: context);
                  // Call the update method on provider.
                  if (selectedImage == null) {
                    SuperCategoryModel updateSuperCate =
                        widget.superCategoryModel.copyWith(
                      superCategoryName: _superCategoryController.text.trim(),
                    );
                    serviceProvider
                        .updateSingleSuperCategoryPro(updateSuperCate);
                  } else {
                    SuperCategoryModel updateSuperCate =
                        widget.superCategoryModel.copyWith(
                      superCategoryName: _superCategoryController.text.trim(),
                    );
                    serviceProvider.updateSingleSuperCategoryWIthImagePro(
                        updateSuperCate, selectedImage!);
                  }

                  Navigator.of(context, rootNavigator: true)
                      .pop(); // Pop loader dialog.
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // Pop loader dialog.
                  showBottonMessage(
                      "Super-Category updated Successfully", context);

                  // Finally, pop the edit dialog.
                  // Navigator.pop(context);
                } catch (e) {
                  // Navigator.of(context, rootNavigator: true)
                  //     .pop(); // Ensure loader is closed.
                  showBottonMessageError(
                      "Error updating Super-Category: ${e.toString()}",
                      context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
