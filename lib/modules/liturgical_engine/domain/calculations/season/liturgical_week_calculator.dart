import '../../enums/liturgical_season.dart';
import '../easter/easter_calculator.dart';
import 'liturgical_season_calculator.dart';

/// Computes the week number within a season, matching the Missal's
/// labels ("3rd Week of Lent," "Week 17 in Ordinary Time"). Only
/// meaningful for Advent, Lent, Easter, and Ordinary Time — the
/// Triduum and Christmas season aren't numbered this way.
///
/// Ordinary Time's numbering is the genuinely irregular one: it runs
/// in two disconnected blocks (before Lent and after Pentecost), and
/// the second block is counted BACKWARD from Christ the King, always
/// week 34, since the number of weeks before Lent varies by year
/// depending on when Easter falls.
class LiturgicalWeekCalculator {
  static int? weekOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    switch (LiturgicalSeasonCalculator.resolve(d)) {
      case LiturgicalSeason.advent:
        return _adventWeek(d);
      case LiturgicalSeason.lent:
        return _lentWeek(d);
      case LiturgicalSeason.easter:
        return _easterWeek(d);
      case LiturgicalSeason.ordinaryTime:
        return _ordinaryTimeWeek(d);
      case LiturgicalSeason.christmas:
      case LiturgicalSeason.sacredTriduum:
        return null;
    }
  }

  static DateTime _mostRecentSunday(DateTime d) => d.subtract(Duration(days: d.weekday % 7));

  static int _adventWeek(DateTime d) {
    final adventStart = _firstAdventSunday(d.year);
    final sunday = _mostRecentSunday(d);
    return 1 + (sunday.difference(adventStart).inDays ~/ 7);
  }

  static int _lentWeek(DateTime d) {
    final easter = EasterCalculator.forYear(d.year);
    final ashWednesday = easter.subtract(const Duration(days: 46));
    var firstSundayOfLent = ashWednesday;
    while (firstSundayOfLent.weekday != DateTime.sunday) {
      firstSundayOfLent = firstSundayOfLent.add(const Duration(days: 1));
    }
    if (d.isBefore(firstSundayOfLent)) return 1; // Ash Wed through the Saturday before 1st Sunday of Lent
    final sunday = _mostRecentSunday(d);
    return 1 + (sunday.difference(firstSundayOfLent).inDays ~/ 7);
  }

  static int _easterWeek(DateTime d) {
    final easter = EasterCalculator.forYear(d.year);
    final sunday = _mostRecentSunday(d);
    return 1 + (sunday.difference(easter).inDays ~/ 7);
  }

  static int _ordinaryTimeWeek(DateTime d) {
    final easter = EasterCalculator.forYear(d.year);
    final baptism = _baptismOfTheLord(d.year);
    final ashWednesday = easter.subtract(const Duration(days: 46));
    final adventStart = _firstAdventSunday(d.year);
    final christTheKing = adventStart.subtract(const Duration(days: 7));

    if (d.isBefore(ashWednesday)) {
      final baptismMonday = baptism.add(const Duration(days: 1));
      final secondSunday = baptismMonday.add(const Duration(days: 6));
      if (d.isBefore(secondSunday)) return 1;
      final sunday = _mostRecentSunday(d);
      return 2 + (sunday.difference(secondSunday).inDays ~/ 7);
    } else {
      final sunday = _mostRecentSunday(d);
      final weeksBeforeChristKing = christTheKing.difference(sunday).inDays ~/ 7;
      return 34 - weeksBeforeChristKing;
    }
  }

  static DateTime _firstAdventSunday(int year) {
    final christmas = DateTime(year, 12, 25);
    final daysSincePrecedingSunday = christmas.weekday % 7;
    final fourthAdventSunday = christmas.subtract(Duration(days: daysSincePrecedingSunday));
    return fourthAdventSunday.subtract(const Duration(days: 21));
  }

  static DateTime _baptismOfTheLord(int year) {
    final epiphany = DateTime(year, 1, 6);
    if (epiphany.weekday == DateTime.sunday) return epiphany.add(const Duration(days: 1));
    return epiphany.add(Duration(days: 7 - epiphany.weekday));
  }
}