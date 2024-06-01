import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/utils/emotions.dart';
import 'package:flutter/material.dart';

class SetEmotionDialog extends StatefulWidget {
  const SetEmotionDialog({
    super.key,
    required this.exclude,
    required this.onSelect,
    this.emotionCount,
  });
  final List<String> exclude;
  final ValueChanged<String> onSelect;
  final Future<int> Function(String)? emotionCount;

  @override
  State<SetEmotionDialog> createState() => _SetEmotionDialogState();
}

class _SetEmotionDialogState extends State<SetEmotionDialog> {
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
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 4.0,
                  ),
                  itemCount: section.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final name = section.list[index];
                    final isExcluded = widget.exclude.contains(name);
                    final btn = Container(
                      alignment: Alignment.center,
                      color: isExcluded
                        ? Colors.grey
                        : section.color,
                      child: Text(name),
                    );
                    return isExcluded
                      ? btn
                      : GestureDetector(
                          onTap: () => widget.onSelect(name),
                          child: btn,
                        );
                  },
                ),
              ]
            ),
        ]
      ),
    );
  }
}