import '../value_objects/calendar_context.dart';
import 'calendar_rule.dart';

class ChristTheKingRule implements CalendarRule {
  const ChristTheKingRule();

  @override
  DateTime resolve(CalendarContext context) {
    final christmas = DateTime(context.year, 12, 25);
    final daysSincePrecedingSunday = christmas.weekday % 7;
    final fourthAdventSunday = christmas.subtract(Duration(days: daysSincePrecedingSunday));
    final firstAdventSunday = fourthAdventSunday.subtract(const Duration(days: 21));
    return firstAdventSunday.subtract(const Duration(days: 7));
  }
}