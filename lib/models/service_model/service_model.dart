class ServiceModel {
  final String id;
  final String categoryId;
  final String categoryName;
  final String superCategoryName; // New field added
  final String servicesName;
  final double price;
  final int serviceDurationMin;
  final int order; // New field added
  final String? description; // New nullable field added

  const ServiceModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.superCategoryName,
    required this.servicesName,
    required this.price,
    required this.serviceDurationMin,
    required this.order, // New field added
    this.description, // New nullable field added
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
      order: json['order'] ?? 0, // New field added
      description: json['description'], // New nullable field added
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
      'order': order, // New field added
      'description': description, // New nullable field added
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
    int? order, // New field added
    String? description, // New nullable field added
  }) {
    return ServiceModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      servicesName: servicesName ?? this.servicesName,
      price: price ?? this.price,
      serviceDurationMin: serviceDurationMin ?? this.serviceDurationMin,
      order: order ?? this.order, // New field added
      description: description ?? this.description, // New nullable field added
    );
  }
}
