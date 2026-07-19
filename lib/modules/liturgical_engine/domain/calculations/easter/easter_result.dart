class EasterResult {
  final int month;
  final int day;

  const EasterResult({
    required this.month,
    required this.day,
  });

  @override
  String toString() => 'EasterResult($month/$day)';
}