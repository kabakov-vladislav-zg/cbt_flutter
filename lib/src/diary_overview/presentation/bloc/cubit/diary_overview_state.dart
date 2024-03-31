part of 'diary_overview_cubit.dart';

@immutable
class DiaryOverviewState {
  const DiaryOverviewState({
    this.list = const [DiaryNote(id: '1', event: 'fhdfh')],
  });

  final List<DiaryNote> list;
}
