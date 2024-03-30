import 'package:cbt_flutter/src/sample_feature/sample_item_details_view.dart';
import 'package:cbt_flutter/src/sample_feature/sample_item_list_view.dart';
import 'package:cbt_flutter/src/settings/presentation/views/settings_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter config = GoRouter(
    initialLocation: SampleItemListView.routeName,
    routes: [
      GoRoute(
        path: SampleItemListView.routeName,
        name: SampleItemListView.routeName,
        builder: (context, state) => const SampleItemListView(),
      ),
      GoRoute(
        path: SettingsView.routeName,
        name: SettingsView.routeName,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: SampleItemDetailsView.routeName,
        name: SampleItemDetailsView.routeName,
        builder: (context, state) => const SampleItemDetailsView(),
      ),
    ],
  );
}