import '../easter/easter_calculator.dart';

/// Determines whether a date is a "privileged" liturgical day per the
/// Table of Liturgical Days (General Norms for the Liturgical Year,
/// nn. 58-59). Privileged days outrank even solemnities of the
/// General Roman Calendar; when a solemnity would fall on one, it
/// must be transferred to the nearest free day (GNLY 60).
class PrivilegedDayCalculator {
  static bool isPrivileged(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final easter = EasterCalculator.forYear(d.year);

    if (d.month == 12 && d.day == 25) return true;
    if (d == easter.add(const Duration(days: 39))) return true; // Ascension
    if (d == easter.add(const Duration(days: 49))) return true; // Pentecost
    if (d == easter.subtract(const Duration(days: 46))) return true; // Ash Wed
    if (_isHolyWeekOrTriduum(d, easter)) return true;
    if (_isWithinEasterOctave(d, easter)) return true;
    if (_isSundayOfAdvent(d)) return true;
    if (_isSundayOfLent(d, easter)) return true;
    if (_isSundayOfEaster(d, easter)) return true;

    return false;
  }

  static bool _isHolyWeekOrTriduum(DateTime d, DateTime easter) {
    final palmSunday = easter.subtract(const Duration(days: 7));
    return d.isAfter(palmSunday) && d.isBefore(easter);
  }

  static bool _isWithinEasterOctave(DateTime d, DateTime easter) {
    final octaveEnd = easter.add(const Duration(days: 7));
    return !d.isBefore(easter) && !d.isAfter(octaveEnd);
  }

  static bool _isSundayOfAdvent(DateTime d) {
    if (d.weekday != DateTime.sunday) return false;
    final christmas = DateTime(d.year, 12, 25);
    final adventStart = _firstAdventSunday(d.year);
    return !d.isBefore(adventStart) && d.isBefore(christmas);
  }

  static bool _isSundayOfLent(DateTime d, DateTime easter) {
    if (d.weekday != DateTime.sunday) return false;
    final ashWednesday = easter.subtract(const Duration(days: 46));
    final palmSunday = easter.subtract(const Duration(days: 7));
    return !d.isBefore(ashWednesday) && !d.isAfter(palmSunday);
  }

  static bool _isSundayOfEaster(DateTime d, DateTime easter) {
    if (d.weekday != DateTime.sunday) return false;
    final pentecost = easter.add(const Duration(days: 49));
    return !d.isBefore(easter) && !d.isAfter(pentecost);
  }

  static DateTime _firstAdventSunday(int year) {
    final christmas = DateTime(year, 12, 25);
    final daysSincePrecedingSunday = christmas.weekday % 7;
    final fourthAdventSunday = christmas.subtract(
      Duration(days: daysSincePrecedingSunday),
    );
    return fourthAdventSunday.subtract(const Duration(days: 21));
  }
}
