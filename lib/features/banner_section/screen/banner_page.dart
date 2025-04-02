// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/image_model/image_model.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/custom_button.dart';
import 'package:admin_panel_ak/widget/text_box/customtextfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});
  // static const String routeName = '/BannerPage';

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  final TextEditingController _imageName = TextEditingController();
  Uint8List? selectedImage;

  // Function to choose an image using FilePicker.
  Future<void> chooseImages() async {
    try {
      FilePickerResult? chosenImageFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (chosenImageFile != null) {
        setState(() {
          selectedImage = chosenImageFile.files.single.bytes;
        });
      }
    } catch (e) {
      showMessage("Error picking image: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.dimenisonNo12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Banner Images',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.dimenisonNo36,
                  ),
                ),
              ),
              const Divider(),
              // Image picker and text field input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                : const Text('Banner Images'),
                          ),
                        ),
                        SizedBox(width: Dimensions.dimenisonNo20),
                        SizedBox(
                          width: Dimensions.dimenisonNo200,
                          child: CustomTextField(
                            controller: _imageName,
                            obscureForPassword: false,
                            label: "Enter Name of Image",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo12),
                  CustomButton(
                    text: "Save",
                    buttonColor: AppColor.buttonRedColor,
                    ontap: () async {
                      if (selectedImage != null && _imageName.text.isNotEmpty) {
                        // Show loading dialog
                        showLoaderDialog(context);

                        try {
                          bool _isValid = imageAndNameValidation(
                              _imageName.text, selectedImage!);

                          if (_isValid) {
                            // Upload the image
                            await FirebaseFirestoreHelper.instance
                                .uploadBannerData(
                              _imageName.text.trim(),
                              selectedImage!,
                            );

                            if (!mounted) return;
                            Navigator.of(context, rootNavigator: true).pop();
                            showBottonMessage(
                                "Successfully uploaded the Banner Images",
                                context);

                            // Clear the image and text field after upload
                            setState(() {
                              selectedImage = null;
                              _imageName.clear();
                            });
                          } else {
                            if (!mounted) return;
                            Navigator.of(context, rootNavigator: true).pop();
                            showBottonMessage(
                                "Image validation failed. Please try again.",
                                context);
                          }
                        } catch (e) {
                          if (!mounted) return;
                          Navigator.of(context, rootNavigator: true).pop();

                          showBottonMessageError(
                              "An error occurred while uploading. Please try again.",
                              context);
                        }
                      } else {
                        showBottonMessageError(
                            "Please select an image and enter a name.",
                            context);
                      }
                    },
                  ),
                  SizedBox(height: Dimensions.dimenisonNo20),
                  Text(
                    'Upload Banner Images',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Dimensions.dimenisonNo30,
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo15),
                ],
              ),
              // StreamBuilder for real-time images
              StreamBuilder<List<ImageModel>>(
                stream:
                    FirebaseFirestoreHelper.instance.getBannerImagesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No images available.'));
                  }

                  final websiteImages = snapshot.data!;
                  // Using ListView.builder instead of GridView.builder
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: websiteImages.length,
                    itemBuilder: (context, index) {
                      ImageModel _imageModel = websiteImages[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.dimenisonNo8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _imageModel.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      bool _isDelete =
                                          await FirebaseFirestoreHelper.instance
                                              .deleteBannerImage(_imageModel);
                                      if (_isDelete) {
                                        showBottonMessage(
                                            "Image deleted successfully",
                                            context);
                                      }
                                    } catch (e) {
                                      showBottonMessageError(
                                          "Error deleting image: ${e.toString()}",
                                          context);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.dimenisonNo5),
                          // Use AspectRatio to ensure the image takes only the space it needs
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            child: _imageModel.image != null
                                ? Image.network(
                                    _imageModel.image,
                                    fit: BoxFit.fitWidth,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons.broken_image_rounded,
                                      size: Dimensions.dimenisonNo60,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator()),
                          ),
                          SizedBox(height: Dimensions.dimenisonNo12),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays a loader dialog.
  void showLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.whiteColor,
          content: SizedBox(
            height: Dimensions.dimenisonNo40,
            width: Dimensions.dimenisonNo200,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xffe16555)),
                SizedBox(width: Dimensions.dimenisonNo18),
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
