import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models.dart';
import '../data/sample_data.dart';

/// Keeps the student's own submitted requests on this device (browser
/// storage on the web), so "My requests" survives a reload.
///
/// The database is insert-only for privacy, so the app cannot read requests
/// back from Supabase – this local copy is what the student sees.
class LocalStore {
  LocalStore._();

  static const _key = 'my_requests_v1';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Local storage unavailable: $e');
    }
  }

  static List<StudentRequest> loadRequests() {
    final raw = _prefs?.getString(_key);
    if (raw == null) return [];
    try {
      return [
        for (final m in jsonDecode(raw) as List)
          _fromJson(m as Map<String, dynamic>),
      ];
    } catch (e) {
      debugPrint('Could not read saved requests: $e');
      return [];
    }
  }

  static Future<void> saveRequests(List<StudentRequest> requests) async {
    await _prefs?.setString(
      _key,
      jsonEncode([for (final r in requests) _toJson(r)]),
    );
  }

  static Map<String, dynamic> _toJson(StudentRequest r) => {
    'id': r.id,
    'type': r.type.id,
    'subject': r.subject,
    'details': r.details,
    'preferredDate': r.preferredDate.toIso8601String(),
    'priority': r.priority,
    'contactMethod': r.contactMethod,
    'phone': r.phone,
    'submittedOn': r.submittedOn.toIso8601String(),
    'status': r.status.name,
  };

  static StudentRequest _fromJson(Map<String, dynamic> m) => StudentRequest(
    id: m['id'] as String,
    type: SampleData.requestType(m['type'] as String),
    subject: m['subject'] as String,
    details: m['details'] as String,
    preferredDate: DateTime.parse(m['preferredDate'] as String),
    priority: m['priority'] as String,
    contactMethod: m['contactMethod'] as String,
    phone: m['phone'] as String?,
    submittedOn: DateTime.parse(m['submittedOn'] as String),
    status: RequestStatus.values.byName(m['status'] as String),
  );
}
