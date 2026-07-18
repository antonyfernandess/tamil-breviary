
import '../enums/liturgical_color.dart';
import '../enums/liturgical_rank.dart';
import '../enums/liturgical_season.dart';
import '../value_objects/celebration_key.dart';

class LiturgicalDay {
  
  final DateTime date;

  final CelebrationKey celebration;

  final LiturgicalSeason season;

  final LiturgicalRank rank;

  final LiturgicalColor color;

  const LiturgicalDay({
    required this.date,
    required this.celebration,
    required this.season,
    required this.rank,
    required this.color,
  });
}