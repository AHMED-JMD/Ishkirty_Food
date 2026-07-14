import 'package:flutter/material.dart';

class DateFilterMenuButton extends StatelessWidget {
  final Icon icon;
  final String tooltip;
  final DateTime baseDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String weekLabel;
  final String monthLabel;
  final String dayLabel;
  final String pickDayLabel;
  final String rangeLabel;
  final void Function(DateTime start, DateTime end)? onWeek;
  final void Function(DateTime start, DateTime end)? onMonth;
  final void Function(DateTime start, DateTime end)? onDay;
  final void Function(DateTime day)? onPickDay;
  final void Function(DateTime start, DateTime end)? onRange;

  DateFilterMenuButton({
    super.key,
    required this.icon,
    this.tooltip = 'تصفية',
    DateTime? baseDate,
    DateTime? firstDate,
    DateTime? lastDate,
    this.weekLabel = 'الإسبوع',
    this.monthLabel = 'الشهر',
    this.dayLabel = 'اليوم',
    this.pickDayLabel = 'تحديد يوم',
    this.rangeLabel = 'تحديد فترة',
    this.onWeek,
    this.onMonth,
    this.onDay,
    this.onPickDay,
    this.onRange,
  })  : baseDate = baseDate ?? DateTime.now(),
        firstDate = firstDate ?? DateTime(2000, 1, 1),
        lastDate = lastDate ?? DateTime(2100, 1, 1);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: icon,
      tooltip: tooltip,
      onSelected: (_) {},
      itemBuilder: (BuildContext context) {
        final items = <PopupMenuEntry<String>>[];

        if (onWeek != null) {
          items.add(
            PopupMenuItem(
              value: 'week',
              onTap: () {
                final start = baseDate.subtract(const Duration(days: 7));
                onWeek?.call(start, baseDate);
              },
              child: Text(
                weekLabel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        if (onMonth != null) {
          items.add(
            PopupMenuItem(
              value: 'month',
              onTap: () {
                final start = baseDate.subtract(const Duration(days: 30));
                onMonth?.call(start, baseDate);
              },
              child: Text(
                monthLabel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        if (onDay != null) {
          items.add(
            PopupMenuItem(
              value: 'day',
              onTap: () {
                onDay?.call(baseDate, baseDate);
              },
              child: Text(
                dayLabel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        if (onPickDay != null) {
          items.add(
            PopupMenuItem(
              value: 'pick_day',
              onTap: () {
                Future.delayed(Duration.zero, () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: baseDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                  );
                  if (d != null) {
                    onPickDay?.call(d);
                  }
                });
              },
              child: Text(
                pickDayLabel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        if (onRange != null) {
          items.add(
            PopupMenuItem(
              value: 'range',
              onTap: () {
                Future.delayed(Duration.zero, () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    initialDateRange:
                        DateTimeRange(start: baseDate, end: baseDate),
                  );
                  if (range != null) {
                    onRange?.call(range.start, range.end);
                  }
                });
              },
              child: Text(
                rangeLabel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        return items;
      },
    );
  }
}
