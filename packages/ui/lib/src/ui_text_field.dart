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
    this.onDelete,
    this.onEditingComplete,
    this.readOnly = false,
    this.clearable = false,
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
  final VoidCallback? onDelete;
  final bool readOnly;
  final bool clearable;
  final int? maxLines;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;

  @override
  State<UITextField> createState() => UITextFieldState();
}

class UITextFieldState extends State<UITextField> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  bool get hasFocus => _hasFocus;

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
    if (_text != widget.value) {
      final currentSelection = selection;
      _text = widget.value;
      if (_hasFocus) {
        selection = currentSelection;
      }
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
  
  String get _text => _textController.text;
  set _text(String value) => _textController.text = value;

  int get selection => _textController.selection.start;
  set selection(int selection) {
    final length = _text.length;
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
      setState(() {
        _hasFocus = true;
      });
      if (widget.onFocus == null) return;
      widget.onFocus!();
    } else {
      setState(() {
        _hasFocus = false;
      });
      if (widget.onBlur == null) return;
      widget.onBlur!();
    }
  }

  void _onDelete() {
    setState(() {
      _text = '';
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_text);
    }
    if (widget.onDelete != null) {
      widget.onDelete!();
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
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        suffixIcon: Visibility(
          visible: _hasFocus && widget.clearable,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IconButton(
            onPressed: _onDelete,
            padding: const EdgeInsets.all(0),
            iconSize: 20,
            icon: const Icon(Icons.close),
          ),
        ),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
    );
  }
}