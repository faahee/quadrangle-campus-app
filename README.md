# Quadrangle – Student Campus App

A Flutter Student Campus App dashboard for the fictional **Kingsbridge University**,
built for the *Flutter Container Widget* project. All data is fictional sample data
(no database, login, or API).

**Live demo:** https://faahee.github.io/quadrangle-campus-app/

## Run it

```bash
flutter pub get
flutter run            # Android emulator / iOS simulator / Chrome
```

Every push to `main` rebuilds the web version and redeploys it to GitHub Pages
(see `.github/workflows/deploy.yml`).

## Project structure

```
lib/
  main.dart                      MaterialApp + shared state
  theme/app_theme.dart           Colour system + consistent card style
  data/models.dart               Data classes
  data/sample_data.dart          All sample data (student, services, alerts, events…)
  state/app_state.dart           In-memory state (read alerts, registrations, payments…)
  widgets/
    campus_action_card.dart      ★ Reusable CampusActionCard + responsive grid
    common_widgets.dart          IconTile, StatusBadge, DateTile, CampusCard, SectionHeader…
    announcement_card.dart       Featured announcement + alert tile
    event_card.dart              Reusable event card with date tile
  screens/
    home_shell.dart              Bottom navigation (Home, Services, Alerts, Profile)
    dashboard_screen.dart        ★ Main dashboard (the assessed screen)
    services_screen.dart         Searchable list of all services
    alerts_screen.dart           Filterable announcements, mark as read
    profile_screen.dart          Profile, digital ID card, settings, sign out
    announcement_detail_screen.dart, event_detail_screen.dart, events_screen.dart
    services/                    Timetable, Results, Attendance, Fees, Library,
                                 Shuttle, Clubs, Helpdesk
```

## What every button does

| Where | Action |
|---|---|
| Bell icon (header) | Opens the Alerts tab (badge shows unread count) |
| Avatar (header) | Opens the Profile tab |
| CGPA / Credits / Attendance | Open Results / Attendance |
| Advisor strip | Dialog → confirm appointment (SnackBar) |
| Up next card | Opens Timetable |
| 8 Quick-access cards | Open their service page |
| Campus update card | Announcement details (marks as read) |
| Event cards | Event details → Register / Cancel, Add to calendar |
| Transport notice | Opens Shuttle |
| Timetable | Day selector; tap class → set/remove reminder |
| Results | Switch semester (GPA recalculated); request transcript |
| Attendance | Tap course → details + Submit MC |
| Fees | Pay / Pay all (balance updates, receipt number); view receipt |
| Library | Renew (+14 days, max 2); book a study room |
| Shuttle | Refresh random live times; notify-me toggle; expand stops |
| Clubs | Filter; Join / Leave (member count updates) |
| Helpdesk | Call / Email / Live chat; New ticket form (validated); FAQs |
| Alerts | Filters, Mark all read, open details |
| Profile | Digital ID, Edit name (updates greeting), copy email/phone, switches, About, Sign out |

## Requirement checklist (Sections 6–8)

| Requirement | Where it is |
|---|---|
| MaterialApp, Scaffold, SafeArea, SingleChildScrollView | `main.dart`, `home_shell.dart`, `dashboard_screen.dart` |
| 10+ meaningful Containers | Header, avatar, crest, pills, snapshot card, divider, advisor strip, next-class card + accent bar + time tile, action cards, announcement, event cards, date tiles, transport notice, footer |
| Profile section | Header: name, ID, programme, avatar, greeting (changes by time of day) |
| Academic section | CGPA, credits, attendance, advisor |
| Quick access (4+) | 8 services, each with a different icon and colour |
| Announcement | Registration deadline with date + "Due soon" badge |
| Student life | 4 events + transport notice |
| Interaction + feedback | InkWell / GestureDetector → navigation, SnackBars, dialogs, colour/state changes |
| Reusable component | `CampusActionCard` (also `EventCard`, `StatusBadge`, `IconTile`, `DateTile`) |
| Width & height | Avatar 76×76, icon tiles, date tile, accent bar 5×58, time tile 72×58 |
| Margin | `SectionHeader`, next-class card, transport notice, event cards |
| Padding | Every card (14–20 px) |
| Alignment | Avatar initials, icon tiles, footer text (`Alignment.center`) |
| Constraints | `BoxConstraints(minHeight: 128)` on action cards, `maxWidth: 760` responsive body, `minHeight: 48` touch targets |
| BoxDecoration | Cards, header, badges, tiles (colour always inside the decoration) |
| Border | Action cards, announcement (gold), date tiles, avatar ring |
| Border radius | 16 px cards, 12 px tiles, 28 px header corners |
| Box shadow | `AppStyle.softShadow` on cards, stronger shadow on header |
| Colour system | Primary navy `#14213D`, accent gold `#C9A227`, tints ivory `#FBF8F1` & parchment `#F3ECDC` |
| Child composition | Row, Column, Wrap, Stack inside Containers |
| Layout choice | Responsive Wrap: 2 columns on phones, 4 on tablets |
| Visual detail | Gradient header, crest watermark, status badges, progress bars, date tiles |
| Accessibility | 48 px+ touch targets, Semantics labels, 12.5 px+ text, high-contrast colours |
