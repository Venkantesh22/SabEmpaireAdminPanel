import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/Service%20Provider/screen/add_service_provider.dart';
import 'package:admin_panel_ak/features/Service%20Provider/screen/service_provider_list.dart';
import 'package:admin_panel_ak/features/User/screen/userscreen.dart';
import 'package:admin_panel_ak/features/appoint/Appoint%20List/appoint_list.dart';
import 'package:admin_panel_ak/features/appoint/add_appoint/screen/add_new_appointment.dart';
import 'package:admin_panel_ak/features/auth/screen/signup.dart';
import 'package:admin_panel_ak/features/banner_section/screen/banner_page.dart';
import 'package:admin_panel_ak/features/banner_section/screen/mobile_banner_page.dart';
import 'package:admin_panel_ak/features/banner_section/screen/tab_banner_page.dart';
import 'package:admin_panel_ak/features/footer_section/screen/footer_form.dart';
import 'package:admin_panel_ak/features/job%20section/screen/job_list.dart';
import 'package:admin_panel_ak/features/job%20section/screen/new_job_add.dart';
import 'package:admin_panel_ak/features/service_service/screen/service_section.dart';
import 'package:admin_panel_ak/features/user_enquiry_page/screen/user_enquiry_page.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:admin_panel_ak/routes/route_name.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class HomeDashBord extends StatefulWidget {
  const HomeDashBord({super.key});

  @override
  State<HomeDashBord> createState() => _HomePageState();
  static const String homeDashBord = '/home';
}

class _HomePageState extends State<HomeDashBord> {
  Widget _selectedItem = ServiceSection();

  screenSeletor(item) {
    try {
      switch (item.route) {
        case RouteNames.appointList:
          setState(() {
            _selectedItem = AppointmentList(
              date: GlobalVariable.today,
            );
          });
          break;
        case RouteNames.serviceSection:
          setState(() {
            _selectedItem = const ServiceSection();
          });
          break;
        case RouteNames.webBannerSection:
          setState(() {
            _selectedItem = const BannerPage();
          });
          break;
        case RouteNames.tabBannerSection:
          setState(() {
            _selectedItem = const TabBannerPage();
          });
          break;
        case RouteNames.mobileBannerSection:
          setState(() {
            _selectedItem = const MobileBannerPage();
          });
          break;
        case RouteNames.footer:
          setState(() {
            _selectedItem = const FooterForm();
          });
          break;
        case RouteNames.userEnquiry:
          setState(() {
            _selectedItem = UserEnquiryPage();
          });
          break;
        case RouteNames.addAppoint:
          setState(() {
            _selectedItem = AddNewAppointment();
          });
          break;
        case RouteNames.addJob:
          setState(() {
            _selectedItem = JobAddPage();
          });
          break;
        case RouteNames.jobList:
          setState(() {
            _selectedItem = JobListPage();
          });
          break;
        case RouteNames.addServiceProvider:
          setState(() {
            _selectedItem = AddServicePage();
          });
          break;
        case RouteNames.listServiceProvider:
          setState(() {
            _selectedItem = ServiceProviderList();
          });
          break;
        case RouteNames.user:
          setState(() {
            _selectedItem = UserScreen();
          });
          break;
        default:
          throw Exception("Invalid route selected: ${item.route}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.primaryBlackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding: EdgeInsets.all(Dimensions.dimenisonNo5),
          child: FutureBuilder<Uint8List>(
            future: loadAssetImage('assets/images/sabWithBea.jpg'),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Icon(
                  Icons.error,
                  color: Colors.red,
                  size: Dimensions.dimenisonNo50,
                );
              } else if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  height: Dimensions.dimenisonNo50,
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
      sideBar: SideBar(
        backgroundColor: Colors.grey[800]!,
        items: const [
          AdminMenuItem(
            title: 'Appointmnet',
            route: RouteNames.appointList,
            icon: Icons.calendar_today,
            children: [
              AdminMenuItem(
                title: 'Appoint List',
                route: RouteNames.appointList,
                icon: Icons.list,
              ),
              AdminMenuItem(
                title: 'Add Appoint',
                route: RouteNames.addAppoint,
                icon: Icons.add,
              ),
            ],
          ),
          AdminMenuItem(
            title: 'Service',
            route: RouteNames.serviceSection,
            icon: Icons.design_services,
          ),
          AdminMenuItem(
            title: 'Banner',
            route: RouteNames.webBannerSection,
            icon: Icons.image,
            children: [
              AdminMenuItem(
                title: 'Web banner',
                route: RouteNames.webBannerSection,
                icon: Icons.web,
              ),
              AdminMenuItem(
                title: 'Mobile Banner',
                route: RouteNames.mobileBannerSection,
                icon: Icons.phone_android,
              ),
              AdminMenuItem(
                title: 'Tab Banner',
                route: RouteNames.tabBannerSection,
                icon: Icons.tablet,
              ),
            ],
          ),
          AdminMenuItem(
            title: 'User Enquiry List',
            route: RouteNames.userEnquiry,
            icon: Icons.person_search,
          ),
          AdminMenuItem(
            title: 'Job',
            route: RouteNames.appointList,
            icon: Icons.work,
            children: [
              AdminMenuItem(
                title: 'Job List',
                route: RouteNames.jobList,
                icon: Icons.list,
              ),
              AdminMenuItem(
                title: 'Add Job',
                route: RouteNames.addJob,
                icon: Icons.add,
              ),
            ],
          ),
          AdminMenuItem(
            title: 'Service Provider',
            route: RouteNames.appointList,
            icon: Icons.handyman,
            children: [
              AdminMenuItem(
                title: 'Service Provider List',
                route: RouteNames.listServiceProvider,
                icon: Icons.list,
              ),
              AdminMenuItem(
                title: 'Add Service Provider',
                route: RouteNames.addServiceProvider,
                icon: Icons.add,
              ),
            ],
          ),
          AdminMenuItem(
            title: 'User',
            route: RouteNames.user,
            icon: Icons.people_alt,
          ),
          AdminMenuItem(
            title: 'Footer',
            route: RouteNames.footer,
            icon: Icons.details,
          ),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSeletor(item);
        },
        footer: CupertinoButton(
          onPressed: () {
            try {
              FirebaseAuthHelper.instance.signOut();
              Routes.instance.push(widget: SignupPage(), context: context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logout failed: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: const Center(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _selectedItem,
    );
  }

  Future<Uint8List> loadAssetImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }
}
