part of 'ui_calendar.dart';

enum DayType {
  today,
  normal,
  outside,
  selected,
}

class UICalendarDay extends StatelessWidget {
  const UICalendarDay({
    super.key,
    required this.day,
    required this.dayType,
    required this.getEventCount,
  });

  final DateTime day;
  final DayType dayType;
  final Future<int> Function(DateTime) getEventCount;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    Color background = Colors.transparent;
    FontWeight fontWeight = FontWeight.normal;
    switch (dayType) {
      case DayType.today:
        fontWeight = FontWeight.bold;
        break;
      case DayType.outside:
        color = Colors.grey;
        break;
      case DayType.selected:
        color = Colors.white;
        background = Colors.blue;
        break;
      default:
    }
    return Stack(
      children: [
        Center(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: background,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ),
        ),
        FutureBuilder<int>(
          future: getEventCount(day),
          builder: (context, snapshot) {
            if (
              !snapshot.hasData
              || snapshot.data == 0
            ) return const SizedBox();
            return Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: Text(
                  snapshot.data.toString(),
                  style: const TextStyle(fontSize: 12),
                )
              ),
            );
          },
        ),
      ],
    );
  }
}