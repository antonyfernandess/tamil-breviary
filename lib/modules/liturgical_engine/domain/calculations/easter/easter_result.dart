class EasterResult {
  final int month;
  final int day;
  /// Represents the result of the Easter calculation, containing the month and day of Easter Sunday.
  const EasterResult({
    required this.month,
    required this.day,
  });

  /// Returns a [DateTime] object representing Easter Sunday for the given year.
  @override
  String toString() => 'EasterResult($month/$day)';
}