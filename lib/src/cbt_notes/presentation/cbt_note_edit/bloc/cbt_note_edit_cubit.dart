import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/update_cbt_note.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'cbt_note_edit_state.dart';

@injectable
class CbtNoteEditCubit extends Cubit<CbtNoteEditState> {
  @factoryMethod
  CbtNoteEditCubit(@factoryParam CbtNote note, {
    required UpdateCbtNote updateCbtNote,
  }) :
    _updateCbtNote = updateCbtNote,
    super(CbtNoteEditState(note: note));
    
  final UpdateCbtNote _updateCbtNote;

  void updateTrigger(String trigger) {
    _update(state.note.copyWith(trigger: trigger));
  }

  void insertThought() {
    final thoughts = [...state.note.thoughts];
    thoughts.add(Thought());
    _update(state.note.copyWith(thoughts: thoughts));
  }

  void updateThought(int index, {
    String? description,
    List<String>? intermediate,
    String? conclusion,
    String? corruption,
  }) {
    final thoughts = [...state.note.thoughts];
    thoughts[index] = thoughts[index].copyWith(
      description: description,
      intermediate: intermediate,
      conclusion: conclusion,
      corruption: corruption,
    );
    _update(state.note.copyWith(thoughts: thoughts));
  }

  void removeThought(int index) {
    final thoughts = [...state.note.thoughts];
    thoughts.removeAt(index);
    _update(state.note.copyWith(thoughts: thoughts));
  }

  void removeEmptyFields() {
    final thoughts = [...state.note.thoughts];
    thoughts.removeWhere((Thought thought) => thought.description.trim().isEmpty);
    _update(state.note.copyWith(thoughts: thoughts));
  }

  void insertEmotion(String name) {
    final emotions = [...state.note.emotions];
    emotions.add(Emotion(name: name));
    _update(state.note.copyWith(emotions: emotions));
  }

  void updateEmotion(int index, {
    String? name,
    int? intensityFirst,
    int? intensitySecond,
  }) {
    final emotions = [...state.note.emotions];
    emotions[index] = emotions[index].copyWith(
      name: name,
      intensityFirst: intensityFirst,
      intensitySecond: intensitySecond,
    );
    _update(state.note.copyWith(emotions: emotions));
  }

  void removeEmotion(int index) {
    final emotions = [...state.note.emotions];
    emotions.removeAt(index);
    _update(state.note.copyWith(emotions: emotions));
  }

  void _update(CbtNote note, { bool throttled = true }) {
    emit(state.copyWith(note: note));
    EasyDebounce.debounce(
      'ThrottledUpdateCbtNote',
      Duration(seconds: throttled ? 2 : 0),
      () => _updateCbtNote(note)
    );
  }
}
