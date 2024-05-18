import 'package:cbt_flutter/core/common/set_corruption_dialog.dart';
import 'package:cbt_flutter/core/common/set_emotion_dialog.dart';
import 'package:cbt_flutter/core/entities/cbt_notes_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_notes_overview_cubit.dart';

class CbtNotesFilterList extends StatelessWidget {
  const CbtNotesFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Center(
              child: BlocSelector<CbtNotesOverviewCubit, CbtNotesOverviewState, CbtNotesFilter>(
                selector: (state) => state.listFilter,
                builder: (context, filter) {
                  return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    children: [
                      UIDropdownButton<bool>(
                        value: filter.isCompleted,
                        clearable: true,
                        hintText: 'статус',
                        items: const [
                          (false, 'новые'),
                          (true, 'проработанные'),
                        ],
                        onChanged: (bool? value) {
                          context
                            .read<CbtNotesOverviewCubit>()
                            .setFilter(isCompleted: () => value);
                        },
                      ),
                      UIDropdownButton<String>(
                        value: filter.emotion,
                        clearable: true,
                        hintText: 'эмоции',
                        items: [
                          if (filter.emotion != null)
                            (filter.emotion, '${filter.emotion}'),
                        ],
                        onTap: () => _emotionDialogBuilder(context),
                        onChanged: (value) {
                          context
                            .read<CbtNotesOverviewCubit>()
                            .setFilter(emotion: () => value);
                        }
                      ),
                      UIDropdownButton<String>(
                        value: filter.corruption,
                        clearable: true,
                        hintText: 'искажение',
                        items: [
                          if (filter.corruption != null)
                            (filter.corruption, '${filter.corruption}'),
                        ],
                        onTap: () => _corruptionDialogBuilder(context),
                        onChanged: (value) {
                          context
                            .read<CbtNotesOverviewCubit>()
                            .setFilter(corruption: () => value);
                        }
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Future<void> _emotionDialogBuilder(BuildContext context) async {
  final cubit = context.read<CbtNotesOverviewCubit>();
  final emotion = cubit.state.listFilter.emotion;
  await showDialog<int>(
    context: context,
    builder: (innerContext)
      => SetEmotionDialog(
        exclude: [if (emotion != null) emotion],
        onSelect: (name) {
          cubit.setFilter(emotion: () => name);
          innerContext.pop();
        },
      ),
  );
}

Future<void> _corruptionDialogBuilder(BuildContext context) async {
  final cubit = context.read<CbtNotesOverviewCubit>();
  await showDialog<int>(
    context: context,
    builder: (innerContext)
      => SetCorruptionDialog(
        onSelect: (name) {
          cubit.setFilter(corruption: () => name);
          innerContext.pop();
        },
      ),
  );
}

