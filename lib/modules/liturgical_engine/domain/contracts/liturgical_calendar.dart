import 'package:catholic/modules/liturgical_engine/domain/definitions/celebration_definition.dart';

abstract interface class LiturgicalCalendar{
  String get key;

  Iterable<CelebrationDefinition> get celebrations;
}