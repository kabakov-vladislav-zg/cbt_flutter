import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/cbt_notes_filter.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/count_cbt_notes.dart';
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
    required CountCbtNotes countCbtNotes,
  }) : 
    _updateCbtNotesStream = updateCbtNotesStream,
    _getCbtNotesStream = getCbtNotesStream,
    _setCbtNotesFilter = setCbtNotesFilter,
    _insertCbtNote = insertCbtNote,
    _removeCbtNote = removeCbtNote,
    _countCbtNotes = countCbtNotes,
    super(CbtNotesOverviewState(
      listFilter: const CbtNotesFilter(isCompleted: false),
      calendarFilter: CbtNotesFilter(
        dateFrom: DateTime.now(),
        dateTo: DateTime.now().add(const Duration(days: 1)),
      ),
      filterType: FilterType.list
    ));
  
  final UpdateCbtNotesStream _updateCbtNotesStream;
  final GetCbtNotesStream _getCbtNotesStream;
  final SetCbtNotesFilter _setCbtNotesFilter;
  final InsertCbtNote _insertCbtNote;
  final RemoveCbtNote _removeCbtNote;
  final CountCbtNotes _countCbtNotes;

  Future<void> subscriptionRequested() async {
    final stream = await _getCbtNotesStream(state.filter);
    stream.listen((list) {
      emit(state.copyWith(list: list));
    });
  }

  Future<CbtNote> addNote({ DateTime? date }) async {
    final cbtNote = CbtNote(timestamp: date);
    await _insertCbtNote(cbtNote);
    _updateCbtNotesStream();
    return cbtNote;
  }

  Future<void> removeNote(String uuid) async {
    await _removeCbtNote(uuid);
    await _updateCbtNotesStream();
  }

  Future<void> setCalendarFilter(DateTime day) async {
    final filter = state
      .calendarFilter
      .copyWithGetter(
        dateFrom: () => day,
        dateTo: () => day.add(const Duration(days: 1)),
      );
    
    if (filter == state.calendarFilter) return;
    emit(state.copyWith(calendarFilter: filter));
    if (state.filterType != FilterType.calendar) return;

    _setCbtNotesFilter(filter);
    await _updateCbtNotesStream();
  }

  Future<int> countCalendarFilter(DateTime day) async {
    return _countCbtNotes(CbtNotesFilter(
      dateFrom: day,
      dateTo: day.add(const Duration(days: 1)),
    ));
  }

  Future<void> setListFilter({
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

  Future<int> countListFilter({
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
      
    return _countCbtNotes(filter);
  }

  Future<void> setFilterType(FilterType filterType) async {
    emit(state.copyWith(filterType: filterType));
    _setCbtNotesFilter(state.filter);
    await _updateCbtNotesStream();
  }
}
