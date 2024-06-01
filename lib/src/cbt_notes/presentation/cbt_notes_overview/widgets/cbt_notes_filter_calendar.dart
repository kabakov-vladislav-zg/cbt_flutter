import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_notes_overview_cubit.dart';

class CbtNotesFilterCalendar extends StatefulWidget {
  const CbtNotesFilterCalendar({super.key});

  @override
  State<CbtNotesFilterCalendar> createState() => _CbtNotesFilterCalendarState();
}

class _CbtNotesFilterCalendarState extends State<CbtNotesFilterCalendar> {
  void _onDaySelected(DateTime day) {
    context
      .read<CbtNotesOverviewCubit>()
      .setCalendarFilter(day);
  }
  Future<int> _count(DateTime day) async {
    return context
      .read<CbtNotesOverviewCubit>()
      .countCalendarFilter(day);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: UICalendar(
        onDaySelected: _onDaySelected,
        getEventCount: _count,
      ),
    );
  }
}