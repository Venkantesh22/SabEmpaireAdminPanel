import 'package:admin_panel_ak/models/service_model/service_model.dart';
import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointModel {
  final String id;
  final String adminId;
  final String status;
  final double totalPrice;
  final double subtotal;
  final DateTime serviceDate;
  final DateTime serviceStartTime;
  final DateTime serviceEndTime;
  final int serviceDuration; // Changed to int (e.g., minutes)
  // String? userNote;
  final UserModel userModel;
  final List<TimeStampModel> timeStampList;
  final bool isUpdate;
  final bool isManual;
  final List<ServiceModel> services;
  final String serviceAt;

  AppointModel({
    required this.id,
    required this.adminId,
    required this.status,
    required this.totalPrice,
    required this.subtotal,
    required this.serviceDate,
    required this.serviceStartTime,
    required this.serviceEndTime,
    required this.serviceDuration,
    // this.userNote = "No User note",
    required this.userModel,
    required this.timeStampList,
    required this.isUpdate,
    required this.isManual,
    required this.services,
    required this.serviceAt,
  });

  /// Creates an AppointModel from a JSON map.
  factory AppointModel.fromJson(Map<String, dynamic> json) {
    return AppointModel(
      id: json['id'] ?? '',
      adminId: json['adminId'] ?? '',
      status: json['status'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      serviceDate:
          (json['serviceDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceStartTime:
          (json['serviceStartTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceEndTime:
          (json['serviceEndTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceDuration: (json['serviceDuration'] ?? 0).toInt(),
      // userNote: json['userNote'] ?? '',
      userModel: UserModel.fromJson(json['userModel'] ?? {}),
      timeStampList: (json['timeStampList'] as List<dynamic>?)
              ?.map((item) => TimeStampModel.fromJson(item))
              .toList() ??
          [],
      isUpdate: json['isUpdate'] ?? false,
      isManual: json['isManual'] ?? false,
      services: (json['services'] as List<dynamic>?)
              ?.map((item) => ServiceModel.fromJson(item))
              .toList() ??
          [],
      serviceAt: json['serviceAt'] ?? '',
    );
  }

  /// Converts the AppointModel into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adminId': adminId,
      'status': status,
      'totalPrice': totalPrice,
      'subtotal': subtotal,
      'serviceDate': Timestamp.fromDate(serviceDate),
      'serviceStartTime': Timestamp.fromDate(serviceStartTime),
      'serviceEndTime': Timestamp.fromDate(serviceEndTime),
      'serviceDuration': serviceDuration,
      // 'userNote': userNote,
      'userModel': userModel.toJson(),
      'timeStampList': timeStampList.map((e) => e.toJson()).toList(),
      'isUpdate': isUpdate,
      'isManual': isManual,
      'services': services.map((e) => e.toJson()).toList(),
      'serviceAt': serviceAt,
    };
  }

  /// Returns a new AppointModel with updated fields.
  AppointModel copyWith({
    String? id,
    String? adminId,
    String? status,
    double? totalPrice,
    double? subtotal,
    DateTime? serviceDate,
    DateTime? serviceStartTime,
    DateTime? serviceEndTime,
    int? serviceDuration,
    // String? userNote,
    UserModel? userModel,
    List<TimeStampModel>? timeStampList,
    bool? isUpdate,
    bool? isManual,
    List<ServiceModel>? services,
    String? serviceAt,
  }) {
    return AppointModel(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      subtotal: subtotal ?? this.subtotal,
      serviceDate: serviceDate ?? this.serviceDate,
      serviceStartTime: serviceStartTime ?? this.serviceStartTime,
      serviceEndTime: serviceEndTime ?? this.serviceEndTime,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      // userNote: userNote ?? this.userNote,
      userModel: userModel ?? this.userModel,
      timeStampList: timeStampList ?? this.timeStampList,
      isUpdate: isUpdate ?? this.isUpdate,
      isManual: isManual ?? this.isManual,
      services: services ?? this.services,
      serviceAt: serviceAt ?? this.serviceAt,
    );
  }
}
