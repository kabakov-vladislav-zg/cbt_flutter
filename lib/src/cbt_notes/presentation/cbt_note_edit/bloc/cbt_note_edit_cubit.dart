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
  CbtNoteEditCubit(@factoryParam CbtNote cbtNote, {
    required UpdateCbtNote updateCbtNote,
  }) :
    _updateCbtNote = updateCbtNote,
    super(CbtNoteEditState(cbtNote: cbtNote));
    
  final UpdateCbtNote _updateCbtNote;
  static const debouncerTag = 'ThrottledUpdateCbtNote';

  void updateTrigger(String trigger) {
    _emitCbtNote(trigger: trigger);
  }

  void insertThought() {
    final thoughts = [...state.cbtNote.thoughts];
    thoughts.add(Thought());
    _emitCbtNote(thoughts: thoughts);
  }

  void updateThought(int index, {
    String? description,
    List<String>? intermediate,
    String? conclusion,
    String? corruption,
  }) {
    final thoughts = [...state.cbtNote.thoughts];
    thoughts[index] = thoughts[index].copyWith(
      description: description,
      intermediate: intermediate,
      conclusion: conclusion,
      corruption: corruption,
    );
    _emitCbtNote(thoughts: thoughts);
  }

  void removeThought(int index) {
    final thoughts = [...state.cbtNote.thoughts];
    thoughts.removeAt(index);
    _emitCbtNote(thoughts: thoughts);
  }

  void removeEmptyFields() {
    final thoughts = [...state.cbtNote.thoughts];
    thoughts.removeWhere((Thought thought) => thought.description.trim().isEmpty);
    _emitCbtNote(thoughts: thoughts);
  }

  void insertEmotion(String name) {
    final emotions = [...state.cbtNote.emotions];
    emotions.add(Emotion(name: name));
    _emitCbtNote(emotions: emotions);
  }

  void updateEmotion(int index, {
    String? name,
    int? intensityFirst,
    int? intensitySecond,
  }) {
    final emotions = [...state.cbtNote.emotions];
    emotions[index] = emotions[index].copyWith(
      name: name,
      intensityFirst: intensityFirst,
      intensitySecond: intensitySecond,
    );
    _emitCbtNote(emotions: emotions);
  }

  void removeEmotion(int index) {
    final emotions = [...state.cbtNote.emotions];
    emotions.removeAt(index);
    _emitCbtNote(emotions: emotions);
  }

  void syncChanges({ bool debounced = true }) {
    final cbtNote = state.cbtNote;
    if(debounced) {
      EasyDebounce.debounce(
        debouncerTag,
        const Duration(seconds: 2),
        () => _updateCbtNote(cbtNote)
      );
    } else {
      EasyDebounce.cancel(debouncerTag);
      _updateCbtNote(cbtNote);
    }
  }

  void _emitCbtNote({
    String? trigger,
    List<Thought>? thoughts,
    List<Emotion>? emotions,
    bool? isCreated,
    bool? isCompleted,
  }) {
    final cbtNote = state.cbtNote.copyWith(
      trigger: trigger,
      thoughts: thoughts,
      emotions: emotions,
      isCreated: isCreated,
      isCompleted: isCompleted,
    );
    emit(state.copyWith(cbtNote: cbtNote));
    syncChanges();
  }
}
