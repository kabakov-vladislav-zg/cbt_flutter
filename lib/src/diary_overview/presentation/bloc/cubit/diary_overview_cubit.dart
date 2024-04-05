import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'diary_overview_state.dart';

@injectable
class DiaryOverviewCubit extends Cubit<DiaryOverviewState> {
  @factoryMethod
  DiaryOverviewCubit() : super(const DiaryOverviewState());

  DiaryNote addNote() {
    final list = [...state.list];
    final note = DiaryNote();
    list.add(note);
    emit(DiaryOverviewState(list: list));
    return note;
  }

  void removeNote(int index) {
    final list = [...state.list];
    list.removeAt(index);
    emit(DiaryOverviewState(list: list));
  }
}
