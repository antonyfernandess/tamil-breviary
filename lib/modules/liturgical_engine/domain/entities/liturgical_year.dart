import 'package:catholic/modules/liturgical_engine/domain/entities/liturgical_day.dart';

class LiturgicalYear {
  final int year;

  final Map<DateTime, LiturgicalDay> _days = {};

  LiturgicalYear({
    required this.year,
  });

  void addDay(LiturgicalDay day) {
    _days[_normalize(day.date)] = day;
  }

  LiturgicalDay? getDay(DateTime date) {
    return _days[_normalize(date)];
  }
  
  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}