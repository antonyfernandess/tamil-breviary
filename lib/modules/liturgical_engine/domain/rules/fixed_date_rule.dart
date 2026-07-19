

import 'calendar_rule.dart';
import '../value_objects/calendar_context.dart';

class FixedDateRule implements CalendarRule {
  final int month;
  final int day;

  const FixedDateRule({
    required this.month, 
    required this.day
  });

  @override
  DateTime resolve(CalendarContext context) {
    return DateTime(context.year, month, day);
  }
}
