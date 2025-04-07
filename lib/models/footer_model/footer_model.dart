class FooterModel {
  final String id;
  final String about;
  final String mobileNo;
  final String mobileNo2;
  final String whatappNo;
  final String address;
  final String emailOfHr;
  final String emailOfInfo;
  final String emailOfCustCare;
  final String emailOfCeo;
  final String facebook;
  final String instaragran;
  final String x;
  final String linked;
  final String youtube;
  final List<String> city;

  FooterModel({
    required this.id,
    required this.about,
    required this.mobileNo,
    required this.mobileNo2, // New field
    required this.whatappNo, // New field
    required this.address, // New field
    required this.emailOfHr,
    required this.emailOfInfo,
    required this.emailOfCustCare,
    required this.emailOfCeo,
    required this.facebook,
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
      mobileNo2: json['mobileNo2'] ?? '', // New field
      whatappNo: json['whatappNo'] ?? '', // New field
      address: json['address'] ?? '', // New field
      emailOfHr: json['emailOfHr'] ?? 'customercare@sabempire.com',
      emailOfInfo: json['emailOfInfo'] ?? 'customercare@sabempire.com',
      emailOfCustCare: json['emailOfCustCare'] ?? 'customercare@sabempire.com',
      emailOfCeo: json['emailOfCeo'] ?? 'customercare@sabempire.com',
      facebook: json['facebook'] ?? '',
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
      'mobileNo2': mobileNo2, // New field
      'whatappNo': whatappNo, // New field
      'address': address, // New field
      'emailOfHr': emailOfHr,
      'emailOfInfo': emailOfInfo,
      'emailOfCustCare': emailOfCustCare,
      'emailOfCeo': emailOfCeo,
      'facebook': facebook,
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
    String? mobileNo2, // New field
    String? whatappNo, // New field
    String? address, // New field
    String? emailOfHr,
    String? emailOfInfo,
    String? emailOfCustCare,
    String? emailOfCeo,
    String? facebook,
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
      mobileNo2: mobileNo2 ?? this.mobileNo2, // New field
      whatappNo: whatappNo ?? this.whatappNo, // New field
      address: address ?? this.address, // New field
      emailOfHr: emailOfHr ?? this.emailOfHr,
      emailOfInfo: emailOfInfo ?? this.emailOfInfo,
      emailOfCustCare: emailOfCustCare ?? this.emailOfCustCare,
      emailOfCeo: emailOfCeo ?? this.emailOfCeo,
      facebook: facebook ?? this.facebook,
      instaragran: instaragran ?? this.instaragran,
      x: x ?? this.x,
      linked: linked ?? this.linked,
      youtube: youtube ?? this.youtube,
      city: city ?? this.city,
    );
  }
}
