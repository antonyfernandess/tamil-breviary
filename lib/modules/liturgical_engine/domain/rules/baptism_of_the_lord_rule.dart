import '../value_objects/calendar_context.dart';
import 'calendar_rule.dart';
import 'epiphany_rule.dart';

class BaptismOfTheLordRule implements CalendarRule {
  const BaptismOfTheLordRule();

  @override
  DateTime resolve(CalendarContext context) {
    final epiphany = const EpiphanyRule().resolve(context);

    if (!context.settings.transferEpiphany) {
      if (epiphany.weekday == DateTime.sunday) {
        return epiphany.add(const Duration(days: 7)); // Sunday after Epiphany
      }
      final daysUntilSunday = 7 - epiphany.weekday;
      return epiphany.add(Duration(days: daysUntilSunday));
    }

    // Epiphany was itself transferred to a Sunday (Jan 2-8) — Baptism
    // of the Lord is celebrated the very next day, Monday.
    return epiphany.add(const Duration(days: 7));
  }
}