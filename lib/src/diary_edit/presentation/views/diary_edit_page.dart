import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/diary_note.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_emotions.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_trigger.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/views/diary_edit_thoughts.dart';
import 'package:cbt_flutter/src/diary_overview/presentation/views/diary_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum DiaryEditSteps { trigger, thoughts, emotions }

class DiaryEditPage extends StatefulWidget {
  const DiaryEditPage({super.key, required this.note, required this.step});

  final DiaryNote note;

  final DiaryEditSteps step;

  static const routeName = '/edit';

  @override
  State<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: DiaryEditSteps.values.length,
      vsync: this,
      initialIndex: widget.step.index,
    );
    _tabController.addListener(_changed);
  }

  @override
  void dispose() {
    _tabController.removeListener(_changed);
    _tabController.dispose();
    super.dispose();
  }

  void _changed() {
    FocusScope.of(context).requestFocus(FocusNode());
    final step = DiaryEditSteps.values[_tabController.index].name;
    context.goNamed(DiaryEditPage.routeName, pathParameters: { 'step': step }, extra: widget.note);
  }
  void _next() {
    int index = _tabController.index + 1;
    if (index >= _tabController.length) {
      context.goNamed(DiaryOverviewPage.routeName);
    } else {
      _tabController.index = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<DiaryEditCubit>(param1: widget.note),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Шаг ${widget.step.name}'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _next,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DiaryEditTrigger(onEditingComplete: _next,),
            const DiaryEditThoughts(),
            const DiaryEditEmotions(),
          ]
        ),
      ),
    );
  }
}