import 'package:cbt_flutter/core/datasources/cbt_notes_api.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@singleton
class CbtNotesRepo {
  CbtNotesRepo({required CbtNotesApi cbtNotesApi}) : _cbtNotesApi = cbtNotesApi;

  final CbtNotesApi _cbtNotesApi;

  late BehaviorSubject<List<CbtNote>> _streamController;

  Future<Stream<List<CbtNote>>> getCbtNotesStream() async {
    final list = await getCbtNotes();
    _streamController = BehaviorSubject<List<CbtNote>>.seeded(list);
    return _streamController.asBroadcastStream();
  }
  
  Future<void> insertCbtNote(CbtNote cbtNote) async {
    await _cbtNotesApi.insertCbtNote(cbtNote);
    final list = await getCbtNotes();
    _streamController.add(list);
  }
  Future<void> updateCbtNote(CbtNote cbtNote) async {
    await _cbtNotesApi.updateCbtNote(cbtNote);
    final list = await getCbtNotes();
    _streamController.add(list);
  }
  Future<void> removeCbtNote(String uuid) async {
    await _cbtNotesApi.deleteCbtNote(uuid);
    final list = await getCbtNotes();
    _streamController.add(list);
  }
  Future<List<CbtNote>> getCbtNotes() async {
    return _cbtNotesApi.getCbtNotes();
  }
}