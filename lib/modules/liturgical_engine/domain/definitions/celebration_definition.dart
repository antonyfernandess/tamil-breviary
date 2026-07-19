

import '../rules/calendar_rule.dart';
import '../enums/liturgical_color.dart';
import '../enums/liturgical_rank.dart';
import '../value_objects/celebration_key.dart';

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