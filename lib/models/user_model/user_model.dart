import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? image; // image is now nullable.
  final String email;
  final String password;
  final TimeStampModel timeStampModel;
  final int? age;
  final String? gender;
  final DateTime? dateOfBirth;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.image,
    required this.email,
    required this.password,
    required this.timeStampModel,
    this.age,
    this.gender,
    this.dateOfBirth,
  });

  // Create a UserModel from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'], // image may be null
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      timeStampModel: TimeStampModel.fromJson(json['timeStampModel'] ?? {}),
      age: json['age'] != null ? json['age'] as int : null,
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
    );
  }

  // Convert a UserModel instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'image': image,
      'email': email,
      'password': password,
      'timeStampModel': timeStampModel.toJson(),
      'age': age,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  // Create a new instance with updated values.
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? image,
    String? email,
    String? password,
    TimeStampModel? timeStampModel,
    int? age,
    String? gender,
    DateTime? dateOfBirth,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      email: email ?? this.email,
      password: password ?? this.password,
      timeStampModel: timeStampModel ?? this.timeStampModel,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
