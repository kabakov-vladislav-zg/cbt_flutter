import 'package:cbt_flutter/core/datasources/cbt_notes_api.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:injectable/injectable.dart';

@singleton
class CbtNotesRepo {
  CbtNotesRepo({required CbtNotesApi cbtNotesApi}) : _cbtNotesApi = cbtNotesApi;

  final CbtNotesApi _cbtNotesApi;
  
  Future<Stream<List<CbtNote>>> getCbtNotes() => _cbtNotesApi.getCbtNotesStream();

  Future<void> insertCbtNote(CbtNote cbtNote) async {
    return _cbtNotesApi.insertCbtNote(cbtNote);
  }
  Future<void> updateCbtNote(CbtNote cbtNote) async {
    return _cbtNotesApi.updateCbtNote(cbtNote);
  }
  Future<void> removeCbtNote(String uuid) async {
    return _cbtNotesApi.deleteCbtNote(uuid);
  }
}