import '../calculations/easter/easter_calculator.dart';
import '../value_objects/calendar_context.dart';
import 'calendar_rule.dart';

class CorpusChristiRule implements CalendarRule {
  const CorpusChristiRule();

  @override
  DateTime resolve(CalendarContext context) {
    final easter = EasterCalculator.forYear(context.year);
    final corpusChristiThursday = easter.add(const Duration(days: 60));
    if (!context.settings.transferCorpusChristi) return corpusChristiThursday;
    return corpusChristiThursday.add(const Duration(days: 3));
  }
}