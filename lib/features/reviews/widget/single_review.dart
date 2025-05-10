import 'package:admin_panel_ak/provider/reviewsProvider.dart';
import 'package:admin_panel_ak/utility/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/ReviewModel/review_model.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

Widget singleReview(
  ReviewModel reviewModel,
  AppProvider appProvider,
  bool showThreeDotMenu,
  BuildContext context,
  Reviewsprovider reviewsprovider,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
        // horizontal: Dimensions.dimenisonNo12,
        ),
    child: Column(
      children: [
        Container(
          padding: ResponsiveLayout.isMobile(context)
              ? EdgeInsets.symmetric(
                  horizontal: Dimensions.dimenisonNo12,
                  vertical: Dimensions.dimenisonNo10)
              : EdgeInsets.symmetric(
                  horizontal: Dimensions.dimenisonNo40,
                  vertical: Dimensions.dimenisonNo10),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the start
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                trailing: showThreeDotMenu
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert), // Three-dot icon
                        onSelected: (value) {
                          // if (value == 'edit') {
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) => PopupWriteReviewsEdit(
                          //       context: context,
                          //       user: appProvider.getUserModel!,
                          //       reviewModel: reviewsprovider.getUserReviews!,
                          //     ),
                          //   );
                          //   // Handle edit action
                          //   print('Edit review: ${reviewModel.id}');
                          //   // Add your edit logic here
                          // } else if (value == 'delete') {
                          FirebaseFirestoreHelper.instance
                              .deleteReviewFB(reviewModel.id, context);
                          // reviewsprovider.getUserReviewsPro();

                          // Handle delete action
                          print('Delete review: ${reviewModel.id}');
                          // Add your delete logic here
                          // }
                        },
                        itemBuilder: (BuildContext context) => [
                          // const PopupMenuItem<String>(
                          //   value: 'edit',
                          //   child: Text('Edit'),
                          // ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      )
                    : null,
                leading: CircleAvatar(
                  radius: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimenisonNo20
                      : Dimensions.dimenisonNo24,
                  backgroundImage: reviewModel.userModel.image != null &&
                          reviewModel.userModel.image!.isNotEmpty
                      ? NetworkImage(reviewModel.userModel
                          .image!) // Use the user's image if available
                      : AssetImage(GlobalVariable.profileImage)
                          as ImageProvider, // Use local image if null or empty
                ),
                title: Text(
                  reviewModel.userModel.name,
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  GlobalVariable.formatDateToString(
                      reviewModel.timeStampModel.dateAndTime),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Dimensions.dimenisonNo12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Add star icons for the rating
              Padding(
                padding: EdgeInsets.only(
                    left: ResponsiveLayout.isMobile(context) ? 4 : 0.0),
                child: Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < reviewModel.rating.round()
                          ? Icons.star
                          : Icons
                              .star_border, // Filled star for rating, border for the rest
                      color: Colors.amber,
                      size: Dimensions.dimenisonNo16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height: 8), // Add spacing between stars and review text
              // Add the review text
              Padding(
                padding: EdgeInsets.only(
                    left: ResponsiveLayout.isMobile(context) ? 4 : 0.0),
                child: Text(
                  reviewModel.reviewText,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimenisonNo12
                        : Dimensions.dimenisonNo14,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.dimenisonNo8,
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity, // Line thickness
          height: 1, // Line height
          color: Colors.grey, // Line color
          margin: ResponsiveLayout.isMobile(context)
              ? EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo16)
              : EdgeInsets.symmetric(horizontal: 32),
        )
      ],
    ),
  );
}
