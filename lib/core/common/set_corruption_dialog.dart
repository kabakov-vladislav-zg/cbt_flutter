import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/utils/corruption.dart';
import 'package:flutter/material.dart';

class SetCorruptionDialog extends StatefulWidget {
  const SetCorruptionDialog({
    super.key,
    required this.onSelect,
  });

  final void Function(String) onSelect;

  @override
  State<SetCorruptionDialog> createState() => _SetCorruptionDialogState();
}

class _SetCorruptionDialogState extends State<SetCorruptionDialog> {
  final _corruptions = getIt.get<Corruptions>().list;
  late final _list = List.filled(_corruptions.length, false);

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Когнктивное искажение'),
            actions: [
              Container(
                margin: const EdgeInsetsDirectional.only(end: 8),
                child: ExpandIcon(
                  isExpanded: _list.contains(true),
                  onPressed: (flag) => setState(() {
                    _list.fillRange(0, _list.length, !flag);
                  }),
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  _list[index] = isExpanded;
                });
              },
              children: [
                for (final corruption in _corruptions)
                  ExpansionPanel(
                    isExpanded: _list[_corruptions.indexOf(corruption)],
                    headerBuilder: (context, isExpanded) {
                      return InkResponse(
                        onTap: () => widget.onSelect(corruption.name),
                        child: ListTile(
                          title: Text(corruption.name),
                        ),
                      );
                    },
                    body: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                      child: Text(corruption.desc),
                    )
                  ),
              ],
            ),
          )
        ]
      ),
    );
  }
}