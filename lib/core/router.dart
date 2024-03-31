import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_page.dart';
import 'package:cbt_flutter/src/diary_overview/presentation/views/diary_overview_page.dart';
import 'package:cbt_flutter/src/settings/presentation/views/settings_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter config = GoRouter(
    initialLocation: DiaryOverviewPage.routeName,
    routes: [
      GoRoute(
        path: DiaryOverviewPage.routeName,
        name: DiaryOverviewPage.routeName,
        builder: (context, state) => const DiaryOverviewPage(),
        routes: [
          GoRoute(
            path: ':noteId',
            name: DiaryEditPage.routeName,
            builder: (context, state) {
              final String noteId = state.pathParameters['noteId']!;
              return DiaryEditPage(noteId: noteId);
            },
          ),
        ],
      ),
      GoRoute(
        path: SettingsView.routeName,
        name: SettingsView.routeName,
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}