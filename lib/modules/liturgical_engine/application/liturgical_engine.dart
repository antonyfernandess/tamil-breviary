
import '../domain/entities/liturgical_day.dart';

abstract interface class LiturgicalEngine {
  LiturgicalDay getDay(DateTime date);
}