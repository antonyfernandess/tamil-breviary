import 'package:catholic/modules/liturgical_engine/application/builders/liturgical_year_builder.dart';
import 'package:catholic/modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';

void main() {
  final builder = LiturgicalYearBuilder(calendar: GeneralRomanCalendar());

  final year = builder.build(2026);

  final christmas = year.getDay(DateTime(2026, 12, 25));

  print(christmas?.celebrations.first.key.value);
}
