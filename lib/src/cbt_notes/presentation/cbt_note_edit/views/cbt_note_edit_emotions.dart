import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../widgets/edit_emotion.dart';
import '../widgets/picker_emotion.dart';

class CbtNoteEditEmotions extends StatefulWidget {
  const CbtNoteEditEmotions({super.key});

  @override
  State<CbtNoteEditEmotions> createState() => _CbtNoteEditEmotionsState();
}

class _CbtNoteEditEmotionsState extends State<CbtNoteEditEmotions> {
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
  final emotions = cubit.state.cbtNote.emotions;
  final exclude = emotions.map((emotion) => emotion.name).toList();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return PickerEmotion(
        exclude: exclude,
        callback: (String name) {
          context.pop();
          cubit.insertEmotion(name);
        },
      );
    }
  );
}
