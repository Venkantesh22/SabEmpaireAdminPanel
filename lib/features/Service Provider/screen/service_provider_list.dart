// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:admin_panel_ak/models/service_provider_model/service_provider_model.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderList extends StatefulWidget {
  @override
  _ServiceProviderListState createState() => _ServiceProviderListState();
}

class _ServiceProviderListState extends State<ServiceProviderList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _eIdController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();

  bool isLoading = false;
  bool isImageIsChange = false;
  Uint8List? selectedImage;

  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('serviceProvider');

  Future<void> deleteJob(String id, BuildContext context) async {
    await FirebaseFirestoreHelper.instance.deleteServiceProvider(id, context);
  }

  void editServiceProvider(ServiceProviderModel serviceProviderModel) {
    // Reset image flag when editing starts.
    isImageIsChange = false;
    selectedImage = null;

    showDialog(
      context: context,
      builder: (context) {
        // Populate controllers with current values.
        _nameController.text = serviceProviderModel.name;
        _descController.text = serviceProviderModel.descp;
        _eIdController.text = serviceProviderModel.eId;
        _yearController.text = serviceProviderModel.yearExperience.toString();
        _monthController.text = serviceProviderModel.monthExperience.toString();
        _orderController.text = serviceProviderModel.order.toString();

        // Function to choose a new image.
        Future<void> chooseImages() async {
          try {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: false,
            );
            if (result != null) {
              setState(() {
                selectedImage = result.files.single.bytes;
                isImageIsChange = true;
              });
            }
          } catch (e) {
            showBottonMessage("Error picking image: ${e.toString()}", context);
          }
        }

        // Function to save the updated profile.
        Future<void> _editProfileSave(ServiceProviderModel oldModel) async {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() {
              isLoading = true;
            });
            try {
              // Build the updated model without image update.
              ServiceProviderModel updatedModelNoImage = ServiceProviderModel(
                id: oldModel.id,
                name: _nameController.text.trim(),
                descp: _descController.text.trim(),
                eId: _eIdController.text.trim(),
                yearExperience: int.parse(_yearController.text.trim()),
                monthExperience: int.parse(_monthController.text.trim()),
                order: int.parse(_orderController.text.trim()),
                image: oldModel.image, // retain the existing image
              );

              // If a new image is selected, update the image URL.
              String? updatedImageUrl = oldModel.image;
              if (isImageIsChange && selectedImage != null) {
                updatedImageUrl = await FirebaseStorageHelper.instance
                    .updateServicePvoviderPicImage(
                        selectedImage!, oldModel.image!, oldModel.eId);
              }

              // Build final updated model.
              ServiceProviderModel finalUpdatedModel = ServiceProviderModel(
                id: oldModel.id,
                name: _nameController.text.trim(),
                descp: _descController.text.trim(),
                eId: _eIdController.text.trim(),
                yearExperience: int.parse(_yearController.text.trim()),
                monthExperience: int.parse(_monthController.text.trim()),
                order: int.parse(_orderController.text.trim()),
                image: updatedImageUrl,
              );

              // Call Firestore update method.
              await FirebaseFirestoreHelper.instance
                  .updateServiceProvider(finalUpdatedModel, context);

              // Reset form.
              _formKey.currentState?.reset();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        "Error updating Service Provider: ${e.toString()}")),
              );
            } finally {
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop();
            }
          }
        }

        return AlertDialog(
          title: Text(
            "Edit Service Provider",
            style: TextStyle(
                fontSize: Dimensions.dimenisonNo24,
                fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.dimenisonNo16),
            child: SizedBox(
              width: Dimensions.screenWidth / 1.3,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => chooseImages(),
                      child: CircleAvatar(
                        radius: Dimensions.dimenisonNo50,
                        backgroundColor: Colors.grey[300],
                        // If a new image is selected, show it; otherwise, check if a saved image exists.
                        backgroundImage: selectedImage != null
                            ? MemoryImage(selectedImage!)
                            : (serviceProviderModel.image != null &&
                                    serviceProviderModel.image!.isNotEmpty
                                ? NetworkImage(serviceProviderModel.image!)
                                : null),
                        // Ensure the image covers the full area.
                        foregroundImage: selectedImage == null &&
                                serviceProviderModel.image != null &&
                                serviceProviderModel.image!.isNotEmpty
                            ? NetworkImage(serviceProviderModel.image!)
                            : null,
                        child: (selectedImage == null &&
                                (serviceProviderModel.image == null ||
                                    serviceProviderModel.image!.isEmpty))
                            ? Icon(Icons.add_a_photo,
                                color: Colors.white,
                                size: Dimensions.dimenisonNo30)
                            : null,
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
                          ? 'Please enter an Employee ID'
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
                        SizedBox(width: Dimensions.dimenisonNo16),
                        Expanded(
                          child: TextFormField(
                            controller: _orderController,
                            decoration: InputDecoration(labelText: 'Order'),
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
                      onPressed: isLoading
                          ? null
                          : () async {
                              await _editProfileSave(serviceProviderModel);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonRedColor,
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimenisonNo16),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Providers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('serviceProvider')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No service providers found.'));
          }

          final serviceProviders = snapshot.data!.docs
              .map((doc) => ServiceProviderModel.fromJson(
                  doc.data() as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => a.order.compareTo(b.order)); // Sort by order

          return ListView.builder(
            itemCount: serviceProviders.length,
            itemBuilder: (context, index) {
              final provider = serviceProviders[index];
              return Card(
                margin: EdgeInsets.all(Dimensions.dimenisonNo8),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(provider.order.toString()),
                      SizedBox(width: 2),
                      (provider.image != null && provider.image!.isNotEmpty)
                          ? Image.network(
                              provider.image!,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person,
                                    size: Dimensions.dimenisonNo30,
                                    color: Colors.grey);
                              },
                            )
                          : Icon(Icons.person,
                              size: Dimensions.dimenisonNo30,
                              color: Colors.grey),
                    ],
                  ),
                  title: Text(provider.name),
                  subtitle: Text(
                      '${provider.descp}\nExperience: ${provider.yearExperience} years, ${provider.monthExperience} months'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editServiceProvider(provider),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm Deletion'),
                                content: Text(
                                    'Are you sure you want to delete this service provider?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirm == true) {
                            await FirebaseFirestoreHelper.instance
                                .deleteServiceProvider(provider.id, context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
