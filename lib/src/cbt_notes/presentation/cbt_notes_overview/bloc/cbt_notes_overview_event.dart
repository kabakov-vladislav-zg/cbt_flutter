part of 'cbt_notes_overview_bloc.dart';

sealed class CbtNotesOverviewEvent  {
  const CbtNotesOverviewEvent();
}

final class CbtNotesOverviewSubscribe extends CbtNotesOverviewEvent {
  const CbtNotesOverviewSubscribe();
}

final class CbtNotesOverviewInsert extends CbtNotesOverviewEvent {
  const CbtNotesOverviewInsert(this.cbtNote);

  final CbtNote cbtNote;
}

final class CbtNotesOverviewRemove extends CbtNotesOverviewEvent {
  const CbtNotesOverviewRemove(this.uuid);

  final String uuid;
}

final class CbtNotesOverviewFilter extends CbtNotesOverviewEvent {
  const CbtNotesOverviewFilter({
    this.uuid,
    this.isCompleted,
    this.dateFrom,
    this.dateTo,
    this.emotion,
    this.corruption,
  });

  final ValueGetter<String>? uuid;
  final ValueGetter<bool>? isCompleted;
  final ValueGetter<DateTime>? dateFrom;
  final ValueGetter<DateTime>? dateTo;
  final ValueGetter<String>? emotion;
  final ValueGetter<String>? corruption;
}
