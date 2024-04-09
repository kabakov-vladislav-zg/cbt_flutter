import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_note_edit_cubit.dart';

class MenuStep extends StatelessWidget {
  const MenuStep({ super.key });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNoteEditCubit, CbtNoteEditState, EditStep>(
      selector: (state) => state.editStep,
      builder: (BuildContext context, EditStep editStep) {
        return editStep == EditStep.creation
          ? const Text('')
          : SizedBox(
            width: 56,
            height: 56,
            child: IconButton(
              onPressed: () {
                final cubit = context.read<CbtNoteEditCubit>();
                if (editStep == EditStep.viewing) {
                  cubit.setStep(EditStep.deconstruction);
                } else {
                  cubit.setStep(EditStep.creation);
                }
              },
              icon: const Icon(Icons.edit),
            ),
          );
      }
    );
  }
}