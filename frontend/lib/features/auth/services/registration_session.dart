/// Pre-filled hints from a social provider (Google / Apple).
class SocialHints {
  const SocialHints({this.name, this.email, this.picture});

  final String? name;
  final String? email;
  final String? picture; // URL to the provider's profile photo

  factory SocialHints.fromMap(Map<String, dynamic> map) => SocialHints(
    name: map['name'] as String?,
    email: map['email'] as String?,
    picture: map['picture'] as String?,
  );
}

/// Holds the transient registration state (token, email, phone) that must
/// survive navigation between the multi-step sign-up flow.
///
/// This is an in-memory singleton — it does NOT persist across app restarts,
/// which is intentional: an incomplete registration should restart cleanly.
class RegistrationSession {
  RegistrationSession._();
  static final RegistrationSession instance = RegistrationSession._();

  String? _token;
  String? _email;
  String? _phone; // E.164, e.g. +201234567890
  SocialHints? _socialHints;

  String? get token => _token;
  String? get email => _email;
  String? get phone => _phone;
  SocialHints? get socialHints => _socialHints;

  void setToken(String token) => _token = token;
  void setEmail(String email) => _email = email;
  void setPhone(String phone) => _phone = phone;
  void setSocialHints(SocialHints hints) => _socialHints = hints;

  /// Reset after registration completes or the user aborts.
  void clear() {
    _token = null;
    _email = null;
    _phone = null;
    _socialHints = null;
  }
}
