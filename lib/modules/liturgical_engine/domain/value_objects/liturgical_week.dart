import 'package:catholic/modules/liturgical_engine/domain/enums/liturgical_season.dart';


class LiturgicalWeek {
  final LiturgicalSeason season;
  final int week;

  const LiturgicalWeek({
    required this.season,
    required this.week,
  });
}