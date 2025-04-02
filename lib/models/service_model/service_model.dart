class ServiceModel {
  final String id;
  final String categoryId;
  final String categoryName;
  final String superCategoryName; // New field added
  final String servicesName;
  final double price;
  final int serviceDurationMin;

  const ServiceModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.superCategoryName,
    required this.servicesName,
    required this.price,
    required this.serviceDurationMin,
  });

  // Create a ServiceModel from a JSON map.
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      superCategoryName: json['superCategoryName'] ?? '',
      servicesName: json['servicesName'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'] ?? 0.0,
      serviceDurationMin: json['serviceDurationMin'] ?? 0,
    );
  }

  // Convert a ServiceModel instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'superCategoryName': superCategoryName,
      'servicesName': servicesName,
      'price': price,
      'serviceDurationMin': serviceDurationMin,
    };
  }

  // Create a new instance with modified values.
  ServiceModel copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    String? superCategoryName,
    String? servicesName,
    double? price,
    int? serviceDurationMin,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      servicesName: servicesName ?? this.servicesName,
      price: price ?? this.price,
      serviceDurationMin: serviceDurationMin ?? this.serviceDurationMin,
    );
  }
}
