/// Holds the authenticated user's tokens and profile after a successful login.
///
/// In-memory only — cleared on logout or app restart.
class AuthSession {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  String? accessToken;
  String? refreshToken;
  Map<String, dynamic>? user;

  bool get isLoggedIn => accessToken != null;

  void setFromLoginResponse(Map<String, dynamic> data) {
    accessToken = data['accessToken'] as String?;
    refreshToken = data['refreshToken'] as String?;
    user = data['user'] as Map<String, dynamic>?;
  }

  void clear() {
    accessToken = null;
    refreshToken = null;
    user = null;
  }
}
