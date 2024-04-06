import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/usescases/update_cbt_note.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:injectable/injectable.dart';

@singleton
class DebouncedUpdateCbtNote {
  DebouncedUpdateCbtNote(this._updateCbtNote);
  final UpdateCbtNote _updateCbtNote;

  void call(CbtNote cbtNote) {
    EasyDebounce.debounce(
      'ThrottledUpdateCbtNote',
      const Duration(seconds: 2),
      () => _updateCbtNote(cbtNote)
    );
  }
}
