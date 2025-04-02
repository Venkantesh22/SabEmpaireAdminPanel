// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/popup/edit_category.dart';
import 'package:admin_panel_ak/features/service_service/screen/add_service_form.dart';
import 'package:admin_panel_ak/features/service_service/widget/single_service_tap.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/add_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ServicesList extends StatefulWidget {
  final String superCategoryName;
  const ServicesList({
    Key? key,
    required this.superCategoryName,
  }) : super(key: key);

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final selectedCategory = serviceProvider.selectedCategory;

    if (selectedCategory == null) {
      return const Center(child: Text('No category selected'));
    }

    return Scaffold(
      body: serviceProvider.getCategoryList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(Dimensions.dimenisonNo10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            selectedCategory.categoryName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimenisonNo30,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.15,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return EditCategoryPopup(
                                    categoryModel: selectedCategory,
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.edit_square,
                              color: Colors.black,
                            ),
                          ),

                          // Delete icon for delete category
                          IconButton(
                            onPressed: () async {
                              showDeleteAlertDialog(context, "Delete Category",
                                  "Do you want to delete ${selectedCategory.categoryName} category",
                                  () async {
                                try {
                                  showLoaderDialog(context);
                                  await serviceProvider.deleteSingleCategoryPro(
                                      selectedCategory);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  // Update Drawer
                                  await serviceProvider.callBackFunction();

                                  await serviceProvider.getCategoryListPro();

                                  // Select the first category by default after data is loaded
                                  if (serviceProvider
                                      .getCategoryList.isNotEmpty) {
                                    serviceProvider.selectCategory(
                                        serviceProvider.getCategoryList[0]);
                                  }
                                  // // Reload the page
                                  // setState(() {});
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showMessage(
                                      "Successfully deleted ${selectedCategory.categoryName}");
                                } catch (e) {
                                  Navigator.of(
                                    context,
                                  ).pop();

                                  showMessage(
                                      "Error not deleting ${selectedCategory.categoryName}");
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          AddButton(
                              text: "Add Services",
                              onTap: () {
                                Routes.instance.push(
                                    widget: AddServiceForm(
                                        categoryModel: selectedCategory),
                                    context: context);
                              })
                        ],
                      ),
                      Divider()
                    ],
                  ),

                  // Services List
                  Expanded(
                      child: StreamBuilder<List<ServiceModel>>(
                    stream: serviceProvider.getServicesListFirebase(
                        serviceProvider.getSelectSuperCategoryModel!.id,
                        selectedCategory.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading Service'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No Service found'));
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            ServiceModel serviceModel = snapshot.data![index];
                            return SingleServiceTap(
                              serviceModel: serviceModel,
                              categoryModel: selectedCategory,
                              index: index,
                            );
                          });
                    },
                  )),
                ],
              ),
            ),
    );
  }
}
