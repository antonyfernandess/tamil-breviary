class CalendarSettings {
  final bool transferEpiphany;
  final bool transferAscension;
  final bool transferCorpusChristi;

  const CalendarSettings({
    this.transferEpiphany = false,
    this.transferAscension = false,
    this.transferCorpusChristi = false,
  });

  static const roman = CalendarSettings();

  static const india = CalendarSettings(
    transferEpiphany: true,
    transferAscension: true,
    transferCorpusChristi: true,
  );
}