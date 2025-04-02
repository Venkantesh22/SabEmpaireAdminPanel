import 'package:admin_panel_ak/models/timestamp_model/timestamp_model.dart';

class JobModel {
  final String id;
  final String jobName;
  final String desc;
  final double salary;
  final TimeStampModel timeStampModel;

  JobModel({
    required this.id,
    required this.jobName,
    required this.desc,
    required this.salary,
    required this.timeStampModel,
  });

  // Convert JSON to JobModel object
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      jobName: json['jobName'] ?? '',
      desc: json['desc'] ?? '',
      salary: (json['salary'] ?? 0).toDouble(),
      timeStampModel: TimeStampModel.fromJson(json['timeStampModel'] ?? {}),
    );
  }

  // Convert JobModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobName': jobName,
      'desc': desc,
      'salary': salary,
      'timeStampModel': timeStampModel.toJson(),
    };
  }

  // Create a new instance with modified values
  JobModel copyWith({
    String? id,
    String? jobName,
    String? desc,
    double? salary,
    TimeStampModel? timeStampModel,
  }) {
    return JobModel(
      id: id ?? this.id,
      jobName: jobName ?? this.jobName,
      desc: desc ?? this.desc,
      salary: salary ?? this.salary,
      timeStampModel: timeStampModel ?? this.timeStampModel,
    );
  }
}
