part of 'diary_overview_cubit.dart';

@immutable
class DiaryOverviewState {
  const DiaryOverviewState({
    this.list = const [],
  });

  final List<DiaryNote> list;
}
