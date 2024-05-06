import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/utils/emotions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

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
      child: CbtNotesOverview(),
    );
  }
}

class CbtNotesOverview extends StatelessWidget {
  CbtNotesOverview({super.key});

  final _emotionsMap = getIt.get<Emotions>().map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cbtNote = CbtNote();
          context.read<CbtNotesOverviewBloc>().add(CbtNotesOverviewInsert(cbtNote));
          context.goNamed(CbtNoteEditPage.routeName, extra: cbtNote);
        },
      ),
      body: BlocSelector<CbtNotesOverviewBloc, CbtNotesOverviewState, List<CbtNote>>(
        selector: (state) => state.list,
        builder: (context, list) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    Color backgroundColor;
                    String label;
                    if (item.isCompleted) {
                      backgroundColor = Colors.green;
                      label = 'проработано';
                    } else if (item.isCreated) {
                      backgroundColor = Colors.orange;
                      label = 'непроработано';
                    } else {
                      backgroundColor = Colors.grey;
                      label = 'черновик';
                    }
                    final badge = Badge(backgroundColor: backgroundColor, label: Text(label));
                    final emotions = item.emotions.map((emotion) {
                      final emotionDesc = _emotionsMap[emotion.name]!;
                      return Badge(
                        backgroundColor: emotionDesc.color,
                        label: Text(emotionDesc.name),
                      );
                    }).toList();

                    return UICard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [badge],
                          ),
                          const Gap(4),
                          Text(item.trigger),
                          const Gap(12),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            clipBehavior: Clip.hardEdge,
                            children: emotions,
                          )
                        ],
                      ),
                      onTap: () {
                        context.goNamed(CbtNoteEditPage.routeName, extra: item);
                      },
                    );
                  }
                ),
              )
            ],
          );
        },
      ),
    );
  }
}