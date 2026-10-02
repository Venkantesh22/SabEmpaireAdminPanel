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
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      isRewardCanCome: map['isRewardCanCome'] ?? true,
      howManyTimeComInMonth: map['howManyTimeComInMonth'] as int?,
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
}