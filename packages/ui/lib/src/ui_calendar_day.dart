part of 'ui_calendar.dart';

class UICalendarDay extends StatelessWidget {
  const UICalendarDay({
    super.key,
    required this.day,
    required this.selectedDay,
    required this.currentDay,
    required this.getEventCount,
  });

  final DateTime day;
  final DateTime selectedDay;
  final DateTime currentDay;
  final Future<int> Function(DateTime) getEventCount;

  @override
  Widget build(BuildContext context) {
    final isSelected = isSameDay(selectedDay, day);
    final isCurrent = isSameDay(currentDay, day);
    return Stack(
      children: [
        Center(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        FutureBuilder<int>(
          future: getEventCount(day),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            return Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: Text(
                  snapshot.data.toString(),
                  style: TextStyle(fontSize: 12),
                )
              ),
            );
          },
        ),
      ],
    );
  }
}