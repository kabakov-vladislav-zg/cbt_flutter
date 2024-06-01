import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ui/src/utils/dispenser.dart';

part 'ui_calendar_day.dart';

class UICalendar extends StatefulWidget {
  const UICalendar({
    super.key,
    required this.getEventCount,
    this.onDaySelected,
  });

  final Future<int> Function(DateTime) getEventCount;
  final ValueChanged<DateTime>? onDaySelected;

  @override
  State<UICalendar> createState() => _UICalendarState();
}

class _UICalendarState extends State<UICalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final _currentDay = DateTime.now();
  final _firstDay = DateTime.fromMicrosecondsSinceEpoch(0);
  late DateTime _selectedDay = _currentDay;
  late DateTime _focusedDay = _currentDay;
  late final _lastDay = _currentDay;
  late final _getEventCount
    = Dispenser<int, DateTime>(widget.getEventCount, isSameDay).call;
  late final _calendarBuilders = CalendarBuilders(
      todayBuilder: (_, day, focusDay)
        => UICalendarDay(dayType: DayType.today, day: day, getEventCount: _getEventCount),
      defaultBuilder: (_, day, focusDay)
        => UICalendarDay(dayType: DayType.normal, day: day, getEventCount: _getEventCount),
      outsideBuilder: (_, day, focusDay)
        => UICalendarDay(dayType: DayType.outside, day: day, getEventCount: _getEventCount),
      selectedBuilder: (_, day, focusDay)
        => UICalendarDay(dayType: DayType.selected, day: day, getEventCount: _getEventCount),
    );
    
  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _selectedDay = day;
      _focusedDay = day;
    });
    widget.onDaySelected?.call(day);
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: _firstDay,
      lastDay: _lastDay,
      locale: 'ru-RU',
      startingDayOfWeek: StartingDayOfWeek.monday,
      rangeSelectionMode: RangeSelectionMode.disabled,
      availableCalendarFormats: const {
        CalendarFormat.week: 'неделя',
        CalendarFormat.twoWeeks: '2 недели',
        CalendarFormat.month: 'месяц',
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: _onFormatChanged,
      onDaySelected: _onDaySelected,
      onPageChanged: _onPageChanged,
      selectedDayPredicate: (day)
        => isSameDay(day, _selectedDay),
      focusedDay: _focusedDay,
      currentDay: _currentDay,
      calendarBuilders: _calendarBuilders,
    );
  }
}