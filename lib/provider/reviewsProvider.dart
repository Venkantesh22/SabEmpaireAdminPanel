import 'package:flutter/material.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:admin_panel_ak/models/ReviewModel/review_model.dart';

class Reviewsprovider with ChangeNotifier {
  double totalRating = 0.0;
  double get getTotalRating => totalRating;

  double star5Per = 0.0;
  double get getStar5Per => star5Per;

  double star4Per = 0.0;
  double get getStar4Per => star4Per;

  double star3Per = 0.0;
  double get getStar3Per => star3Per;

  double star2Per = 0.0;
  double get getStar2Per => star2Per;

  double star1Per = 0.0;
  double get getStar1Per => star1Per;

  double averageRating = 0.0;
  double get getAverageRating => averageRating;

  bool _isAlreadPostReview = false;
  bool get getIsAlreadPostReview => _isAlreadPostReview;

  ReviewModel? _userReviewModel;
  ReviewModel? get getUserReviews => _userReviewModel;

  List<ReviewModel> _reviewModelList = [];
  List<ReviewModel> get getReviewModelList => _reviewModelList;

  Future<void> getAllReviewsPro() async {
    FirebaseFirestoreHelper.instance.streamAllReviews().listen((reviewList) {
      _reviewModelList = reviewList;
      calculateAllStarPercentages(_reviewModelList); // Calculate percentages
      calculateAverageRating(_reviewModelList); // Calculate average rating
      notifyListeners();
    });
  }

  // Future<void> getUserReviewsPro() async {
  //   _userReviewModel =
  //       await FirebaseFirestoreHelper.instance.getUserReviewsModel();

  //   _isAlreadPostReview = _userReviewModel != null;
  //   print("_isAlreadPostReview  $_isAlreadPostReview");

  //   notifyListeners();
  // }

  // Function to calculate percentages for all star ratings
  void calculateAllStarPercentages(List<ReviewModel> reviewModelList) {
    if (reviewModelList.isEmpty) {
      star5Per = 0.0;
      star4Per = 0.0;
      star3Per = 0.0;
      star2Per = 0.0;
      star1Per = 0.0;
      totalRating = 0.0;
      notifyListeners();
      return;
    }

    // Count the number of reviews for each star rating
    int fiveStarCount =
        reviewModelList.where((review) => review.rating == 5.0).length;
    int fourStarCount =
        reviewModelList.where((review) => review.rating == 4.0).length;
    int threeStarCount =
        reviewModelList.where((review) => review.rating == 3.0).length;
    int twoStarCount =
        reviewModelList.where((review) => review.rating == 2.0).length;
    int oneStarCount =
        reviewModelList.where((review) => review.rating == 1.0).length;

    // Calculate percentages
    star5Per = (fiveStarCount / reviewModelList.length) * 100;
    star4Per = (fourStarCount / reviewModelList.length) * 100;
    star3Per = (threeStarCount / reviewModelList.length) * 100;
    star2Per = (twoStarCount / reviewModelList.length) * 100;
    star1Per = (oneStarCount / reviewModelList.length) * 100;
    totalRating = reviewModelList.length.toDouble();
    print("$star5Per");
    print("$star4Per");
    print("$star3Per");
    print("$star2Per");
    print("$star1Per");
    print("$totalRating");

    notifyListeners();
  }

  // Function to calculate the average rating
  void calculateAverageRating(List<ReviewModel> reviewModelList) {
    if (reviewModelList.isEmpty) {
      averageRating = 0.0;
      notifyListeners();
      return;
    }

    // Sum up all the ratings
    double totalRatingsSum =
        reviewModelList.fold(0.0, (sum, review) => sum + review.rating);

    // Calculate the average
    averageRating = totalRatingsSum / reviewModelList.length;

    notifyListeners();
  }
}
