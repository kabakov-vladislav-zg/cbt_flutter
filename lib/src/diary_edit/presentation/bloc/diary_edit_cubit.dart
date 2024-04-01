import 'package:cbt_flutter/core/entities/diary_note.dart';
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
}
