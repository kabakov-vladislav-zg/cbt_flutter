import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_note_edit_cubit.dart';

class CbtNoteEditTrigger extends StatelessWidget {
  const CbtNoteEditTrigger({
    super.key,
    this.onEditingComplete,
  });
  
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: BlocBuilder<CbtNoteEditCubit, CbtNoteEditState>(
              builder: (context, state) {
                final isCreation = state.editStep == EditStep.creation;
                final isEdit = state.editStep == EditStep.edit;
                return UITextField(
                  value: state.cbtNote.trigger,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  expands: true,
                  readOnly: !(isCreation || isEdit),
                  hintText: 'Опишите произошедшее событие',
                  onEditingComplete: onEditingComplete,
                  onChanged: (value) {
                    context
                      .read<CbtNoteEditCubit>()
                      .updateTrigger(value);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
