import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryEditEvent extends StatefulWidget {
  const DiaryEditEvent({super.key});

  @override
  State<DiaryEditEvent> createState() => _DiaryEditEventState();
}

class _DiaryEditEventState extends State<DiaryEditEvent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<DiaryEditCubit>(context); 
    final text = bloc.state.event; 
    _controller = TextEditingController(text: text);
    _controller.addListener(_changed);
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    super.dispose();
  }

  _changed() {
    context.read<DiaryEditCubit>().setEvent(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiaryEditCubit, DiaryNote>(
      listenWhen: (previous, current) =>
          previous.event != current.event &&
          current.event != _controller.text,
      listener: (context, state) {
        _controller.text = state.event;
      },
      child: TextField(controller: _controller),
    );
  }
}
