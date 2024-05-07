import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UITextField extends StatefulWidget {
  const UITextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.value,
    this.expands = false,
    this.autofocus = false,
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.onTap,
    this.onTapOutside,
    this.onBackspace,
    this.onDelete,
    this.onEditingComplete,
    this.readOnly = false,
    this.clearable = false,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? value;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final VoidCallback? onTap;
  final void Function(String)? onFocus;
  final void Function(String)? onBlur;
  final VoidCallback? onTapOutside;
  final VoidCallback? onBackspace;
  final VoidCallback? onDelete;
  final bool readOnly;
  final bool clearable;
  final int? maxLines;
  final bool expands;
  final bool autofocus;
  final String? hintText;
  final TextInputType? keyboardType;

  @override
  State<UITextField> createState() => UITextFieldState();
}

class UITextFieldState extends State<UITextField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  bool get hasFocus => _hasFocus;
  void requestFocus() => _focusNode.requestFocus();

  late final TextEditingController _textController;
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

  @override
  void initState() {
    _textController = widget.controller ?? TextEditingController();
    if (widget.value != null) {
      _textController.text = widget.value!;
    }

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
    if (widget.onBackspace != null) {
      _focusNode.onKeyEvent = _onBackspace;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UITextField oldWidget) {
    if (widget.value != null && widget.value != _text) {
      final currentSelection = selection;
      _text = widget.value!;
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
      widget.onFocus?.call(_text);
    } else {
      setState(() {
        _hasFocus = false;
      });
      widget.onBlur?.call(_text);
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

  void _onTapOutside(PointerDownEvent e) {
    _focusNode.unfocus();
    widget.onTapOutside?.call();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      onTapOutside: _onTapOutside,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      expands: widget.expands,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        isCollapsed: true,
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
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}