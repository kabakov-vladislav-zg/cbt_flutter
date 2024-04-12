import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'sliver_text_field_list_item.dart';

class SliverTextFieldList extends StatefulWidget {
  const SliverTextFieldList({
    super.key,
    required this.items,
    required this.onChange,
  });

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
    _items = items
      .map((item) => SliverTextFieldListItem(
        text: item,
        onChange: _onChange,
        onDelete: _onDelete))
      .toList();
    super.initState();
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _onDelete(String uuid, { String? text, bool force = false }) {
    final index = _items.indexWhere((item) => item.uuid == uuid);
    if (index == -1) return;
    if (_items.length == 1) {
      if (force) {
        _items[index].text = '';
      }
      return;
    }
    if ((index == 0 && text != null)) return;
    setState(() {
      _items
        .removeAt(index)
        .dispose();
    });
    if (index > 0) {
      final item = _items[index - 1];
      if (text == null) {
        item.requestFocus();
      } else {
        int offset;
        if (item.isEmpty()) {
          offset = 1;
          item.text += text;
        } else {
          offset = item.text.length + 1;
          item.text += ' $text';
        }
        item.requestFocus();
        item.selection = offset;
      }
    } else {
      _items[0].requestFocus();
      _items[0].selection = 1;
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
      nextItem.requestFocus();
      nextItem.text += text;
      nextItem.selection = 1;
    } else {
      final item = SliverTextFieldListItem(
        text: text,
        onChange: _onChange,
        onDelete: _onDelete,
      );
      _insert(index + 1, item);
      item.requestFocus();
      item.selection = 1;
    }
    _onChange();
  }

  void _insert([final int? index, final SliverTextFieldListItem? item]) {
    final newItem = item
      ?? SliverTextFieldListItem(
          text: '',
          onChange: _onChange,
          onDelete: _onDelete,
        );
    setState(() {
      if (index == null) {
        final lastItem = _items.last;
        if (lastItem.isEmpty()) {
          lastItem.requestFocus();
          lastItem.selection = 1;
        } else {
          _items.add(newItem);
        }
      } else {
        _items.insert(index, newItem);
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final index = oldIndex < newIndex
        ? newIndex - 1
        : newIndex;
      _insert(
        index,
        _items.removeAt(oldIndex),
      );
    });
    _onChange();
  }

  void _onChange() {
    List<String> items = _items
      .map((item) => item.clearText)
      .toList();
    items.removeWhere((text) => text.isEmpty);
    widget.onChange(items);
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverReorderableList(
          onReorder: _onReorder,
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _items[index];
            return Material(
              key: Key(_items[index].uuid),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.drag_indicator),
                    )
                  ),
                  Expanded(
                    child: TextField(
                      controller: item.textController,
                      focusNode: item.focusNode,
                      onEditingComplete: () => _onEditingComplete(index),
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        suffix: _ClearBtn(
                          focusNode: item.focusNode,
                          onPressed: () => _onDelete(item.uuid, force: true),
                        ),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                ),
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text('добавить', style: TextStyle(color: Colors.black),),
                onPressed: _insert,
              )
            ],
          ),
        )
      ],
    );
  }
}

class _ClearBtn extends StatefulWidget {
  const _ClearBtn({
    required this.focusNode,
    required this.onPressed,
  });

  final FocusNode focusNode;
  final VoidCallback onPressed;

  @override
  State<_ClearBtn> createState() => _ClearBtnState();
}

class _ClearBtnState extends State<_ClearBtn> {
  late bool isFocused;

  @override
  void initState() {
    widget.focusNode.addListener(_onFocus);
    isFocused = widget.focusNode.hasFocus;
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocus);
    super.dispose();
  }

  void _onFocus() {
    setState(() {
      isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isFocused,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: IconButton(
        onPressed: widget.onPressed,
        padding: const EdgeInsets.all(0),
        iconSize: 20,
        icon: const Icon(Icons.close),
      ),
    );
  }
}
