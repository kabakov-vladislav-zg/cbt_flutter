import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/edit_thought.dart';

class DiaryEditThoughts extends StatefulWidget {
  const DiaryEditThoughts({super.key});

  @override
  State<DiaryEditThoughts> createState() => _DiaryEditThoughtsState();
}

class _DiaryEditThoughtsState extends State<DiaryEditThoughts> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiaryEditCubit, DiaryNote, List<Thought>>(
      selector: (state) => state.thoughts,
      builder: (context, thoughts) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: thoughts.length,
                itemBuilder: (BuildContext context, int index) {
                  return EditThought(
                    thought: thoughts[index],
                    index: index,
                    onEditingComplete: () => _newThought(context),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: Btn(
                    onPressed: () => _newThought(context),
                    text: 'добавить',
                    block: true,
                  ),
                ),
              )
            ]
          ),
        );
      },
    );
  }

  void _newThought(BuildContext context) {
    final cubit = context.read<DiaryEditCubit>();
    cubit.setThought(null, thought: const Thought(description: ''));
  }
}
