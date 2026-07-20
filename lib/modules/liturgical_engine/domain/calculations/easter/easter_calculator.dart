import 'easter_algorithm.dart';

/// Public entry point for getting Easter Sunday as a real [DateTime].
/// Wraps [EasterAlgorithm] and caches results per year, since many
/// other liturgical dates (Ash Wednesday, Ascension, Pentecost, etc.)
/// are computed relative to Easter and would otherwise trigger
/// repeated recalculation for the same year.
class EasterCalculator {
  static final Map<int, DateTime> _cache = {}; /// Cache for storing computed Easter Sunday dates by year.

  static DateTime forYear(int year) {
    
    ///  Returns the date of Easter Sunday for the given year, using a cache to avoid redundant calculations.
    return _cache.putIfAbsent(year, () { 
      final result = EasterAlgorithm.calculate(year); // Use the EasterAlgorithm to calculate the month and day of Easter Sunday.
      return DateTime(year, result.month, result.day); // Return the calculated Easter Sunday as a DateTime.
    });
  }
}