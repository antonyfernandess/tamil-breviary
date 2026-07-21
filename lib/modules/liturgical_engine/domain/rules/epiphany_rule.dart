import '../value_objects/calendar_context.dart';
import 'calendar_rule.dart';

class EpiphanyRule implements CalendarRule {
  const EpiphanyRule();

  @override
  DateTime resolve(CalendarContext context) {
    if (!context.settings.transferEpiphany) {
      return DateTime(context.year, 1, 6);
    }
    for (int day = 2; day <= 8; day++) {
      final date = DateTime(context.year, 1, day);
      if (date.weekday == DateTime.sunday) return date;
    }
    throw StateError('Unable to calculate Epiphany.'); // This should never happen, as there is always a Sunday between January 2 and January 8.
  }
}