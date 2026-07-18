import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_color.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_rank.dart';
import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_season.dart';
import 'package:catholic/modules/liturgical_engine/domain/value_objects/celebration_key.dart';

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