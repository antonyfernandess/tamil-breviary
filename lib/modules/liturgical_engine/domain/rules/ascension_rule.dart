import '../calculations/easter/easter_calculator.dart';
import '../value_objects/calendar_context.dart';
import 'calendar_rule.dart';

class AscensionRule implements CalendarRule {
  const AscensionRule();

  @override
  DateTime resolve(CalendarContext context) {
    final easter = EasterCalculator.forYear(context.year);
    final ascensionThursday = easter.add(const Duration(days: 39));
    if (!context.settings.transferAscension) return ascensionThursday;
    return ascensionThursday.add(const Duration(days: 3)); // nearest Sunday
  }
}