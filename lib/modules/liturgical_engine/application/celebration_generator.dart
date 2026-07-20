import 'package:catholic/modules/liturgical_engine/application/services/liturgical_precedence.dart';
import '../domain/definitions/celebration_definition.dart';
import '../domain/definitions/liturgical_calendar.dart';
import '../domain/entities/celebration.dart';
import '../domain/enums/liturgical_rank.dart';
import '../domain/value_objects/calendar_context.dart';
import '../domain/value_objects/calendar_settings.dart';
import 'resolved_celebrations.dart';

/// Generates concrete [Celebration] instances for a given liturgical year.
///
/// Every registered [LiturgicalCalendar] contributes its
/// [CelebrationDefinition]s.
///
/// When multiple celebrations fall on the same day they are ordered by
/// liturgical precedence (highest rank first). The generator preserves every
/// celebration; later layers decide which one becomes the primary celebration
/// and which become commemorations.
class CelebrationGenerator {
  final List<LiturgicalCalendar> calendars;
  final LiturgicalPrecedence precedence;
  final CalendarSettings settings;

  const CelebrationGenerator({
    required this.calendars,
    required this.precedence,
    this.settings = CalendarSettings.roman,
  });

  List<ResolvedCelebrations> generate(int year) {
    final context = CalendarContext(year: year, settings: settings);
    final byDate = <DateTime, List<CelebrationDefinition>>{};

    for (final calendar in calendars) {
      for (final definition in calendar.celebrationsForYear(year)) {
        final date = _normalize(definition.rule.resolve(context));
        byDate.putIfAbsent(date, () => []).add(definition);
      }
    }

    return byDate.entries.map((entry) {
      final definitions = entry.value;
      final obligatory =
          definitions
              .where((d) => d.rank != LiturgicalRank.optionalMemorial)
              .toList()
            ..sort(precedence.compare);

      if (obligatory.isNotEmpty) {
        return ResolvedCelebrations(date: entry.key, primary: obligatory.first);
      }

      final optionals = definitions
          .where((d) => d.rank == LiturgicalRank.optionalMemorial)
          .toList();
      return ResolvedCelebrations(
        date: entry.key,
        primary: null,
        optionalMemorials: optionals,
      );
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
