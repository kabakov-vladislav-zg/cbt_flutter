import 'package:flutter/material.dart';

class UIDropdownButton<T> extends StatefulWidget {
  const UIDropdownButton({
    super.key,
    this.value,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.hintText,
    this.clearable = false,
    this.items = const [],
  });

  final T? value;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool clearable;
  final String? hintText;
  final List<(T?, String)> items;

  @override
  State<UIDropdownButton<T>> createState() => _UIDropdownButtonState<T>();
}

class _UIDropdownButtonState<T> extends State<UIDropdownButton<T>> {

  @override
  Widget build(BuildContext context) {
    Widget result = DropdownButton<T>(
      value: widget.value,
      underline: const SizedBox(),
      isDense: true,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      icon: widget.onTap != null
        ? const SizedBox()
        : const Icon(Icons.keyboard_arrow_down),
      onChanged: widget.onChanged,
      hint: widget.hintText != null
        ? Text(widget.hintText!)
        : null,
      items: [
        for (final item in widget.items)
          DropdownMenuItem(
            value: item.$1,
            child: Text(item.$2),
          ),
      ],
    );
    if (widget.onTap != null) {
      result = GestureDetector(
        onTap: widget.onTap,
        child: AbsorbPointer(
          child: result,
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 1,
                offset: const Offset(0, 1.0),
              ),
            ]
          ),
          child: result,
        ),
        if (widget.clearable && widget.value != null)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              widget.onChanged?.call(null);
              widget.onClear?.call();
            },
          ),
      ],
    );
  }

}