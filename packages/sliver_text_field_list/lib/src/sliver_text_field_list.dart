import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class SliverTextFieldList extends StatefulWidget {
  const SliverTextFieldList({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
  });

  final List<String> value;
  final void Function(List<String>) onChanged;
  final void Function(List<String>)? onChangeEnd;

  @override
  State<SliverTextFieldList> createState() => _SliverTextFieldListState();
}

class _SliverTextFieldListState extends State<SliverTextFieldList> {
  final _getKey = _GetKey<UITextFieldState>();
  late final List<String> _items = widget.value.isEmpty
    ? ['']
    : [...widget.value];

  void _onDelete(int index) {
    setState(() {
      if (_items.length > 1) {
        _items.removeAt(index);
      } else {
        _items[0] = '';
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nextItem = _getItem(index) ?? _getItem(index - 1);
      nextItem!.requestFocus();
      nextItem.selection = double.maxFinite.toInt();
    });
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd!(_getValue());
    } else {
      widget.onChanged(_getValue());
    }
  }

  void _onEditingComplete(int index) {
    String text = '';
    String currentText = _items[index];

    final selection = _getItem(index)!.selection;
    final length = currentText.length;
    if (selection < length) {
      text = currentText.substring(selection).trim();
      currentText = currentText.substring(0, selection);
    }
    setState(() {
      _items[index] = currentText.trim();
    });

    final nwxtIndex = index + 1;
    UITextFieldState? nextItem = _getItem(nwxtIndex);
    if (nextItem != null && nextItem.isEmpty) {
      setState(() {
        _items[nwxtIndex] = text;
      });
      nextItem.requestFocus();
      nextItem.selection = 0;
    } else {
      setState(() {
        _items.insert(nwxtIndex, text);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nextItem = _getItem(nwxtIndex);
        nextItem!.requestFocus();
        nextItem!.selection = 0;
      });
    }
    widget.onChanged(_getValue());
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
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd!(_getValue());
    } else {
      widget.onChanged(_getValue());
    }
  }

  void _onChanged(int index, String value) {
    setState(() {
      _items[index] = value;
    });
    widget.onChanged(_getValue());
  }

  void _onBackspace(int index) {
    if (_items.length == 1) return;
    final text = _items[index].trim();
    if (index == 0 && text.isNotEmpty) return;
    setState(() {
      _items.removeAt(index);
    });

    if (index > 0) {
      final prevIndex = index - 1;
      final prevItem = _getItem(prevIndex)!;
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
    }
    widget.onChanged(_getValue());
  }

  void _addItem() {
    if (_items.last.isNotEmpty) {
      setState(() {
        _items.add('');
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getItem(_items.length - 1)!.requestFocus();
    });
  }

  UITextFieldState? _getItem(int index) {
    return _getKey(index).currentState;
  }

  List<String> _getValue() {
    final List<String> items = [];
    for (final item in _items) {
      if (item.trim().isNotEmpty) {
        items.add(item);
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverReorderableList(
          onReorder: _onReorder,
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            final clearable = _items.length > 1 || _items[index].isNotEmpty;
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
                      onDelete: () => _onDelete(index),
                      onTapOutside: widget.onChangeEnd == null
                        ? null
                        : () => widget.onChangeEnd!(_getValue()),
                      maxLines: null,
                      clearable: clearable,
                      keyboardType: TextInputType.text,
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
                onPressed: _addItem,
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
    }
    return _keys[index]!;
  }
}
