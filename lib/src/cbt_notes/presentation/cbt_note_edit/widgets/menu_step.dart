import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_note_edit_cubit.dart';

class MenuStep extends StatefulWidget {
  const MenuStep({ super.key });

  @override
  State<MenuStep> createState() => _MenuStepState();
}
class _MenuStepState extends State<MenuStep> {
  late final CbtNoteEditCubit _cubit;
  List<DropdownMenuItem<EditStep>> _dropdownMenuItems = [];
  late EditStep _editStep;

  @override
  void initState() {
    _cubit = context.read<CbtNoteEditCubit>();
    _setEntries();
    super.initState();
  }

  _setEntries() {
    final avaibleSteps = _cubit.getAvaibleSteps();
    setState(() {
      _dropdownMenuItems = avaibleSteps.map((EditStep editStep) {
        return DropdownMenuItem<EditStep>(
          value: editStep,
          child: Text(editStep.name),
        );
      }).toList();
      _editStep = _cubit.state.editStep;
    });
  }

  void _onChanged(EditStep? editStep) {
    if (editStep == null || editStep == _editStep) return;
    _cubit.setStep(editStep);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<CbtNoteEditCubit, CbtNoteEditState>(
      listener: (context, state) => _setEntries(),
      listenWhen: (previous, current) => previous.editStep != current.editStep,
      child: DropdownButton<EditStep>(
        value: _editStep,
        onChanged: _onChanged,
        items: _dropdownMenuItems,
      ),
    );
  }
}