import 'package:admin_panel_ak/features/appoint/Appoint%20List/user_info_sidebar/screen/user_info_sidebar.dart';
import 'package:admin_panel_ak/features/appoint/Appoint%20List/user_list/screen/user_list.dart';
import 'package:admin_panel_ak/models/appointModel/appoint_model.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_panel_ak/models/user_model/user_model.dart';

import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

class AppointmentList extends StatefulWidget {
  DateTime date;
  AppointmentList({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  State<AppointmentList> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AppointmentList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppointModel? selectedOrder;
  int? selectIndex;
  UserModel? selectedUser;

  // Function to update the selected order
  void _onBookingSelected(AppointModel order, UserModel user, int index) {
    setState(() {
      selectedOrder = order;
      selectedUser = user;
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    // SalonModel? salonModal = appProvider.getSalonInformation;

    // Show fallback UI if salonModal is null (though ideally, it shouldn't be after loading)
    // if (salonModal == null) {
    //   return Scaffold(
    //     body: Center(
    //       child: const Text("Failed to load salon information."),
    //     ),
    //   );
    // }

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60.0),
      //   child: CustomAppBar(scaffoldKey: _scaffoldKey),
      // ),
      body: Row(
        children: [
          // Left Side: User Booking List
          Expanded(
            child: UserList(
              date: widget.date,
              onBookingSelected: _onBookingSelected,
            ),
          ),
          // Right Side: Detailed User Information
          Container(
            decoration: const BoxDecoration(
              color: AppColor.sideBarBgColor,
              border: Border(
                left: BorderSide(width: 2.0, color: Colors.black),
              ),
            ),
            width: Dimensions.screenWidth / 3,
            child: selectedOrder != null
                ? UserInfoSideBar(
                    appointModel: selectedOrder!,
                    user: selectedUser!,
                    index: selectIndex!,
                  )
                : const Center(
                    child: Text("Select a booking to see details"),
                  ),
          ),
        ],
      ),
    );
  }
}
