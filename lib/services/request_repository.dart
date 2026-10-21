import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../data/models.dart';

/// Saves complaints, reports and other student requests to Supabase
/// (table `campus_requests`).
class RequestRepository {
  RequestRepository._();

  static bool _ready = false;

  /// Connects to Supabase once at start-up. Safe to call without a key:
  /// the app then keeps requests on the device only.
  static Future<void> init() async {
    if (!SupabaseConfig.isConfigured || _ready) return;
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.publishableKey,
      );
      _ready = true;
    } catch (e) {
      debugPrint('Supabase init failed: $e');
    }
  }

  static bool get isOnline => _ready;

  /// Returns true when the request was stored in the database.
  static Future<bool> submit(
    StudentRequest request, {
    required Student student,
    required String email,
  }) async {
    if (!_ready) return false;
    try {
      await Supabase.instance.client.from('campus_requests').insert({
        'reference': request.id,
        'student_id': student.studentId,
        'student_name': student.fullName,
        'email': email,
        'request_type': request.type.label,
        'subject': request.subject,
        'details': request.details,
        'needed_by': request.preferredDate.toIso8601String().substring(0, 10),
        'priority': request.priority,
        'contact_method': request.contactMethod,
        'phone': request.phone,
      });
      return true;
    } catch (e) {
      debugPrint('Saving request failed: $e');
      return false;
    }
  }
}
