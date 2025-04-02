import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalVariable {
  static const String salon = "Salon";

// variable for increment appointment no.
  static String samayCollectionId = "";
  static String salonSettingCollectionId = "";
  static String samayAppCollectionId = "";
  static String samaySocial = "";
  static int appointmentNO = 0;

  static String customerNo = "7972391849";
  static String customerGmail = "samaystartup@gmail.com";

  static DateTime today = DateTime.now();

  // Function to get current date and time in a formatted string
  static String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd MMM yyyy').format(now);
  }

  static String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('hh:mm a').format(now); // HH:mm a (e.g. 03:45 PM)
  }

// TimeOfDay 24 hr convert to TimeOfDay 12hr
  static TimeOfDay convertTo12HourFormat(TimeOfDay time) {
    int hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    return TimeOfDay(hour: hour, minute: time.minute);
  }

// TimeOfDay 24 hr convert to String 12:30 AM
  static String timeOfDayToDateTimeAM(TimeOfDay timeOfDay) {
    DateTime dateTime = DateTime(2024, 1, 1, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Formate DateTime (dd MMM yyy) to  DateTime
  static DateTime DateTimeFomate(DateTime _date) {
    String _formatted = DateFormat("dd MMM yyyy").format(_date);
    DateTime _FormateDate = DateFormat("dd MMM yyyy").parse(_formatted);
    return _FormateDate;
  }

// Funtion to convert DateTime to String
  static String formatDateToString(DateTime dateTime) {
    // Create a DateFormat object with the desired format
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    // Format the DateTime object to a string
    String formattedDate = formatter.format(dateTime);

    // Return the formatted string
    return formattedDate;
  }

  static String formatTimeToString(DateTime dateTime) {
    // Create a DateFormat object with the desired format
    final DateFormat formatter = DateFormat('hh:mm a');

    // Format the DateTime object to a string
    String formattedDate = formatter.format(dateTime);

    // Return the formatted string
    return formattedDate;
  }

  // Counter code
  static String indiaCode = "+91";

  //
  static String GstExclusive = "Exclusive";
  static String GstInclusive = "Inclusive";

  //Samay Admin plain
  static int salonPlatformFee = 20;

  // Dart Mode
  static bool isDarkMode = false;

  // super Category
  static String supCatHair = "Hair Services";
  static String supCatSkin = "Skin Services";
  static String supCatManiPedi = "Mani Pedi Services";
  static String supCatNail = "Nail Services";
  static String supCatMakeUp = "Makeup Services";
  static String supCatMassage = "Massage Services";
  static String supCatOther = "Other Services";

  // UserEnquriy state
  static String pendingState = "Pending";
  static String justEnquiryState = "Just Enquiry";

  static TimeOfDay openTime = TimeOfDay(hour: 09, minute: 00);
  static TimeOfDay closeTime = TimeOfDay(hour: 18, minute: 00);
  static String getServiceBookingDuration = "30";
}
