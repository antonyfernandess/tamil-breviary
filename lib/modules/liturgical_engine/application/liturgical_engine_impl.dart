import '../domain/calculations/season/liturgical_season_calculator.dart';
import '../domain/calculations/season/privileged_day_calculator.dart';
import '../domain/entities/liturgical_day.dart';
import '../domain/entities/liturgical_year.dart';
import '../domain/entities/optional_memorial.dart';
import '../domain/enums/liturgical_color.dart';
import '../domain/enums/liturgical_rank.dart';
import '../domain/enums/liturgical_season.dart';
import '../domain/value_objects/calendar_settings.dart';
import '../domain/value_objects/celebration_key.dart';
import 'celebration_generator.dart';
import 'liturgical_engine.dart';
import 'resolved_celebrations.dart';


/// Implementation of the LiturgicalEngine interface, 
/// responsible for generating and managing the liturgical calendar based on 
/// the provided celebration generator and calendar settings.
class LiturgicalEngineImpl implements LiturgicalEngine {
  final CelebrationGenerator generator;
  final Map<int, LiturgicalYear> _yearCache = {};
  final CalendarSettings settings;

  // Solemnities that ARE a privileged day themselves — they must
  // never be "transferred away" from their own date.
  static const _neverTransferKeys = {
    'christmas',
    'nativity_of_the_lord',
    'ash_wednesday',
    'palm_sunday',
    'holy_thursday',
    'good_friday',
    'easter_sunday',
    'ascension',
    'pentecost',
    'epiphany',
  };

  LiturgicalEngineImpl({
    required this.generator,
    this.settings = CalendarSettings.roman,
  });

  /// Retrieves the liturgical day for a given date, normalizing the date to ensure consistency.
  @override
  LiturgicalDay getDay(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final liturgicalYear = getYear(normalized.year);
    return liturgicalYear.getDay(normalized)!;
  }
  /// Retrieves the liturgical year for a given year, generating it if not already cached.
  @override
  LiturgicalYear getYear(int year) {
    return _yearCache.putIfAbsent(year, () => _generateYear(year));
  }
  /// Generates the liturgical year for a given year, applying precedence rules to resolve celebrations.
  LiturgicalYear _generateYear(int year) {
    final liturgicalYear = LiturgicalYear(year: year);
    final resolvedByDate = _applyPrecedenceRules(generator.generate(year));

    final startOfYear = DateTime(year, 1, 1);
    final startOfNextYear = DateTime(year + 1, 1, 1);
    final totalDays = startOfNextYear.difference(startOfYear).inDays;

    for (var i = 0; i < totalDays; i++) {
      final date = startOfYear.add(Duration(days: i));
      liturgicalYear.addDay(_buildDay(date, resolvedByDate[_normalize(date)]));
    }

    return liturgicalYear;
  }
  /// Applies precedence rules to a list of resolved celebrations, determining which celebrations take precedence on each date.
  Map<DateTime, ResolvedCelebrations> _applyPrecedenceRules(List<ResolvedCelebrations> resolved) {
    final byDate = <DateTime, ResolvedCelebrations>{};
    final sorted = [...resolved]..sort((a, b) => a.date.compareTo(b.date));

    for (final entry in sorted) {
      var targetDate = _normalize(entry.date);
      final primary = entry.primary;
      final isPrivileged = PrivilegedDayCalculator.isPrivileged(targetDate);
      final season = LiturgicalSeasonCalculator.resolve(targetDate);
      final isLentWeekday =
          season == LiturgicalSeason.lent && targetDate.weekday != DateTime.sunday && !isPrivileged;

      if (primary != null) {
        final isSelfDefining = _neverTransferKeys.contains(primary.key.value);

        if (isPrivileged && !isSelfDefining) {
          if (primary.rank == LiturgicalRank.solemnity) {
            targetDate = _nearestFreeDay(targetDate, byDate);
            byDate[targetDate] = ResolvedCelebrations(date: targetDate, primary: primary);
          }
          continue;
        }

        // GNLY 16: obligatory memorials on Lent weekdays are reduced
        // to optional — the Lenten weekday stays primary, the saint
        // is only offered as an "or" commemoration.
        if (isLentWeekday && primary.rank == LiturgicalRank.memorial) {
          byDate[targetDate] = ResolvedCelebrations(
            date: targetDate,
            primary: null,
            optionalMemorials: [primary, ...entry.optionalMemorials],
          );
          continue;
        }

        byDate[targetDate] = ResolvedCelebrations(date: targetDate, primary: primary);
        continue;
      }

      if (!isPrivileged && entry.optionalMemorials.isNotEmpty) {
        byDate[targetDate] = entry;
      }
    }

    return byDate;
  }

  /// Finds the nearest free day after a blocked date, skipping privileged days and already placed celebrations.
  DateTime _nearestFreeDay(DateTime blockedDate, Map<DateTime, ResolvedCelebrations> alreadyPlaced) {
    var candidate = blockedDate.add(const Duration(days: 1));
    while (PrivilegedDayCalculator.isPrivileged(candidate) || alreadyPlaced.containsKey(candidate)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  /// Builds a liturgical day for a given date and resolved celebrations.
  LiturgicalDay _buildDay(DateTime date, ResolvedCelebrations? resolved) {
    final season = LiturgicalSeasonCalculator.resolve(date);

    if (resolved?.primary != null) {
      final primary = resolved!.primary!;
      return LiturgicalDay(
        date: date,
        celebration: primary.key,
        season: season,
        rank: primary.rank,
        color: primary.color,
      );
    }

    final isSunday = date.weekday == DateTime.sunday;
    final optionalMemorials = (resolved?.optionalMemorials ?? const [])
        .map((def) => OptionalMemorial(key: def.key, color: def.color))
        .toList();

    return LiturgicalDay(
      date: date,
      celebration: CelebrationKey(isSunday ? '${season.name}_sunday' : '${season.name}_feria'),
      season: season,
      rank: LiturgicalRank.feria,
      color: _defaultColorFor(season),
      optionalMemorials: optionalMemorials,
    );
  }
  /// Determines the default liturgical color for a given season.
  LiturgicalColor _defaultColorFor(LiturgicalSeason season) {
    switch (season) {
      case LiturgicalSeason.advent:
        return LiturgicalColor.violet;
      case LiturgicalSeason.lent:
        return LiturgicalColor.violet;
      case LiturgicalSeason.christmas:
        return LiturgicalColor.white;
      case LiturgicalSeason.easter:
        return LiturgicalColor.white;
      case LiturgicalSeason.sacredTriduum:
        return LiturgicalColor.red;
      case LiturgicalSeason.ordinaryTime:
        return LiturgicalColor.green;
    }
  }
  /// Normalizes a date to remove time components, ensuring consistency in date comparisons.
  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
