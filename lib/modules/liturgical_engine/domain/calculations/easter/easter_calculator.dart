import 'easter_algorithm.dart';

/// Public entry point for getting Easter Sunday as a real [DateTime].
/// Wraps [EasterAlgorithm] and caches results per year, since many
/// other liturgical dates (Ash Wednesday, Ascension, Pentecost, etc.)
/// are computed relative to Easter and would otherwise trigger
/// repeated recalculation for the same year.
class EasterCalculator {
  static final Map<int, DateTime> _cache = {};

  static DateTime forYear(int year) {
    return _cache.putIfAbsent(year, () {
      final result = EasterAlgorithm.calculate(year);
      return DateTime(year, result.month, result.day);
    });
  }
}