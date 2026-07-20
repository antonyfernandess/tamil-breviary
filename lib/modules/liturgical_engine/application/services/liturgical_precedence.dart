import 'package:catholic/modules/liturgical_engine/domain/definitions/celebration_definition.dart';


class LiturgicalPrecedence {
  const LiturgicalPrecedence();

  int compare(
    CelebrationDefinition first,
    CelebrationDefinition second,
  ) {
    return first.rank.index.compareTo(second.rank.index);
  }

  CelebrationDefinition higher(
    CelebrationDefinition first,
    CelebrationDefinition second,
  ) {
    return compare(first, second) <= 0 ? first : second;
  }
}