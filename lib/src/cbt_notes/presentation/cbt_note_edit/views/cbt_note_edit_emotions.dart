import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/common/set_emotion_dialog.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/src/cbt_notes/presentation/cbt_note_edit/widgets/set_emotion_intensity_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../widgets/edit_emotion.dart';

class CbtNoteEditEmotions extends StatelessWidget {
  const CbtNoteEditEmotions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNoteEditCubit, CbtNoteEditState, List<Emotion>>(
      selector: (state) => state.cbtNote.emotions,
      builder: (context, emotions) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: emotions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16),
                    child: EditEmotion(
                      key: Key(emotions[index].name),
                      emotion: emotions[index],
                      index: index,
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: Btn(
                    onPressed: () => _emotionDialogBuilder(context),
                    text: 'добавить',
                    block: true,
                  ),
                ),
              ),
            ]
          ),
        );
      },
    );
  }
}

Future<void> _emotionDialogBuilder(BuildContext context) async {
  final cubit = context.read<CbtNoteEditCubit>();
  final emotions = cubit.state.cbtNote.emotions;
  final editStep = cubit.state.editStep;
  final exclude = emotions.map((emotion) => emotion.name).toList();
  final record = await showDialog<({
    String name,
    int intensity,
  })>(
    context: context,
    builder: (innerContext) {
      return SetEmotionDialog(
        exclude: exclude,
        onSelect: (name)
          => _emotionIntensityDialogBuilder(innerContext, name),
      );
    }
  );
  if (record == null) return;
  cubit.insertEmotion(
    name: record.name,
    intensityFirst: editStep == EditStep.creation
      ? record.intensity
      : 0,
    intensitySecond: record.intensity,
  );
}

Future<void> _emotionIntensityDialogBuilder(BuildContext context, String name) async {
  final router = GoRouter.of(context);
  final intensity = await showDialog<int>(
    context: context,
    builder: (innerContext)
      => SetEmotionIntensityDialog(name: name),
  );
  if (intensity == null) return;
  router.pop((name: name, intensity: intensity));
}
