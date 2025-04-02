import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';

class UserEnquiryModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String message;
  final String state;
  final String? reason;
  final TimeStampModel timeStampModel;

  UserEnquiryModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.message,
    required this.state,
    this.reason,
    required this.timeStampModel,
  });

  /// Creates a UserEnquiryModel from a JSON map.
  factory UserEnquiryModel.fromJson(Map<String, dynamic> json) {
    return UserEnquiryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      message: json['message'] ?? '',
      state: json['state'] ?? '',
      reason: json['reason'], // Nullable field
      timeStampModel: TimeStampModel.fromJson(json['timeStampModel'] ?? {}),
    );
  }

  /// Converts the UserEnquiryModel into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'message': message,
      'state': state,
      'reason': reason,
      'timeStampModel': timeStampModel.toJson(),
    };
  }

  /// Returns a new UserEnquiryModel with updated fields.
  UserEnquiryModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? message,
    String? state,
    String? reason,
    TimeStampModel? timeStampModel,
  }) {
    return UserEnquiryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      message: message ?? this.message,
      state: state ?? this.state,
      reason: reason ?? this.reason,
      timeStampModel: timeStampModel ?? this.timeStampModel,
    );
  }
}
