import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryEditTrigger extends StatefulWidget {
  const DiaryEditTrigger({super.key, this.onEditingComplete});

  final VoidCallback? onEditingComplete;

  @override
  State<DiaryEditTrigger> createState() => _DiaryEditTriggerState();
}

class _DiaryEditTriggerState extends State<DiaryEditTrigger> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<DiaryEditCubit>(context); 
    final text = bloc.state.trigger;
    _controller = TextEditingController(text: text);
    _controller.addListener(_changed);
  }


  @override
  void dispose() {
    _controller.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    context.read<DiaryEditCubit>().setEvent(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryEditCubit, DiaryNote>(
      listenWhen: (previous, current) =>
          previous.trigger != current.trigger &&
          current.trigger != _controller.text,
      listener: (context, state) {
        _controller.text = state.trigger;
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: TextField(
                controller: _controller,
                onEditingComplete: widget.onEditingComplete,
                keyboardType: TextInputType.text,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  isCollapsed: true,
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  hintText: 'Опишите произошедшее событие',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade400
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
