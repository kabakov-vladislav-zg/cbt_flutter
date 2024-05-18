import 'package:cbt_flutter/core/common/layouts/exercise_overview_layout.dart';
import 'package:cbt_flutter/core/di/sl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_notes_overview_cubit.dart';
import '../widgets/cbt_notes_filter_list.dart';
import '../widgets/sliver_cbt_notes_overview.dart';
import '../../cbt_note_edit/views/cbt_note_edit_page.dart';

class CbtNotesOverviewPage extends StatelessWidget {
  const CbtNotesOverviewPage({super.key});

  static const routeName = 'cbt_notes_overview';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt.get<CbtNotesOverviewCubit>()..subscriptionRequested(),
      child: const CbtNotesOverview(),
    );
  }
}

class CbtNotesOverview extends StatefulWidget {
  const CbtNotesOverview({super.key});

  @override
  State<CbtNotesOverview> createState() => _CbtNotesOverviewState();
}

class _CbtNotesOverviewState extends State<CbtNotesOverview> {
  void _addCbtNote() async {
    final router = GoRouter.of(context);
    final cbtNote = await context.read<CbtNotesOverviewCubit>().addNote();
    router.goNamed(
      CbtNoteEditPage.routeName,
      extra: cbtNote,
    );
  }

  void _toggleFilterType(FilterType filterType) async {
    await context
      .read<CbtNotesOverviewCubit>()
      .setFilterType(filterType);
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
          default:
            nextFilterType = FilterType.calendar;
            icon = Icons.calendar_month;
        }
        return Scaffold(
          body: ExerciseOverviewLayout(
            onboarding: Container(),
            slivers: const [
              SliverAppBar(
                title: Text('КПТ-дневник'),
              ),
              CbtNotesFilterList(),
              SliverCbtNotesOverview(),
            ],
          ),
          floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filled(
                  icon: Icon(icon),
                  onPressed: ()
                    => _toggleFilterType(nextFilterType),
                ),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addCbtNote,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
