import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/cbt_notes_filter.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/get_cbt_notes_stream.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/remowe_cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/insert_cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/set_cbt_notes_filter.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/update_cbt_notes_stream.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cbt_notes_overview_state.dart';

@injectable
class CbtNotesOverviewCubit extends Cubit<CbtNotesOverviewState> {
  @factoryMethod
  CbtNotesOverviewCubit({
    required UpdateCbtNotesStream updateCbtNotesStream,
    required GetCbtNotesStream getCbtNotesStream,
    required SetCbtNotesFilter setCbtNotesFilter,
    required InsertCbtNote insertCbtNote,
    required RemoveCbtNote removeCbtNote,
  }) : 
    _updateCbtNotesStream = updateCbtNotesStream,
    _getCbtNotesStream = getCbtNotesStream,
    _setCbtNotesFilter = setCbtNotesFilter,
    _insertCbtNote = insertCbtNote,
    _removeCbtNote = removeCbtNote,
    super(const CbtNotesOverviewState());
  
  final UpdateCbtNotesStream _updateCbtNotesStream;
  final GetCbtNotesStream _getCbtNotesStream;
  final SetCbtNotesFilter _setCbtNotesFilter;
  final InsertCbtNote _insertCbtNote;
  final RemoveCbtNote _removeCbtNote;

  Future<void> subscriptionRequested() async {
    final stream = await _getCbtNotesStream(state.filter);
    stream.listen((list) {
      emit(state.copyWith(list: list));
    });
  }

  Future<CbtNote> addNote() async {
    final cbtNote = CbtNote();
    final list = [...state.list];
    list.add(cbtNote);
    await _insertCbtNote(cbtNote);
    _updateCbtNotesStream();
    return cbtNote;
  }

  Future<void> removeNote(String uuid) async {
    await _removeCbtNote(uuid);
    await _updateCbtNotesStream();
  }

  Future<void> setDate({
    ValueGetter<DateTime>? dateFrom,
    ValueGetter<DateTime>? dateTo,
  }) async {
    final filter = state
      .calendarFilter
      .copyWithGetter(
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    
    if (filter == state.calendarFilter) return;
    emit(state.copyWith(calendarFilter: filter));
    if (state.filterType != FilterType.calendar) return;

    _setCbtNotesFilter(filter);
    await _updateCbtNotesStream();
  }

  Future<void> setFilter({
    ValueGetter<bool?>? isCompleted,
    ValueGetter<String?>? emotion,
    ValueGetter<String?>? corruption,
  }) async {
    final filter = state
      .listFilter
      .copyWithGetter(
        isCompleted: isCompleted,
        emotion: emotion,
        corruption: corruption,
      );
    
    if (filter == state.listFilter) return;
    emit(state.copyWith(listFilter: filter));
    if (state.filterType != FilterType.list) return;

    _setCbtNotesFilter(filter);
    await _updateCbtNotesStream();
  }

  Future<void> setFilterType(FilterType filterType) async {
    emit(state.copyWith(filterType: filterType));
    _setCbtNotesFilter(state.filter);
    await _updateCbtNotesStream();
  }
}
