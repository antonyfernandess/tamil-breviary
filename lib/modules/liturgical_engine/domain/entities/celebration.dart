import 'package:catholic/modules/liturgical_engine/domain/definitions/celebration_definition.dart';

class Celebration{
  final CelebrationDefinition definition;

  final DateTime date;

  const Celebration({
    required this.definition,
    required this.date,
  });
}