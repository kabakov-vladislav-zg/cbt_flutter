import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class SliverTextFieldListItem {
  SliverTextFieldListItem({
    required this.text,
    required VoidCallback onChange,
  }) : _onChangeCallback = onChange {
    textController = TextEditingController(text: text);
    textController.addListener(_onChange);
    focusNode = FocusNode();
    uuid = const Uuid().v1();
  }

  late final TextEditingController textController;
  late final FocusNode focusNode;
  late final String uuid;
  final VoidCallback _onChangeCallback;
  String text;

  void _onChange() {
    text = textController.text;
    _onChangeCallback();
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
  final ShortcutActivator _shortcutActivator = const SingleActivator(LogicalKeyboardKey.backspace);
  Map<ShortcutActivator, VoidCallback> getBindings(int index) => { _shortcutActivator: () => _onDelete(index) };

  late final List<SliverTextFieldListItem> _items;

  void _onDelete(int index) {
    if (index == 0) return;
    _items[index].dispose();
    setState(() {
      _items.removeAt(index);
    });
    _items[index - 1].focusNode.requestFocus();
    _onChange();
  }

  void _onEditingComplete(int index) {
    final nextItem = _items.elementAtOrNull(index + 1);
    if (nextItem != null && nextItem.text.trim().isEmpty) {
      nextItem.focusNode.requestFocus();
    } else {
      final item = SliverTextFieldListItem(
        text: '',
        onChange: _onChange,
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

  @override
  void initState() {
    final items = widget.items.isEmpty ? [''] : widget.items;
    _items = items.map((item) {
      return SliverTextFieldListItem(
        text: item,
        onChange: _onChange,
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

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        final itemWidget = widget.itemBuilder(SliverTextFieldListBuilderParams(
          context: context,
          index: index,
          textController: _items[index].textController,
          focusNode: _items[index].focusNode,
          onEditingComplete: () => _onEditingComplete(index),
        ));
        if (itemWidget == null) return null;
        return Container(
          key: Key(_items[index].uuid),
          margin: const EdgeInsetsDirectional.only(bottom: 16),
          child: CallbackShortcuts(
            bindings: getBindings(index),
            child: itemWidget,
          ),
        );
      },
    );
  }
}
