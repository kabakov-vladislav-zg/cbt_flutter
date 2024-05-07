import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../widgets/deconstruct_thought_dialog.dart';

class EditThought extends StatelessWidget {
  const EditThought({
    super.key,
    required this.thought,
    required this.index,
  });

  final Thought thought;

  final int index;

  void _dialogBuilder(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) {
        return BlocProvider.value(
          value: context.read<CbtNoteEditCubit>(),
          child: DeconstructThoughtDialog(
            index: index,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final badge = thought.isCompleted
      ? const Badge(backgroundColor: Colors.green, label: Text('проработано'))
      : const Badge(backgroundColor: Colors.red, label: Text('непроработано'));
    return UICard(
      onTap: () => _dialogBuilder(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [badge],
          ),
          const Gap(4),
          Text(thought.description),
          const Gap(12),
          if (thought.corruption.isNotEmpty)
            Badge(
              backgroundColor: Colors.white,
              label: Text(
                thought.corruption,
                style: const TextStyle(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
