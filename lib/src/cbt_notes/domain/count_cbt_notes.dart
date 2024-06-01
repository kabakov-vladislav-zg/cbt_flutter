import 'package:cbt_flutter/core/entities/cbt_notes_filter.dart';
import 'package:cbt_flutter/src/cbt_notes/data/cbt_notes_repo.dart';
import 'package:injectable/injectable.dart';


@singleton
class CountCbtNotes {
  CountCbtNotes(this._repo);
  final CbtNotesRepo _repo;

  Future<int> call(CbtNotesFilter? filter) async {
    return _repo.countCbtNotes(filter);
  }
}