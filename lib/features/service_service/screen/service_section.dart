import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/popup/add_new_super_category.dart';
import 'package:admin_panel_ak/features/service_service/screen/services_page.dart';
import 'package:admin_panel_ak/features/service_service/widget/super_cate_image.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/service_firebase_firestore.dart';
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
  State<ServiceSection> createState() => _ServiceSectionState();
}

class _ServiceSectionState extends State<ServiceSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<List<SuperCategoryModel>> getSuperCategoryStream() async* {
    final superCategoryStream =
        ServiceFirebaseFirestore.instance.getAllSuperCategories();

    await for (final superCategoryList in superCategoryStream) {
      debugPrint(
          'Fetched Super Categories: ${superCategoryList.map((e) => e.superCategoryName).toList()}');
      yield superCategoryList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Service Section'),
        actions: [
          AddButton(
            text: "Super Category",
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AddNewSuperCategory(),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<SuperCategoryModel>>(
        stream: getSuperCategoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint('Error: ${snapshot.error}');
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('No data found');
            return const Center(child: Text('No Super Category Found'));
          }

          List<SuperCategoryModel> sortedCategories = snapshot.data!.toList();
          sortedCategories.sort((a, b) => a.order.compareTo(b.order));

          return Padding(
            padding: EdgeInsets.all(Dimensions.dimenisonNo8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Super Category",
                    style: TextStyle(
                      fontSize: Dimensions.dimenisonNo20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo20),
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sortedCategories.length,
                        itemBuilder: (context, index) {
                          SuperCategoryModel cate = sortedCategories[index];
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${cate.order}',
                                  style: TextStyle(
                                    fontSize: Dimensions.dimenisonNo16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Provider.of<ServiceProvider>(context,
                                            listen: false)
                                        .selectSuperCatePro(cate);
                                    Routes.instance.push(
                                      widget: ServicesPages(
                                          superCategoryName:
                                              cate.superCategoryName),
                                      context: context,
                                    );
                                  },
                                  child: SuperCateImage(
                                    superCategoryModel: cate,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
