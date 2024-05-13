import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_notes_overview_bloc.dart';
import '../widgets/cbt_notes_filter.dart';
import '../widgets/sliver_cbt_notes_overview.dart';
import '../../cbt_note_edit/views/cbt_note_edit_page.dart';

class CbtNotesOverviewPage extends StatelessWidget {
  const CbtNotesOverviewPage({super.key});

  static const routeName = 'cbt_notes_overview';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)
        => getIt.get<CbtNotesOverviewBloc>()
          ..add(const CbtNotesOverviewSubscribe()),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: const UIDraggableScrollableSheet(
        height: 300,
        heading: CbtNotesFilter(),
        slivers: [
          SliverCbtNotesOverview(),
        ],
      ),
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
    );
  }
}
