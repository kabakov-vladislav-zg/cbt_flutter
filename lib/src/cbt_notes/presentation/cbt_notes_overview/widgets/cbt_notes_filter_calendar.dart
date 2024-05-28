import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class CbtNotesFilterCalendar extends StatefulWidget {
  const CbtNotesFilterCalendar({super.key});

  @override
  State<CbtNotesFilterCalendar> createState() => _CbtNotesFilterCalendarState();
}

class _CbtNotesFilterCalendarState extends State<CbtNotesFilterCalendar> {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: UICalendar(
        getEventCount: (p0) async {
          await Future.delayed(const Duration(seconds: 5));
          return 5;
        },
      ),
    );
  }
}