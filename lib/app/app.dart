import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modules/liturgical_engine/application/celebration_generator.dart';
import '../modules/liturgical_engine/application/liturgical_engine_impl.dart';
import '../modules/liturgical_engine/application/services/calendar_service.dart';
import '../modules/liturgical_engine/application/services/calendar_service_impl.dart';
import '../modules/liturgical_engine/application/services/liturgical_precedence.dart';
import '../modules/liturgical_engine/domain/value_objects/calendar_settings.dart';
import '../modules/liturgical_engine/infrastructure/calendars/general_roman_calendar.dart';
import '../modules/liturgical_engine/infrastructure/calendars/sqlite_fixed_feast_calendar.dart';
import '../modules/liturgical_engine/infrastructure/database/feast_repository.dart';
import 'router.dart';

class CatholicApp extends StatefulWidget {
  const CatholicApp({super.key});

  @override
  State<CatholicApp> createState() => _CatholicAppState();
}

class _CatholicAppState extends State<CatholicApp> {
  late final Future<CalendarService> _calendarServiceFuture;

  @override
  void initState() {
    super.initState();
    _calendarServiceFuture = _buildCalendarService();
  }

  Future<CalendarService> _buildCalendarService() async {
    final feastRows = await FeastRepository().loadAll();

    final generator = CelebrationGenerator(
      calendars: [
        GeneralRomanCalendar(),
        SqliteFixedFeastCalendar(rows: feastRows),
      ],
      precedence: const LiturgicalPrecedence(),
      settings: CalendarSettings.india,
    );

    
    /// Temporary test to verify that the calendar is generated correctly.
    final calendarService = CalendarServiceImpl(
      engine: LiturgicalEngineImpl(
        generator: generator,
        settings: CalendarSettings.india,
      ),
    );

    // --- temporary test, remove after checking output ---
    final year2026 = calendarService.getYear(2026);
    print('Total days: ${year2026.days.length}');
    for (final day in year2026.days) {
      final dateStr = day.date.toIso8601String().substring(0, 10);
      final optionals = day.optionalMemorials.map((m) => m.key.value).join(', ');
      print('$dateStr  ${day.season.name.padRight(14)}  ${day.celebration.value}'
          '${optionals.isNotEmpty ? '  [or: $optionals]' : ''}');
    }
    // --- end temporary test ---

    return CalendarServiceImpl(
      engine: LiturgicalEngineImpl(
        generator: generator,
        settings: CalendarSettings.india,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CalendarService>(
      future: _calendarServiceFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Failed to load calendar: ${snapshot.error}'),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return Provider<CalendarService>.value(
          value: snapshot.data!,
          child: MaterialApp(
            title: 'Catholic',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: Colors.deepPurple,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.deepPurple,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.home,
          ),
        );
      },
    );
  }
}
