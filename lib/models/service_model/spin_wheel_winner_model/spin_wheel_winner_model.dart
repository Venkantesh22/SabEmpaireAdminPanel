import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpinWheelWinnerModel {
  final String rewardId;
  final String userId;
  final String title;
  final DateTime dateOfCreate;
  final String offer;

  // Fetched from userData/{userId}
  final UserModel? user;

  SpinWheelWinnerModel({
    required this.rewardId,
    required this.userId,
    required this.title,
    required this.dateOfCreate,
    required this.offer,
    this.user,
  });

  factory SpinWheelWinnerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final Map<String, dynamic> data = document.data() ?? {};

    final dynamic dateValue = data['dateOfCreate'];

    DateTime dateOfCreate;

    if (dateValue is Timestamp) {
      dateOfCreate = dateValue.toDate();
    } else if (dateValue is String) {
      dateOfCreate =
          DateTime.tryParse(dateValue) ?? DateTime.now();
    } else {
      dateOfCreate = DateTime.now();
    }

    final DocumentReference<Map<String, dynamic>>
        documentReference = document.reference;

    final DocumentReference<Map<String, dynamic>>?
        userReference = documentReference.parent.parent;

    return SpinWheelWinnerModel(
      rewardId: data['id']?.toString() ?? document.id,
      userId: userReference?.id ?? '',
      title: data['title']?.toString() ?? 'Unknown Reward',
      dateOfCreate: dateOfCreate,
      offer: data['offer']?.toString() ?? 'SpinWheel',
      user: null,
    );
  }

  SpinWheelWinnerModel copyWith({
    String? rewardId,
    String? userId,
    String? title,
    DateTime? dateOfCreate,
    String? offer,
    UserModel? user,
  }) {
    return SpinWheelWinnerModel(
      rewardId: rewardId ?? this.rewardId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      dateOfCreate: dateOfCreate ?? this.dateOfCreate,
      offer: offer ?? this.offer,
      user: user ?? this.user,
    );
  }
}