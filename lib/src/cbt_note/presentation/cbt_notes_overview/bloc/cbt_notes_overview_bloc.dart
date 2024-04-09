import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/src/cbt_note/data/cbt_notes_repo.dart';
import 'package:cbt_flutter/src/cbt_note/domain/remowe_cbt_note.dart';
import 'package:cbt_flutter/src/cbt_note/domain/insert_cbt_note.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cbt_notes_overview_state.dart';
part 'cbt_notes_overview_event.dart';

@injectable
class CbtNotesOverviewBloc extends Bloc<CbtNotesOverviewEvent, CbtNotesOverviewState> {
  @factoryMethod
  CbtNotesOverviewBloc({
    required CbtNotesRepo cbtNotesRepo,
    required InsertCbtNote insertCbtNote,
    required RemoveCbtNote removeCbtNote,
  }) : 
    _cbtNotesRepo = cbtNotesRepo,
    _insertCbtNote = insertCbtNote,
    _removeCbtNote = removeCbtNote,
    super(const CbtNotesOverviewState()) {
      on<CbtNotesOverviewSubscribe>(_onSubscriptionRequested);
      on<CbtNotesOverviewInsert>(_addNote);
      on<CbtNotesOverviewRemove>(_removeNote);
    }
  
  final CbtNotesRepo _cbtNotesRepo;
  final InsertCbtNote _insertCbtNote;
  final RemoveCbtNote _removeCbtNote;

  Future<void> _onSubscriptionRequested(
    CbtNotesOverviewSubscribe event,
    Emitter<CbtNotesOverviewState> emit,
  ) async {
    await emit.forEach<List<CbtNote>>(
      await _cbtNotesRepo.getCbtNotesStream(),
      onData: (list) => state.copyWith(list: list),
    );
  }

  Future<void> _addNote(
    CbtNotesOverviewInsert event,
    Emitter<CbtNotesOverviewState> emit,
  ) async {
    final list = [...state.list];
    list.add(event.cbtNote);
    _insertCbtNote(event.cbtNote);
  }

  Future<void> _removeNote(
    CbtNotesOverviewRemove event,
    Emitter<CbtNotesOverviewState> emit,
  ) async {
    _removeCbtNote(event.uuid);
  }
}
