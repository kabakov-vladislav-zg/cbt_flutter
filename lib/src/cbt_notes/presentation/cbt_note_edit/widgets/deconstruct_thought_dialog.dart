import 'package:cbt_flutter/core/common/buttons/btn.dart';
import 'package:cbt_flutter/core/common/form/sliver_text_field_list.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_note_edit_cubit.dart';

class DeconstructThoughtDialog extends StatefulWidget {
  const DeconstructThoughtDialog({
    super.key,
    required this.thought,
    required this.index,
  });

  final Thought thought;
  final int index;

  @override
  State<DeconstructThoughtDialog> createState() => _DeconstructThoughtDialogState();
}
class _DeconstructThoughtDialogState extends State<DeconstructThoughtDialog> {
  late final Thought _thought = widget.thought;
  late final int _index = widget.index;
  late final CbtNoteEditCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<CbtNoteEditCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: _thought.description),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Text('Промежуточные мысли (необязательно)'),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 24),
                  sliver: SliverTextFieldList(
                    items: _thought.intermediate,
                    onChange: (intermediate)
                      => _cubit.updateThought(_index, intermediate: intermediate),
                    itemBuilder: (SliverTextFieldListBuilderParams params) {
                      return TextField(
                        controller: params.textController,
                        focusNode: params.focusNode,
                        onEditingComplete: params.onEditingComplete,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                      );
                    }
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Text('Когнктивное искажение'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: TextField(
                      controller: TextEditingController(text: _thought.corruption),
                      onChanged: (corruption) => _cubit.updateThought(_index, corruption: corruption),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Text('Рациональный ответ'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: TextField(
                      controller: TextEditingController(text: _thought.conclusion),
                      onChanged: (conclusion) => _cubit.updateThought(_index, conclusion: conclusion),
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
