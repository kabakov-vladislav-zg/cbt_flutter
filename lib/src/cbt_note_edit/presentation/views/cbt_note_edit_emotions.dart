import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/bloc/cbt_note_edit_cubit.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/widgets/picker_emotion.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CbtNoteEditEmotions extends StatefulWidget {
  const CbtNoteEditEmotions({super.key});

  @override
  State<CbtNoteEditEmotions> createState() => _CbtNoteEditEmotionsState();
}

class _CbtNoteEditEmotionsState extends State<CbtNoteEditEmotions> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNoteEditCubit, CbtNoteEditState, List<Emotion>>(
      selector: (state) => state.note.emotions,
      builder: (context, emotions) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  ...emotions.mapIndexed((index, emotion) => EditEmotion(index: index, emotion: emotion)),
                ]),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: Btn(
                    onPressed: () => _dialogBuilder(context),
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
}

Future<void> _dialogBuilder(BuildContext context) {
  final cubit = context.read<CbtNoteEditCubit>();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return PickerEmotion(
        callback: (String name) {
          context.pop();
          cubit.setEmotion(null, emotion: Emotion(name: name));
        },
      );
    }
  );
}

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
  late Emotion _emotion = widget.emotion;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CbtNoteEditCubit, CbtNoteEditState>(
      listenWhen: (oldState, state) {
        final previous = oldState.note.emotions[_index];
        final current = state.note.emotions[_index];
        return previous != current;
      },
      listener: (context, state) {
        _emotion = state.note.emotions[_index];
      },
      child: Padding(
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
              Text(_emotion.name),
              Slider(
                label: _emotion.intensityFirst.toString(),
                value: _emotion.intensityFirst.toDouble(),
                divisions: 10,
                min: 0,
                max: 10,
                onChanged: (value) {
                  final emotion = _emotion.copyWith(intensityFirst: value.toInt());
                  context.read<CbtNoteEditCubit>().setEmotion(_index, emotion: emotion);
                }
              )
            ]
          ),
        ),
      ),
    );
  }
}
