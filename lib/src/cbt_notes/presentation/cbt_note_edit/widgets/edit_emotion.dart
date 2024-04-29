import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_note_edit_cubit.dart';

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
  late final _index = widget.index;
  final _maxIntensity = Emotion.maxIntensity;
  late final CbtNoteEditCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<CbtNoteEditCubit>();
    super.initState();
  }

  void _onChanged(double value) {
    final intensityFirst = value.toInt();
    _cubit.updateEmotion(_index, intensityFirst: intensityFirst);
  }

  void _remove() {
    _cubit.removeEmotion(_index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.emotion.name),
                GestureDetector(
                  onTap: _remove,
                  child: const Icon(Icons.delete_outlined),
                )
              ],
            ),
            Slider(
              label: widget.emotion.intensityFirst.toString(),
              value: widget.emotion.intensityFirst.toDouble(),
              divisions: _maxIntensity,
              min: 0,
              max: _maxIntensity.toDouble(),
              onChanged: _onChanged,
            ),
          ]
        ),
      ),
    );
  }
}
