import 'package:admin_panel_ak/models/reward/spin_wheel/spin_wheel_option.dart';

class SpinWheelModel {
  final bool isOfferIsLive;
  final String code;
  final List<SpinWheelOptionModel> spinWheelOptionModelList;

  SpinWheelModel({
    this.isOfferIsLive = false,
    this.code = '',
    this.spinWheelOptionModelList = const [],
  });

  factory SpinWheelModel.fromMap(Map<String, dynamic> map) {
    return SpinWheelModel(
      isOfferIsLive: map['isOfferIsLive'] as bool? ?? false,
      code: map['code']?.toString() ?? '',
      spinWheelOptionModelList:
          (map['spinWheelOptionModelList'] as List<dynamic>? ?? [])
              .whereType<Map>()
              .map(
                (item) => SpinWheelOptionModel.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isOfferIsLive': isOfferIsLive,
      'code': code,
      'spinWheelOptionModelList':
          spinWheelOptionModelList
              .map((option) => option.toMap())
              .toList(),
    };
  }

  SpinWheelModel copyWith({
    bool? isOfferIsLive,
    String? code,
    List<SpinWheelOptionModel>? spinWheelOptionModelList,
  }) {
    return SpinWheelModel(
      isOfferIsLive: isOfferIsLive ?? this.isOfferIsLive,
      code: code ?? this.code,
      spinWheelOptionModelList:
          spinWheelOptionModelList ?? this.spinWheelOptionModelList,
    );
  }
}