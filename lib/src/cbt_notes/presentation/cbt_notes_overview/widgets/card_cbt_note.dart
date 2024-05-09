import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/utils/emotions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';
import 'package:intl/intl.dart';

import '../../cbt_note_edit/views/cbt_note_edit_page.dart';

class CardCbtNote extends StatelessWidget {
  CardCbtNote({
    super.key,
    required this.cbtNote,
  });

  final CbtNote cbtNote;

  final _emotionsMap = getIt.get<Emotions>().map;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final String label;
    if (cbtNote.isCompleted) {
      backgroundColor = Colors.green;
      label = 'проработано';
    } else if (cbtNote.isCreated) {
      backgroundColor = Colors.orange;
      label = 'непроработано';
    } else {
      backgroundColor = Colors.grey;
      label = 'черновик';
    }
    final badge = Badge(
      backgroundColor: backgroundColor,
      label: Text(label),
    );
    final emotions = cbtNote.emotions.map((emotion) {
      final emotionDesc = _emotionsMap[emotion.name]!;
      return Badge(
        backgroundColor: emotionDesc.color,
        label: Text(emotionDesc.name),
      );
    }).toList();
    return UICard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(DateFormat.Hm().format(cbtNote.timestamp)),
              badge
            ],
          ),
          const Gap(4),
          Text(cbtNote.trigger),
          const Gap(12),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            clipBehavior: Clip.hardEdge,
            children: emotions,
          )
        ],
      ),
      onTap: () {
        context.goNamed(
          CbtNoteEditPage.routeName,
          extra: cbtNote,
        );
      },
    );
  }
}