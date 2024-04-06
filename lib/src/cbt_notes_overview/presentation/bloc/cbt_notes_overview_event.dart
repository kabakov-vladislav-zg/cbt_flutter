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
