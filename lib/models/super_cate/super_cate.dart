class SuperCategoryModel {
  final String id;
  final String superCategoryName;
  final bool haveData;
  final String adminId;
  final String? imgUrl;
  final int order;

  const SuperCategoryModel({
    required this.id,
    required this.superCategoryName,
    required this.haveData,
    required this.adminId,
    this.imgUrl,
    required this.order,
  });

  // Convert a JSON map into a SuperCategoryModel instance.
  factory SuperCategoryModel.fromJson(Map<String, dynamic> json) {
    return SuperCategoryModel(
      id: json['id'] ?? '',
      superCategoryName: json['superCategoryName'] ?? '',
      haveData: json['haveData'] ?? false,
      adminId: json['adminId'] ?? '',
      imgUrl: json['imgUrl'],
      order: json['order'] ?? 0,
    );
  }

  // Convert a SuperCategoryModel instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'superCategoryName': superCategoryName,
      'haveData': haveData,
      'adminId': adminId,
      'imgUrl': imgUrl,
      'order': order,
    };
  }

  // Create a new instance with modified values.
  SuperCategoryModel copyWith({
    String? id,
    String? superCategoryName,
    bool? haveData,
    String? adminId,
    String? imgUrl,
    int? order,
  }) {
    return SuperCategoryModel(
      id: id ?? this.id,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      haveData: haveData ?? this.haveData,
      adminId: adminId ?? this.adminId,
      imgUrl: imgUrl ?? this.imgUrl,
      order: order ?? this.order,
    );
  }
}
