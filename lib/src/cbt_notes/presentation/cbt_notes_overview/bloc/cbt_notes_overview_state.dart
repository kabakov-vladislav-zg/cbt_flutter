part of 'cbt_notes_overview_bloc.dart';

@immutable
class CbtNotesOverviewState extends Equatable {
  const CbtNotesOverviewState({
    this.list = const [],
    this.filter = const CbtNotesFilter(isCompleted: false),
  });

  final List<CbtNote> list;
  final CbtNotesFilter filter;

  CbtNotesOverviewState copyWith({
    List<CbtNote>? list,
    CbtNotesFilter? filter,
  }) {
    return CbtNotesOverviewState(
      list: list ?? this.list,
      filter: filter ?? this.filter,
    );
  }

  @override
  get props => [list, filter];
}
