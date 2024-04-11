import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './deconstruct_thought_dialog.dart';
import '../bloc/cbt_note_edit_cubit.dart';

class DeconstructThought extends StatefulWidget {
  const DeconstructThought({
    super.key,
    required this.thought,
    required this.index,
  });

  final Thought thought;
  final int index;

  @override
  State<DeconstructThought> createState() => _DeconstructThoughtState();
}

class _DeconstructThoughtState extends State<DeconstructThought> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
          )
        ],
      ),
      child: TextField(
        onTap: () => _dialogBuilder(context, thought: widget.thought, index: widget.index),
        controller: TextEditingController(text: widget.thought.description),
        readOnly: true,
        keyboardType: TextInputType.text,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          suffix: IconButton(
            onPressed: () => print('2222'),
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}

Future<void> _dialogBuilder(
  BuildContext context, {
  required Thought thought,
  required int index,
}) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext innerContext) {
        return BlocProvider.value(
          value: context.watch<CbtNoteEditCubit>(),
          child: DeconstructThoughtDialog(
            thought: thought,
            index: index,
          ),
        );
      });
}
