// import 'package:admin_panel_ak/utility/color.dart';
// import 'package:company_admin/models/service_model/service_model.dart';
// import 'package:admin_panel_ak/utility/color.dart';
// import 'package:admin_panel_ak/utility/dimenison.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PriceRow extends StatelessWidget {
//   final ServiceModel serviceModel;

//   const PriceRow({super.key, required this.serviceModel});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: serviceModel.discountInPer != 0.0
//           ? [
//               // Discount Percentage
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: serviceModel.discountInPer.toString(),
//                       style: TextStyle(
//                         color: AppColor.buttonColor,
//                         fontSize: Dimensions.dimenisonNo16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "%",
//                       style: TextStyle(
//                         color: AppColor.buttonColor,
//                         fontSize: Dimensions.dimenisonNo16,
//                         fontFamily: GoogleFonts.roboto().fontFamily,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(width: Dimensions.dimenisonNo8),
//               // Original Price with rupee symbol using Text.rich (strikethrough and gray)
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '₹ ',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: Dimensions.dimenisonNo16,
//                         decoration: TextDecoration.lineThrough,
//                       ),
//                     ),
//                     TextSpan(
//                       text: serviceModel.originalPrice.toString(),
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: Dimensions.dimenisonNo16,
//                         fontFamily: GoogleFonts.roboto().fontFamily,
//                         fontWeight: FontWeight.w500,
//                         decoration: TextDecoration.lineThrough,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: Dimensions.dimenisonNo8),
//               // Final Price with rupee symbol (normal, no strikethrough)
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '₹',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: Dimensions.dimenisonNo16,
//                       ),
//                     ),
//                     TextSpan(
//                       text: serviceModel.price.toString(),
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: Dimensions.dimenisonNo16,
//                         fontFamily: GoogleFonts.roboto().fontFamily,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]
//           : [
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '₹',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: Dimensions.dimenisonNo16,
//                       ),
//                     ),
//                     TextSpan(
//                       text: serviceModel.price.toString(),
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: Dimensions.dimenisonNo16,
//                         fontFamily: GoogleFonts.roboto().fontFamily,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//     );
//   }
// }
