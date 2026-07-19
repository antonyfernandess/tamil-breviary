//import 'package:catholic/modules/liturgical_engine/domain/calculations/easter/easter_calculator.dart';

import 'package:catholic/modules/liturgical_engine/application/celebration_generator.dart';
import 'package:catholic/modules/liturgical_engine/application/liturgical_engine_impl.dart';
import 'package:catholic/modules/liturgical_engine/domain/calculations/season/liturgical_season_calculator.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';

void main() {
  // print(EasterCalculator.forYear(2026)); // should print 2026-04-05
  // print(EasterCalculator.forYear(2027)); // should print 2027-03-28
  final generator = CelebrationGenerator(calendars: [GeneralRomanCalendar()]);
  final celebrations2026 = generator.generate(2026);
  for (final c in celebrations2026) {
    print('${c.date.toIso8601String().substring(0, 10)}  ${c.definition.key}');
  }
  void testSeason(String label, DateTime date) {
  print('$label (${date.toIso8601String().substring(0, 10)}): '
      '${LiturgicalSeasonCalculator.resolve(date)}');
}

testSeason('Jan 1', DateTime(2026, 1, 1));           // christmas (carried from 2025)
testSeason('Jan 10', DateTime(2026, 1, 10));         // ordinaryTime (after Baptism)
testSeason('Ash Wednesday', DateTime(2026, 2, 18));  // lent
testSeason('Holy Thursday', DateTime(2026, 4, 2));   // sacredTriduum
testSeason('Easter Sunday', DateTime(2026, 4, 5));   // easter
testSeason('Pentecost', DateTime(2026, 5, 24));      // easter
testSeason('Day after Pentecost', DateTime(2026, 5, 25)); // ordinaryTime
testSeason('Nov 15', DateTime(2026, 11, 15));        // ordinaryTime
testSeason('1st Sunday Advent', DateTime(2026, 11, 29)); // advent
testSeason('Christmas', DateTime(2026, 12, 25));     // christmas

final engine = LiturgicalEngineImpl(
  generator: CelebrationGenerator(calendars: [GeneralRomanCalendar()]),
);

void testDay(DateTime date) {
  final day = engine.getDay(date);
  print('${day.date.toIso8601String().substring(0, 10)}  '
      '${day.celebration}  ${day.season}  ${day.rank}  ${day.color}');
}

testDay(DateTime(2026, 4, 5));  // Easter Sunday — named celebration
testDay(DateTime(2026, 7, 19)); // random ordinary weekday — default
testDay(DateTime(2026, 12, 6)); // random Advent Sunday — default, violet
}
