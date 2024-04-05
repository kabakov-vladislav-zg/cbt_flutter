part of 'diary_overview_bloc.dart';

@immutable
class DiaryOverviewState extends Equatable {
  const DiaryOverviewState({
    this.list = const [],
  });

  final List<DiaryNote> list;

  DiaryOverviewState copyWith({
    List<DiaryNote>? list,
  }) {
    return DiaryOverviewState(
      list: list ?? this.list,
    );
  }

  @override
  List<Object?> get props => [
    list,
  ];
}
