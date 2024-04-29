import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../widgets/edit_emotion.dart';
import '../widgets/set_emotion_dialog.dart';

class CbtNoteEditEmotions extends StatefulWidget {
  const CbtNoteEditEmotions({super.key});

  @override
  State<CbtNoteEditEmotions> createState() => _CbtNoteEditEmotionsState();
}

class _CbtNoteEditEmotionsState extends State<CbtNoteEditEmotions> {
  late final CbtNoteEditCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<CbtNoteEditCubit>();
    super.initState();
  }

  Future<void> _dialogBuilder() async {
    final emotions = _cubit.state.cbtNote.emotions;
    final exclude = emotions.map((emotion) => emotion.name).toList();
    final record = await showDialog<({
      String name,
      int intensity,
    })>(
      context: context,
      builder: (context)
        => SetEmotionDialog(exclude: exclude),
    );
    if (record == null) return;
    _cubit.insertEmotion(
      name: record.name,
      intensityFirst: record.intensity,
    );
  }

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
                  return EditEmotion(
                    key: Key(emotions[index].name),
                    emotion: emotions[index],
                    index: index,
                  );
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60,
                  child: Btn(
                    onPressed: _dialogBuilder,
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
