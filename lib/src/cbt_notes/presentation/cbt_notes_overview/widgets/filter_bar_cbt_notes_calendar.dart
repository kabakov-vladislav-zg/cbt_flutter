import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../bloc/cbt_notes_overview_cubit.dart';

class FilterBarCbtNotesCalendar extends StatefulWidget {
  const FilterBarCbtNotesCalendar({super.key});

  @override
  State<FilterBarCbtNotesCalendar> createState() => _FilterBarCbtNotesCalendarState();
}

class _FilterBarCbtNotesCalendarState extends State<FilterBarCbtNotesCalendar> {
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