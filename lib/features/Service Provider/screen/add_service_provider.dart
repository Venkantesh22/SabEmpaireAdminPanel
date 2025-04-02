import 'dart:io';
import 'dart:typed_data';

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/service_provider_model/service_provider_model.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddServicePage extends StatefulWidget {
  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _eIdController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();

  bool isLoading = false;

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

  void _saveServiceProvider() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final desc = _descController.text.trim();
      final eId = _eIdController.text.trim();
      final year = int.tryParse(_yearController.text.trim()) ?? 0;
      final month = int.tryParse(_monthController.text.trim()) ?? 0;

      setState(() {
        isLoading = true;
      });
      ServiceProviderModel serviceProviderModel = ServiceProviderModel(
          id: "",
          name: name,
          descp: desc,
          eId: eId,
          yearExperience: year,
          monthExperience: month);

      try {
        await FirebaseFirestoreHelper.instance.createServiceProvider(
            serviceProviderModel, selectedImage, context);
      } catch (e) {
      } finally {
        _formKey.currentState?.reset();
        setState(() {
          selectedImage = null;
          isLoading = false;
        });
      }

      // Clear form
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service'),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.dimenisonNo16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: chooseImages,
                  child: CircleAvatar(
                    radius: Dimensions.dimenisonNo50,
                    // backgroundImage: selectedImage != null
                    //     ? FileImage(selectedImage!)
                    //     : null,
                    // child: selectedImage == null
                    //     ? Icon(Icons.add_a_photo, size: 50)
                    //     : null,
                    child: Center(
                      child: selectedImage != null
                          ? Image.memory(
                              selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.add_a_photo, size: 50),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.dimenisonNo16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a name'
                      : null,
                ),
                SizedBox(height: Dimensions.dimenisonNo16),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                SizedBox(height: Dimensions.dimenisonNo16),
                TextFormField(
                  controller: _eIdController,
                  decoration: InputDecoration(labelText: 'Employee ID'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a Employee ID'
                      : null,
                ),
                SizedBox(height: Dimensions.dimenisonNo16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        decoration: InputDecoration(labelText: 'Years'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null
                            ? 'Enter a valid number'
                            : null,
                      ),
                    ),
                    SizedBox(width: Dimensions.dimenisonNo16),
                    Expanded(
                      child: TextFormField(
                        controller: _monthController,
                        decoration: InputDecoration(labelText: 'Months'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null
                            ? 'Enter a valid number'
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimenisonNo16),
                ElevatedButton(
                  onPressed: isLoading ? null : _saveServiceProvider,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.buttonRedColor,
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.dimenisonNo16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Job",
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
