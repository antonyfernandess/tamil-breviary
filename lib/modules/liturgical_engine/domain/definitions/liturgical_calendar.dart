import 'celebration_definition.dart';

abstract interface class LiturgicalCalendar {
  String get key;

  Iterable<CelebrationDefinition> celebrationsForYear(int year);
}