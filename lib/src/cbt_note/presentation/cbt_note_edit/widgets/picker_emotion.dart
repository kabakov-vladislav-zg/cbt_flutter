import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/utils/emotions.dart';
import 'package:flutter/material.dart';

class PickerEmotion extends StatefulWidget {
  const PickerEmotion({super.key, required this.callback, required this.exclude});
  final void Function(String) callback;
  final List<String> exclude;

  @override
  State<PickerEmotion> createState() => _PickerEmotionState();
}

class _PickerEmotionState extends State<PickerEmotion> {
  final _emotions = getIt.get<Emotions>();
  late final List<GlobalKey> _keys = _emotions.sections.map((section) => GlobalKey()).toList();

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
                    color: _emotions.sections[index].color,
                    child: Text(_emotions.sections[index].section),
                  ),
                );
              },
              childCount: _emotions.sections.length,
            ),
          ),
          for (final section in _emotions.sections) 
            SliverMainAxisGroup(
              slivers: [
                SliverAppBar(
                  key: _keys[_emotions.sections.indexOf(section)],
                  pinned: true,
                  automaticallyImplyLeading: false,
                  title: Text(section.section),
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
                      final name = section.list[index];
                      final isExcluded = widget.exclude.contains(name);
                      final btn = Container(
                          alignment: Alignment.center,
                          color: isExcluded ? Colors.grey : section.color,
                          child: Text(name),
                        );
                      return isExcluded
                        ? btn
                        : GestureDetector(
                            onTap: () => widget.callback(name),
                            child: btn,
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