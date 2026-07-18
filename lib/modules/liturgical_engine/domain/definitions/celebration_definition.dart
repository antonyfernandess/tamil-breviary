import 'package:catholic/modules/liturgical_engine/domain/contracts/calendar_rule.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_color.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_rank.dart';
import 'package:catholic/modules/liturgical_engine/domain/value_objects/celebration_key.dart';

class CelebrationDefinition {
  final CelebrationKey key;

  final CalendarRule rule;  

  final LiturgicalRank rank;

  final LiturgicalColor color;
  
  const CelebrationDefinition({
    required this.key,
    required this.rule,
    required this.rank,
    required this.color,
  });
}