// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/models/admin_model/admin_model.dart';
import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.code.toString());
      return false;
    }
  }

  Future<bool> signUp(
    String name,
    String number,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      showLoaderDialog(context);

      // Create admin account
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Upload image to storage
      String uidOfCreateUser = userCredential.user!.uid;

      TimeStampModel _timeStampModel = TimeStampModel(
          id: uidOfCreateUser,
          dateAndTime: GlobalVariable.today,
          updateBy: "vender");

      final adminData = AdminModel(
          id: uidOfCreateUser,
          name: name,
          number: number,
          email: email,
          password: password,
          timeStampModel: _timeStampModel);

      await _firestore
          .collection("SabAdmin")
          .doc(adminData.id)
          .set(adminData.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.code.toString());
      print("Error occurred while creating account ${error.code.toString()}");
      return false;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Error occurred while creating account $e");
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      showMessage('Error occurred');
      print(e.toString());
      return false;
    }
  }

  //Forget Password Function
  void resetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
      showMessage("Password Reset Email has been send!");
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showMessage(" Invalid email.");
      }
    }
  }
}
