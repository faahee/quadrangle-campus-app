/// Supabase connection settings.
///
/// The publishable (anon) key is safe to ship in a client app: the database's
/// row-level security only lets it *insert* new requests.
/// Override at build time with:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_KEY=...
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lgdwuazuwxkcczakhsxh.supabase.co',
  );

  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_KEY',
    defaultValue: 'sb_publishable_ms7XUXE44DXUggVkUyrxtg_runLdIUP',
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
