import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_notes_overview_bloc.dart';
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
          context.read<CbtNotesOverviewBloc>().add(CbtNotesOverviewInsert(cbtNote));
          context.goNamed(CbtNoteEditPage.routeName, pathParameters: { 'step': 'trigger' }, extra: cbtNote);
        },
      ),
      body: BlocSelector<CbtNotesOverviewBloc, CbtNotesOverviewState, List<CbtNote>>(
        selector: (state) => state.list,
        builder: (context, list) {
          return ListView.builder(
            restorationId: 'CbtNotesOverviewPage',
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final item = list[index];
              return ListTile(
                title: Text(item.trigger),
                leading: const CircleAvatar(
                  foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                ),
                onTap: () {
                  context.goNamed(CbtNoteEditPage.routeName, extra: item);
                }
              );
            },
          );
        },
      ),
    );
  }
}