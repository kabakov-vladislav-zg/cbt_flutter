import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_note_edit_cubit.dart';
import '../../cbt_notes_overview/views/cbt_notes_overview_page.dart';
import './cbt_note_edit_emotions.dart';
import './cbt_note_edit_trigger.dart';
import './cbt_note_edit_thoughts.dart';
import '../widgets/menu_step.dart';

enum EditPage {
  trigger(title: 'триггер'),
  thoughts(title: 'мысли'),
  emotions(title: 'эмоции');

  const EditPage({
    required this.title,
  });

  final String title;
}

class CbtNoteEditPage extends StatelessWidget {
  const CbtNoteEditPage({super.key, required this.cbtNote});

  final CbtNote cbtNote;

  static const routeName = 'cbt_note_edit';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CbtNoteEditCubit>(param1: cbtNote),
      child: CbtNoteEdit(cbtNote: cbtNote),
    );
  }
}

class CbtNoteEdit extends StatefulWidget {
  const CbtNoteEdit({super.key, required this.cbtNote});

  final CbtNote cbtNote;

  @override
  State<CbtNoteEdit> createState() => _CbtNoteEditState();
}

class _CbtNoteEditState extends State<CbtNoteEdit> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final CbtNoteEditCubit _cubit;
  int _index = 0;
  late final EditStep _initialEditStep;

  @override
  void initState() {
    _tabController = TabController(
      length: EditPage.values.length,
      vsync: this,
      initialIndex: _index,
    );
    _tabController.addListener(_changed);
    _cubit = context.read<CbtNoteEditCubit>();
    _initialEditStep = _cubit.state.editStep;
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_changed);
    _tabController.dispose();
    _cubit.syncChanges();
    super.dispose();
  }

  void _changed() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _index = _tabController.index;
    });
  }
  void _next() {
    int index = _tabController.index + 1;
    if (index >= _tabController.length) {
      final editStep = _cubit.state.editStep;
      switch (editStep) {
        case EditStep.creation:
          if (_cubit.isCompleted()) {
            _cubit.setStep(EditStep.viewing);
          } else if (_cubit.isCreated()) {
            _cubit.setStep(EditStep.deconstruction);
            _tabController.index = 1;
          } else {

          }
          break;
        case EditStep.deconstruction:
          if (_cubit.isCompleted()) {
            _cubit.setStep(EditStep.viewing);
            if (_initialEditStep != EditStep.viewing) {
              context.goNamed(CbtNotesOverviewPage.routeName);
            }
          } else {

          }
          break;
        default:
          context.goNamed(CbtNotesOverviewPage.routeName);
      }
    } else {
      _tabController.index = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EditPage.values[_index].title),
        actions: const [
          MenuStep(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _next,
        child: Icon(
          _index + 1 >= EditPage.values.length
            ? Icons.check
            : Icons.keyboard_arrow_right
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CbtNoteEditTrigger(onEditingComplete: _next),
          const CbtNoteEditThoughts(),
          const CbtNoteEditEmotions(),
        ]
      ),
    );
  }
}
