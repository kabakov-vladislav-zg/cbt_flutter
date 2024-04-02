import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/utils/list_emotions.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryEditEmotions extends StatefulWidget {
  const DiaryEditEmotions({super.key});

  @override
  State<DiaryEditEmotions> createState() => _DiaryEditEmotionsState();
}

class _DiaryEditEmotionsState extends State<DiaryEditEmotions> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiaryEditCubit, DiaryNote, List<Emotion>>(
      selector: (state) => state.emotions,
      builder: (context, emotions) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ...emotions.mapIndexed((index, emotion) => Spacer()),
                  Btn(
                    onPressed: () => _dialogBuilder(context),
                    text: 'добавить',
                    block: true,
                  )
                ]),
              )
            ),
          ]
        );
      },
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              title: Text('Эмоции'),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: listEmotions[index].color,
                    child: Text(listEmotions[index].name),
                  );
                },
                childCount: listEmotions.length,
              ),
            ),
            for (final section in listEmotions)
              SliverMainAxisGroup(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    title: Text(section.name),
                  ),
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          color: section.color,
                          child: Text(section.list[index]),
                        );
                      },
                      childCount: section.list.length,
                    ),
                  ),
                ]
              ),
          ]
        )
      );
    }
  );
}

// class EditEmotion extends StatefulWidget {
//   const EditEmotion({
//     super.key,
//     required this.emotion,
//     required this.index,
//   });

//   final Emotion emotion;
//   final int index;

//   @override
//   State<EditEmotion> createState() => _EditEmotionState();
// }

// class _EditEmotionState extends State<EditEmotion> {
//   late final TextEditingController _controller;
//   late final _index = widget.index;
//   late final _emotion = widget.emotion;

//   @override
//   void initState() {
//     super.initState();
//     final text = _thought.description; 
//     _controller = TextEditingController(text: text);
//     _controller.addListener(_changed);
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_changed);
//     super.dispose();
//   }

//   _changed() {
//     final text = _controller.text;
//     final thought = _thought.copyWith(description: text);
//     context.read<DiaryEditCubit>().setThought(_index, thought: thought);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DiaryEditCubit, DiaryNote>(
//       listenWhen: (oldState, state) {
//         final previous = oldState.thoughts[_index].description;
//         final current = state.thoughts[_index].description;
//         return previous != current && current != _controller.text;
//       },
//       listener: (context, state) {
//         _controller.text = state.thoughts[_index].description;
//       },
//       child: TextField(controller: _controller),
//     );
//   }
// }
