// ignore_for_file: unused_local_variable, unnecessary_null_comparison, prefer_final_fields

import 'package:admin_panel_ak/constants/router.dart';
import 'package:admin_panel_ak/features/Calender/screen/calender.dart';
import 'package:admin_panel_ak/features/appoint/add_appoint/widget/single_service_tap.dart';
import 'package:admin_panel_ak/features/appoint/add_appoint/widget/single_service_tap_icon.dart';
import 'package:admin_panel_ak/features/appoint/add_appoint/widget/time_tap.dart';
import 'package:admin_panel_ak/features/dastbord/dastbord.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/appoint_booking.dart';

import 'package:admin_panel_ak/provider/bookingProvider.dart';
import 'package:admin_panel_ak/utility/responsive_layout.dart';
import 'package:admin_panel_ak/widget/button/customauthbutton.dart';
import 'package:admin_panel_ak/widget/text_box/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

class AddNewAppointment extends StatefulWidget {
  const AddNewAppointment({
    super.key,
  });

  @override
  State<AddNewAppointment> createState() => _AddNewAppointmentState();
}

class _AddNewAppointmentState extends State<AddNewAppointment> {
  DateTime _time = DateTime.now();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _appointmentDateController = TextEditingController();
  TextEditingController _appointmentTimeController =
      TextEditingController(text: "Select Time");
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _userNote = TextEditingController();

  List<ServiceModel> serchServiceList = [];
  List<ServiceModel> allServiceList = [];
  List<ServiceModel> selectService = [];

  bool _showCalender = false;
  bool _showServiceList = false;
  bool _showTimeContaine = false;
  bool _isLoading = false;

  int _timediff = 30;
  int appointmentNO = 0;
  bool isGSTAvaible = false;

//Serching  Services base on service name and code
  void serchService(String value) {
    // Filtering based on both service name and service code
    serchServiceList = allServiceList
        .where((element) =>
            element.servicesName.toLowerCase().contains(value.toLowerCase()))
        .toList();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
    _initializeTimes();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });

    // AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    // ServiceProvider serviceProvider =
    //     Provider.of<ServiceProvider>(context, listen: false);

    try {
      bookingProvider.getWatchList.clear();
      // _settingModel = await SettingFb.instance
      //     .fetchSettingFromFB(appProvider.getSalonInformation.id);
      // await bookingProvider.fetchSettingPro(appProvider.getSalonInformation.id);
      // await appProvider.getSalonInfoFirebase();
      // await serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);
      // _timediff = int.parse(serviceProvider.getSettingModel!.diffbtwTimetap);
      setState(() {
        _appointmentDateController.text =
            DateFormat("dd MMM yyyy").format(_time);
        bookingProvider.getWatchList.clear();
      });

      List<ServiceModel> fetchedServices =
          await AppintBookingFb.instance.getAllServicesFromCategories();

      // _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();

      // GlobalVariable.salonPlatformFee = _samaySalonSettingModel!.platformFee;

      // gprint("Gst is == ${_settingModel!.gSTIsIncludingOrExcluding}");
      // print("Plact fee ${_samaySalonSettingModel!.platformFee}");

      setState(() {
        allServiceList = fetchedServices;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  String? _selectedTimeSlot;

//for Salon open and closer time
  DateTime? _startTime;
  DateTime? _endTime;

//For time slot
  Map<String, List<String>> _categorizedTimeSlots = {
    'Morning': [],
    'Afternoon': [],
    'Evening': [],
    'Night': [],
  };

  String timeOfDayToString(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour
        .toString()
        .padLeft(2, '0'); // Ensures two digits for hour
    final minute = timeOfDay.minute
        .toString()
        .padLeft(2, '0'); // Ensures two digits for minute
    return "$hour:$minute";
  }

  void _initializeTimes() {
    try {
      // Ensure openTime and closeTime are not null and are TimeOfDay

      // Convert TimeOfDay to string for formatting
      // String salonOpenTime = _timeOfDayToString(widget.salonModel.openTime!);
      // String salonCloseTime = _timeOfDayToString(widget.salonModel.closeTime!);
      String salonOpenTime = _timeOfDayToString(GlobalVariable.openTime);
      String salonCloseTime = _timeOfDayToString(GlobalVariable.closeTime);

      if (salonOpenTime.isEmpty || salonCloseTime.isEmpty) {
        throw 'Salon opening or closing time is empty.';
      }

      // Parse the 12-hour time format with AM/PM (e.g., '11:00 PM')
      try {
        _startTime = DateFormat('hh:mm a').parse(salonOpenTime);
        _endTime = DateFormat('hh:mm a').parse(salonCloseTime);

        print("Parsed startTime: $_startTime, endTime: $_endTime");
      } catch (e) {
        throw 'Error parsing the opening or closing time: $e';
      }
    } catch (e) {
      // Handle parsing errors and fallback times
      print('Error: $e');

      // Set default times if parsing fails
      _startTime = DateTime.now(); // Fallback to the current time
      _endTime =
          DateTime.now().add(Duration(hours: 8)); // Default to 8 hours later

      print("Using fallback times: startTime: $_startTime, endTime: $_endTime");
    }
  }

// Helper method to convert TimeOfDay to a 12-hour AM/PM string
  String _timeOfDayToString(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour % 12; // Convert hour to 12-hour format
    final minute = timeOfDay.minute;
    final period = timeOfDay.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _normalizeTimeString(String timeString) {
    return timeString.replaceAllMapped(
      RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)'),
      (match) => '${match[1]?.padLeft(2, '0')}:${match[2]} ${match[3]}',
    );
  }

  int parseDuration(String duration) {
    final regex = RegExp(r'(\d+)h (\d+)m');
    final match = regex.firstMatch(duration);

    if (match != null) {
      final hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      return hours * 60 + minutes;
    }

    return 0; // Default to 0 if parsing fails
  }

//Generate Time slotes
  void _generateTimeSlots(int serviceDurationInMinutes) {
    if (_startTime != null && _endTime != null) {
      DateTime currentTime = _startTime!;
      _categorizedTimeSlots.forEach((key, value) => value.clear());

      while (currentTime.isBefore(_endTime!)) {
        final slotEndTime =
            currentTime.add(Duration(minutes: serviceDurationInMinutes));
        String formattedTime = DateFormat('hh:mm a').format(currentTime);

        if (currentTime.hour < 12) {
          _categorizedTimeSlots['Morning']!.add(formattedTime);
        } else if (currentTime.hour < 17) {
          _categorizedTimeSlots['Afternoon']!.add(formattedTime);
        } else if (currentTime.hour < 21) {
          _categorizedTimeSlots['Evening']!.add(formattedTime);
        } else {
          _categorizedTimeSlots['Night']!.add(formattedTime);
        }
        currentTime = currentTime.add(Duration(minutes: _timediff));
      }

      // Ensure the last slot includes the closing time, but only if the list is not empty.
      if (_categorizedTimeSlots['Night']!.isNotEmpty) {
        String lastSlotFormattedTime = DateFormat('hh:mm a').format(_endTime!);
        if (_categorizedTimeSlots['Night']!.last != lastSlotFormattedTime) {
          _categorizedTimeSlots['Night']!.add(lastSlotFormattedTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    final serviceBookingDuration = GlobalVariable.getServiceBookingDuration;
    final serviceDurationInMinutes = parseDuration(serviceBookingDuration);
    _generateTimeSlots(serviceDurationInMinutes);

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () {
                  if (_showCalender ||
                      _showServiceList ||
                      _showTimeContaine == true) {
                    setState(() {
                      _showCalender = false;
                      _showServiceList = false;
                      _showTimeContaine = false;
                    });
                  }
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.screenHeight * 2,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo16),
                                  child: Text(
                                    "Add New Appointment",
                                    style: TextStyle(
                                      fontSize: Dimensions.dimenisonNo20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Container to User TextBox
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Dimensions.dimenisonNo16),
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo16),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.5),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.dimenisonNo8),
                                  ),
                                  child: Center(
                                    child: textbox(),
                                  ),
                                ),
                                //! Genarate List of Service which in Watch list
                                GestureDetector(
                                  onTap: () {
                                    if (_showCalender ||
                                        _showServiceList ||
                                        _showTimeContaine == true) {
                                      setState(() {
                                        _showCalender = false;
                                        _showServiceList = false;
                                        _showTimeContaine = false;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.dimenisonNo18,
                                        vertical: Dimensions.dimenisonNo12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Select Serivce",
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.dimenisonNo18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "Service Duration ${bookingProvider.getServiceBookingDuration}",
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.dimenisonNo18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimensions.dimenisonNo10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.dimenisonNo12),
                                          child: Wrap(
                                            spacing: Dimensions
                                                .dimenisonNo12, // Horizontal space between items
                                            runSpacing: Dimensions
                                                .dimenisonNo12, // Vertical space between rows
                                            children: List.generate(
                                              bookingProvider
                                                  .getWatchList.length,
                                              (index) {
                                                ServiceModel servicelist =
                                                    bookingProvider
                                                        .getWatchList[index];
                                                return SizedBox(
                                                  width:
                                                      Dimensions.dimenisonNo300,
                                                  child:
                                                      SingleServiceTapDeleteIcon(
                                                    serviceModel: servicelist,
                                                    onTap: () {
                                                      try {
                                                        showLoaderDialog(
                                                            context);
                                                        setState(() {
                                                          bookingProvider
                                                              .removeServiceToWatchList(
                                                                  servicelist);

                                                          bookingProvider
                                                              .calculateTotalBookingDuration();
                                                          bookingProvider
                                                              .calculateSubTotal();
                                                        });

                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        showMessage(
                                                            'Service is removed from Watch List');
                                                      } catch (e) {
                                                        showMessage(
                                                            'Error occurred while removing service from Watch List: ${e.toString()}');
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimensions.dimenisonNo12),
                                        //! TextBox for user note
                                        // SizedBox(
                                        //   width: Dimensions.screenWidth,
                                        //   child: FormCustomTextField(
                                        //     requiredField: false,
                                        //     controller: _userNote,
                                        //     title: "User Note",
                                        //     maxline: 2,
                                        //     hintText:R
                                        //         "Instruction of for appointment",
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //     height: Dimensions.dimenisonNo12),
                                        // Detail of appointment
                                        //! Appointment Details
                                        if (_appointmentDateController != null)
                                          priceSection(
                                              bookingProvider,
                                              serviceDurationInMinutes,
                                              context),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_showTimeContaine)
                            Positioned(
                              right: Dimensions.dimenisonNo360,
                              top: Dimensions.dimenisonNo150,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo12),
                                  color: Colors.white,
                                  width: Dimensions.dimenisonNo500,
                                  child: Column(
                                    children: [
                                      TimeSlot(
                                        section: 'Morning',
                                        timeSlots:
                                            _categorizedTimeSlots['Morning'] ??
                                                [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      TimeSlot(
                                        section: 'Afternoon',
                                        timeSlots: _categorizedTimeSlots[
                                                'Afternoon'] ??
                                            [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      TimeSlot(
                                        section: 'Evening',
                                        timeSlots:
                                            _categorizedTimeSlots['Evening'] ??
                                                [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      TimeSlot(
                                        section: 'Night',
                                        timeSlots:
                                            _categorizedTimeSlots['Night'] ??
                                                [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: Dimensions.dimenisonNo12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (_showCalender)
                            Positioned(
                              right: Dimensions.dimenisonNo360,
                              top: Dimensions.dimenisonNo120,
                              child: SizedBox(
                                height: Dimensions.dimenisonNo450,
                                width: Dimensions.dimenisonNo360,
                                child: CustomCalendar(
                                  controller: _appointmentDateController,
                                  initialDate: _time,
                                  onDateChanged: (selectedDate) {},
                                ),
                              ),
                            ),
                          if (_showServiceList)
                            Positioned(
                              left: 93,
                              top: 215,
                              child: Container(
                                width: Dimensions.dimenisonNo500,
                                constraints: const BoxConstraints(
                                  maxHeight:
                                      320, // Set a max height to make it scrollable
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.dimenisonNo10),
                                ),
                                child: _serviceController.text.isNotEmpty &&
                                        serchServiceList.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: Dimensions.dimenisonNo12,
                                          left: Dimensions.dimenisonNo16,
                                          bottom: Dimensions.dimenisonNo12,
                                        ),
                                        child: Text(
                                          "No service found",
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.dimenisonNo14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : serchServiceList.contains(
                                                // ignore: iterable_contains_unrelated_type
                                                _serviceController.text) ||
                                            _serviceController.text.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              top: Dimensions.dimenisonNo12,
                                              left: Dimensions.dimenisonNo16,
                                              bottom: Dimensions.dimenisonNo12,
                                            ),
                                            child: Text(
                                              "Enter a Service name or Code",
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.dimenisonNo14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: serchServiceList.length,
                                            itemBuilder: (context, index) {
                                              ServiceModel serviceModel =
                                                  serchServiceList[index];
                                              return
                                                  // !isSearched()

                                                  SingleServiceAppAppointTap(
                                                      serviceModel:
                                                          serviceModel);
                                            },
                                          ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Column textbox() {
    return ResponsiveLayout.isTablet(context)
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _nameController,
                      title: "First Name",
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.dimenisonNo30,
                  ),
                  //! User last Name textbox

                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _lastNameController,
                      title: "Last Name",
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.dimenisonNo30,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //! select Date text box
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Appointment Date",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.90,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo5,
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo30,
                          width: Dimensions.dimenisonNo250,
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                _showCalender = !_showCalender;
                              });
                              print(_showCalender);
                            },
                            readOnly: true,
                            cursorHeight: Dimensions.dimenisonNo16,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            controller: _appointmentDateController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo10,
                                  vertical: Dimensions.dimenisonNo10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.dimenisonNo16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.90,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo5,
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo30,
                          width: Dimensions.dimenisonNo250,
                          child: TextFormField(
                            onChanged: (String value) {
                              serchService(value);
                              _showServiceList = true;
                            },
                            onTap: () {
                              setState(() {
                                _showServiceList = !_showServiceList;
                              });
                            },
                            cursorHeight: Dimensions.dimenisonNo16,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            controller: _serviceController,
                            decoration: InputDecoration(
                              hintText: "Search Service...",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo10,
                                  vertical: Dimensions.dimenisonNo10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.dimenisonNo16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //! mobile text box
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _mobileController,
                      title: "Mobile No",
                    ),
                  ),
                  //! select time textbox
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.90,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo5,
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo30,
                          width: Dimensions.dimenisonNo250,
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                _showTimeContaine = !_showTimeContaine;
                                print("Time : $_showTimeContaine");
                              });
                            },
                            cursorHeight: Dimensions.dimenisonNo16,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            controller: _appointmentTimeController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo10,
                                  vertical: Dimensions.dimenisonNo10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.dimenisonNo16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        : Column(
            children: [
              // User Name textbox
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _nameController,
                      title: "First Name",
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.dimenisonNo30,
                  ),
                  //! User last Name textbox

                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _lastNameController,
                      title: "Last Name",
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.dimenisonNo30,
                  ),
                  //! select Date text box
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Appointment Date",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.90,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo5,
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo30,
                          width: Dimensions.dimenisonNo250,
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                _showCalender = !_showCalender;
                              });
                              print(_showCalender);
                            },
                            readOnly: true,
                            cursorHeight: Dimensions.dimenisonNo16,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            controller: _appointmentDateController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo10,
                                  vertical: Dimensions.dimenisonNo10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.dimenisonNo16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //! Search box for Services  text box

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.90,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo5,
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo30,
                          width: Dimensions.dimenisonNo250,
                          child: TextFormField(
                            onChanged: (String value) {
                              serchService(value);
                              _showServiceList = true;
                            },
                            onTap: () {
                              setState(() {
                                _showServiceList = !_showServiceList;
                              });
                            },
                            cursorHeight: Dimensions.dimenisonNo16,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            controller: _serviceController,
                            decoration: InputDecoration(
                              hintText: "Search Service...",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo10,
                                  vertical: Dimensions.dimenisonNo10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.dimenisonNo16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.dimenisonNo30,
                  ),
                  //! mobile text box
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _mobileController,
                      title: "Mobile No",
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.dimenisonNo30,
                  ),

                  //! select time textbox
                  SizedBox(
                    height: Dimensions.dimenisonNo70,
                    width: Dimensions.dimenisonNo250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.90,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo5,
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo30,
                          width: Dimensions.dimenisonNo250,
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                _showTimeContaine = !_showTimeContaine;
                                print("Time : $_showTimeContaine");
                              });
                            },
                            cursorHeight: Dimensions.dimenisonNo16,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            controller: _appointmentTimeController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo10,
                                  vertical: Dimensions.dimenisonNo10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.dimenisonNo16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // SizedBox(height: Dimensions.dimenisonNo16),
            ],
          );
  }

  Container priceSection(
    BookingProvider bookingProvider,
    int serviceDurationInMinutes,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo250),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo20),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.dimenisonNo16),
          if (_selectedTimeSlot != null)
            Text(
              'Appointment Summary.',
              style: TextStyle(
                fontSize: Dimensions.dimenisonNo16,
                fontWeight: FontWeight.bold,
              ),
            ),
          const Divider(
            color: Colors.white,
          ),
          if (_selectedTimeSlot != null) ...[
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment Date',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
                Spacer(),
                Text(
                  _appointmentDateController.text,
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment Duration',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
                const Spacer(),
                Text(
                  bookingProvider.getServiceBookingDuration,
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment Start Time',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
                const Spacer(),
                Text(
                  '$_selectedTimeSlot',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment End Time',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('hh:mm a').format(
                    DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
                          Duration(minutes: serviceDurationInMinutes),
                        ),
                  ),
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            const Divider(
              color: Colors.white,
            ),
            Center(
              child: Text(
                'Price Details',
                style: TextStyle(
                  fontSize: Dimensions.dimenisonNo16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'SubTotal',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.currency_rupee,
                  size: Dimensions.dimenisonNo16,
                ),
                Text(
                  bookingProvider.getSubTotal.toString(),
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),

            Row(
              children: [
                Text(
                  'Net',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
                const Spacer(),
                Text(
                  // "₹${}",
                  "₹${bookingProvider.getNetPrice!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),

            // Add GST Price
            // _settingModel!.gstNo.length == 15
            //     ? Column(
            //         children: [
            //           SizedBox(height: Dimensions.dimenisonNo10),
            //           Row(
            //             children: [
            //               Text(
            //                 'GST 18% (SGST & CGST)',
            //                 style: TextStyle(
            //                   fontSize: Dimensions.dimenisonNo14,
            //                   fontWeight: FontWeight.w500,
            //                   letterSpacing: 0.90,
            //                 ),
            //               ),
            //               const Spacer(),
            //               Icon(
            //                 Icons.currency_rupee,
            //                 size: Dimensions.dimenisonNo16,
            //               ),
            //               Text(
            //                 bookingProvider.getCalGSTAmount.toStringAsFixed(2),
            //                 style: TextStyle(
            //                   fontSize: Dimensions.dimenisonNo14,
            //                   fontWeight: FontWeight.w500,
            //                   letterSpacing: 0.90,
            //                 ),
            //               ),
            //             ],
            //           )
            //         ],
            //       )
            //     : SizedBox(),
            // SizedBox(height: Dimensions.dimenisonNo10),
            // Row(
            //   children: [
            //     Text(
            //       'Platform fee',
            //       style: TextStyle(
            //         fontSize: Dimensions.dimenisonNo14,
            //         fontWeight: FontWeight.w500,
            //         letterSpacing: 0.90,
            //       ),
            //     ),
            //     const Spacer(),
            //     Icon(
            //       Icons.currency_rupee,
            //       size: Dimensions.dimenisonNo16,
            //     ),
            //     Text(
            //       _samaySalonSettingModel!.platformFee,
            //       style: TextStyle(
            //         fontSize: Dimensions.dimenisonNo14,
            //         fontWeight: FontWeight.w500,
            //         letterSpacing: 0.90,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.currency_rupee,
                  size: Dimensions.dimenisonNo16,
                ),
                Text(
                  // _settingModel!.gstNo.length == 15
                  //     ?
                  bookingProvider.getFinalTotal.round().toString(),
                  // : bookingProvider.getfinalTotal.round().toString(),
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.90,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo16),

            //! Save Button
            //  saveAppointChenckButton(
            //   context, serviceDurationInMinutes, bookingProvider),
            //! Save Button
            saveAppointButton(
                context, serviceDurationInMinutes, bookingProvider),
            SizedBox(height: Dimensions.dimenisonNo10),
          ],
        ],
      ),
    );
  }

  CustomAuthButton saveAppointButton(BuildContext context,
      int serviceDurationInMinutes, BookingProvider bookingProvider) {
    return CustomAuthButton(
      text: "Save Appointment",
      ontap: () async {
        // showLoaderDialog(context);

        //! user full name
        String fullName =
            "${_nameController.text.trim()} ${_lastNameController.text.trim()}";
        //! user model

        // get Book appointment time

        bool _isVaildater = addNewAppointmentVaildation(_nameController.text,
            _lastNameController.text, _mobileController.text);
        // Navigator.of(context, rootNavigator: true).pop();
        if (_isVaildater) {
          // showLoaderDialog(context);

          // final List<TimeStampModel> _timeStampList = [];

          // TimeStampModel _timeStampModel = TimeStampModel(
          //     id: "",
          //     dateAndTime: GlobalVariable.today,
          //     updateBy: "Sab (Create a Appointment)");

          // _timeStampList.add(_timeStampModel);

          // UserModel userInfo = UserModel(
          //     id: _mobileController.text.trim(),
          //     name: fullName,
          //     phone: _mobileController.text.trim(),
          //     image:
          //         'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
          //     email: "No email",
          //     password: " ",
          //     timeStampModel: _timeStampModel);

          // AppointModel appointmentModel = AppointModel(
          //     id: "",
          //     adminId: "",
          //     status: "Pending",
          //     totalPrice: bookingProvider.getFinalTotal,
          //     subtotal: bookingProvider.getSubTotal,
          //     serviceDate: bookingProvider.getAppointSelectedDate,
          //     serviceStartTime: bookingProvider.getAppointStartTime,
          //     serviceEndTime: bookingProvider.getAppointEndTime,
          //     userNote: bookingProvider.getUserNote!,
          //     userModel: userInfo,
          //     timeStampList: _timeStampList,
          //     isUpdate: false,
          //     isManual: true,
          //     services: bookingProvider.getWatchList,
          // serviceAt: "Salon");
          final serviceDurationInMinutes =
              parseDuration(bookingProvider.getServiceBookingDuration);

          bool value = await AppintBookingFb.instance.saveAppointmentManual(
              context,
              fullName,
              _mobileController.text.trim(),
              bookingProvider.getFinalTotal,
              bookingProvider.getSubTotal,
              bookingProvider.getAppointSelectedDate,
              bookingProvider.getAppointStartTime,
              bookingProvider.getAppointEndTime,
              serviceDurationInMinutes,
              // bookingProvider.getUserNote! ?? " ",
              bookingProvider.getWatchList,
              "Salon");

          // Navigator.of(context, rootNavigator: true).pop();

          showMessage("Successfull add the appointment");

          if (value) {
            showLoaderDialog(context);
            Future.delayed(
              const Duration(seconds: 1),
              () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: Dimensions.dimenisonNo250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Dimensions.dimenisonNo12,
                            ),
                            Icon(
                              FontAwesomeIcons.solidHourglassHalf,
                              size: Dimensions.dimenisonNo40,
                              color: AppColor.buttonRedColor,
                            ),
                            SizedBox(
                              height: Dimensions.dimenisonNo20,
                            ),
                            Text(
                              'Appointment Book Successfull',
                              style: TextStyle(
                                fontSize: Dimensions.dimenisonNo16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.dimenisonNo16,
                            ),
                            Text(
                              '     Your booking has been processed!\nDetails of appointment are included below',
                              style: TextStyle(
                                fontSize: Dimensions.dimenisonNo12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // SizedBox(
                            //   height: Dimensions.dimenisonNo20,
                            // ),
                            // Text(
                            //   'Appointment No : $appointmentNO',
                            //   style: TextStyle(
                            //     fontSize: Dimensions.dimenisonNo14,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Routes.instance.push(
                                widget: const HomeDashBord(), context: context);
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimenisonNo18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
    );
  }
}
