import 'package:admin_panel_ak/features/user_enquiry_page/widget/user_enquiry_widget.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/user_enquiry_model/user_enquiry_model.dart';
import 'package:flutter/material.dart';

class UserEnquiryPage extends StatefulWidget {
  const UserEnquiryPage({super.key});

  @override
  State<UserEnquiryPage> createState() => _UserEnquiryPageState();
}

class _UserEnquiryPageState extends State<UserEnquiryPage> {
  bool _isLoading = false;
  List<UserEnquiryModel> userEnquiryList = [];

  getData() async {
    setState(() {
      _isLoading = true;
    });

    userEnquiryList =
        await FirebaseFirestoreHelper.instance.getListUserEnquiryForm(context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Enquiry List"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.builder(
                  itemCount: userEnquiryList.length,
                  itemBuilder: (context, index) {
                    UserEnquiryModel user = userEnquiryList[index];
                    return UserEnquiryWidget(userEnquiryModel: user);
                  }),
            ),
    );
  }
}
