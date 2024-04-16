import 'package:flutter/material.dart';

class UITextField extends StatefulWidget {
  const UITextField({
    super.key,
    this.controller,
    this.value = '',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String value;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  State<UITextField> createState() => _UITextFieldState();
}

class _UITextFieldState extends State<UITextField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = widget.controller ?? TextEditingController();
    _textController.text = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UITextField oldWidget) {
    if (widget.value != oldWidget.value) {
      _textController.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
    );
  }
}