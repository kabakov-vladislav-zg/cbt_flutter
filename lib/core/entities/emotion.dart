import 'package:cbt_flutter/core/entities/json_map.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emotion.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class Emotion extends Equatable {
  Emotion({
    required this.name,
    this.intensityFirst = 1,
    int? intensitySecond,
    String? uuid,
  }) :
    intensitySecond = intensitySecond ?? intensityFirst,
    _uuid = uuid ?? const Uuid().v1(),
    assert(_isValidIntensity(intensityFirst)),
    assert(intensitySecond == null || _isValidIntensity(intensitySecond));

  final String name;

  final int intensityFirst;

  final int intensitySecond;

  final String _uuid;

  String get uuid => _uuid;

  static int maxIntensity = 10;
  static bool _isValidIntensity(int value) => !value.isNegative && value <= maxIntensity;

  Emotion copyWith({
    String? name,
    int? intensityFirst,
    int? intensitySecond,
  }) {
    return Emotion(
      name: name ?? this.name,
      intensityFirst: intensityFirst ?? this.intensityFirst,
      intensitySecond: intensitySecond ?? this.intensitySecond,
      uuid: _uuid,
    );
  }

  JsonMap toJson() => _$EmotionToJson(this);

  static Emotion fromJson(JsonMap json) => _$EmotionFromJson(json);

  @override
  List<Object> get props => [name, intensityFirst, intensitySecond, uuid];
}