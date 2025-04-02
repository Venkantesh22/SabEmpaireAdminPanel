import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';

class AdminModel {
  String id;
  String name;
  String number;
  String email;
  String password;
  final TimeStampModel timeStampModel;

  AdminModel({
    required this.id,
    required this.name,
    required this.number,
    required this.email,
    required this.password,
    required this.timeStampModel,
  });

  // Convert JSON to AdminModel object
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      timeStampModel: TimeStampModel.fromJson(json['timeStampModel'] ?? {}),
    );
  }

  // Convert AdminModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'email': email,
      'password': password,
      'timeStampModel': timeStampModel.toJson(),
    };
  }

  // Create a new instance with modified values
  AdminModel copyWith({
    String? id,
    String? name,
    String? number,
    String? email,
    String? password,
    TimeStampModel? timeStampModel,
  }) {
    return AdminModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      email: email ?? this.email,
      password: password ?? this.password,
      timeStampModel: timeStampModel ?? this.timeStampModel,
    );
  }
}
