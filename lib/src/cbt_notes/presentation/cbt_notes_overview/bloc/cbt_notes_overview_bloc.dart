import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/get_cbt_notes_stream.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/remowe_cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/insert_cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/update_cbt_notes_stream.dart';
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
    required UpdateCbtNotesStream updateCbtNotesStream,
    required GetCbtNotesStream getCbtNotesStream,
    required InsertCbtNote insertCbtNote,
    required RemoveCbtNote removeCbtNote,
  }) : 
    _updateCbtNotesStream = updateCbtNotesStream,
    _getCbtNotesStream = getCbtNotesStream,
    _insertCbtNote = insertCbtNote,
    _removeCbtNote = removeCbtNote,
    super(const CbtNotesOverviewState()) {
      on<CbtNotesOverviewSubscribe>(_onSubscriptionRequested);
      on<CbtNotesOverviewInsert>(_addNote);
      on<CbtNotesOverviewRemove>(_removeNote);
    }
  
  final UpdateCbtNotesStream _updateCbtNotesStream;
  final GetCbtNotesStream _getCbtNotesStream;
  final InsertCbtNote _insertCbtNote;
  final RemoveCbtNote _removeCbtNote;

  Future<void> _onSubscriptionRequested(
    CbtNotesOverviewSubscribe event,
    Emitter<CbtNotesOverviewState> emit,
  ) async {
    await emit.forEach<List<CbtNote>>(
      await _getCbtNotesStream(),
      onData: (list) => state.copyWith(list: list),
    );
  }

  Future<void> _addNote(
    CbtNotesOverviewInsert event,
    Emitter<CbtNotesOverviewState> emit,
  ) async {
    final list = [...state.list];
    list.add(event.cbtNote);
    await _insertCbtNote(event.cbtNote);
    await _updateCbtNotesStream();
  }

  Future<void> _removeNote(
    CbtNotesOverviewRemove event,
    Emitter<CbtNotesOverviewState> emit,
  ) async {
    await _removeCbtNote(event.uuid);
    await _updateCbtNotesStream();
  }
}
