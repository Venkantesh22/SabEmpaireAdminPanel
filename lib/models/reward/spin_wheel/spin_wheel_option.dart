class SpinWheelOptionModel {
  final String? id;
  final String? title;
  final bool? isRewardCanCome;
  final int? howManyTimeComInMonth;

  SpinWheelOptionModel({
    this.id,
    this.title,
    this.isRewardCanCome,
    this.howManyTimeComInMonth,
  });

  factory SpinWheelOptionModel.fromMap(Map<String, dynamic> map) {
    return SpinWheelOptionModel(
      id: map['id']?.toString(),
      title: map['title']?.toString(),
      isRewardCanCome: map['isRewardCanCome'] as bool? ?? true,
      howManyTimeComInMonth:
          (map['howManyTimeComInMonth'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isRewardCanCome': isRewardCanCome,
      'howManyTimeComInMonth': howManyTimeComInMonth,
    };
  }

  SpinWheelOptionModel copyWith({
    String? id,
    String? title,
    bool? isRewardCanCome,
    int? howManyTimeComInMonth,
  }) {
    return SpinWheelOptionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isRewardCanCome: isRewardCanCome ?? this.isRewardCanCome,
      howManyTimeComInMonth:
          howManyTimeComInMonth ?? this.howManyTimeComInMonth,
    );
  }
}