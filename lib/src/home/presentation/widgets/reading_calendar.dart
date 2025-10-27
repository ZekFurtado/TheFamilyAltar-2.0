import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../domain/entities/user_streak.dart';

class ReadingCalendar extends StatelessWidget {
  const ReadingCalendar({
    super.key,
    required this.streak,
    this.onDateSelected,
  });

  final UserStreak streak;
  final Function(DateTime)? onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Reading Calendar",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          TableCalendar<DateTime>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ) ?? const TextStyle(),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.primary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildCalendarDay(context, day);
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildCalendarDay(context, day, isToday: true);
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              onDateSelected?.call(selectedDay);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(BuildContext context, DateTime day, {bool isToday = false}) {
    final isCompleted = streak.completedDates.any((date) =>
        date.year == day.year &&
        date.month == day.month &&
        date.day == day.day);

    final isMissed = day.isBefore(DateTime.now()) && !isCompleted && !isToday;

    Color? backgroundColor;
    Color? textColor;

    if (isCompleted) {
      backgroundColor = Colors.green;
      textColor = Colors.white;
    } else if (isMissed) {
      backgroundColor = Colors.red.withValues(alpha: 0.7);
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}