import 'auth_api_client.dart';
import 'auth_session.dart';
import 'registration_session.dart';

export 'auth_api_client.dart' show AuthException;

/// Converts a local Egyptian phone number to E.164 format (+20XXXXXXXXXX).
///
/// Accepts:
///   - 10 digits (1XXXXXXXXX)        → +201XXXXXXXXX
///   - 11 digits starting with 0     → +201XXXXXXXXX
///   - Already in E.164 (+20…)       → unchanged
String toE164Egypt(String input) {
  final String digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) {
    throw const AuthException('Phone number cannot be empty.');
  }
  if (digits.startsWith('20') && digits.length == 12) return '+$digits';
  if (digits.startsWith('0') && digits.length == 11) {
    return '+20${digits.substring(1)}';
  }
  if (digits.length == 10) return '+20$digits';
  throw AuthException('Invalid Egyptian phone number: "$input".');
}

/// High-level auth service.  All methods update [RegistrationSession] on
/// success so the caller does not have to manage the token manually.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final AuthApiClient _client = AuthApiClient.instance;
  final RegistrationSession _session = RegistrationSession.instance;

  // ─── Step 1: request email OTP ─────────────────────────────────────────────

  Future<void> requestOtp(String email) async {
    final Map<String, dynamic> data = await _client.requestOtp(email);
    _session.setEmail(email);
    _session.setToken(data['registrationToken'] as String);
  }

  // ─── Resend email OTP ──────────────────────────────────────────────────────

  Future<void> resendOtp() async {
    final String token = _requireToken();
    final Map<String, dynamic> data = await _client.resendOtp(token);
    _session.setToken(data['registrationToken'] as String);
  }

  // ─── Step 2: verify email OTP ──────────────────────────────────────────────

  Future<void> verifyOtp(String otp) async {
    final String token = _requireToken();
    final Map<String, dynamic> data = await _client.verifyOtp(token, otp);
    _session.setToken(data['registrationToken'] as String);
  }

  // ─── Step 3: request phone OTP ─────────────────────────────────────────────

  /// [localNumber] is the raw input from the user (e.g. 01234567890).
  /// It is converted to E.164 before being sent to the server.
  Future<void> requestPhoneOtp(String localNumber) async {
    final String token = _requireToken();
    final String e164 = toE164Egypt(localNumber);
    final Map<String, dynamic> data = await _client.requestPhoneOtp(
      token,
      e164,
    );
    _session.setPhone(e164);
    _session.setToken(data['registrationToken'] as String);
  }

  // ─── Resend phone OTP ──────────────────────────────────────────────────────

  Future<void> resendPhoneOtp() async {
    final String token = _requireToken();
    final Map<String, dynamic> data = await _client.resendPhoneOtp(token);
    _session.setToken(data['registrationToken'] as String);
  }

  // ─── Step 4: verify phone OTP ──────────────────────────────────────────────

  Future<void> verifyPhoneOtp(String otp) async {
    final String token = _requireToken();
    final Map<String, dynamic> data = await _client.verifyPhoneOtp(token, otp);
    _session.setToken(data['registrationToken'] as String);
  }

  // ─── Step 5: submit profile ────────────────────────────────────────────────

  Future<void> completeProfile({
    required String fullName,
    required String dateOfBirth,
    required String gender,
    required String city,
    int preferredLanguageId = 1,
    int roleId = 1,
    String? referralCode,
  }) async {
    final String token = _requireToken();
    final Map<String, dynamic> data = await _client.completeProfile(
      token,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      gender: gender.toLowerCase(),
      city: city,
      preferredLanguageId: preferredLanguageId,
      roleId: roleId,
      referralCode: referralCode,
    );
    _session.setToken(data['registrationToken'] as String);
  }

  // ─── Step 6: complete registration ────────────────────────────────────────

  /// Returns the auth payload `{accessToken, refreshToken, user}`.
  Future<Map<String, dynamic>> completeRegistration({
    required String password,
    required String confirmPassword,
  }) async {
    final String token = _requireToken();
    final Map<String, dynamic> result = await _client.completeRegistration(
      token,
      password: password,
      confirmPassword: confirmPassword,
    );
    AuthSession.instance.setFromLoginResponse(result);
    _session.clear();
    return result;
  }

  // ─── Social profile completion ────────────────────────────────────────────

  /// Called from the profile completion page when the user signed up via a
  /// social provider (Google / Apple). Creates the account and returns auth
  /// tokens — no password step required.
  Future<Map<String, dynamic>> completeSocialProfile({
    required String fullName,
    required String dateOfBirth,
    required String gender,
    required String city,
    int preferredLanguageId = 1,
    int roleId = 1,
    String? referralCode,
  }) async {
    final String token = _requireToken();
    final Map<String, dynamic> result = await _client.completeSocialProfile(
      token,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      gender: gender.toLowerCase(),
      city: city,
      preferredLanguageId: preferredLanguageId,
      roleId: roleId,
      referralCode: referralCode,
    );
    AuthSession.instance.setFromLoginResponse(result);
    _session.clear();
    return result;
  }

  // ─── Login ────────────────────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    final Map<String, dynamic> data = await _client.login(email, password);
    AuthSession.instance.setFromLoginResponse(data);
  }

  // ─── Social login ─────────────────────────────────────────────────────────

  /// Returns `true` if profile completion is required (new social user),
  /// `false` if the user is fully logged in.
  Future<bool> socialLogin(String provider, String idToken) async {
    final Map<String, dynamic> data = await _client.socialLogin(
      provider,
      idToken,
    );
    if (data['requiresProfile'] == true) {
      _session.setToken(data['registrationToken'] as String);
      final Map<String, dynamic>? hints =
          data['socialHints'] as Map<String, dynamic>?;
      if (hints != null) {
        _session.setSocialHints(SocialHints.fromMap(hints));
        final String? email = hints['email'] as String?;
        if (email != null) _session.setEmail(email);
      }
      return true;
    }
    AuthSession.instance.setFromLoginResponse(data);
    return false;
  }

  // ─── Forgot password ──────────────────────────────────────────────────────

  /// Sends a password-reset OTP to [email].
  /// Stores the registration token so the reset page can use it.
  Future<void> forgotPassword(String email) async {
    final Map<String, dynamic> data = await _client.forgotPassword(email);
    _session.setEmail(email);
    _session.setToken(data['registrationToken'] as String);
  }

  /// Verifies the reset OTP and sets the new password.
  Future<void> resetPassword({
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final String token = _requireToken();
    await _client.resetPassword(
      token,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    _session.clear();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _requireToken() {
    final String? t = _session.token;
    if (t == null) {
      throw const AuthException(
        'Registration session expired. Please start over.',
      );
    }
    return t;
  }
}
