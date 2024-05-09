import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/cbt_notes_overview_bloc.dart';
import './card_cbt_note.dart';

class SliverCbtNotesOverview extends StatelessWidget {
  const SliverCbtNotesOverview({super.key});

  List<({String date, List<CbtNote> cbtNotes})> _getGroupedList(List<CbtNote> list) {
    final List<({String date, List<CbtNote> cbtNotes})> sections = [];

    final groupByDate = groupBy<CbtNote, String>(
      list,
      (cbtNote)
        => DateFormat.yMMMMd('ru_RU').format(cbtNote.timestamp),
    );
    groupByDate.forEach((date, cbtNotes)
      => sections.add((date: date, cbtNotes: cbtNotes)));

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CbtNotesOverviewBloc, CbtNotesOverviewState, List<CbtNote>>(
      selector: (state) => (state.list),
      builder: (context, list) {
        final groupedList = _getGroupedList(list);
        return SliverMainAxisGroup(
          slivers: [
            for (final group in groupedList)
              SliverMainAxisGroup(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    title: Text(group.date),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList.builder(
                      itemCount: group.cbtNotes.length,
                      itemBuilder: (context, index) {
                        return CardCbtNote(cbtNote: group.cbtNotes[index]);
                      }
                    ),
                  )
                ],
              ),
          ],
        );
      },
    );
  }
}