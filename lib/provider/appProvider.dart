import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/footer_model/footer_model.dart';
import 'package:admin_panel_ak/models/job_model/job_model.dart';

import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  final FirebaseFirestoreHelper _firebase = FirebaseFirestoreHelper.instance;

  FooterModel? footerModel;
  FooterModel get getFooterModel => footerModel!;

  JobModel? _jobModel;
  JobModel? get getJobModel => _jobModel;
  List<JobModel> _listOfJob = [];
  List<JobModel> get getListOfJob => _listOfJob;

  Future<void> fatchFooterInfor() async {
    footerModel = await _firebase.getFirstFooter();
    notifyListeners();
  }

  Future<bool> updateFooter(FooterModel footer) async {
    bool isDone = await _firebase.updateFooter(footer);
    if (isDone) {
      footerModel = footer;
      notifyListeners();
    }
    return isDone;
  }
}
