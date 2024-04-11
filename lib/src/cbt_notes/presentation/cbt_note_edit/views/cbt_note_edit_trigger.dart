import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_note_edit_cubit.dart';

class CbtNoteEditTrigger extends StatefulWidget {
  const CbtNoteEditTrigger({super.key, this.onEditingComplete});

  final VoidCallback? onEditingComplete;

  @override
  State<CbtNoteEditTrigger> createState() => _CbtNoteEditTriggerState();
}

class _CbtNoteEditTriggerState extends State<CbtNoteEditTrigger> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CbtNoteEditCubit>();
    final text = cubit.state.cbtNote.trigger;
    _controller = TextEditingController(text: text);
    _controller.addListener(_changed);
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    final cubit = context.read<CbtNoteEditCubit>();
    cubit.updateTrigger(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: BlocSelector<CbtNoteEditCubit, CbtNoteEditState, EditStep>(
              selector: (state) => state.editStep,
              builder: (context, editStep) {
                return TextField(
                  controller: _controller,
                  onEditingComplete: widget.onEditingComplete,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  expands: true,
                  readOnly: editStep != EditStep.creation,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Опишите произошедшее событие',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade400
                    )
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}