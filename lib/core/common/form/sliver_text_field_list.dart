import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'sliver_text_field_list_item.dart';

class SliverTextFieldListBuilderParams {
  const SliverTextFieldListBuilderParams({
    required this.context,
    required this.index,
    required this.textController,
    required this.focusNode,
    required this.onEditingComplete,
  });

  final BuildContext context;
  final int index;
  final TextEditingController textController;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
}

class SliverTextFieldList extends StatefulWidget {
  const SliverTextFieldList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onChange,
  });

  final Widget? Function(SliverTextFieldListBuilderParams) itemBuilder;
  final List<String> items;
  final void Function(List<String> items) onChange;

  @override
  State<SliverTextFieldList> createState() => _SliverTextFieldListState();
}

class _SliverTextFieldListState extends State<SliverTextFieldList> {
  late final List<SliverTextFieldListItem> _items;

  @override
  void initState() {
    final items = widget.items.isEmpty ? [''] : widget.items;
    _items = items.map((item) {
      return SliverTextFieldListItem(
        text: item,
        onChange: _onChange,
        onDelete: _onDelete,
      );
    }).toList();
    super.initState();
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _onDelete(String uuid, [String? text]) {
    final index = _items.indexWhere((item) => item.uuid == uuid);
    if (index < 1) return;
    _items[index].dispose();
    setState(() {
      _items.removeAt(index);
    });
    final item = _items[index - 1];
    if (text != null) {
      final initialText = item.textController.text;
      item.textController.text += ' $text';
      item.focusNode.requestFocus();
      item.selection = initialText.length + 1;
    } else {
      item.focusNode.requestFocus();
    }
    _onChange();
  }

  void _onEditingComplete(int index) {
    final currentItem = _items[index];
    String text = '';
    if (currentItem.selection < currentItem.text.length) {
      text = currentItem.text.substring(currentItem.selection);
      currentItem.text = currentItem.text.substring(0, currentItem.selection);
    }
    final nextItem = _items.elementAtOrNull(index + 1);
    if (nextItem != null && nextItem.isEmpty()) {
      nextItem.focusNode.requestFocus();
      nextItem.text += text;
      nextItem.selection = 1;
    } else {
      final item = SliverTextFieldListItem(
        text: text,
        onChange: _onChange,
        onDelete: _onDelete,
      );
      setState(() {
        _items.insert(index + 1, item);
      });
      item.focusNode.requestFocus();
      item.selection = 1;
    }
    _onChange();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final SliverTextFieldListItem item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
    _onChange();
  }

  void _onChange() {
    List<String> items = _items.map((item) => item.clearText).toList();
    items.removeWhere((text) => text.trim().isEmpty);
    widget.onChange(items);
  }

  @override
  Widget build(BuildContext context) {
    return SliverReorderableList(
      onReorder: _onReorder,
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        final itemWidget = widget.itemBuilder(SliverTextFieldListBuilderParams(
          context: context,
          index: index,
          textController: _items[index].textController,
          focusNode: _items[index].focusNode,
          onEditingComplete: () => _onEditingComplete(index),
        ));
        if (itemWidget == null) return Container(height: 0);
        return Material(
          key: Key(_items[index].uuid),
          child: ReorderableDragStartListener(
            index: index,
            child: itemWidget,
          ),
        );
      },
    );
  }
}
