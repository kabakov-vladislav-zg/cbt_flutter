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
    this.intensityFirst = 0,
    int? intensitySecond,
    String? uuid,
  }) :
    intensitySecond = intensitySecond ?? intensityFirst,
    _uuid = uuid ?? const Uuid().v1();

  final String name;

  final int intensityFirst;

  final int intensitySecond;

  final String _uuid;

  String get uuid => _uuid;

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