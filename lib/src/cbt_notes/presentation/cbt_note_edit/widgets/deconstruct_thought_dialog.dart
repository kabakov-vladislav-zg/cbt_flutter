import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/src/cbt_notes/presentation/cbt_note_edit/utils/debounce.dart';
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
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: CustomScrollView(slivers: [
        const SliverAppBar(
          floating: true,
          title: Text('Деконструкция мысли'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: BlocBuilder<CbtNoteEditCubit, CbtNoteEditState>(
            builder: (context, state) {
              final update = context
                .read<CbtNoteEditCubit>()
                .updateThought;
              final thought = state.cbtNote.thoughts[index];
              return SliverMainAxisGroup(slivers: [
                const SliverToBoxAdapter(
                  child: Text('Изначальная мысль'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: UITextField(
                      readOnly: state.editStep != EditStep.edit,
                      maxLines: null,
                      value: thought.description,
                      onChanged: (value) {
                        debounce(() {
                          update(index, description: value);
                        }, debounced: true);
                      },
                      onBlur: (value) {
                        debounce(() {
                          update(index, description: value);
                        });
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Text('Промежуточные мысли (необязательно)'),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 24),
                  sliver: SliverTextFieldList(
                    value: thought.intermediate,
                    onChanged: (value) {
                      debounce(() {
                        update(index, intermediate: value);
                      }, debounced: true);
                    },
                    onChangeEnd: (value) {
                      debounce(() {
                        update(index, intermediate: value);
                      });
                    },
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
                      maxLines: null,
                      onTap: () => _dialogBuilder(context, index),
                      value: thought.corruption,
                      onChanged: (value) =>
                        update(index, corruption: value),
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
                      maxLines: null,
                      onChanged: (value) {
                        debounce(() {
                          update(index, conclusion: value);
                        }, debounced: true);
                      },
                      onBlur: (value) {
                        debounce(() {
                          update(index, conclusion: value);
                        });
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Btn(onPressed: () => context.pop(), text: 'готово'),
                  ),
                ),
              ]);
            },
          ),
        ),
      ]),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context, int index) {
  final updateThought = context.read<CbtNoteEditCubit>().updateThought;
  return showDialog(
    context: context,
    builder: (BuildContext innerContext) {
      return SetCorruptionDialog(
        onSelect: (corruption) {
          updateThought(
            index,
            corruption: corruption,
          );
          innerContext.pop();
        },
      );
    },
  );
}
