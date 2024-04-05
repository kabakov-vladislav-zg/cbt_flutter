import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class DiaryNote extends Equatable {
  DiaryNote({
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
      trigger: trigger ?? this.trigger,
      thoughts: thoughts ?? this.thoughts,
      emotions: emotions ?? this.emotions,
      isCreated: isCreated ?? this.isCreated,
      isCompleted: isCompleted ?? this.isCompleted,
      uuid: _uuid,
      timestamp: _timestamp,
    );
  }

  @override
  List<Object> get props => [trigger, thoughts, emotions, isCreated, isCompleted, uuid, timestamp];
}
