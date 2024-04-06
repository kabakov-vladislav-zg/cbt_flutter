import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/core/usescases/update_diary_note.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class DiaryEditCubit extends Cubit<DiaryNote> {
  @factoryMethod
  DiaryEditCubit(@factoryParam DiaryNote note, {
    required UpdateDiaryNote updateDiaryNote,
  }) :
    _updateDiaryNote = updateDiaryNote,
    super(note);
    
  final UpdateDiaryNote _updateDiaryNote;

  void setEvent(String text) {
    emit(state.copyWith(trigger: text));
    _updateDiaryNote(state);
  }
  void setThought(int? index, { required Thought thought }) {
    final thoughts = [...state.thoughts];
    if (index != null) {
      thoughts[index] = thought;
    } else {
      thoughts.add(thought);
    }
    emit(state.copyWith(thoughts: thoughts));
    _updateDiaryNote(state);
  }

  void removeThought(int index) {
    final thoughts = [...state.thoughts];
    thoughts.removeAt(index);
    emit(state.copyWith(thoughts: thoughts));
    _updateDiaryNote(state);
  }

  void removeEmptyFields() {
    final thoughts = [...state.thoughts];
    thoughts.removeWhere((Thought thought) => thought.description.trim().isEmpty);
    emit(state.copyWith(thoughts: thoughts));
    _updateDiaryNote(state);
  }

  void setEmotion(int? index, {required Emotion emotion}) {
    final emotions = [...state.emotions];
    if (index != null) {
      emotions[index] = emotion;
    } else {
      emotions.add(emotion);
    }
    emit(state.copyWith(emotions: emotions));
    _updateDiaryNote(state);
  }
}
