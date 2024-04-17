import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
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
  final _getKey = _GetKey<UITextFieldState>();
  late final List<String> _items = widget.items.isEmpty
    ? ['']
    : [...widget.items];

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDelete(int index) {
    setState(() {
      if (_items.length > 1) {
        _items.removeAt(index);
      } else {
        _items[0] = '';
      }
    });
    _emit();
  }

  void _onEditingComplete(int index) {
    String text = '';

    final selection = _getItem(index)!.selection;
    final currentText = _items[index];
    final length = currentText.length;
    if (selection < length) {
      text = currentText.substring(selection);
      setState(() {
        _items[index] = currentText.substring(0, selection);
      });
    }

    UITextFieldState? nextItem = _getItem(index + 1);
    if (nextItem != null && nextItem.isEmpty) {
      setState(() {
        _items[index + 1] = text;
      });
      nextItem.requestFocus();
      nextItem.selection = 0;
    } else {
      setState(() {
        _items.insert(index + 1, text);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nextItem = _getItem(index + 1);
        nextItem!.requestFocus();
        nextItem!.selection = 0;
      });      
    }
    _emit();
  }

  void _onReorder(int oldIndex, int newIndex) {
    final index = oldIndex < newIndex
      ? newIndex - 1
      : newIndex;
    setState(() {
      _items.insert(
        index,
        _items.removeAt(oldIndex),
      );
    });
    _emit();
  }

  void _onChanged(int index, String value) {
    setState(() {
      _items[index] = value;
    });
    _emit();
  }

  void _onBackspace(int index) {
    final text = _items[index].trim();

    if (index > 0) {
      final prevIndex = index - 1;
      final prevItem = _getItem(prevIndex)!;
      setState(() {
        _items.removeAt(index);
      });
      if (text.isEmpty) {
        prevItem.requestFocus();
      } else {
        int offset;
        String prevText = _items[prevIndex].trim();
        if (prevText.isEmpty) {
          offset = 0;
          prevText = text;
        } else {
          offset = prevText.length + 1;
          prevText += ' $text';
        }
        setState(() {
          _items[prevIndex] = prevText;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          prevItem.requestFocus();
          prevItem.selection = offset;
        }); 
      }
    } else if (_items.length > 1 && text.isEmpty) {
      setState(() {
        _items.removeAt(0);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getItem(0)!.selection = 0;
      }); 
    }
    _emit();
  }

  UITextFieldState? _getItem(int index) {
    return _getKey(index).currentState;
  }

  void _emit() {
    final List<String> items = [];
    for (final item in _items) {
      if (item.trim().isNotEmpty) {
        items.add(item);
      }
    }
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
            return Material(
              key: Key('item$index'),
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
                    child: UITextField(
                      key: _getKey(index),
                      value: _items[index],
                      onChanged: (value) => _onChanged(index, value),
                      onEditingComplete: () => _onEditingComplete(index),
                      onBackspace: () => _onBackspace(index),
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        suffixIcon: Visibility(
                          visible: true,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: IconButton(
                            onPressed: () => _onDelete(index),
                            padding: const EdgeInsets.all(0),
                            iconSize: 20,
                            icon: const Icon(Icons.close),
                          ),
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
                onPressed: () {},
              )
            ],
          ),
        )
      ],
    );
  }
}

class _GetKey<T extends State> {
  final Map<int, GlobalKey<T>> _keys = {};

  GlobalKey<T> call(int index) {
    if (_keys[index] == null) {
      _keys[index] = GlobalKey<T>();
      return _keys[index]!;
    } else {
      return _keys[index]!;
    }
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
