import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/bloc/cbt_note_edit_cubit.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/views/cbt_note_edit_emotions.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/views/cbt_note_edit_trigger.dart';
import 'package:cbt_flutter/src/cbt_note_edit/presentation/views/cbt_note_edit_thoughts.dart';
import 'package:cbt_flutter/src/cbt_notes_overview/presentation/views/cbt_notes_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum CbtNoteEditSteps {
  trigger(title: 'триггер'),
  thoughts(title: 'мысли'),
  emotions(title: 'эмоции');

  const CbtNoteEditSteps({
    required this.title,
  });

  final String title;
}

class CbtNoteEditPage extends StatefulWidget {
  const CbtNoteEditPage({super.key, required this.cbtNote});

  final CbtNote cbtNote;

  static const routeName = 'cbt_note_edit';

  @override
  State<CbtNoteEditPage> createState() => _CbtNoteEditPageState();
}

class _CbtNoteEditPageState extends State<CbtNoteEditPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late CbtNoteEditSteps _step;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: CbtNoteEditSteps.values.length,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(_changed);
    _step = CbtNoteEditSteps.values[_tabController.index];
  }

  @override
  void dispose() {
    _tabController.removeListener(_changed);
    _tabController.dispose();
    super.dispose();
  }

  void _changed() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _step = CbtNoteEditSteps.values[_tabController.index];
    });
  }
  void _next() {
    int index = _tabController.index + 1;
    if (index >= _tabController.length) {
      context.goNamed(CbtNotesOverviewPage.routeName);
    } else {
      _tabController.index = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CbtNoteEditCubit>(param1: widget.cbtNote),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_step.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _next,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            CbtNoteEditTrigger(onEditingComplete: _next,),
            const CbtNoteEditThoughts(),
            const CbtNoteEditEmotions(),
          ]
        ),
      ),
    );
  }
}
