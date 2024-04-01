import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ...thoughts.mapIndexed((index, thought) => EditThought(thought: thought, index: index)),
                  Btn(
                    onPressed: () => context.read<DiaryEditCubit>().setThought(null, thought: const Thought(description: '')),
                    text: 'добавить',
                    block: true,
                  )
                ]),
              )
            ),
          ]
        );
      },
    );
  }
}

class EditThought extends StatefulWidget {
  const EditThought({
    super.key,
    required this.thought,
    required this.index,
  });

  final Thought thought;
  final int index;

  @override
  State<EditThought> createState() => _EditThoughtState();
}

class _EditThoughtState extends State<EditThought> {
  late final TextEditingController _controller;
  late final _index = widget.index;
  late final _thought = widget.thought;

  @override
  void initState() {
    super.initState();
    final text = _thought.description; 
    _controller = TextEditingController(text: text);
    _controller.addListener(_changed);
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    super.dispose();
  }

  _changed() {
    final text = _controller.text;
    final thought = _thought.copyWith(description: text);
    context.read<DiaryEditCubit>().setThought(_index, thought: thought);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryEditCubit, DiaryNote>(
      listenWhen: (oldState, state) {
        final previous = oldState.thoughts[_index].description;
        final current = state.thoughts[_index].description;
        return previous != current && current != _controller.text;
      },
      listener: (context, state) {
        _controller.text = state.thoughts[_index].description;
      },
      child: TextField(controller: _controller),
    );
  }
}
