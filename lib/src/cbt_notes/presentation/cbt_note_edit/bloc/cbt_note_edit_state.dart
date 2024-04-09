part of 'cbt_note_edit_cubit.dart';

@immutable
class CbtNoteEditState extends Equatable {
  const CbtNoteEditState({
    required this.cbtNote,
  });

  final CbtNote cbtNote;

  CbtNoteEditState copyWith({
    CbtNote? cbtNote,
  }) {
    return CbtNoteEditState(
      cbtNote: cbtNote ?? this.cbtNote,
    );
  }

  @override
  List<Object?> get props => [
    cbtNote,
  ];
}
