import 'dart:convert';

import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/json_map.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cbt_note.g.dart';

@immutable
@JsonSerializable()
class CbtNote extends Equatable {
  CbtNote({
    this.trigger = '',
    this.thoughts = const [],
    this.emotions = const [],
    this.isCreated = false,
    this.isCompleted = false,
    String? uuid,
    int? timestamp,
  }) :
    uuid = uuid ?? const Uuid().v1(),
    timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;


  final String trigger;

  @JsonKey(fromJson: _thoughtListFromString, toJson: jsonEncode)
  final List<Thought> thoughts;

  @JsonKey(fromJson: _emotionListFromString, toJson: jsonEncode)
  final List<Emotion> emotions;

  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool isCreated;

  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool isCompleted;

  final String uuid;

  final int timestamp;

  static bool _boolFromString(String flag) => flag == 'true';

  static String _boolToString(bool flag) => flag ? 'true' : 'false';

  static List<Thought> _thoughtListFromString(String string) {
    var list = jsonDecode(string);
    return (list as List).map((data) => Thought.fromJson(data)).toList();
  }
  static List<Emotion> _emotionListFromString(String string) {
    var list = jsonDecode(string);
    return (list as List).map((data) => Emotion.fromJson(data)).toList();
  }


  CbtNote copyWith({
    String? trigger,
    List<Thought>? thoughts,
    List<Emotion>? emotions,
    bool? isCreated,
    bool? isCompleted,
  }) {
    return CbtNote(
      trigger: trigger ?? this.trigger,
      thoughts: thoughts ?? this.thoughts,
      emotions: emotions ?? this.emotions,
      isCreated: isCreated ?? this.isCreated,
      isCompleted: isCompleted ?? this.isCompleted,
      uuid: uuid,
      timestamp: timestamp,
    );
  }

  JsonMap toJson() => _$CbtNoteToJson(this);

  static CbtNote fromJson(JsonMap json) => _$CbtNoteFromJson(json);

  @override
  List<Object> get props => [trigger, thoughts, emotions, isCreated, isCompleted, uuid, timestamp];
}
