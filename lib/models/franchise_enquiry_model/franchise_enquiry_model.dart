import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';

class FranchiseEnquiryModel {
  final String id;
  final String name;
  final String mobileNo;
  final String message;
  final String state; // Default value: "Pending"
  final String? reason; // Nullable field with default value: ""
  final TimeStampModel timeStampModel;

  FranchiseEnquiryModel({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.message,
    this.state = "Pending",
    this.reason,
    required this.timeStampModel,
  });

  // Factory method to create an instance from JSON
  factory FranchiseEnquiryModel.fromJson(Map<String, dynamic> json) {
    return FranchiseEnquiryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      message: json['message'] ?? '',
      state: json['state'] ?? 'Pending',
      reason: json['reason'] ?? '',
      timeStampModel: TimeStampModel.fromJson(json['timeStampModel'] ?? {}),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobileNo': mobileNo,
      'message': message,
      'state': state,
      'reason': reason,
      'timeStampModel': timeStampModel.toJson(),
    };
  }

  // Method to create a copy of the instance with modified values
  FranchiseEnquiryModel copyWith({
    String? id,
    String? name,
    String? mobileNo,
    String? message,
    String? state,
    String? reason,
    TimeStampModel? timeStampModel,
  }) {
    return FranchiseEnquiryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNo: mobileNo ?? this.mobileNo,
      message: message ?? this.message,
      state: state ?? this.state,
      reason: reason ?? this.reason,
      timeStampModel: timeStampModel ?? this.timeStampModel,
    );
  }
}
