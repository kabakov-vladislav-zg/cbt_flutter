import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_notes_overview_cubit.dart';
import 'filter_bar_cbt_notes_calendar.dart';
import 'filter_bar_cbt_notes_list.dart';

class FilterBarCbtNotes extends StatelessWidget {
  const FilterBarCbtNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNotesOverviewCubit, CbtNotesOverviewState, FilterType>(
      selector: (state) => state.filterType,
      builder: (context, filterType) {
        switch (filterType) {
          case FilterType.list:
            return const FilterBarCbtNotesList();
          case FilterType.calendar:
            return const FilterBarCbtNotesCalendar();
        }
      }
    );
  }
}