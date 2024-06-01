import 'package:cbt_flutter/core/di/sl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_notes_overview_cubit.dart';
import '../widgets/cbt_notes_actions.dart';
import '../widgets/filter_bar_cbt_notes.dart';
import '../widgets/cbt_notes_overview.dart';

class CbtNotesOverviewPage extends StatelessWidget {
  const CbtNotesOverviewPage({super.key});

  static const routeName = 'cbt_notes_overview';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
        getIt.get<CbtNotesOverviewCubit>()
        ..subscriptionRequested(),
      child: const _CbtNotesOverviewPage(),
    );
  }
}

class _CbtNotesOverviewPage extends StatelessWidget {
  const _CbtNotesOverviewPage();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNotesOverviewCubit, CbtNotesOverviewState, FilterType>(
      selector: (state) => state.filterType,
      builder: (context, filterType) {
        return const Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(title: Text('КПТ-дневник')),
                FilterBarCbtNotes(),
                CbtNotesOverview(),
              ],
            ),
          ),
          floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CbtNotesActions(),
          ),
        );
      },
    );
  }
}
