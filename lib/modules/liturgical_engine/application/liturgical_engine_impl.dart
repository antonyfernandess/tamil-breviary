import '../domain/calculations/season/liturgical_season_calculator.dart';
import '../domain/entities/celebration.dart';
import '../domain/entities/liturgical_day.dart';
import '../domain/entities/liturgical_year.dart';
import '../domain/enums/liturgical_color.dart';
import '../domain/enums/liturgical_rank.dart';
import '../domain/enums/liturgical_season.dart';
import '../domain/value_objects/celebration_key.dart';
import 'celebration_generator.dart';
import 'liturgical_engine.dart';

class LiturgicalEngineImpl implements LiturgicalEngine {
  final CelebrationGenerator generator;
  final Map<int, LiturgicalYear> _yearCache = {};

  LiturgicalEngineImpl({required this.generator});

  @override
  LiturgicalDay getDay(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final liturgicalYear = _yearFor(normalized.year);

    // getDay() only ever returns null if nothing was ever added for
    // that date — but _yearFor() pre-populates every named
    // celebration, so a miss here just means "plain feria/Sunday."
    return liturgicalYear.getDay(normalized) ?? _buildDefaultDay(normalized);
  }

  LiturgicalYear _yearFor(int calendarYear) {
    return _yearCache.putIfAbsent(calendarYear, () {
      final liturgicalYear = LiturgicalYear(year: calendarYear);
      for (final celebration in generator.generate(calendarYear)) {
        liturgicalYear.addDay(_dayFromCelebration(celebration));
      }
      return liturgicalYear;
    });
  }

  LiturgicalDay _dayFromCelebration(Celebration celebration) {
    return LiturgicalDay(
      date: celebration.date,
      celebration: celebration.definition.key,
      season: LiturgicalSeasonCalculator.resolve(celebration.date),
      rank: celebration.definition.rank,
      color: celebration.definition.color,
    );
  }

  LiturgicalDay _buildDefaultDay(DateTime date) {
    final season = LiturgicalSeasonCalculator.resolve(date);
    final isSunday = date.weekday == DateTime.sunday;

    return LiturgicalDay(
      date: date,
      celebration: CelebrationKey(
        isSunday ? '${season.name}_sunday' : '${season.name}_feria',
      ),
      season: season,
      rank: LiturgicalRank.feria,
      color: _defaultColorFor(season),
    );
  }

  LiturgicalColor _defaultColorFor(LiturgicalSeason season) {
    switch (season) {
      case LiturgicalSeason.advent:
      case LiturgicalSeason.lent:
        return LiturgicalColor.violet;
      case LiturgicalSeason.christmas:
      case LiturgicalSeason.easter:
        return LiturgicalColor.white;
      case LiturgicalSeason.sacredTriduum:
        return LiturgicalColor.red;
      case LiturgicalSeason.ordinaryTime:
        return LiturgicalColor.green;
    }
  }
}