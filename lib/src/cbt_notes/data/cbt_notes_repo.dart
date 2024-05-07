import 'package:cbt_flutter/core/datasources/cbt_notes_api.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@singleton
class CbtNotesRepo {
  CbtNotesRepo({
    required CbtNotesApi cbtNotesApi,
  }) : _cbtNotesApi = cbtNotesApi;

  final CbtNotesApi _cbtNotesApi;

  late final BehaviorSubject<List<CbtNote>> _streamController;

  Future<Stream<List<CbtNote>>> getCbtNotesStream() async {
    final list = await _getCbtNotes();
    _streamController = BehaviorSubject<List<CbtNote>>.seeded(list);
    return _streamController.asBroadcastStream();
  }

  Future<void> updateCbtNotesStream() async {
    final list = await _getCbtNotes();
    _streamController.add(list);
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
  Future<List<CbtNote>> _getCbtNotes() async {
    return _cbtNotesApi.getCbtNotes();
  }
}