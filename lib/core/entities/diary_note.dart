import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/json_map.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'diary_note.g.dart';

@immutable
@JsonSerializable()
class DiaryNote extends Equatable {
  DiaryNote({
    required this.id,
    this.trigger = '',
    this.thoughts = const [],
    this.emotions = const [],
    this.isCreated = false,
    this.isCompleted = false,
    String? uuid,
    int? timestamp,
  }) :
    _uuid = uuid ?? const Uuid().v1(),
    _timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  final String id;

  final String trigger;

  final List<Thought> thoughts;

  final List<Emotion> emotions;

  final bool isCreated;

  final bool isCompleted;

  final String _uuid;

  final int _timestamp;

  String get uuid => _uuid;

  int get timestamp => _timestamp;

  DiaryNote copyWith({
    String? id,
    String? trigger,
    List<Thought>? thoughts,
    List<Emotion>? emotions,
    bool? isCreated,
    bool? isCompleted,
  }) {
    return DiaryNote(
      id: id ?? this.id,
      trigger: trigger ?? this.trigger,
      thoughts: thoughts ?? this.thoughts,
      emotions: emotions ?? this.emotions,
      isCreated: isCreated ?? this.isCreated,
      isCompleted: isCompleted ?? this.isCompleted,
      uuid: _uuid,
      timestamp: _timestamp,
    );
  }

  static DiaryNote fromJson(JsonMap json) => _$DiaryNoteFromJson(json);

  JsonMap toJson() => _$DiaryNoteToJson(this);

  @override
  List<Object> get props => [id, trigger, thoughts, emotions, isCreated, isCompleted, uuid, timestamp];
}
