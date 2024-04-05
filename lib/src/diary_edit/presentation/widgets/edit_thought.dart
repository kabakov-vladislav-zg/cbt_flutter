import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditThought extends StatefulWidget {
  const EditThought({
    super.key,
    required this.thought,
    required this.index,
    required this.onEditingComplete,
  });

  final Thought thought;
  final int index;
  final VoidCallback onEditingComplete;

  @override
  State<EditThought> createState() => _EditThoughtState();
}
class _EditThoughtState extends State<EditThought> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  final GlobalKey _fieldKey = GlobalKey<State<TextField>>();
  late final _index = widget.index;
  late Thought _thought;
  late final DiaryEditCubit _cubit;

  @override
  void initState() {
    super.initState();
    _thought = widget.thought;
    final text = _thought.description; 
    _textController = TextEditingController(text: text);
    _textController.addListener(_onChange);
    _focusNode = FocusNode();
    _cubit = context.read<DiaryEditCubit>();
    if (text.trim().isEmpty) _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textController.removeListener(_onChange);
    _textController.dispose();
    super.dispose();
  }

  void _onChange() {
    final text = _textController.text;
    final thought = _thought.copyWith(description: text);
    _cubit.setThought(_index, thought: thought);
  }

  void _remove() {
    _cubit.removeThought(_index);
  }

  void _onEditingComplete() {
    if(_textController.text.isEmpty) return;
    widget.onEditingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.backspace): () {
            if(_textController.text.trim().isEmpty) _remove();
          },
        },
        child: TextField(
          key: _fieldKey,
          focusNode: _focusNode,
          controller: _textController,
          keyboardType: TextInputType.text,
          maxLines: null,
          onEditingComplete: _onEditingComplete,
          decoration: InputDecoration(
            suffix: GestureDetector(
              onTap: _remove,
              child: const Icon(Icons.delete_outlined),
            ),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
