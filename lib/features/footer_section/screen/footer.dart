import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/models/footer_model/footer_model.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

class Footer extends StatelessWidget {
  final FooterModel footerModel;
  const Footer({super.key, required this.footerModel});

  @override
  Widget build(BuildContext context) {
    // Helper to launch a URL in a new tab.

    // Method to open WhatsApp with the phone number
    Future<void> _openWhatsApp(String phoneNumber) async {
      try {
        final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
        await launchUrl(whatsappUrl);
      } catch (e) {
        showBottonMessageError('Could not launch WhatsApp $e', context);
      }
    }

    Future<void> _openInstaragran(String instaUrl) async {
      try {
        final Uri Url = Uri.parse(instaUrl);
        await launchUrl(Url);
      } catch (e) {
        print('Could not launch nstaragran $e');
        showMessage('Could not launch nstaragran $e');
      }
    }

    // Build social media icon that opens the link.
    Widget _buildSocialIcon(IconData iconData, String url, VoidCallback ontap) {
      return InkWell(
        onTap: () => ontap,
        child: Icon(
          iconData,
        ),
      );
    }

    IconButton iconButtonMethod(
      IconData iconData,
      String url,
    ) {
      return IconButton(
          onPressed: () {
            js.context.callMethod('open', [url]);
          },
          icon: FaIcon(
            iconData,
            size: Dimensions.dimenisonNo24,
            color: Colors.grey,
          ));
    }

    return Padding(
      padding: EdgeInsets.all(Dimensions.dimenisonNo12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Dimensions.screenWidth / 5,
                child: Center(
                  child: Image.asset(
                    'assets/images/sabWithBea.jpg',
                    height: Dimensions.dimenisonNo80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: Dimensions.dimenisonNo20,
              ),
              // Column 1: About Us

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About Us",
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo20),
                    // Instead of wrapping Text with Expanded, set maxLines directly.
                    Text(
                      footerModel.about,
                      overflow: TextOverflow.visible,
                      maxLines: 6,
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: Dimensions.screenWidth / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Cities",
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: footerModel.city.map((city) {
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: Dimensions.dimenisonNo8),
                          child: Text(
                            city,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.dimenisonNo20),

              SizedBox(
                width: Dimensions.screenWidth / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo16),
                    Row(
                      children: [
                        Icon(Icons.phone,
                            size: Dimensions.dimenisonNo16,
                            color: Colors.white),
                        SizedBox(width: Dimensions.dimenisonNo8),
                        Flexible(
                          child: Text(
                            footerModel.mobileNo,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo14,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.dimenisonNo16),
                    Row(
                      children: [
                        Icon(Icons.email,
                            size: Dimensions.dimenisonNo16,
                            color: Colors.white),
                        SizedBox(width: Dimensions.dimenisonNo8),
                        Flexible(
                          child: Text(
                            footerModel.email,
                            style: TextStyle(
                                fontSize: Dimensions.dimenisonNo14,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.dimenisonNo16),
                    // Social media icons row.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: iconButtonMethod(
                                Icons.facebook, footerModel.faceback)),
                        if (footerModel.instaragran.isNotEmpty)
                          Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: iconButtonMethod(
                                  FontAwesomeIcons.instagram,
                                  footerModel.instaragran)),
                        if (footerModel.x.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: iconButtonMethod(
                                FontAwesomeIcons.twitter, footerModel.x),
                          ),
                        if (footerModel.linked.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: iconButtonMethod(FontAwesomeIcons.linkedinIn,
                                footerModel.linked),
                          ),
                        if (footerModel.youtube.isNotEmpty)
                          iconButtonMethod(
                              FontAwesomeIcons.youtube, footerModel.youtube),
                      ],
                    ),

                    // Copyright row.
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.dimenisonNo16),
          Text(
            "© Copyright by Samay",
            style: TextStyle(
                color: Colors.white, fontSize: Dimensions.dimenisonNo14),
          )
        ],
      ),
    );
  }
}
