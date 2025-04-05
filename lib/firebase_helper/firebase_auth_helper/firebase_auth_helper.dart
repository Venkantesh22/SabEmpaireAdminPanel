// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/models/admin_model/admin_model.dart';
import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  // Updated login function with BCrypt verification from Firestore
  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);

      // Sign in using Firebase Authentication
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Retrieve user data from Firestore (assuming collection "SabAdmin" is keyed by user id)
      final uid = _auth.currentUser!.uid;
      final userDoc = await _firestore.collection("SabAdmin").doc(uid).get();
      if (!userDoc.exists) {
        Navigator.of(context, rootNavigator: true).pop();
        showMessage("User data not found");
        return false;
      }

      // Get the stored hashed password from Firestore
      final storedHashedPassword = userDoc.data()?['password'];

      // Debug print to verify hash format (remove in production)
      print("Stored hash: $storedHashedPassword");

      // Verify the provided password against the stored hash using BCrypt
      if (!BCrypt.checkpw(password, storedHashedPassword)) {
        Navigator.of(context, rootNavigator: true).pop();
        showMessage("Password verification failed");
        return false;
      }

      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.code.toString());
      return false;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Error occurred during login: $e");
      print("Error occurred during login: $e");
      return false;
    }
  }

  // Updated signUp function with BCrypt hashing
  Future<bool> signUp(
    String name,
    String number,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      showLoaderDialog(context);

      // Create admin account using Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uidOfCreateUser = userCredential.user!.uid;

      // Generate the salt and hash the password using BCrypt
      String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // Build a timestamp model (example code)
      TimeStampModel _timeStampModel = TimeStampModel(
        id: uidOfCreateUser,
        dateAndTime: GlobalVariable.today,
        updateBy: "vender",
      );

      // Create the admin model with the hashed password
      final adminData = AdminModel(
        id: uidOfCreateUser,
        name: name,
        number: number,
        email: email,
        password: hashedPassword, // Hashed password stored here
        timeStampModel: _timeStampModel,
      );

      // Save the user data in Firestore
      await _firestore
          .collection("SabAdmin")
          .doc(adminData.id)
          .set(adminData.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.code.toString());
      print("Error occurred while creating account: ${error.code}");
      return false;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Error occurred while creating account: $e");
      return false;
    }
  }

  // Future<bool> login(
  //     String email, String password, BuildContext context) async {
  //   try {
  //     showLoaderDialog(context);
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     Navigator.of(context, rootNavigator: true).pop();
  //     return true;
  //   } on FirebaseAuthException catch (error) {
  //     Navigator.of(context, rootNavigator: true).pop();
  //     showMessage(error.code.toString());
  //     return false;
  //   }
  // }

  // Future<bool> signUp(
  //   String name,
  //   String number,
  //   String email,
  //   String password,
  //   BuildContext context,
  // ) async {
  //   try {
  //     showLoaderDialog(context);

  //     // Create admin account
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);

  //     // Upload image to storage
  //     String uidOfCreateUser = userCredential.user!.uid;

  //     TimeStampModel _timeStampModel = TimeStampModel(
  //         id: uidOfCreateUser,
  //         dateAndTime: GlobalVariable.today,
  //         updateBy: "vender");

  //     final adminData = AdminModel(
  //         id: uidOfCreateUser,
  //         name: name,
  //         number: number,
  //         email: email,
  //         password: password,
  //         timeStampModel: _timeStampModel);

  //     await _firestore
  //         .collection("SabAdmin")
  //         .doc(adminData.id)
  //         .set(adminData.toJson());
  //     Navigator.of(context, rootNavigator: true).pop();
  //     return true;
  //   } on FirebaseAuthException catch (error) {
  //     Navigator.of(context, rootNavigator: true).pop();
  //     showMessage(error.code.toString());
  //     print("Error occurred while creating account ${error.code.toString()}");
  //     return false;
  //   } catch (e) {
  //     Navigator.of(context, rootNavigator: true).pop();
  //     showMessage("Error occurred while creating account $e");
  //     return false;
  //   }
  // }

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
