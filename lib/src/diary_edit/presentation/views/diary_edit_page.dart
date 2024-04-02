import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_emotions.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_event.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_thoughts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum DiaryEditSteps { event, thoughts, emotions }

class DiaryEditPage extends StatefulWidget {
  const DiaryEditPage({super.key, required this.note, required this.step});

  final DiaryNote note;

  final DiaryEditSteps step;

  static const routeName = '/edit';

  @override
  State<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: DiaryEditSteps.values.length,
      vsync: this,
      initialIndex: widget.step.index,
    );
    _controller.addListener(_changed);
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    super.dispose();
  }

  _changed() {
    final step = DiaryEditSteps.values[_controller.index].name;
    context.goNamed(DiaryEditPage.routeName, pathParameters: { 'step': step }, extra: widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<DiaryEditCubit>(param1: widget.note),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Шаг ${widget.step.name}'),
        ),
        body: TabBarView(
          controller: _controller,
          children: const [
            DiaryEditEvent(),
            DiaryEditThoughts(),
            DiaryEditEmotions(),
          ]
        ),
      ),
    );
  }
}
