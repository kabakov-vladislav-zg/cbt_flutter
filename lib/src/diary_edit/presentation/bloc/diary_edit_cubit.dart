import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class DiaryEditCubit extends Cubit<DiaryNote> {
  @factoryMethod
  DiaryEditCubit(@factoryParam DiaryNote note)
  : super(note);

  void setEvent(String text) {
    emit(state.copyWith(event: text));
  }
  void setThought(int? index, {required Thought thought}) {
    final thoughts = [...state.thoughts];
    if (index != null) {
      thoughts[index] = thought;
    } else {
      thoughts.add(thought);
    }
    emit(state.copyWith(thoughts: thoughts));
  }
  void setEmotion(int? index, {required Emotion emotion}) {
    final emotions = [...state.emotions];
    if (index != null) {
      emotions[index] = emotion;
    } else {
      emotions.add(emotion);
    }
    emit(state.copyWith(emotions: emotions));
  }
}
