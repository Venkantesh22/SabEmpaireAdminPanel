// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/popup/add_new_super_category.dart';
import 'package:admin_panel_ak/features/service_service/screen/services_page.dart';
import 'package:admin_panel_ak/features/service_service/widget/super_cate_image.dart';
import 'package:admin_panel_ak/models/super_cate/super_cate.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/add_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceSection extends StatefulWidget {
  const ServiceSection({super.key});

  @override
  State<ServiceSection> createState() => _SuperCategoryPageState();
}

class _SuperCategoryPageState extends State<ServiceSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  void getDate() async {
    setState(() {
      isLoading = true;
    });

    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    await serviceProvider.getSuperCategoryListPro();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Section'),
        actions: [
          AddButton(
            text: "Super Category",
            onTap: () {
              // Use showDialog to display the AddNewSuperCategory widget
              showDialog(
                context: context,
                builder: (context) => const AddNewSuperCategory(),
              );
            },
          )
        ],
      ),
      body: serviceProvider.getSuperCategoryList.isEmpty ||
              serviceProvider.getSuperCategoryList == null
          ? const Center(
              child: Text('No Super Category Found'),
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.dimenisonNo8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Super Category",
                          style: TextStyle(
                            fontSize: Dimensions.dimenisonNo20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        // Wrap ListView.builder in a SizedBox with a fixed height
                        SizedBox(
                          height: MediaQuery.of(context).size.height /
                              1.5, // Adjust the height as needed
                          child: Consumer<ServiceProvider>(
                            builder: (context, serviceProvider, child) {
                              // Define the desired order for the super categories.
                              List<String> desiredOrder = [
                                GlobalVariable.supCatHair,
                                GlobalVariable.supCatSkin,
                                GlobalVariable.supCatManiPedi,
                                GlobalVariable.supCatNail,
                                GlobalVariable.supCatMakeUp,
                                GlobalVariable.supCatMassage,
                                GlobalVariable.supCatOther,
                              ];

                              // Create a sorted copy of the super category list.
                              List<SuperCategoryModel> sortedCategories =
                                  serviceProvider.getSuperCategoryList.toList();
                              sortedCategories.sort((a, b) {
                                int indexA =
                                    desiredOrder.indexOf(a.superCategoryName);
                                int indexB =
                                    desiredOrder.indexOf(b.superCategoryName);
                                if (indexA == -1) {
                                  indexA = desiredOrder.length + 1;
                                }
                                if (indexB == -1) {
                                  indexB = desiredOrder.length + 1;
                                }
                                return indexA.compareTo(indexB);
                              });

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sortedCategories.length,
                                itemBuilder: (context, index) {
                                  SuperCategoryModel cate =
                                      sortedCategories[index];
                                  return CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      serviceProvider.selectSuperCatePro(cate);
                                      Routes.instance.push(
                                          widget: ServicesPages(
                                            superCategoryName:
                                                cate.superCategoryName,
                                          ),
                                          context: context);
                                    },
                                    child: SuperCateImage(
                                      superCategoryModel: cate,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
