import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_notes_overview_bloc.dart';
import '../widgets/sliver_cbt_notes_overview.dart';
import '../../cbt_note_edit/views/cbt_note_edit_page.dart';

class CbtNotesOverviewPage extends StatelessWidget {
  const CbtNotesOverviewPage({super.key});

  static const routeName = 'cbt_notes_overview';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CbtNotesOverviewBloc>()
      ..add(const CbtNotesOverviewSubscribe()),
      child: const CbtNotesOverview(),
    );
  }
}

class CbtNotesOverview extends StatelessWidget {
  const CbtNotesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cbtNote = CbtNote();
          context
            .read<CbtNotesOverviewBloc>()
            .add(CbtNotesOverviewInsert(cbtNote));
          context.goNamed(
            CbtNoteEditPage.routeName,
            extra: cbtNote,
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('КПТ-дневник'),
          ),
          SliverCbtNotesOverview(),
        ],
      ),
    );
  }
}