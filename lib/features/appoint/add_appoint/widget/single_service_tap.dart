import 'package:admin_panel_ak/provider/bookingProvider.dart';
import 'package:admin_panel_ak/widget/button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_ak/constants/custom_chip.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

class SingleServiceAppAppointTap extends StatefulWidget {
  final ServiceModel serviceModel;
  const SingleServiceAppAppointTap({
    super.key,
    required this.serviceModel,
  });

  @override
  State<SingleServiceAppAppointTap> createState() =>
      _SingleServiceAppAppointTapState();
}

class _SingleServiceAppAppointTapState
    extends State<SingleServiceAppAppointTap> {
  bool _isAdd = false;
  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    Duration? _serviceDuration =
        Duration(minutes: widget.serviceModel.serviceDurationMin);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: Dimensions.dimenisonNo16,
            right: Dimensions.dimenisonNo16,
            top: Dimensions.dimenisonNo10,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.dimenisonNo8,
            horizontal: Dimensions.dimenisonNo10,
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5),
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.serviceModel.servicesName,
                        style: TextStyle(
                          color: AppColor.serviceTapTextColor,
                          fontSize: Dimensions.dimenisonNo16,
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: Dimensions.dimenisonNo8),
                      //   child: Text(
                      //     'service code : ${widget.serviceModel.serviceCode}',
                      //     style: TextStyle(
                      //       color: Colors.grey,
                      //       fontSize: Dimensions.dimenisonNo10,
                      //       fontFamily: GoogleFonts.roboto().fontFamily,
                      //       letterSpacing: 1,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Spacer(),
                  CustomChip(text: widget.serviceModel.categoryName)
                ],
              ),
              // Padding(
              //   padding:
              //       EdgeInsets.symmetric(vertical: Dimensions.dimenisonNo8),
              //   child: const CustomDotttedLine(),
              // ),

              Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: Dimensions.dimenisonNo14,
                    color: Colors.black,
                  ),
                  _serviceDuration.inHours >= 1
                      ? Text(
                          ' ${_serviceDuration.inHours.toString()}h : ',
                          style: TextStyle(
                            color: AppColor.serviceTapTextColor,
                            fontSize: Dimensions.dimenisonNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        )
                      : SizedBox(),
                  Text(
                    " ${(_serviceDuration.inMinutes % 60).toString()}min",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimenisonNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: Dimensions.dimenisonNo12,
                  ),
                  Text(
                    "Price ₹${widget.serviceModel.price}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimenisonNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    buttonColor: bookingProvider.getWatchList
                            .contains(widget.serviceModel)
                        ? Colors.red
                        : AppColor.greenColor,
                    ontap: () {
                      setState(() {
                        _isAdd = !_isAdd;
                      });
                      bookingProvider.getWatchList.contains(widget.serviceModel)
                          // _isAdd
                          ? setState(() {
                              bookingProvider.removeServiceToWatchList(
                                  widget.serviceModel);
                              bookingProvider.calculateTotalBookingDuration();
                              bookingProvider.calculateSubTotal();

                              print(
                                  "watch  lIst  remove ${bookingProvider.getWatchList.length}");
                            })
                          : setState(() {
                              bookingProvider
                                  .addServiceToWatchList(widget.serviceModel);
                              bookingProvider.calculateTotalBookingDuration();
                              bookingProvider.calculateSubTotal();
                              print(
                                  "watch  lIst add ${bookingProvider.getWatchList.length}");
                            });
                    },
                    text: bookingProvider.getWatchList
                            .contains(widget.serviceModel)
                        ? "Remove -"
                        : "Add+",
                  ),
                ],
              ),
              SizedBox(height: Dimensions.dimenisonNo10),
              // Text(
              //   widget.serviceModel.description,
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: Dimensions.dimenisonNo12,
              //     fontFamily: GoogleFonts.roboto().fontFamily,
              //     // fontWeight: FontWeight.w500,
              //     letterSpacing: 1,
              //   ),
              // ),
              // SizedBox(height: Dimensions.dimenisonNo16),
            ],
          ),
        )
      ],
    );
  }
}
