import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditThought extends StatefulWidget {
  const EditThought({
    super.key,
    required this.thought,
    required this.index,
    this.onEditingComplete,
  });

  final Thought thought;
  final int index;
  final VoidCallback? onEditingComplete;

  @override
  State<EditThought> createState() => _EditThoughtState();
}
class _EditThoughtState extends State<EditThought> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  final GlobalKey _fieldKey = GlobalKey<State<TextField>>();
  late final _index = widget.index;
  late final _thought = widget.thought;
  int _maxLines = 3;

  @override
  void initState() {
    super.initState();
    final text = _thought.description; 
    _textController = TextEditingController(text: text);
    _textController.addListener(_onChange);
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textController.removeListener(_onChange);
    _textController.dispose();
    super.dispose();
  }

  _onChange() {
    final text = _textController.text;
    updateDisplayedLineCount();
    final thought = _thought.copyWith(description: text);
    final cubit = context.read<DiaryEditCubit>();
    cubit.setThought(_index, thought: thought);
  }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  void updateDisplayedLineCount() {
    final text = _textController.text;
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 16)),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    final size = getRedBoxSize(_fieldKey.currentContext!);
    textPainter.layout(maxWidth: size.width);
    final metrics = textPainter.computeLineMetrics();
    setState(() {
      _maxLines = metrics.length > _maxLines ? metrics.length : _maxLines;
    });
  }

  _remove() {
    final cubit = context.read<DiaryEditCubit>();
    cubit.removeThought(_index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
          )
        ],
      ),
      child: TextField(
        key: _fieldKey,
        controller: _textController,
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        maxLines: _maxLines,
        onEditingComplete: widget.onEditingComplete,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          // suffixIcon: GestureDetector(
          //   onTap: _remove,
          //   child: const Icon(Icons.clear),
          // ),
        ),
      ),
    );
  }
}
