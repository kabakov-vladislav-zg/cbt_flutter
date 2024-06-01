part of 'cbt_notes_overview_cubit.dart';

enum FilterType {list, calendar}

@immutable
class CbtNotesOverviewState extends Equatable {
  const CbtNotesOverviewState({
    this.list = const [],
    required this.listFilter,
    required this.calendarFilter,
    required this.filterType,
  });

  final List<CbtNote> list;
  final CbtNotesFilter calendarFilter;
  final CbtNotesFilter listFilter;
  final FilterType filterType;

  CbtNotesFilter get filter {
    switch (filterType) {
      case FilterType.list:
        return listFilter;
      case FilterType.calendar:
        return calendarFilter;
    }
  }

  CbtNotesOverviewState copyWith({
    List<CbtNote>? list,
    CbtNotesFilter? listFilter,
    CbtNotesFilter? calendarFilter,
    FilterType? filterType,
  }) {
    return CbtNotesOverviewState(
      list: list ?? this.list,
      listFilter: listFilter ?? this.listFilter,
      calendarFilter: calendarFilter ?? this.calendarFilter,
      filterType: filterType ?? this.filterType,
    );
  }

  @override
  get props => [list, calendarFilter, listFilter, filterType];
}
