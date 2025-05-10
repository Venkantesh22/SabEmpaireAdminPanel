import 'package:admin_panel_ak/features/FranchiseEnquiry/widget/franchise_enquiry_widget.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/franchise_enquiry_model/franchise_enquiry_model.dart';
import 'package:flutter/material.dart';

class FranchiseEnquire extends StatefulWidget {
  const FranchiseEnquire({super.key});

  @override
  State<FranchiseEnquire> createState() => _FranchiseEnquireState();
}

class _FranchiseEnquireState extends State<FranchiseEnquire> {
  bool _isLoading = false;
  List<FranchiseEnquiryModel> FranchiseList = [];

  getData() async {
    setState(() {
      _isLoading = true;
    });

    FranchiseList =
        await FirebaseFirestoreHelper.instance.getFranchiseFormList();

    // Sort the list by dateAndTime in descending order
    FranchiseList.sort((a, b) =>
        b.timeStampModel.dateAndTime.compareTo(a.timeStampModel.dateAndTime));

    print("Sorted Franchise List: $FranchiseList");

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
        title: Text("Franchies List"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.builder(
                  itemCount: FranchiseList.length,
                  itemBuilder: (context, index) {
                    FranchiseEnquiryModel franchise = FranchiseList[index];
                    return FranchiseEnquiryWidget(franchiseModel: franchise);
                  }),
            ),
    );
  }
}
