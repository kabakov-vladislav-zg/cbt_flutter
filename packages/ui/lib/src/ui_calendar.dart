import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ui/src/utils/dispenser.dart';

part 'ui_calendar_day.dart';

class UICalendar extends StatefulWidget {
  const UICalendar({
    super.key,
    required this.getEventCount,
  });

  final Future<int> Function(DateTime) getEventCount;

  @override
  State<UICalendar> createState() => _UICalendarState();
}

class _UICalendarState extends State<UICalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final _currentDay = DateTime.now();
  late DateTime _lastSelectedDay = _currentDay;
  late DateTime _selectedDay = _currentDay;
  late DateTime _focusedDay = _currentDay;
  late final _getEventCount = Dispenser<int, DateTime>(widget.getEventCount, isSameDay);

  Widget? _dayBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    return UICalendarDay(
      day: day,
      selectedDay: _selectedDay,
      currentDay: _currentDay,
      getEventCount: _getEventCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.fromMicrosecondsSinceEpoch(0),
      lastDay: DateTime.now(),
      locale: 'ru-RU',
      startingDayOfWeek: StartingDayOfWeek.monday,
      rangeSelectionMode: RangeSelectionMode.disabled,
      availableCalendarFormats: const {
        CalendarFormat.week : 'неделя',
        CalendarFormat.twoWeeks: '2 недели',
        CalendarFormat.month: 'месяц',
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onDaySelected: (day, focusedDay) {
        _lastSelectedDay = day;
        _getEventCount(day).then((value) {
          if (!isSameDay(day, _lastSelectedDay)) return;
          if (isSameDay(day, _selectedDay)) return;
          if (value > 0) {
            setState(() {
              _selectedDay = day;
              _focusedDay = day;
            });
          }
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      focusedDay: _focusedDay,
      currentDay: _currentDay,
      calendarBuilders: CalendarBuilders(
        todayBuilder: _dayBuilder,
        defaultBuilder: _dayBuilder,
        outsideBuilder: _dayBuilder,
      ),
    );
  }
}