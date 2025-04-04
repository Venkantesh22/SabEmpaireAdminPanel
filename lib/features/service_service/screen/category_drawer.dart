import 'package:admin_panel_ak/features/popup/add_new_category.dart';
import 'package:admin_panel_ak/features/service_service/widget/category_button.dart';
import 'package:admin_panel_ak/models/category_model/category_model.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/button/add_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CatergoryDrawer extends StatefulWidget {
  final String superCategoryName;
  const CatergoryDrawer({
    super.key,
    required this.superCategoryName,
  });

  @override
  State<CatergoryDrawer> createState() => _CatergoryDrawerState();
}

class _CatergoryDrawerState extends State<CatergoryDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  void getDate() async {
    setState(() {
      isLoading = true;
    });
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    // await serviceProvider.callBackFunction(appProvider.getSalonInformation.id);
    await serviceProvider.getCategoryListPro();

    // Sort the category list by order
    serviceProvider.getCategoryList.sort((a, b) => a.order.compareTo(b.order));

    setState(() {
      isLoading = false;
    });

    // Select the first category by default after data is loaded
    if (serviceProvider.getCategoryList.isNotEmpty) {
      serviceProvider.selectCategory(serviceProvider.getCategoryList[0]);
    }
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive width:
    final screenWidth = MediaQuery.of(context).size.width;
    // For mobile use 90% of the width; for larger screens, use a fixed width
    final drawerWidth =
        screenWidth < 600 ? screenWidth * 0.9 : Dimensions.dimenisonNo250;

    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Drawer(
            child: Container(
              width: drawerWidth,
              color: const Color.fromARGB(255, 55, 54, 54),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top header with title and close icon
                  SizedBox(
                    height: Dimensions.dimenisonNo8,
                  ),
                  // Add Category Button

                  AddButton(
                    text: "Add Category",
                    bgColor: Colors.white,
                    textColor: Colors.black,
                    iconColor: Colors.black,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddNewCategory(),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.dimenisonNo5,
                      vertical: Dimensions.dimenisonNo10,
                    ),
                    child: Center(
                      child: Text(
                        serviceProvider
                            .getSelectSuperCategoryModel!.superCategoryName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.dimenisonNo24,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.dimenisonNo10),
                    child: const Divider(color: Colors.white),
                  ),
                  Expanded(
                    child: Consumer<ServiceProvider>(
                      builder: (context, serviceProvider, child) {
                        if (isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (serviceProvider.getCategoryList.isEmpty) {
                          return const Center(
                              child: Text("No Category",
                                  style: TextStyle(color: Colors.white)));
                        }
                        if (serviceProvider.selectedCategory == null) {
                          serviceProvider.selectCategory(
                              serviceProvider.getCategoryList.first);
                        }
                        return ListView.builder(
                          itemCount: serviceProvider.getCategoryList.length,
                          itemBuilder: (context, index) {
                            CategoryModel categoryModel =
                                serviceProvider.getCategoryList[index];
                            return CatergryButton(
                              text:
                                  "${categoryModel.order}.${categoryModel.categoryName}",
                              isSelected:
                                  serviceProvider.selectedCategory?.id ==
                                      categoryModel.id,
                              onTap: () {
                                serviceProvider.selectCategory(categoryModel);
                                Navigator.of(context)
                                    .pushNamed('/services_list');
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
