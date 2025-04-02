import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_panel_ak/constants/custom_chip.dart';
import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:admin_panel_ak/widget/pricerow.dart';

class SingleServiceTapDeleteIcon extends StatelessWidget {
  final ServiceModel serviceModel;
  final VoidCallback onTap;

  const SingleServiceTapDeleteIcon({
    Key? key,
    required this.serviceModel,
    required this.onTap,
  }) : super(key: key);

  // @override
  @override
  Widget build(BuildContext context) {
    Duration? _serviceDuration =
        Duration(minutes: serviceModel.serviceDurationMin);
    return Container(
      // height: Dimensions.dimenisonNo55,
      margin: EdgeInsets.only(bottom: Dimensions.dimenisonNo12),
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.dimenisonNo5,
          horizontal: Dimensions.dimenisonNo12),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.dimenisonNo12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '▪️ ${serviceModel.servicesName}',
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: Dimensions.dimenisonNo8),
                    //   child: Text(
                    //     'service code : ${serviceModel.serviceCode}',
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
                const Spacer(),
                CustomChip(
                  text: serviceModel.categoryName,
                )
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.dimenisonNo5,
                  ),
                  Text(
                    "Price ₹${serviceModel.price}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimenisonNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.dimenisonNo12,
                  ),
                  Row(
                    children: [
                      Text(
                        "During : ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
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
                        "${(_serviceDuration.inMinutes % 60).toString()}min",
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
                  SizedBox(
                    height: Dimensions.dimenisonNo5,
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: Dimensions.dimenisonNo30,
                ),
              ),
              SizedBox(
                width: Dimensions.dimenisonNo20,
              )
            ],
          ),
        ],
      ),
    );
  }
}
