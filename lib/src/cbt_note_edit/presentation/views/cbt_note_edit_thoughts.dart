import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/bloc/cbt_note_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/edit_thought.dart';

class CbtNoteEditThoughts extends StatefulWidget {
  const CbtNoteEditThoughts({super.key});

  @override
  State<CbtNoteEditThoughts> createState() => _CbtNoteEditThoughtsState();
}

class _CbtNoteEditThoughtsState extends State<CbtNoteEditThoughts> {
  late final CbtNoteEditCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<CbtNoteEditCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.removeEmptyFields();
    super.dispose();
  }


  void _newThought(BuildContext context) {
    final cubit = context.read<CbtNoteEditCubit>();
    cubit.setThought(null, thought: Thought(description: ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNoteEditCubit, CbtNote, List<Thought>>(
      selector: (state) => state.thoughts,
      builder: (context, thoughts) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList.builder(
                itemCount: thoughts.length,
                itemBuilder: (BuildContext context, int index) {
                  return EditThought(
                    key: Key(thoughts[index].uuid),
                    thought: thoughts[index],
                    index: index,
                    onEditingComplete: () => _newThought(context),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: Btn(
                    onPressed: () => _newThought(context),
                    text: 'добавить',
                    block: true,
                  ),
                ),
              ),
            )
          ]
        );
      },
    );
  }
}
