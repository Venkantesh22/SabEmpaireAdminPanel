import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';

class SpinWheelModel {
  final bool isOfferIsLive;
  final List<SpinWheelOptionModel> spinWheelOptionModelList;

  SpinWheelModel({
    this.isOfferIsLive = false,
    this.spinWheelOptionModelList = const [],
  });

  factory SpinWheelModel.fromMap(Map<String, dynamic> map) {
    return SpinWheelModel(
      isOfferIsLive: map['isOfferIsLive'] as bool? ?? false,
      spinWheelOptionModelList:
          (map['spinWheelOptionModelList'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(
                (item) => SpinWheelOptionModel.fromMap(item),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isOfferIsLive': isOfferIsLive,
      'spinWheelOptionModelList':
          spinWheelOptionModelList
              .map((option) => option.toMap())
              .toList(),
    };
  }

  SpinWheelModel copyWith({
    bool? isOfferIsLive,
    List<SpinWheelOptionModel>? spinWheelOptionModelList,
  }) {
    return SpinWheelModel(
      isOfferIsLive: isOfferIsLive ?? this.isOfferIsLive,
      spinWheelOptionModelList:
          spinWheelOptionModelList ?? this.spinWheelOptionModelList,
    );
  }
}