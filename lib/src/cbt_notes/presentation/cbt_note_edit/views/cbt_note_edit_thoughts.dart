import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../widgets/edit_thought.dart';
import '../widgets/deconstruct_thought.dart';

class CbtNoteEditThoughts extends StatelessWidget {
  const CbtNoteEditThoughts({super.key});

  @override
  Widget build(BuildContext context) {
    final insertThought = context.read<CbtNoteEditCubit>().insertThought;

    return BlocSelector<CbtNoteEditCubit, CbtNoteEditState, EditStep>(
      selector: (state) => state.editStep,
      builder: (context, editStep) {
        return CustomScrollView(slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: BlocSelector<CbtNoteEditCubit, CbtNoteEditState, List<Thought>>(
              selector: (state) => state.cbtNote.thoughts,
              builder: (context, thoughts) {
                return SliverList.builder(
                  itemCount: thoughts.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (editStep == EditStep.creation) {
                      return EditThought(
                        key: Key(thoughts[index].uuid),
                        thought: thoughts[index],
                        index: index,
                        onEditingComplete: () => insertThought(),
                      );
                    } else {
                      return DeconstructThought(
                        key: Key(thoughts[index].uuid),
                        thought: thoughts[index],
                        index: index,
                      );
                    }
                  },
                );
              },
            ),
          ),
          if (editStep == EditStep.creation)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: Btn(
                    onPressed: () => insertThought(),
                    text: 'добавить',
                    block: true,
                  ),
                ),
              ),
            ),
        ]);
      },
    );
  }
}
