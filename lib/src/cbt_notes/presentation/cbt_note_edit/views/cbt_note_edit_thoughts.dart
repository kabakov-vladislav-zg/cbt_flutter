import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/src/cbt_notes/presentation/cbt_note_edit/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_text_field_list/sliver_text_field_list.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../widgets/edit_thought.dart';
import '../widgets/deconstruct_thought_dialog.dart';

class CbtNoteEditThoughts extends StatelessWidget {
  const CbtNoteEditThoughts({super.key});

  void _insertThought(BuildContext context) {
    final cubit = context.read<CbtNoteEditCubit>();
    final (:index, thought: _) = cubit.insertThought();
    showDialog(
      context: context,
      builder: (innerContext) {
        return BlocProvider.value(
          value: cubit,
          child: DeconstructThoughtDialog(
            index: index,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        sliver: BlocBuilder<CbtNoteEditCubit, CbtNoteEditState>(
          builder: (context, state) {
            final thoughts = state.cbtNote.thoughts;
            if (state.editStep == EditStep.creation) {
              final items = thoughts
                .map((thought) => thought.description)
                .toList();
              final insertThoughtList = context
                .read<CbtNoteEditCubit>()
                .insertThoughtList;
              return SliverTextFieldList(
                value: items,
                onChanged: (value) {
                  debounce(() {
                    insertThoughtList(value);
                  }, debounced: true);
                },
                onChangeEnd: (value) {
                  debounce(() {
                    insertThoughtList(value);
                  });
                },
              );
            } else {
              return SliverMainAxisGroup(
                slivers: [
                  SliverList.builder(
                    itemCount: thoughts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 16),
                        child: EditThought(
                          index: index,
                          thought: thoughts[index],
                        ),
                      );
                    },
                  ),
                  if (state.editStep == EditStep.edit)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 60,
                        child: Btn(
                          onPressed: () => _insertThought(context),
                          text: 'добавить',
                          block: true,
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    ]);
  }
}
