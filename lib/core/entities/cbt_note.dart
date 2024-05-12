import 'dart:convert';

import 'package:cbt_flutter/core/utils/json/json_converters.dart';
import 'package:cbt_flutter/core/utils/json/json_map.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
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
    String? trigger,
    List<Thought>? thoughts,
    List<Emotion>? emotions,
    bool? isCreated,
    bool? isCompleted,
    String? uuid,
    DateTime? timestamp,
  }) :
    trigger = trigger ?? '',
    thoughts = thoughts ?? const [],
    emotions = emotions ?? const [],
    isCreated = isCreated ?? false,
    isCompleted = isCompleted ?? false,
    uuid = uuid ?? const Uuid().v1(),
    timestamp = timestamp ?? DateTime.now();

  final String uuid;
  
  final String trigger;

  @JsonKey(fromJson: _thoughtsFromJson, toJson: jsonEncode)
  final List<Thought> thoughts;

  @JsonKey(fromJson: _emotionsFromJson, toJson: jsonEncode)
  final List<Emotion> emotions;

  @JsonKey(fromJson: boolFromJson, toJson: boolToJson)
  final bool isCreated;

  @JsonKey(fromJson: boolFromJson, toJson: boolToJson)
  final bool isCompleted;

  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
  final DateTime timestamp;

  static const table = 'CbtNotes';
  static const columns = (
    uuid: 'uuid',
    trigger: 'trigger',
    timestamp: 'timestamp',
    isCreated: 'isCreated',
    isCompleted: 'isCompleted',
    thoughts: 'thoughts',
    emotions: 'emotions',
  );
  static String get model => '''
    ${columns.uuid} TEXT PRIMARY KEY,
    ${columns.trigger} TEXT,
    ${columns.timestamp} INTEGER,
    ${columns.isCreated} TEXT,
    ${columns.isCompleted} TEXT,
    ${columns.thoughts} TEXT,
    ${columns.emotions} TEXT
  ''';

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

List<Thought> _thoughtsFromJson(String json)
  => listFromJson(json, Thought.fromJson);
  
List<Emotion> _emotionsFromJson(String json)
  => listFromJson(json, Emotion.fromJson);