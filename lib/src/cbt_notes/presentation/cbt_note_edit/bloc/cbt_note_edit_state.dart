part of 'cbt_note_edit_cubit.dart';

enum EditStep { creation, deconstruction, viewing }

@immutable
class CbtNoteEditState extends Equatable {
  CbtNoteEditState({
    required this.cbtNote,
  }) : editStep = _getActualStep(cbtNote);

  final CbtNote cbtNote;
  final EditStep editStep;

  CbtNoteEditState copyWith({
    CbtNote? cbtNote,
  }) {
    return CbtNoteEditState(
      cbtNote: cbtNote ?? this.cbtNote,
    );
  }

  static EditStep _getActualStep(CbtNote cbtNote) {
    if (cbtNote.isCompleted) {
      return EditStep.viewing;
    } else if (cbtNote.isCreated) {
      return EditStep.deconstruction;
    } else {
      return EditStep.creation;
    }
  }

  @override
  List<Object?> get props => [
    cbtNote,
  ];
}
