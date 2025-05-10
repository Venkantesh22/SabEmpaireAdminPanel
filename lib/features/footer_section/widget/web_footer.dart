import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/models/footer_model/footer_model.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

Widget webFooter(
    IconButton Function(IconData iconData, String url) iconButtonMethod,
    BuildContext context,
    FooterModel footerModel,
    String email) {
  Future<void> _openWhatsApp(String phoneNumber) async {
    try {
      final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
      await launchUrl(whatsappUrl);
    } catch (e) {
      print('Could not launch WhatsApp: $e');
    }
  }

  IconButton _buildSocialIcon(IconData iconData, String url) {
    return IconButton(
      onPressed: () {
        if (url.isNotEmpty) {
          js.context.callMethod('open', [url]);
        } else {
          print('Invalid URL');
        }
      },
      icon: FaIcon(
        iconData,
        size: Dimensions.dimenisonNo24,
        color: Colors.grey,
      ),
    );
  }

  return Container(
    color: Colors.black,
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.dimenisonNo12,
        horizontal: Dimensions.dimenisonNo8,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: Dimensions.dimenisonNo12),

              // Column 1: Logo and Address
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        GlobalVariable.LogWithBeuText,
                        height: Dimensions.dimenisonNo80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    Text(
                      "Address: ${footerModel.address}",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.dimenisonNo20),

              // Column 2: About Us
              Expanded(
                flex: 2,
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
                    Text(
                      footerModel.about,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      maxLines: 6,
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Column 3: Service Cities
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Cities",
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

              // Column 4: Contact Us
              Expanded(
                flex: 1,
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
                            "${footerModel.mobileNo}, ${footerModel.mobileNo2}",
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo14,
                              color: Colors.white,
                            ),
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
                            email,
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.dimenisonNo16),

                    // Social media icons row
                    Wrap(
                      children: [
                        _buildSocialIcon(Icons.facebook, footerModel.facebook),
                        if (footerModel.instaragran.isNotEmpty)
                          _buildSocialIcon(FontAwesomeIcons.instagram,
                              footerModel.instaragran),
                        if (footerModel.x.isNotEmpty)
                          _buildSocialIcon(
                              FontAwesomeIcons.twitter, footerModel.x),
                        if (footerModel.linked.isNotEmpty)
                          _buildSocialIcon(
                              FontAwesomeIcons.linkedinIn, footerModel.linked),
                        if (footerModel.youtube.isNotEmpty)
                          _buildSocialIcon(
                              FontAwesomeIcons.youtube, footerModel.youtube),
                        if (footerModel.whatappNo.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              _openWhatsApp(footerModel.whatappNo);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              size: Dimensions.dimenisonNo24,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.dimenisonNo5),
          Text(
            "© 2025 Sab Empire Hair & Skin Solutions PVT LTD. All rights reserved.",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: Dimensions.dimenisonNo10,
            ),
          ),
        ],
      ),
    ),
  );
}
