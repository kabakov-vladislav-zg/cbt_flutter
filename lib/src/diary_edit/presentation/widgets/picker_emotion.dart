import 'package:cbt_flutter/core/utils/list_emotions.dart';
import 'package:flutter/material.dart';

class PickerEmotion extends StatefulWidget {
  const PickerEmotion({super.key, this.callback});
  final void Function(String)? callback;

  @override
  State<PickerEmotion> createState() => _PickerEmotionState();
}

class _PickerEmotionState extends State<PickerEmotion> {
  final _keys = listEmotions.map((section) => GlobalKey<State<SliverAppBar>>()).toList();

  @override
  Widget build(BuildContext context) {
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
                return GestureDetector(
                  onTap: () {
                    final key = _keys[index];
                    Scrollable.ensureVisible(key.currentContext!);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: listEmotions[index].color,
                    child: Text(listEmotions[index].name),
                  ),
                );
              },
              childCount: listEmotions.length,
            ),
          ),
          for (final section in listEmotions) 
            SliverMainAxisGroup(
              slivers: [
                SliverAppBar(
                  key: _keys[listEmotions.indexOf(section)],
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
                      return GestureDetector(
                        onTap: () {
                          if (widget.callback != null) {
                            widget.callback!(section.list[index]);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: section.color,
                          child: Text(section.list[index]),
                        ),
                      );
                    },
                    childCount: section.list.length,
                  ),
                ),
              ]
            ),
        ]
      ),
    );
  }
}