import '../domain/definitions/liturgical_calendar.dart';
import '../domain/entities/celebration.dart';
import '../domain/definitions/celebration_definition.dart';
import '../domain/value_objects/calendar_context.dart';

/// Resolves every [CelebrationDefinition] across one or more
/// [LiturgicalCalendar]s into concrete, dated [Celebration]s for a
/// given year. When two celebrations fall on the same date, the
/// higher-ranking one wins (lower enum index = higher rank, matching
/// the order declared in LiturgicalRank: solemnity beats feast beats
/// memorial, and so on).
class CelebrationGenerator {
  final List<LiturgicalCalendar> calendars;

  CelebrationGenerator({required this.calendars});

  List<Celebration> generate(int year) {
    final context = CalendarContext(year: year);
    final byDate = <DateTime, Celebration>{};

    for (final calendar in calendars) {
      for (final definition in calendar.celebrationsForYear(year)) {
        final date = _normalize(definition.rule.resolve(context));
        final candidate = Celebration(definition: definition, date: date);

        final existing = byDate[date];
        if (existing == null || _outranks(candidate.definition, existing.definition)) {
          byDate[date] = candidate;
        }
      }
    }

    final celebrations = byDate.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return celebrations;
  }

  bool _outranks(CelebrationDefinition a, CelebrationDefinition b) {
    return a.rank.index < b.rank.index;
  }

  DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);
}