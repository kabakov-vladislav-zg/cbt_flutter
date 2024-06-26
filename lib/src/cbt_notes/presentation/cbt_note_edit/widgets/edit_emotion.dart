import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../widgets/set_emotion_intensity_dialog.dart';
import '../utils/debounce.dart';

class EditEmotion extends StatefulWidget {
  const EditEmotion({
    super.key,
    required this.emotion,
    required this.index,
  });

  final Emotion emotion;
  final int index;

  @override
  State<EditEmotion> createState() => _EditEmotionState();
}

class _EditEmotionState extends State<EditEmotion> {
  late final _cubit = context.read<CbtNoteEditCubit>();
  late final _updateEmotion = _cubit.updateEmotion;

  Future<void> _dialogBuilder() async {
    final name = widget.emotion.name;
    final isCreation = _cubit.state.editStep == EditStep.creation;
    final initIntensity = isCreation
      ? widget.emotion.intensityFirst
      : widget.emotion.intensitySecond;
    final intensity = await showDialog<int>(
      context: context,
      builder: (context) =>
        SetEmotionIntensityDialog(name: name, value: initIntensity),
    );
    if (intensity == null) return;
    if (isCreation) {
      _updateEmotion(widget.index, intensityFirst: intensity);
    } else {
      _updateEmotion(widget.index, intensitySecond: intensity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNoteEditCubit, CbtNoteEditState, EditStep>(
      selector: (state) => state.editStep,
      builder: (context, editStep) {
        final isCreation = editStep == EditStep.creation;
        final isEdit = editStep == EditStep.edit;
        final buttonDelete = IconButton(
          icon: const Icon(Icons.delete_outlined),
          onPressed: () {
            _cubit.removeEmotion(widget.index);
          },
        );
        return UICard(
          clickable: !isEdit,
          onTap: _dialogBuilder,
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.all(0),
                title: Text(widget.emotion.name),
                trailing: isCreation || isEdit || widget.emotion.intensityFirst == 0
                  ? buttonDelete
                  : null,
              ),
              UISlider(
                label: 'Изначальная интенсивность',
                max: Emotion.maxIntensity,
                value: widget.emotion.intensityFirst,
                readOnly: !(isCreation || isEdit),
                onChanged: (value) {
                  debounce(() {
                    _updateEmotion(widget.index, intensityFirst: value);
                  }, debounced: true);
                },
                onChangeEnd: (value) {
                  debounce(() {
                    _updateEmotion(widget.index, intensityFirst: value);
                  });
                },
              ),
              if (!isCreation)
                UISlider(
                  label: 'Интенсивность после проработки',
                  max: Emotion.maxIntensity,
                  value: widget.emotion.intensitySecond,
                  onChanged: (value) {
                    debounce(() {
                      _updateEmotion(widget.index, intensitySecond: value);
                    }, debounced: true);
                  },
                  onChangeEnd: (value) {
                    debounce(() {
                      _updateEmotion(widget.index, intensitySecond: value);
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
