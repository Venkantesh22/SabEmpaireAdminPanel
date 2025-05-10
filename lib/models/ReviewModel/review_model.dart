import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';

class ReviewModel {
  final String id;
  final double rating;
  final String reviewText;
  final TimeStampModel timeStampModel;
  final UserModel userModel;
  final bool isShowToDisplay; // New field added

  ReviewModel({
    required this.id,
    required this.rating,
    required this.reviewText,
    required this.timeStampModel,
    required this.userModel,
    this.isShowToDisplay = false, // Initialize the new field
  });

  /// Creates a copy of this ReviewModel with the given fields replaced.
  ReviewModel copyWith({
    String? id,
    double? rating,
    String? reviewText,
    TimeStampModel? timeStampModel,
    UserModel? userModel,
    bool? isShowToDisplay, // Add the new field to copyWith
  }) {
    return ReviewModel(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      timeStampModel: timeStampModel ?? this.timeStampModel,
      userModel: userModel ?? this.userModel,
      isShowToDisplay:
          isShowToDisplay ?? this.isShowToDisplay, // Handle the new field
    );
  }

  /// Creates a ReviewModel from a JSON map.
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewText: json['reviewText'] as String,
      timeStampModel: TimeStampModel.fromJson(
          json['timeStampModel'] as Map<String, dynamic>),
      userModel: UserModel.fromJson(json['userModel'] as Map<String, dynamic>),
      isShowToDisplay:
          json['isShowToDisplay'] as bool? ?? false, // Default to true if null
    );
  }

  /// Converts this ReviewModel into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'reviewText': reviewText,
      'timeStampModel': timeStampModel.toJson(),
      'userModel': userModel.toJson(),
      'isShowToDisplay': isShowToDisplay, // Include the new field in JSON
    };
  }
}
