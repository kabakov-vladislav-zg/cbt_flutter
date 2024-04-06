import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/cbt_note_edit/domain/usescases/debounced_update_cbt_note.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'cbt_note_edit_state.dart';

@injectable
class CbtNoteEditCubit extends Cubit<CbtNoteEditState> {
  @factoryMethod
  CbtNoteEditCubit(@factoryParam CbtNote note, {
    required DebouncedUpdateCbtNote updateCbtNote,
  }) :
    _updateCbtNote = updateCbtNote,
    super(CbtNoteEditState(note: note));
    
  final DebouncedUpdateCbtNote _updateCbtNote;

  void setEvent(String text) {
    emit(state.copyWith(note: state.note.copyWith(trigger: text)));
    _updateCbtNote(state.note);
  }
  void setThought(int? index, { required Thought thought }) {
    final thoughts = [...state.note.thoughts];
    if (index != null) {
      thoughts[index] = thought;
    } else {
      thoughts.add(thought);
    }
    emit(state.copyWith(note: state.note.copyWith(thoughts: thoughts)));
    _updateCbtNote(state.note);
  }

  void removeThought(int index) {
    final thoughts = [...state.note.thoughts];
    thoughts.removeAt(index);
    emit(state.copyWith(note: state.note.copyWith(thoughts: thoughts)));
    _updateCbtNote(state.note);
  }

  void removeEmptyFields() {
    final thoughts = [...state.note.thoughts];
    thoughts.removeWhere((Thought thought) => thought.description.trim().isEmpty);
    emit(state.copyWith(note: state.note.copyWith(thoughts: thoughts)));
    _updateCbtNote(state.note);
  }

  void setEmotion(int? index, {required Emotion emotion}) {
    final emotions = [...state.note.emotions];
    if (index != null) {
      emotions[index] = emotion;
    } else {
      emotions.add(emotion);
    }
    emit(state.copyWith(note: state.note.copyWith(emotions: emotions)));
    _updateCbtNote(state.note);
  }
}
