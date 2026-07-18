import 'package:catholic/modules/liturgical_engine/domain/entities/liturgical_day.dart';

abstract interface class CalendarService {
  LiturgicalDay getDay(DateTime date);
}