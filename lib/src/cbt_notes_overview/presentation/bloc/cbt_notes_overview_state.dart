part of 'cbt_notes_overview_bloc.dart';

@immutable
class CbtNotesOverviewState extends Equatable {
  const CbtNotesOverviewState({
    this.list = const [],
  });

  final List<CbtNote> list;

  CbtNotesOverviewState copyWith({
    List<CbtNote>? list,
  }) {
    return CbtNotesOverviewState(
      list: list ?? this.list,
    );
  }

  @override
  List<Object?> get props => [
    list,
  ];
}
