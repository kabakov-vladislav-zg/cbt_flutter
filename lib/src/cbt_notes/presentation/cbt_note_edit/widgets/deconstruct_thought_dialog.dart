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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverTextFieldList(
              items: const [],
              onChange: (list) => print(list),
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
        ]
      ),
    );
  }
}
