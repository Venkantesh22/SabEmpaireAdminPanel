class CategoryModel {
  final String id;
  final String categoryName;
  final bool haveData;
  final String? superCategoryName;
  final bool isThreeCategory; // New variable
  final String secondCategoryName; // New variable
  final int order; // New variable

  const CategoryModel({
    required this.id,
    required this.categoryName,
    required this.haveData,
    this.superCategoryName,
    this.isThreeCategory = false, // Default value
    this.secondCategoryName = '', // Default value
    this.order = 0, // Default value
  });

  // Factory method to create a CategoryModel from a JSON map.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      haveData: json['haveData'] ?? false,
      superCategoryName: json['superCategoryName'],
      isThreeCategory: json['isThreeCategory'] ?? false, // New field
      secondCategoryName: json['secondCategoryName'] ?? '', // New field
      order: json['order'] ?? 0, // New field
    );
  }

  // Convert the CategoryModel instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'haveData': haveData,
      'superCategoryName': superCategoryName,
      'isThreeCategory': isThreeCategory, // New field
      'secondCategoryName': secondCategoryName, // New field
      'order': order, // New field
    };
  }

  // Create a new instance with modified values.
  CategoryModel copyWith({
    String? id,
    String? categoryName,
    bool? haveData,
    String? superCategoryName,
    bool? isThreeCategory, // New field
    String? secondCategoryName, // New field
    int? order, // New field
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      haveData: haveData ?? this.haveData,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      isThreeCategory: isThreeCategory ?? this.isThreeCategory, // New field
      secondCategoryName:
          secondCategoryName ?? this.secondCategoryName, // New field
      order: order ?? this.order, // New field
    );
  }
}
