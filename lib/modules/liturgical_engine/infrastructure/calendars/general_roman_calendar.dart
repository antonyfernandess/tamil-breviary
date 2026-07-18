

import '../../domain/definitions/celebration_definition.dart';
import '../../domain/enums/liturgical_color.dart';
import '../../domain/enums/liturgical_rank.dart';
import '../../domain/rules/fixed_date_rule.dart';
import '../../domain/value_objects/celebration_key.dart';

class GeneralRomanCalendar {
  List<CelebrationDefinition> get celebrations => [
    CelebrationDefinition(
      key: CelebrationKey('christmas'),
      rule: FixedDateRule(month: 12, day: 25),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.white,
    ),
    CelebrationDefinition(
      key: CelebrationKey('mary_mother_of_god'),
      rule: FixedDateRule(month: 1, day: 1),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.white,
    ),
    CelebrationDefinition(
      key: CelebrationKey('saint_joseph'),
      rule: FixedDateRule(month: 3, day: 19),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.white,
    ),
    CelebrationDefinition(
      key: CelebrationKey('annunciation'),
      rule: FixedDateRule(month: 3, day: 25),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.white,
    ),
  ];
}
