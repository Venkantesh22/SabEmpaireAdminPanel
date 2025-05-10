// ignore_for_file: unused_field, prefer_final_fields

import 'package:admin_panel_ak/features/reviews/widget/popup_reviews_edit.dart';
import 'package:admin_panel_ak/features/reviews/widget/rating_bar.dart';
import 'package:admin_panel_ak/features/reviews/widget/single_review.dart';
import 'package:admin_panel_ak/features/reviews/widget/sorf_by_card.dart';
import 'package:admin_panel_ak/utility/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_ak/constants/constants.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';

import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/ReviewModel/review_model.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:admin_panel_ak/provider/reviewsProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isloading = false;
  bool isNewestSelected = false;
  bool isHighestSelected = false;
  bool isLowestSelected = false;
  // ReviewModel? userReview;

  // Helper function to format total ratings
  String formatTotalRatings(double totalRatings) {
    if (totalRatings >= 100000) {
      // Convert to lakhs (L)
      return "${(totalRatings / 100000).toStringAsFixed(1)}L";
    } else if (totalRatings >= 1000) {
      // Convert to thousands (K)
      return "${(totalRatings / 1000).toStringAsFixed(1)}K";
    } else {
      // Return the number as is
      return totalRatings.toStringAsFixed(0);
    }
  }

  void setAllSelectToFalse() {
    isNewestSelected = false;
    isHighestSelected = false;
    isLowestSelected = false;
  }

  Future<void> getData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        Reviewsprovider reviewsprovider =
            Provider.of<Reviewsprovider>(context, listen: false);

        setState(() {
          _isloading = true;
        });

        await reviewsprovider.getAllReviewsPro();

        setState(() {
          _isloading = false;
        });
      } catch (e) {
        print("Error in getData: $e");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Reviewsprovider reviewsprovider = Provider.of<Reviewsprovider>(context);
    return Scaffold(
      backgroundColor:
          _isloading ? Colors.white : Color.fromARGB(179, 174, 172, 172),
      // key: _scaffoldKey,
      // drawer: const CustomDrawer(),
      // appBar: GlobalVariable.islogin
      //     ? CustomAppbarWIthLogin(scaffoldKey: _scaffoldKey)
      //     : CustomAppbarWIthOutLogin(scaffoldKey: _scaffoldKey),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: ResponsiveLayout.isMobile(context)
                    ? EdgeInsets.symmetric(
                        horizontal: Dimensions.dimenisonNo8,
                        vertical: Dimensions.dimenisonNo12)
                    : EdgeInsets.all(Dimensions.dimenisonNo20),
                padding: ResponsiveLayout.isMobile(context)
                    ? EdgeInsets.all(Dimensions.dimenisonNo8)
                    : EdgeInsets.all(Dimensions.dimenisonNo20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(Dimensions.dimenisonNo16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // heading text
                    headingText(),

                    // Container for rating bar
                    ratingContainer(reviewsprovider),

                    // writeReviewWidget(appProvider, reviewsprovider),

                    horizontalLine(),

                    reviewsprovider.getUserReviews != null
                        ? singleReview(reviewsprovider.getUserReviews!,
                            appProvider, true, context, reviewsprovider)
                        : const SizedBox(),

                    horizontalLine(),

                    sortByWidget(),

                    listOfReviews(appProvider, reviewsprovider),
                  ],
                ),
              ),
            )),
    );
  }

  Padding sortByWidget() {
    return Padding(
      padding: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo12,
              vertical: Dimensions.dimenisonNo10)
          : EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo40,
              vertical: Dimensions.dimenisonNo10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sort by",
            style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimenisonNo12
                    : Dimensions.dimenisonNo14,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          const SizedBox(
            height: 4,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                sortByCard("Newest", () {
                  setAllSelectToFalse();
                  setState(() {
                    isNewestSelected =
                        !isNewestSelected; // Toggle the selection state
                  });
                }, isNewestSelected, context),
                sortByCard("Highest", () {
                  setAllSelectToFalse();
                  setState(() {
                    isHighestSelected =
                        !isHighestSelected; // Toggle the selection state
                  });
                }, isHighestSelected, context),
                sortByCard("Lowest", () {
                  setState(() {
                    setAllSelectToFalse();
                    isLowestSelected =
                        !isLowestSelected; // Toggle the selection state
                  });
                }, isLowestSelected, context),
              ],
            ),
          )
        ],
      ),
    );
  }

  StreamBuilder<List<ReviewModel>> listOfReviews(
      AppProvider appProvider, Reviewsprovider reviewsprovider) {
    return StreamBuilder<List<ReviewModel>>(
      stream: FirebaseFirestoreHelper.instance.streamAllReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(Dimensions.dimenisonNo16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading reviews.'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No reviews available.'),
          );
        } else {
          // Get the list of reviews
          List<ReviewModel> reviewList = snapshot.data!;

          // Remove reviews where the user ID matches the logged-in user's ID

          // Check if the user is logged in before filtering
          // if (appProvider.getUserModel != null) {
          //   reviewList = reviewList
          //       .where((review) =>
          //           review.userModel.id != appProvider.getUserModel!.id)
          //       .toList();
          // }

          // Sort the reviews based on the selected sort option
          if (isHighestSelected) {
            // Sort by rating (highest to lowest)
            reviewList.sort((a, b) => b.rating.compareTo(a.rating));
          } else if (isLowestSelected) {
            // Sort by rating (lowest to highest)
            reviewList.sort((a, b) => a.rating.compareTo(b.rating));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviewList.length,
            itemBuilder: (context, index) {
              ReviewModel review = reviewList[index];
              return singleReview(
                  review, appProvider, true, context, reviewsprovider);
            },
          );
        }
      },
    );
  }

  Container horizontalLine() {
    return Container(
      width: double.infinity, // Line thickness
      height: 1, // Line height
      color: Colors.grey, // Line color
      margin: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo12)
          : EdgeInsets.symmetric(horizontal: 32),
    );
  }

  // Widget writeReviewWidget(
  //     AppProvider appProvider, Reviewsprovider reviewsprovider) {
  //   return InkWell(
  //     onTap: () async {
  //       if (GlobalVariable.islogin) {
  //         // Show the review dialog if the user is logged in
  //         reviewsprovider.getIsAlreadPostReview
  //             ? showDialog(
  //                 context: context,
  //                 builder: (context) => PopupWriteReviewsEdit(
  //                   context: context,
  //                   user: appProvider.getUserModel!,
  //                   reviewModel: reviewsprovider.getUserReviews!,
  //                 ),
  //               )
  //             : showDialog(
  //                 context: context,
  //                 builder: (context) => PopupWriteReviews(
  //                   context: context,
  //                   user: appProvider.getUserModel!,
  //                 ),
  //               );
  //       } else {
  //         // Show a message or redirect to the login page if the user is not logged in
  //         showBottonMessageError('Please log in to write a review.', context);
  //       }
  //     },
  //     child: Container(
  //       padding: ResponsiveLayout.isMobile(context)
  //           ? EdgeInsets.symmetric(
  //               horizontal: Dimensions.dimenisonNo12,
  //               vertical: Dimensions.dimenisonNo8)
  //           : EdgeInsets.symmetric(
  //               horizontal: Dimensions.dimenisonNo16,
  //               vertical: Dimensions.dimenisonNo12),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
  //         border: Border.all(
  //           color: Colors.black,
  //           width: 2,
  //         ),
  //       ),
  //       margin: ResponsiveLayout.isMobile(context)
  //           ? EdgeInsets.only(
  //               left: Dimensions.dimenisonNo12,
  //               bottom: Dimensions.dimenisonNo12)
  //           : EdgeInsets.only(
  //               top: Dimensions.dimenisonNo20,
  //               bottom: Dimensions.dimenisonNo20),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           // Icon for write review
  //           Icon(
  //             Icons.message_outlined,
  //             color: Colors.black,
  //             size: ResponsiveLayout.isMobile(context)
  //                 ? Dimensions.dimenisonNo16
  //                 : Dimensions.dimenisonNo20,
  //           ),
  //           SizedBox(
  //             width: Dimensions.dimenisonNo12,
  //           ),

  //           Text(
  //             "Write a Review",
  //             style: TextStyle(
  //               fontSize: ResponsiveLayout.isMobile(context)
  //                   ? Dimensions.dimenisonNo14
  //                   : Dimensions.dimenisonNo16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Padding ratingContainer(Reviewsprovider reviewsprovider) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimenisonNo10
              : Dimensions.dimenisonNo40,
          vertical: Dimensions.dimenisonNo16),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Align horizontally to the center
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align vertically to the center
        children: [
          ratingTextColumn(reviewsprovider),
          // add line
          Container(
            width: 1, // Line thickness
            height: Dimensions.dimenisonNo60, // Line height
            color: Colors.grey, // Line color
            margin: ResponsiveLayout.isMobile(context)
                ? EdgeInsets.all(Dimensions.dimenisonNo12)
                : EdgeInsets.symmetric(horizontal: 32),
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Keep the Column height minimal
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimenisonNo20
                        : Dimensions.dimenisonNo40,
                    child: ratingBar(
                      "5",
                      reviewsprovider.getStar5Per / 100,
                      reviewsprovider.getStar5Per.toInt().toString(),
                      context,
                    )), // Use SizedBox for fixed height
                SizedBox(
                    height: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimenisonNo20
                        : Dimensions.dimenisonNo40,
                    child: ratingBar(
                      "4",
                      reviewsprovider.getStar4Per / 100,
                      reviewsprovider.getStar4Per.toInt().toString(),
                      context,
                    )),
                SizedBox(
                    height: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimenisonNo20
                        : Dimensions.dimenisonNo40,
                    child: ratingBar(
                      "3",
                      reviewsprovider.getStar3Per / 100,
                      reviewsprovider.getStar3Per.toInt().toString(),
                      context,
                    )),
                SizedBox(
                    height: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimenisonNo20
                        : Dimensions.dimenisonNo40,
                    child: ratingBar(
                      "2",
                      reviewsprovider.getStar2Per / 100,
                      reviewsprovider.getStar2Per.toInt().toString(),
                      context,
                    )),
                SizedBox(
                    height: ResponsiveLayout.isMobile(context)
                        ? Dimensions.dimenisonNo20
                        : Dimensions.dimenisonNo40,
                    child: ratingBar(
                      "1",
                      reviewsprovider.getStar1Per / 100,
                      reviewsprovider.getStar1Per.toInt().toString(),
                      context,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column ratingTextColumn(Reviewsprovider reviewsprovider) {
    return Column(
      children: [
        Padding(
          padding: ResponsiveLayout.isMobile(context)
              ? EdgeInsets.all(Dimensions.dimenisonNo8)
              : EdgeInsets.all(Dimensions.dimenisonNo12),
          child: Text(
            reviewsprovider.averageRating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimenisonNo20
                      : null,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
          ),
        ),
        SizedBox(
          height: ResponsiveLayout.isMobile(context)
              ? null
              : Dimensions.dimenisonNo16,
        ),
        Text(
          " ${formatTotalRatings(reviewsprovider.getTotalRating)} Ratings",
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimenisonNo12
                : Dimensions.dimenisonNo16,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget headingText() {
    return Align(
      alignment: ResponsiveLayout.isMobile(context)
          ? Alignment.center
          : Alignment.centerLeft,
      child: Text(
        'Reviews and Ratings',
        style: TextStyle(
          fontSize: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimenisonNo20
              : 32,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: Colors.black,
        ),
      ),
    );
  }
}
