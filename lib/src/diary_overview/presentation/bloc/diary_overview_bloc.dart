import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/repos/diary_note_repo.dart';
import 'package:cbt_flutter/core/usescases/remowe_diary_note.dart';
import 'package:cbt_flutter/core/usescases/set_diary_note.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'diary_overview_state.dart';
part 'diary_overview_event.dart';

@injectable
class DiaryOverviewCubit extends Bloc<DiaryOverviewEvent, DiaryOverviewState> {
  @factoryMethod
  DiaryOverviewCubit({
    required DiaryNoteRepo diaryNoteRepo,
    required SetDiaryNote setDiaryNote,
    required RemoveDiaryNote removeDiaryNote,
  }) : 
    _diaryNoteRepo = diaryNoteRepo,
    _setDiaryNote = setDiaryNote,
    _removeDiaryNote = removeDiaryNote,
    super(const DiaryOverviewState()) {
      on<DiaryOverviewSubscriptionRequested>(_onSubscriptionRequested);
      on<DiaryOverviewAddCbtNote>(_addNote);
      on<DiaryOverviewRemoveCbtNote>(_removeNote);
    }
  
  final DiaryNoteRepo _diaryNoteRepo;
  final SetDiaryNote _setDiaryNote;
  final RemoveDiaryNote _removeDiaryNote;

  Future<void> _onSubscriptionRequested(
    DiaryOverviewSubscriptionRequested event,
    Emitter<DiaryOverviewState> emit,
  ) async {
    await emit.forEach<List<DiaryNote>>(
      _diaryNoteRepo.getCbtNotes(),
      onData: (list) {
        return state.copyWith(list: list);
      },
    );
  }

  Future<void> _addNote(
    DiaryOverviewAddCbtNote event,
    Emitter<DiaryOverviewState> emit,
  ) async {
    final list = [...state.list];
    list.add(event.note);
    _setDiaryNote(event.note);
  }

  Future<void> _removeNote(
    DiaryOverviewRemoveCbtNote event,
    Emitter<DiaryOverviewState> emit,
  ) async {
    _removeDiaryNote(event.uuid);
  }
}
