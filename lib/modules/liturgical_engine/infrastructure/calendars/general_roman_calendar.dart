

import 'package:catholic/modules/liturgical_engine/domain/definitions/liturgical_calendar.dart';

import '../../domain/definitions/celebration_definition.dart';
import '../../domain/enums/liturgical_color.dart';
import '../../domain/enums/liturgical_rank.dart';
import '../../domain/rules/easter_based_rule.dart';
import '../../domain/value_objects/celebration_key.dart';

class GeneralRomanCalendar implements LiturgicalCalendar {

  @override
  String get key => 'general_roman_calendar';

  @override
  Iterable<CelebrationDefinition> celebrationsForYear(int year) => _celebrations;

  static final List<CelebrationDefinition> _celebrations = [
    CelebrationDefinition(
      key: CelebrationKey('ash_wednesday'),
      rule: EasterBasedRule(offsetDays: -46),
      rank: LiturgicalRank.feria,
      color: LiturgicalColor.violet,
    ),
    CelebrationDefinition(
      key: CelebrationKey('palm_sunday'),
      rule: EasterBasedRule(offsetDays: -7),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.red,
    ),
    CelebrationDefinition(
      key: CelebrationKey('holy_thursday'),
      rule: EasterBasedRule(offsetDays: -3),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.white,
    ),
    CelebrationDefinition(
      key: CelebrationKey('good_friday'),
      rule: EasterBasedRule(offsetDays: -2),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.red,
    ),
    CelebrationDefinition(
      key: CelebrationKey('easter_sunday'),
      rule: EasterBasedRule(offsetDays: 0),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.white,
    ),
    CelebrationDefinition(
      key: CelebrationKey('ascension'),
      rule: EasterBasedRule(offsetDays: 39),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.white,
    ),
    CelebrationDefinition(
      key: CelebrationKey('pentecost'),
      rule: EasterBasedRule(offsetDays: 49),
      rank: LiturgicalRank.solemnity,
      color: LiturgicalColor.red,
    ),
  ];
}
