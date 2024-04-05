import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_page.dart';
import 'package:cbt_flutter/src/diary_overview/presentation/bloc/cubit/diary_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DiaryOverviewPage extends StatelessWidget {
  const DiaryOverviewPage({super.key});

  static const routeName = '/diary';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<DiaryOverviewCubit>(),
      child: Scaffold(
        body: BlocSelector<DiaryOverviewCubit, DiaryOverviewState, List<DiaryNote>>(
          selector: (state) => state.list,
          builder: (context, list) {
            return ListView.builder(
              restorationId: 'diaryOverviewPage',
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                final item = list[index];
                return ListTile(
                  title: Text(item.trigger),
                  leading: const CircleAvatar(
                    foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () {
                    context.goNamed(DiaryEditPage.routeName, pathParameters: { 'step': 'event' }, extra: item);
                  }
                );
              },
            );
          },
        ),
      )
    );
  }
}