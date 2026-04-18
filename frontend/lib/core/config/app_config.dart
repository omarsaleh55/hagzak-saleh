abstract final class AppConfig {
  /// Base URL for the backend API.
  ///
  /// Override with `--dart-define=BASE_URL=...` for each environment.
  /// Examples:
  /// - Android emulator → http://10.0.2.2:3000
  /// - iOS simulator    → http://localhost:3000
  /// - Web/production   → your deployed backend URL
  ///
  /// Defaults to the Android emulator host to preserve current behavior when
  /// no compile-time override is provided.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  /// Web (server) OAuth 2.0 client ID used by google_sign_in to produce an
  /// ID token the backend can verify.
  static const String googleWebClientId =
      '266939416736-2upknulopogd3eqvvjqbl7ngs0db9877.apps.googleusercontent.com';
}
