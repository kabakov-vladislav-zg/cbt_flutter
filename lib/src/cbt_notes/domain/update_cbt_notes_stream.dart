import 'package:cbt_flutter/src/cbt_notes/data/cbt_notes_repo.dart';
import 'package:injectable/injectable.dart';


@singleton
class UpdateCbtNotesStream {
  UpdateCbtNotesStream(this._repo);
  final CbtNotesRepo _repo;

  Future<void> call() async {
    return _repo.updateCbtNotesStream();
  }
}