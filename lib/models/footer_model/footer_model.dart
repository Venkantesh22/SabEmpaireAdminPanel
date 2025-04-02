class FooterModel {
  final String id;
  final String about;
  final String mobileNo;
  final String email;
  final String faceback;
  final String instaragran;
  final String x;
  final String linked;
  final String youtube;
  final List<String> city;

  FooterModel({
    required this.id,
    required this.about,
    required this.mobileNo,
    required this.email,
    required this.faceback,
    required this.instaragran,
    required this.x,
    required this.linked,
    required this.youtube,
    required this.city,
  });

  /// Creates an instance from a JSON map.
  factory FooterModel.fromJson(Map<String, dynamic> json) {
    return FooterModel(
      id: json['id'] ?? '',
      about: json['about'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      email: json['email'] ?? '',
      faceback: json['faceback'] ?? '',
      instaragran: json['instaragran'] ?? '',
      x: json['x'] ?? '',
      linked: json['linked'] ?? '',
      youtube: json['youtube'] ?? '',
      city: json['city'] != null ? List<String>.from(json['city']) : [],
    );
  }

  /// Converts the instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about': about,
      'mobileNo': mobileNo,
      'email': email,
      'faceback': faceback,
      'instaragran': instaragran,
      'x': x,
      'linked': linked,
      'youtube': youtube,
      'city': city,
    };
  }

  /// Returns a new instance with the given values updated.
  FooterModel copyWith({
    String? id,
    String? about,
    String? mobileNo,
    String? email,
    String? faceback,
    String? instaragran,
    String? x,
    String? linked,
    String? youtube,
    List<String>? city,
  }) {
    return FooterModel(
      id: id ?? this.id,
      about: about ?? this.about,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      faceback: faceback ?? this.faceback,
      instaragran: instaragran ?? this.instaragran,
      x: x ?? this.x,
      linked: linked ?? this.linked,
      youtube: youtube ?? this.youtube,
      city: city ?? this.city,
    );
  }
}
