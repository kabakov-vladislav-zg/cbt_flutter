part of 'cbt_note_edit_cubit.dart';

@immutable
class CbtNoteEditState extends Equatable {
  const CbtNoteEditState({
    required this.note,
  });

  final CbtNote note;

  CbtNoteEditState copyWith({
    CbtNote? note,
  }) {
    return CbtNoteEditState(
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
    note,
  ];
}
