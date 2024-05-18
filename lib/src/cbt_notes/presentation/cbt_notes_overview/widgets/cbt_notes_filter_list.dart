import 'package:cbt_flutter/core/entities/cbt_notes_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      )
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
