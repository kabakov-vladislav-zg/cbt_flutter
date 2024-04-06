part of 'diary_overview_bloc.dart';

sealed class DiaryOverviewEvent  {
  const DiaryOverviewEvent();
}

final class DiaryOverviewSubscriptionRequested extends DiaryOverviewEvent {
  const DiaryOverviewSubscriptionRequested();
}

final class DiaryOverviewAddCbtNote extends DiaryOverviewEvent {
  const DiaryOverviewAddCbtNote(this.note);

  final DiaryNote note;
}

final class DiaryOverviewRemoveCbtNote extends DiaryOverviewEvent {
  const DiaryOverviewRemoveCbtNote(this.uuid);

  final String uuid;
}
