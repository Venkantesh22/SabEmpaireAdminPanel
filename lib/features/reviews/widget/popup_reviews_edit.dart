// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_ak/constants/global_variable.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/ReviewModel/review_model.dart';
import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:admin_panel_ak/provider/reviewsProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';

class PopupWriteReviewsEdit extends StatefulWidget {
  final BuildContext context;
  final UserModel user;
  final ReviewModel reviewModel;

  const PopupWriteReviewsEdit({
    required this.context,
    required this.user,
    super.key,
    required this.reviewModel,
  });

  @override
  State<PopupWriteReviewsEdit> createState() => _PopupWriteReviewsEditState();
}

class _PopupWriteReviewsEditState extends State<PopupWriteReviewsEdit> {
  double _rating = 0;
  bool _isloading = false;
  TextEditingController _reviewText = TextEditingController();

  getData() {
    setState(() {
      _isloading = true;
    });
    _reviewText.text = widget.reviewModel.reviewText;
    _rating = widget.reviewModel.rating;

    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _reviewText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showReviewDialog(context);
    });
    return const SizedBox.shrink();
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimensions.dimenisonNo16,
                ),
              ),
              contentPadding: EdgeInsets.all(Dimensions.dimenisonNo24),
              content: _isloading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: Dimensions.screenWidth * 1.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header
                              Text(
                                'WRITE A REVIEW',
                                style: TextStyle(
                                  fontSize: Dimensions.dimenisonNo20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.dimenisonNo20,
                              ),

                              // User info row
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: Dimensions.dimenisonNo24,
                                    backgroundImage: widget.user.image !=
                                                null &&
                                            widget.user.image!.isNotEmpty
                                        ? NetworkImage(widget.user
                                            .image!) // Use the user's image if available
                                        : AssetImage(
                                                GlobalVariable.profileImage)
                                            as ImageProvider, // Use local image if null or empty
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.user.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'This post on the SabEmpire website',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Star rating
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final starIndex = index + 1;
                                  return IconButton(
                                    icon: Icon(
                                      _rating >= starIndex
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 32,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(
                                          () => _rating = starIndex.toDouble());
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 20),

                              // Review text field
                              TextField(
                                controller: _reviewText,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'Write your review…',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                // onChanged: (val) =>
                                //     setState(() => _reviewText = val),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

              // Actions: POST & CLOSE
              actionsPadding: EdgeInsets.symmetric(
                  horizontal: Dimensions.dimenisonNo16,
                  vertical: Dimensions.dimenisonNo8),
              actions: [
                // POST button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red background
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.dimenisonNo8),
                    ),
                  ),
                  onPressed: (_rating > 0 && _reviewText.text.isNotEmpty)
                      ? () async {
                          try {
                            Reviewsprovider reviewProvider =
                                Provider.of<Reviewsprovider>(context,
                                    listen: false);
                            TimeStampModel timeStampModel = TimeStampModel(
                              id: "",
                              dateAndTime: GlobalVariable.today,
                              updateBy: "User",
                            );

                            // Construct a ReviewModel
                            final review = ReviewModel(
                              id: widget.reviewModel.id,
                              rating: _rating,
                              reviewText: _reviewText.text,
                              timeStampModel: timeStampModel,
                              userModel: widget.user,
                            );

                            // Upload the review to Firestore
                            // bool isPostSuccessful =
                            //     await FirebaseFirestoreHelper.instance
                            //         .editReviewFB(review, context);

                            // if (isPostSuccessful) {
                            //   await reviewProvider.getAllReviewsPro();
                            //   reviewProvider.getUserReviewsPro();
                            //   // Close the dialog after successful post
                            //   Navigator.of(context, rootNavigator: true).pop();
                            // }
                          } catch (e) {
                            // Handle errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Failed to post review. Please try again.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      : null, // Disable button if rating or review text is empty
                  child: const Text(
                    'POST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // CLOSE button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.dimenisonNo8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
