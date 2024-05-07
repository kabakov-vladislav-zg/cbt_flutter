import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/data/cbt_notes_repo.dart';
import 'package:injectable/injectable.dart';


@singleton
class GetCbtNotesStream {
  GetCbtNotesStream(this._repo);
  final CbtNotesRepo _repo;

  Future<Stream<List<CbtNote>>> call() async {
    return _repo.getCbtNotesStream();
  }
}