import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cbt_note_edit/views/cbt_note_edit_page.dart';
import '../bloc/cbt_notes_overview_cubit.dart';

class CbtNotesActions extends StatelessWidget {
  const CbtNotesActions({super.key});
  
  void _toggleFilterType(BuildContext context, FilterType filterType) {
    context
      .read<CbtNotesOverviewCubit>()
      .setFilterType(filterType);
  }

  void _addCbtNote(BuildContext context) async {
    final router = GoRouter.of(context);
    final cbtNote = await context.read<CbtNotesOverviewCubit>().addNote();
    router.goNamed(
      CbtNoteEditPage.routeName,
      extra: cbtNote,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNotesOverviewCubit, CbtNotesOverviewState, FilterType>(
      selector: (state) => state.filterType,
      builder: (context, filterType) {
        FilterType nextFilterType;
        IconData icon;
        switch (filterType) {
          case FilterType.calendar:
            nextFilterType = FilterType.list;
            icon = Icons.list;
            break;
          case FilterType.list:
            nextFilterType = FilterType.calendar;
            icon = Icons.calendar_month;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton.filled(
              icon: Icon(icon),
              onPressed: () {
                _toggleFilterType(context, nextFilterType);
              },
            ),
            IconButton.filled(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addCbtNote(context);
              },
            ),
          ],
        );
      },
    );
  }
}
