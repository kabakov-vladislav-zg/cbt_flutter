import 'package:cbt_flutter/core/datasources/cbt_notes_api.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/cbt_notes_filter.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@singleton
class CbtNotesRepo {
  CbtNotesRepo({
    required CbtNotesApi cbtNotesApi,
  }) : _cbtNotesApi = cbtNotesApi;

  final CbtNotesApi _cbtNotesApi;

  late final BehaviorSubject<List<CbtNote>> _streamController;

  CbtNotesFilter? _filter;

  Future<Stream<List<CbtNote>>> getCbtNotesStream(CbtNotesFilter? filter) async {
    _filter = filter;
    final list = await _getCbtNotes();
    _streamController = BehaviorSubject<List<CbtNote>>.seeded(list);
    return _streamController.asBroadcastStream();
  }

  Future<void> updateCbtNotesStream() async {
    final list = await _getCbtNotes();
    _streamController.add(list);
  }

  void setCbtNotesFilter(CbtNotesFilter filter) {
    _filter = filter;
  }
  
  Future<void> insertCbtNote(CbtNote cbtNote) async {
    await _cbtNotesApi.insertCbtNote(cbtNote);
  }

  Future<void> updateCbtNote(CbtNote cbtNote) async {
    await _cbtNotesApi.updateCbtNote(cbtNote);
  }

  Future<void> removeCbtNote(String uuid) async {
    await _cbtNotesApi.deleteCbtNote(uuid);
  }
  
  Future<int> countCbtNotes(filter) async {
    return _cbtNotesApi.countCbtNotes(filter);
  }

  Future<List<CbtNote>> _getCbtNotes() async {
    return _cbtNotesApi.getCbtNotes(_filter);
  }
}