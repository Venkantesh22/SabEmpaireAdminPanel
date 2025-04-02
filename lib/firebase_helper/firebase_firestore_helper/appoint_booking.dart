// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/models/appointModel/appoint_model.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppintBookingFb {
  static AppintBookingFb instance = AppintBookingFb();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//! ------------------ Add New Appointment function ---------------------

  Future<List<ServiceModel>> getAllServicesFromCategories() async {
    List<ServiceModel> allServices = []; // List to store all services
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore.collectionGroup("services").get();
      return snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error : getAllServicesFromCategories $e ");
      rethrow;
    }
  }

  Future<bool> saveAppointmentManual(
    final BuildContext context,
    String name,
    String phone,
    double totalPrice,
    double subtotal,
    final DateTime serviceDate,
    final DateTime serviceStartTime,
    final DateTime serviceEndTime,
    final int serviceDuration,
    final List<ServiceModel> services,
    final String serviceAt,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      // // If adminUid is null, handle the error.
      if (adminUid == null) {
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss loader.
        showBottonMessageError("User is not logged in.", context);
        return false;
      }

      DocumentReference<Map<String, dynamic>> docRef =
          _firebaseFirestore.collection("Appointment").doc();

      final List<TimeStampModel> _timeStampList = [];

      // Update timeStamp with the new document ID.
      TimeStampModel time = TimeStampModel(
        id: docRef.id,
        dateAndTime: GlobalVariable.today,
        updateBy: "Sab",
      );
      _timeStampList.add(time);

      // Update user info with the new document ID and timestamp.
      UserModel userMdoel = UserModel(
          id: docRef.id,
          image:
              'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
          name: name,
          phone: phone,
          email: "no email",
          password: "",
          timeStampModel: time);

      AppointModel appointData = AppointModel(
          id: docRef.id,
          adminId: adminUid,
          status: "Pending",
          totalPrice: totalPrice,
          subtotal: subtotal,
          serviceDate: serviceDate,
          serviceStartTime: serviceStartTime,
          serviceEndTime: serviceEndTime,
          serviceDuration: serviceDuration,
          userModel: userMdoel,
          timeStampList: _timeStampList,
          isUpdate: false,
          isManual: true,
          services: services,
          serviceAt: serviceAt);

      await docRef.set(appointData.toJson());

      // await docRef.set({

      // 'id': docRef.id,
      // 'adminId': adminUid,
      // 'status': "Pending",
      // 'totalPrice': totalPrice,
      // 'subtotal': subtotal,
      // 'serviceDate': serviceDate,
      // 'serviceStartTime': serviceStartTime,
      // 'serviceEndTime': serviceEndTime,
      // 'serviceDuration': serviceDuration,
      // 'userModel': useupdate.toJson(),
      // 'timeStampList': _timeStampList.map((e) => e.toJson()).toList(),
      // 'isUpdate': false,
      // 'isManual': true,
      // 'services': services.map((service) => service.toJson()).toList(),
      // 'serviceAt': serviceAt,
      // });
      // Navigator.of(context, rootNavigator: true).pop(); // Correct pop call.
      showBottonMessage("Successfully booked appointment", context);
      return true;
    } catch (e) {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Ensure the loader is dismissed.
      print("Error: Failed Booking appointment: $e");
      showBottonMessageError("Error: Failed Booking appointment", context);
      return false;
    }
  }

  // //! User Appointment function
  // //Get User Appointment by Date
  // Future<List<AppointModel>> getUserBookingListFB(DateTime selectDate) async {
  //   try {
  //     // Normalize the `selectDate` to the start of the day (removing time).
  //     DateTime startOfDay =
  //         DateTime(selectDate.year, selectDate.month, selectDate.day);
  //     DateTime endOfDay = startOfDay.add(const Duration(days: 1));

  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore
  //             .collection('Appointment')
  //             .where('serviceDate', isGreaterThanOrEqualTo: startOfDay)
  //             .where('serviceDate', isLessThan: endOfDay)
  //             .get();

  //     List<AppointModel> bookingList = querySnapshot.docs
  //         .map((e) => AppointModel.fromJson(e.data()))
  //         .toList();

  //     print("Length of bookings fetched from Firestore: ${bookingList.length}");
  //     return bookingList;
  //   } catch (e) {
  //     print("Error fetching booking list from Firestore: $e");
  //     return [];
  //   }
  // }

  Future<List<AppointModel>> getUserBookingListFB(DateTime selectDate) async {
    try {
      // Normalize the selectDate to the start of the day.
      DateTime startOfDay =
          DateTime(selectDate.year, selectDate.month, selectDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection('Appointment')
              .where('serviceDate', isGreaterThanOrEqualTo: startOfDay)
              .where('serviceDate', isLessThan: endOfDay)
              .get();

      List<AppointModel> bookingList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        print("Raw data for doc ${doc.id}: $data");

        try {
          // Attempt to convert the JSON data to an AppointModel.
          final appointment = AppointModel.fromJson(data);
          bookingList.add(appointment);
          print("-----------------------------\n");

          print(appointment);
        } catch (e) {
          print("Error converting doc ${doc.id} to AppointModel: $e");
        }
      }

      print("Length of bookings fetched from Firestore: ${bookingList.length}");
      return bookingList;
    } catch (e) {
      print("Error fetching booking list from Firestore: $e");
      return [];
    }
  }

  // Update Appointment by Id
  Future<bool> updateAppointmentFB(
      appointmentId, AppointModel appointModel) async {
    try {
      await _firebaseFirestore
          .collection('Appointment')
          .doc(appointmentId)
          .update(appointModel.toJson());
      return true;
    } on Exception catch (e) {
      print("Error At Firebase :$e");
      rethrow;
      // TODO
    }
  }
}
