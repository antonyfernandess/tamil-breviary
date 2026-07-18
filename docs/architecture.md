# Tamil Catholic Liturgical App

## Architecture

Presentation (Flutter UI)
        │
Application
        │
Domain
        │
Infrastructure

The Liturgical Engine is independent of Flutter.

Every feature communicates through CalendarService.

CalendarService returns a LiturgicalDay.

Other modules consume LiturgicalDay.

Modules:

- Calendar
- Readings
- Mass
- Breviary
- Saints
- Prayers
- Search
- Settings

The engine is responsible only for liturgical calculations.