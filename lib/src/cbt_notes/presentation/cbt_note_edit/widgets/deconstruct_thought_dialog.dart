import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/cbt_notes/presentation/cbt_note_edit/widgets/set_corruption_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_text_field_list/sliver_text_field_list.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_note_edit_cubit.dart';

class DeconstructThoughtDialog extends StatelessWidget {
  const DeconstructThoughtDialog({
    super.key,
    required this.thought,
    required this.index,
  });

  final Thought thought;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CbtNoteEditCubit>();
    return Dialog.fullscreen(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            title: Text('Деконструкция мысли'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverMainAxisGroup(
              slivers: [
                const SliverToBoxAdapter(
                  child: Text('Изначальная мысль'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: UITextField(
                      readOnly: true,
                      value: thought.description,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Text('Промежуточные мысли (необязательно)'),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 24),
                  sliver: SliverTextFieldList(
                    items: thought.intermediate,
                    onChange: (intermediate)
                      => cubit.updateThought(index, intermediate: intermediate),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Text('Когнктивное искажение'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: UITextField(
                      readOnly: true,
                      onTap: () => _dialogBuilder(context),
                      value: thought.corruption,
                      onChanged: (corruption) => cubit.updateThought(index, corruption: corruption),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Text('Рациональный ответ'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: UITextField(
                      value: thought.conclusion,
                      onChanged: (conclusion) => cubit.updateThought(index, conclusion: conclusion),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Btn(
                      onPressed: () => context.pop(),
                      text: 'готово'
                    ),
                  ),
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext innerContext) {
      return BlocProvider.value(
        value: context.watch<CbtNoteEditCubit>(),
        child: SetCorruptionDialog(),
      );
    }
  );
}