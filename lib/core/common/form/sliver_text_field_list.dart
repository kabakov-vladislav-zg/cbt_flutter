import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SliverTextFieldListItem {
  SliverTextFieldListItem({
    required this.text,
    required VoidCallback onChange,
    required Future<void> Function(String uuid) onDelete,
  }) : _onChangeCallback = onChange,
       _onDeleteCallback = onDelete {
    textController = TextEditingController(text: getText(text));
    textController.addListener(_onChange);
    focusNode = FocusNode();
    uuid = const Uuid().v1();
  }

  late final TextEditingController textController;
  late final FocusNode focusNode;
  late final String uuid;
  final VoidCallback _onChangeCallback;
  final Future<void> Function(String uuid) _onDeleteCallback;
  static const String _invisibleChar = '\u200B';
  String text;

  static String getText(String value) {
    if (value.startsWith(_invisibleChar)) {
      return value;
    } else {
      return _invisibleChar + value;
    }
  }

  bool isEmpty() {
    return text.trim() == _invisibleChar;
  }

  void _onChange() {
    text = textController.text;
    if (text.isEmpty) {
      textController.text = _invisibleChar;
      _onDeleteCallback(uuid);
    } else {
      _onChangeCallback();
    }
  }

  void dispose() {
    textController.removeListener(_onChange);
    textController.dispose();
    focusNode.dispose();
  }
}

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

  Future<void> _onDelete(String uuid) async {
    await Future.delayed(const Duration(seconds: 0));
    final index = _items.indexWhere((item) => item.uuid == uuid);
    if (index < 1) return;
    _items[index].dispose();
    setState(() {
      _items.removeAt(index);
    });
    _items[index - 1].focusNode.requestFocus();
    _onChange();
  }

  void _onEditingComplete(int index) {
    final nextItem = _items.elementAtOrNull(index + 1);
    if (nextItem != null && nextItem.isEmpty()) {
      nextItem.focusNode.requestFocus();
    } else {
      final item = SliverTextFieldListItem(
        text: '',
        onChange: _onChange,
        onDelete: _onDelete,
      );
      setState(() {
        _items.insert(index + 1, item);
      });
      item.focusNode.requestFocus();
      _onChange();
    }
  }

  void _onChange() {
    List<String> items = _items.map((item) => item.text).toList();
    items.removeWhere((text) => text.trim().isEmpty);
    widget.onChange(items);
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
