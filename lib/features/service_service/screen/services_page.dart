import 'package:admin_panel_ak/features/appbar/dast_bord_appbar/dash_bord_appbar.dart';
import 'package:admin_panel_ak/features/service_service/screen/category_drawer.dart';
import 'package:admin_panel_ak/features/service_service/screen/services_list.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesPages extends StatefulWidget {
  final String superCategoryName;

  const ServicesPages({
    Key? key,
    required this.superCategoryName,
  }) : super(key: key);

  @override
  State<ServicesPages> createState() => _ServicesPagesState();
}

class _ServicesPagesState extends State<ServicesPages> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    // Calculate responsive drawer width.
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth =
        screenWidth < 600 ? screenWidth * 0.9 : 250.0; // Adjust as needed

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: DashBordAppBar(),
      ),
      body: Row(
        children: [
          // Persistent side panel for categories.
          SizedBox(
            width: drawerWidth,
            child: CatergoryDrawer(
              superCategoryName: widget.superCategoryName,
            ),
          ),
          // Expanded space for the services list.
          Expanded(
            child: serviceProvider.getCategoryList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  )
                : Navigator(
                    onGenerateRoute: (settings) {
                      if (settings.name == '/services_list') {
                        return MaterialPageRoute(
                          builder: (context) => ServicesList(
                            superCategoryName: widget.superCategoryName,
                          ),
                        );
                      }
                      return null;
                    },
                    initialRoute: '/services_list',
                    onUnknownRoute: (settings) => MaterialPageRoute(
                      builder: (context) => ServicesList(
                        superCategoryName: widget.superCategoryName,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
