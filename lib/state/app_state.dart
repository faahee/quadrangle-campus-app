import 'dart:math';

import 'package:flutter/widgets.dart';

import '../data/models.dart';
import '../data/sample_data.dart';
import '../services/local_store.dart';

/// App state (in memory; the student's own requests are also saved on the device) shared by every screen.
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

  /// Requests submitted on this device (newest first), then the samples.
  final List<StudentRequest> requests = [
    ...LocalStore.loadRequests(),
    ...SampleData.requests(),
  ];

  bool pushNotifications = true;
  bool emailDigest = false;

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

  // ----- Requests -----
  /// Unique reference such as `REQ-2026-K3F9QZ` (time-based + random), so
  /// submissions from different devices never clash in the database.
  String _newReference() {
    final now = DateTime.now();
    final stamp = now.millisecondsSinceEpoch.toRadixString(36).toUpperCase();
    final salt = Random()
        .nextInt(1296)
        .toRadixString(36)
        .toUpperCase()
        .padLeft(2, '0');
    return 'REQ-${now.year}-${stamp.substring(stamp.length - 4)}$salt';
  }

  int get openRequests => requests.where((r) => r.isOpen).length;

  StudentRequest addRequest({
    required RequestType type,
    required String subject,
    required String details,
    required DateTime preferredDate,
    required String priority,
    required String contactMethod,
    String? phone,
  }) {
    final request = StudentRequest(
      id: _newReference(),
      type: type,
      subject: subject,
      details: details,
      preferredDate: preferredDate,
      priority: priority,
      contactMethod: contactMethod,
      phone: phone,
      submittedOn: DateTime.now(),
      status: RequestStatus.submitted,
    );
    requests.insert(0, request);
    LocalStore.saveRequests(
      requests
          .where((r) => !SampleData.requests().any((s) => s.id == r.id))
          .toList(),
    );
    notifyListeners();
    return request;
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
