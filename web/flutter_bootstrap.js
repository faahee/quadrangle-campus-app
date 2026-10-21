{{flutter_js}}
{{flutter_build_config}}

// Load the app without registering Flutter's offline service worker, so every
// visit gets the latest deployed version (no stale cached copies).
_flutter.loader.load();
