import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UITextField extends StatefulWidget {
  const UITextField({
    super.key,
    this.controller,
    this.focusNode,
    this.value = '',
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.onTap,
    this.onBackspace,
    this.onEditingComplete,
    this.readOnly = false,
    this.decoration,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String value;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final VoidCallback? onTap;
  final VoidCallback? onFocus;
  final VoidCallback? onBlur;
  final VoidCallback? onBackspace;
  final bool readOnly;
  final int? maxLines;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;

  @override
  State<UITextField> createState() => UITextFieldState();
}

class UITextFieldState extends State<UITextField> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _textController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _textController.text = widget.value;
    _focusNode.addListener(_onFocusChanged);
    if (widget.onBackspace != null) {
      _focusNode.onKeyEvent = _onBackspace;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UITextField oldWidget) {
    if (widget.value != oldWidget.value) {
      final currentSelection = selection;
      _text = widget.value;
      selection = currentSelection;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void requestFocus() => _focusNode.requestFocus();
  bool get hasFocus => _focusNode.hasFocus;
  
  String get _text => _textController.text;
  set _text(String value) => _textController.text = value;

  int get selection => _textController.selection.start;
  set selection(int selection) {
    final length = widget.value.length;
    final offset = selection > length ? length : selection;
    _textController.selection = TextSelection.collapsed(offset: offset);
  }

  bool get isEmpty => _text.trim().isEmpty;
  bool get isNotEmpty => _text.trim().isNotEmpty;

  KeyEventResult _onBackspace(FocusNode node, KeyEvent event) {
    final isBackspace = event.logicalKey == LogicalKeyboardKey.backspace;
    if (isBackspace && selection == 0) {
      widget.onBackspace!();
    }
    return KeyEventResult.handled;
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      if (widget.onFocus == null) return;
      widget.onFocus!();
    } else {
      if (widget.onBlur == null) return;
      widget.onBlur!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      readOnly: widget.readOnly,
      decoration: widget.decoration,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
    );
  }
}