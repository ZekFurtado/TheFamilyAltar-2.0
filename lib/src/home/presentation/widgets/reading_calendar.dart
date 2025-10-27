import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../domain/entities/user_streak.dart';

class ReadingCalendar extends StatefulWidget {
  ReadingCalendar({
    super.key,
    required this.streak,
    this.onDateSelected, this.selectedDay,
  });

  final UserStreak streak;
  DateTime? selectedDay;
  final Function(DateTime)? onDateSelected;

  @override
  State<ReadingCalendar> createState() => _ReadingCalendarState();
}

class _ReadingCalendarState extends State<ReadingCalendar> {
  DateTime? selectedDay;

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
            focusedDay: widget.selectedDay ?? DateTime.now(),
            selectedDayPredicate: (day) {
              return widget.selectedDay != null && isSameDay(widget.selectedDay!, day);
            },
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
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isSelected = widget.selectedDay != null && isSameDay(widget.selectedDay!, day);
                return _buildCalendarDay(context, day, isSelected: isSelected);
              },
              todayBuilder: (context, day, focusedDay) {
                final isSelected = widget.selectedDay != null && isSameDay(widget.selectedDay!, day);
                return _buildCalendarDay(context, day, isToday: true, isSelected: isSelected);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildCalendarDay(context, day, isSelected: true);
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                widget.selectedDay = selectedDay;
              });
              widget.onDateSelected?.call(widget.selectedDay ?? DateTime.now());
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(BuildContext context, DateTime day, {bool isToday = false, bool isSelected = false}) {
    final isCompleted = widget.streak.completedDates.any((date) =>
        date.year == day.year &&
        date.month == day.month &&
        date.day == day.day);

    // Only mark as missed if:
    // 1. Day is before today
    // 2. Not completed
    // 3. Not today
    // 4. Day is after or equal to the first app use date (don't mark dates before user started)
    final firstUseDate = widget.streak.firstAppUseDate;
    final isMissed = day.isBefore(DateTime.now()) && 
                     !isCompleted && 
                     !isToday &&
                     firstUseDate != null &&
                     day.isAfter(firstUseDate.subtract(const Duration(days: 1)));

    Color? backgroundColor;
    Color? textColor;
    Border? border;

    // Handle selection state first - it should override other states for visual feedback
    if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.secondary;
      textColor = Theme.of(context).colorScheme.onSecondary;
      border = Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 3,
      );
    } else if (isCompleted) {
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
        border: border,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: textColor,
            fontWeight: (isToday || isSelected) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}