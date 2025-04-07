// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_ak/models/footer_model/footer_model.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:provider/provider.dart';

class FooterForm extends StatefulWidget {
  const FooterForm({super.key});

  @override
  State<FooterForm> createState() => _FooterFormState();
}

class _FooterFormState extends State<FooterForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field.
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _mobileNo2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailOfHrController = TextEditingController();
  final TextEditingController _emailOfInfoController = TextEditingController();
  final TextEditingController _emailOfCustCareController =
      TextEditingController();
  final TextEditingController _emailOfCeoController = TextEditingController();
  final TextEditingController _whatappNoController =
      TextEditingController(); // New controller
  final TextEditingController _facebackController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _linkedController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool isLoading = false;
  bool isLoadingPage = false;
  bool isfirstTimeCreate = false;

  FooterModel? footerModel;
  List<String> cityList = [];

  Future<void> getData() async {
    if (!mounted) return;
    setState(() {
      isLoadingPage = true;
    });

    footerModel = await FirebaseFirestoreHelper.instance.getFirstFooter();
    isfirstTimeCreate = (footerModel == null);
    print("isfirstTimeCreate == $isfirstTimeCreate");

    if (footerModel != null) {
      _aboutController.text = footerModel!.about;
      _mobileController.text = footerModel!.mobileNo;
      _mobileNo2Controller.text = footerModel!.mobileNo2;
      _addressController.text = footerModel!.address;
      _emailOfHrController.text = footerModel!.emailOfHr;
      _emailOfInfoController.text = footerModel!.emailOfInfo;
      _emailOfCustCareController.text = footerModel!.emailOfCustCare;
      _emailOfCeoController.text = footerModel!.emailOfCeo;
      _whatappNoController.text = footerModel!.whatappNo; // Populate new field
      _facebackController.text = footerModel!.facebook;
      _instagramController.text = footerModel!.instaragran;
      _xController.text = footerModel!.x;
      _linkedController.text = footerModel!.linked;
      _youtubeController.text = footerModel!.youtube;
      cityList.addAll(footerModel!.city);
    }

    if (mounted) {
      setState(() {
        isLoadingPage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> _saveFooter() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      AppProvider appProvider =
          Provider.of<AppProvider>(context, listen: false);
      try {
        FooterModel footer = FooterModel(
          id: isfirstTimeCreate
              ? ""
              : footerModel!.id, // This will be updated by the service.
          about: _aboutController.text.trim(),
          mobileNo: _mobileController.text.trim(),
          mobileNo2: _mobileNo2Controller.text.trim(),
          address: _addressController.text.trim(),
          emailOfHr: _emailOfHrController.text.trim(),
          emailOfInfo: _emailOfInfoController.text.trim(),
          emailOfCustCare: _emailOfCustCareController.text.trim(),
          emailOfCeo: _emailOfCeoController.text.trim(),
          whatappNo: _whatappNoController.text.trim(), // New field
          facebook: _facebackController.text.trim(),
          instaragran: _instagramController.text.trim(),
          x: _xController.text.trim(),
          linked: _linkedController.text.trim(),
          youtube: _youtubeController.text.trim(),
          city: cityList,
        );
        bool isDone = isfirstTimeCreate
            ? await FirebaseFirestoreHelper.instance.createFooter(footer)
            : await appProvider.updateFooter(footer);

        if (isfirstTimeCreate) {
          if (isDone) {
            showBottonMessage("Footer created successfully", context);
          } else {
            showBottonMessageError("Error: Unable to create footer", context);
          }
        } else {
          if (isDone) {
            showBottonMessage("Footer update successfully", context);
          } else {
            showBottonMessageError("Error: update to create footer", context);
          }
        }

        await appProvider.fatchFooterInfor();

        if (mounted) {
          _formKey.currentState?.reset();
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving footer: ${e.toString()}")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _mobileController.dispose();
    _mobileNo2Controller.dispose();
    _addressController.dispose();
    _emailOfHrController.dispose();
    _emailOfInfoController.dispose();
    _emailOfCustCareController.dispose();
    _emailOfCeoController.dispose();
    _whatappNoController.dispose(); // Dispose new controller
    _facebackController.dispose();
    _instagramController.dispose();
    _xController.dispose();
    _linkedController.dispose();
    _youtubeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Please enter $fieldName email";
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Please enter a valid email address for $fieldName";
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a mobile number";
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return "Mobile number must be exactly 10 digits";
    }
    return null;
  }

  String? _validateWhatsapp(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a WhatsApp number";
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return "WhatsApp number must be exactly 10 digits";
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an address";
    }
    return null;
  }

  // Simple URL validation: checks if it starts with "http" or "https"
  String? _validateUrl(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Please enter $fieldName URL";
    }
    if (!value.startsWith("http://") && !value.startsWith("https://")) {
      return "Please enter a valid URL for $fieldName";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Footer Settings"),
        backgroundColor: AppColor.whiteColor,
      ),
      body: isLoadingPage
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.dimenisonNo16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _aboutController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Enter information about the website",
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Please enter about information"
                          : null,
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: _validateMobile,
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _mobileNo2Controller,
                      decoration: const InputDecoration(
                        labelText: "Secondary Mobile Number",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: _validateMobile,
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _whatappNoController,
                      decoration: const InputDecoration(
                        labelText: "WhatsApp Number",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: _validateWhatsapp,
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Address",
                      ),
                      validator: _validateAddress,
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _emailOfHrController,
                      decoration: const InputDecoration(
                        labelText: "HR Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateEmail(value, "HR"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _emailOfInfoController,
                      decoration: const InputDecoration(
                        labelText: "Info Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateEmail(value, "Info"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _emailOfCustCareController,
                      decoration: const InputDecoration(
                        labelText: "Customer Care Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          _validateEmail(value, "Customer Care"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _emailOfCeoController,
                      decoration: const InputDecoration(
                        labelText: "CEO Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateEmail(value, "CEO"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _facebackController,
                      decoration: const InputDecoration(
                        labelText: "Facebook URL",
                      ),
                      validator: (value) => _validateUrl(value, "Facebook"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _instagramController,
                      decoration: const InputDecoration(
                        labelText: "Instagram URL",
                      ),
                      validator: (value) => _validateUrl(value, "Instagram"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _xController,
                      decoration: const InputDecoration(
                        labelText: "X URL",
                      ),
                      validator: (value) => _validateUrl(value, "X"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _linkedController,
                      decoration: const InputDecoration(
                        labelText: "LinkedIn URL",
                      ),
                      validator: (value) => _validateUrl(value, "LinkedIn"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    TextFormField(
                      controller: _youtubeController,
                      decoration: const InputDecoration(
                        labelText: "YouTube URL",
                      ),
                      validator: (value) => _validateUrl(value, "YouTube"),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: "Cities",
                              hintText: "Enter a city",
                            ),
                          ),
                        ),
                        SizedBox(width: Dimensions.dimenisonNo8),
                        ElevatedButton(
                          onPressed: () {
                            if (_cityController.text.trim().isNotEmpty) {
                              setState(() {
                                cityList.add(_cityController.text.trim());
                                _cityController.clear();
                                print("cityList == $cityList");
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.buttonRedColor,
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.dimenisonNo20),
                    if (footerModel != null && footerModel!.city.isNotEmpty)
                      SizedBox(
                        height: Dimensions.dimenisonNo40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cityList.length,
                          itemBuilder: (context, index) {
                            String cityName = cityList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo8),
                              child: Chip(
                                label: Text(cityName),
                                backgroundColor: Colors.grey.shade200,
                                deleteIcon: Icon(Icons.close,
                                    size: Dimensions.dimenisonNo18),
                                onDeleted: () {
                                  setState(() {
                                    cityList.removeAt(index);
                                    print("cityList == $cityList");
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(height: Dimensions.dimenisonNo20),
                    ElevatedButton(
                      onPressed: isLoading ? null : _saveFooter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonRedColor,
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.dimenisonNo16),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Footer",
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
