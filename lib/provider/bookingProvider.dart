import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/appoint_booking.dart';
import 'package:admin_panel_ak/models/appointModel/appoint_model.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  List<ServiceModel> _watchList = [];
  List<ServiceModel> get getWatchList => _watchList;

  DateTime _appointStartTime = DateTime.now();
  DateTime get getAppointStartTime => _appointStartTime;

  DateTime _appointEndTime = DateTime.now();
  DateTime get getAppointEndTime => _appointEndTime;

  Duration? _appointDuration;
  Duration? get getAppointDuration => _appointDuration;

  String _serviceBookingDuration = "0h 0m";
  String get getServiceBookingDuration => _serviceBookingDuration;

  double _finalTotal = 0.0;
  double get getFinalTotal => _finalTotal;

  double _subTotal = 0.0;
  double get getSubTotal => _subTotal;

  // GST calculation.
  double _calGstAmount = 0.0;
  double get getCalGSTAmount => _calGstAmount;

  double? _netPrice = 0.0;
  double? get getNetPrice => _netPrice;

  // User note.
  String? _userNote;
  String? get getUserNote => _userNote;

  DateTime _appointSelectedDate = DateTime.now();
  DateTime get getAppointSelectedDate => _appointSelectedDate;

  void addServiceToWatchList(ServiceModel serviceModel) {
    _watchList.add(serviceModel);
    notifyListeners();
  }

  /// Removes a service from the watch list.
  void removeServiceToWatchList(ServiceModel serviceModel) {
    _watchList.remove(serviceModel);
    notifyListeners();
  }

  /// Calculates total booking duration from services in the watch list.
  void calculateTotalBookingDuration() {
    try {
      int totalMinutes =
          _watchList.fold(0, (sum, item) => sum + item.serviceDurationMin);
      Duration totalDuration = Duration(minutes: totalMinutes);
      _appointDuration = totalDuration;
      _serviceBookingDuration =
          "${totalDuration.inHours}h ${totalDuration.inMinutes % 60}min";
      notifyListeners();
    } catch (e) {
      debugPrint("Error calculating total booking duration: $e");
    }
  }

  /// Calculates the subtotal, discount, GST, and final total.
  void calculateSubTotal() {
    try {
      print("Calculate GST for incl pro----------");
      // _isGSTApply = true;

      _subTotal = _watchList.fold(0.0, (sum, item) => sum + item.price);
      print("Subtotal Inclusive: $_subTotal");

      // Calculate discount percentage based on subtotal.
      calNetPirce();
      _finalTotal = _subTotal;
      notifyListeners();
    } catch (e) {
      debugPrint("Error in calculateSubTotal: $e");
    }
  }

  void calNetPirce() {
    {
      _netPrice = _subTotal / 1.18;
    }
  }

  // ----------------- Update Methods -----------------

  /// Updates the user note.
  void updateUserNote(String note) {
    _userNote = note;
    notifyListeners();
  }

  /// Updates the selected date (normalized to year/month/day only).
  void updateSelectedDate(DateTime newDate) {
    _appointSelectedDate = DateTime(newDate.year, newDate.month, newDate.day);
    notifyListeners();
  }

  /// Updates the appointment start time using the current selected date.
  void updatAppointStartTime(DateTime startTime) {
    DateTime formattedStartTime = DateTime(
      _appointSelectedDate.year,
      _appointSelectedDate.month,
      _appointSelectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    _appointStartTime = formattedStartTime;
    notifyListeners();
  }

  /// Updates the appointment end time using the current selected date.
  void updateAppointEndTime(DateTime endTime) {
    DateTime formattedEndTime = DateTime(
      _appointSelectedDate.year,
      _appointSelectedDate.month,
      _appointSelectedDate.day,
      endTime.hour,
      endTime.minute,
    );
    _appointEndTime = formattedEndTime;
    notifyListeners();
  }

  /// Updates the appointment duration.
  void updateAppointDuration(Duration duration) {
    _appointDuration = duration;
    notifyListeners();
  }

  // ----------------- Data Fetch Methods -----------------

  List<AppointModel> _bookinglist = [];
  List<AppointModel> get getBookingList => _bookinglist;

  /// Fetches booking list for a specific date.
  Future<void> getBookingListPro(DateTime date) async {
    try {
      // Normalize the date.
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      print("Normalized Date for Firestore Query: $normalizedDate");

      _bookinglist =
          await AppintBookingFb.instance.getUserBookingListFB(normalizedDate);
      // await _userBookingFB.getUserBookingListFB(normalizedDate, salonId);
      print("Fetched bookings for date: $normalizedDate");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching booking list: $e");
    }
  }

  /// Updates an appointment in the booking list.
  Future<bool> updateAppointment(
      int index, appointmentId, AppointModel appointModel) async {
    try {
      await AppintBookingFb.instance
          .updateAppointmentFB(appointmentId, appointModel);
      _bookinglist[index] = appointModel;
      return true;
    } catch (e) {
      debugPrint("Error updating appointment: $e");
      return false;
    }
  }
}
