class ServiceProviderModel {
  final String id;
  final String name;
  final String descp;
  final String eId;
  final String? image; // Optional field
  final int yearExperience;
  final int monthExperience;
  final int order; // New variable added

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.descp,
    required this.eId,
    this.image,
    required this.yearExperience,
    required this.monthExperience,
    required this.order, // New variable added
  });

  // Convert a ServiceProviderModel to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descp': descp,
      'eId': eId,
      'image': image,
      'yearExperience': yearExperience,
      'monthExperience': monthExperience,
      'order': order, // New variable added
    };
  }

  // Create a ServiceProviderModel from a Firestore Map
  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'], // Matches Firestore field
      name: json['name'], // Matches Firestore field
      descp: json['descp'], // Matches Firestore field
      eId: json['eId'], // Map Firestore 'eId' to model's 'eId'
      image: json['image'], // Matches Firestore field
      yearExperience: json['yearExperience'], // Matches Firestore field
      monthExperience: json['monthExperience'], // Matches Firestore field
      order: json['order'], // New variable added
    );
  }

  ServiceProviderModel copyWith({
    String? id,
    String? name,
    String? descp,
    String? eId,
    String? image,
    int? yearExperience,
    int? monthExperience,
    int? order, // New variable added
  }) {
    return ServiceProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      descp: descp ?? this.descp,
      eId: eId ?? this.eId,
      image: image ?? this.image,
      yearExperience: yearExperience ?? this.yearExperience,
      monthExperience: monthExperience ?? this.monthExperience,
      order: order ?? this.order, // New variable added
    );
  }
}
