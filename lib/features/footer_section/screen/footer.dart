import 'dart:js' as js;

import 'package:admin_panel_ak/utility/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admin_panel_ak/models/footer_model/footer_model.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

import '../widget/web_footer.dart';

class Footer extends StatelessWidget {
  final FooterModel footerModel;
  final String email;

  const Footer({
    Key? key,
    required this.footerModel,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return ResponsiveLayout(
      mobile: webFooter(iconButtonMethod, context, footerModel, email),
      desktop: webFooter(iconButtonMethod, context, footerModel, email),
    );
  }
}
