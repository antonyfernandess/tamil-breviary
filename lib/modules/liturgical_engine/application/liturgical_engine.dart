import 'package:catholic/modules/liturgical_engine/domain/entities/liturgical_day.dart';

abstract interface class LiturgicalEngine {
  LiturgicalDay getDay(DateTime date);
}