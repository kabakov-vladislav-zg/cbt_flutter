import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cbt_note_edit_cubit.dart';

class SetCorruptionDialog extends StatelessWidget {
  const SetCorruptionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Dialog.fullscreen(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            title: Text('Когнктивное искажение'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverMainAxisGroup(
              slivers: [

              ]
            ),
          ) 
        ]
      ),
    );
  }
}