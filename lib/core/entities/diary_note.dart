import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/json_map.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'diary_note.g.dart';

@immutable
@JsonSerializable()
class DiaryNote extends Equatable {
  const DiaryNote({
    required this.id,
    this.event = '',
    this.thoughts = const [],
    this.emotions = const [],
    this.isCreated = false,
    this.isCompleted = false,
  });

  final String id;

  final String event;

  final List<Thought> thoughts;

  final List<Emotion> emotions;

  final bool isCreated;

  final bool isCompleted;

  // DiaryNote copyWith({
  //   String? id,
  //   String? title,
  //   String? description,
  //   bool? isCompleted,
  // }) {
  //   return DiaryNote(
  //     id: id ?? this.id,
  //     title: title ?? this.title,
  //     description: description ?? this.description,
  //     isCompleted: isCompleted ?? this.isCompleted,
  //   );
  // }

  static DiaryNote fromJson(JsonMap json) => _$DiaryNoteFromJson(json);

  JsonMap toJson() => _$DiaryNoteToJson(this);

  @override
  List<Object> get props => [id, event, thoughts, emotions, isCreated, isCompleted];
}
