
import 'celebration_definition.dart';

abstract interface class LiturgicalCalendar{
  String get key;

  Iterable<CelebrationDefinition> get celebrations;
}