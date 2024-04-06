import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/core/usescases/update_cbt_note.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class CbtNoteEditCubit extends Cubit<CbtNote> {
  @factoryMethod
  CbtNoteEditCubit(@factoryParam CbtNote note, {
    required UpdateCbtNote updateCbtNote,
  }) :
    _updateCbtNote = updateCbtNote,
    super(note);
    
  final UpdateCbtNote _updateCbtNote;

  void setEvent(String text) {
    emit(state.copyWith(trigger: text));
    _updateCbtNote(state);
  }
  void setThought(int? index, { required Thought thought }) {
    final thoughts = [...state.thoughts];
    if (index != null) {
      thoughts[index] = thought;
    } else {
      thoughts.add(thought);
    }
    emit(state.copyWith(thoughts: thoughts));
    _updateCbtNote(state);
  }

  void removeThought(int index) {
    final thoughts = [...state.thoughts];
    thoughts.removeAt(index);
    emit(state.copyWith(thoughts: thoughts));
    _updateCbtNote(state);
  }

  void removeEmptyFields() {
    final thoughts = [...state.thoughts];
    thoughts.removeWhere((Thought thought) => thought.description.trim().isEmpty);
    emit(state.copyWith(thoughts: thoughts));
    _updateCbtNote(state);
  }

  void setEmotion(int? index, {required Emotion emotion}) {
    final emotions = [...state.emotions];
    if (index != null) {
      emotions[index] = emotion;
    } else {
      emotions.add(emotion);
    }
    emit(state.copyWith(emotions: emotions));
    _updateCbtNote(state);
  }
}
