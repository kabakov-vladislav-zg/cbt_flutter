import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/core/usescases/set_diary_note.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class DiaryEditCubit extends Cubit<DiaryNote> {
  @factoryMethod
  DiaryEditCubit(@factoryParam DiaryNote note, {
    required SetDiaryNote setDiaryNote,
  }) :
    _setDiaryNote = setDiaryNote,
    super(note);
    
  final SetDiaryNote _setDiaryNote;

  void setEvent(String text) {
    emit(state.copyWith(trigger: text));
    _setDiaryNote(state);
  }
  void setThought(int? index, { required Thought thought }) {
    final thoughts = [...state.thoughts];
    if (index != null) {
      thoughts[index] = thought;
    } else {
      thoughts.add(thought);
    }
    emit(state.copyWith(thoughts: thoughts));
    _setDiaryNote(state);
  }

  void removeThought(int index) {
    final thoughts = [...state.thoughts];
    thoughts.removeAt(index);
    emit(state.copyWith(thoughts: thoughts));
    _setDiaryNote(state);
  }

  void removeEmptyFields() {
    final thoughts = [...state.thoughts];
    thoughts.removeWhere((Thought thought) => thought.description.trim().isEmpty);
    emit(state.copyWith(thoughts: thoughts));
    _setDiaryNote(state);
  }

  void setEmotion(int? index, {required Emotion emotion}) {
    final emotions = [...state.emotions];
    if (index != null) {
      emotions[index] = emotion;
    } else {
      emotions.add(emotion);
    }
    emit(state.copyWith(emotions: emotions));
    _setDiaryNote(state);
  }
}