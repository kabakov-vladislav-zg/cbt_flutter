import 'package:cbt_flutter/core/entities/json_map.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'emotion.g.dart';

@immutable
@JsonSerializable()
class Emotion extends Equatable {
  const Emotion({
    required this.name,
    this.intensityFirst = 0,
    int? intensitySecond,
  }) : intensitySecond = intensitySecond ?? intensityFirst;

  final String name;

  final int intensityFirst;

  final int intensitySecond;

  Emotion copyWith({
    String? name,
    int? intensityFirst,
    int? intensitySecond,
  }) {
    return Emotion(
      name: name ?? this.name,
      intensityFirst: intensityFirst ?? this.intensityFirst,
      intensitySecond: intensitySecond ?? this.intensitySecond,
    );
  }

  static Emotion fromJson(JsonMap json) => _$EmotionFromJson(json);

  JsonMap toJson() => _$EmotionToJson(this);

  @override
  List<Object> get props => [name, intensityFirst, intensitySecond];
}