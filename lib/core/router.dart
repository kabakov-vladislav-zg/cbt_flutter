import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/views/cbt_note_edit_page.dart';
import 'package:cbt_flutter/src/cbt_notes_overview/presentation/views/cbt_notes_overview_page.dart';
import 'package:cbt_flutter/src/settings/presentation/views/settings_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter config = GoRouter(
    initialLocation: '/${CbtNotesOverviewPage.routeName}',
    routes: [
      GoRoute(
        path: '/${CbtNotesOverviewPage.routeName}',
        name: CbtNotesOverviewPage.routeName,
        builder: (context, state) => const CbtNotesOverviewPage(),
        routes: [
          GoRoute(
            path: CbtNoteEditPage.routeName,
            name: CbtNoteEditPage.routeName,
            builder: (context, state) {
              final cbtNote = state.extra as CbtNote;
              return CbtNoteEditPage(cbtNote: cbtNote);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/${SettingsPage.routeName}',
        name: SettingsPage.routeName,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}