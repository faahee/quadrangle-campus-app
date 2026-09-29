import 'package:flutter/widgets.dart';

import '../data/models.dart';
import '../data/sample_data.dart';

/// Simple in-memory app state shared by every screen.
/// Taps on cards and buttons update this state, and any widget that reads it
/// through [AppStateScope.of] rebuilds automatically.
class AppState extends ChangeNotifier {
  String preferredName = SampleData.student.preferredName;

  final Set<String> readAnnouncements = {};
  final Set<String> registeredEvents = {'chess-open'};
  final Set<String> joinedClubs = {'coding'};
  final Set<String> shuttleAlerts = {};

  final List<Invoice> invoices = SampleData.invoices();
  final List<BorrowedBook> books = SampleData.books();
  final List<HelpTicket> tickets = SampleData.tickets();

  bool pushNotifications = true;
  bool emailDigest = false;

  int _ticketCounter = 10483;

  // ----- Profile -----
  void updatePreferredName(String name) {
    preferredName = name.trim().isEmpty
        ? SampleData.student.preferredName
        : name.trim();
    notifyListeners();
  }

  void setPushNotifications(bool value) {
    pushNotifications = value;
    notifyListeners();
  }

  void setEmailDigest(bool value) {
    emailDigest = value;
    notifyListeners();
  }

  // ----- Announcements -----
  int get unreadCount => SampleData.announcements
      .where((a) => !readAnnouncements.contains(a.id))
      .length;

  bool isRead(String id) => readAnnouncements.contains(id);

  void markRead(String id) {
    if (readAnnouncements.add(id)) notifyListeners();
  }

  void markAllRead() {
    readAnnouncements.addAll(SampleData.announcements.map((a) => a.id));
    notifyListeners();
  }

  // ----- Events -----
  bool isRegistered(String id) => registeredEvents.contains(id);

  /// Returns true when the student is now registered.
  bool toggleEvent(String id) {
    final registered = registeredEvents.add(id);
    if (!registered) registeredEvents.remove(id);
    notifyListeners();
    return registered;
  }

  // ----- Clubs -----
  bool isMember(String id) => joinedClubs.contains(id);

  bool toggleClub(String id) {
    final joined = joinedClubs.add(id);
    if (!joined) joinedClubs.remove(id);
    notifyListeners();
    return joined;
  }

  // ----- Shuttle -----
  bool hasShuttleAlert(String id) => shuttleAlerts.contains(id);

  bool toggleShuttleAlert(String id) {
    final on = shuttleAlerts.add(id);
    if (!on) shuttleAlerts.remove(id);
    notifyListeners();
    return on;
  }

  // ----- Fees -----
  double get outstanding => invoices
      .where((i) => !i.paid)
      .fold<double>(0, (sum, i) => sum + i.amount);

  void payInvoice(Invoice invoice) {
    invoice.paid = true;
    notifyListeners();
  }

  // ----- Library -----
  static const int maxRenewals = 2;

  /// Extends the loan by 14 days. Returns false when no renewals are left.
  bool renewBook(BorrowedBook book) {
    if (book.renewals >= maxRenewals) return false;
    book.renewals++;
    book.dueDate = book.dueDate.add(const Duration(days: 14));
    notifyListeners();
    return true;
  }

  // ----- Helpdesk -----
  HelpTicket addTicket(String category, String subject) {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final ticket = HelpTicket(
      id: 'HD-${_ticketCounter++}',
      category: category,
      subject: subject,
      status: 'Submitted',
      date: '${now.day} ${months[now.month - 1]} ${now.year}',
    );
    tickets.insert(0, ticket);
    notifyListeners();
    return ticket;
  }
}

/// Makes [AppState] available to the whole widget tree.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in the widget tree');
    return scope!.notifier!;
  }
}
