import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';

/// Thrown whenever the backend returns a non-2xx response or the device has
/// no connectivity.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Thin HTTP wrapper for the auth module.
///
/// Every method returns the decoded `data` field from the backend's
/// `{success, message, data}` envelope, or throws [AuthException].
class AuthApiClient {
  AuthApiClient._();
  static final AuthApiClient instance = AuthApiClient._();

  static const Duration _timeout = Duration(seconds: 15);

  Uri _uri(String path) => Uri.parse('${AppConfig.baseUrl}/api/v1/auth$path');

  Map<String, String> _headers({String? bearerToken}) => {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    if (bearerToken != null)
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
  };

  /// Parses the response body.
  /// Returns `data` on success, throws [AuthException] on failure.
  dynamic _parse(http.Response response) {
    late Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const AuthException(
        'Unexpected server response. Please try again.',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body['data'];
    }

    final String message = (body['message'] as String?)?.isNotEmpty == true
        ? body['message'] as String
        : 'Something went wrong (${response.statusCode}).';
    throw AuthException(message);
  }

  Future<dynamic> _post(
    String path, {
    required Map<String, dynamic> body,
    String? bearerToken,
  }) async {
    try {
      final http.Response response = await http
          .post(
            _uri(path),
            headers: _headers(bearerToken: bearerToken),
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return _parse(response);
    } on AuthException {
      rethrow;
    } on SocketException {
      throw const AuthException(
        'No internet connection. Please check your network and try again.',
      );
    } catch (_) {
      throw const AuthException(
        'Could not reach the server. Please try again.',
      );
    }
  }

  // ─── Registration ─────────────────────────────────────────────────────────

  /// Step 1 – request email OTP. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> requestOtp(String email) async {
    final dynamic data = await _post(
      '/register/request-otp',
      body: {'email': email},
    );
    return data as Map<String, dynamic>;
  }

  /// Resend email OTP. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> resendOtp(String token) async {
    final dynamic data = await _post(
      '/register/resend-otp',
      body: {},
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }

  /// Step 2 – verify email OTP. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> verifyOtp(String token, String otp) async {
    final dynamic data = await _post(
      '/register/verify-otp',
      body: {'otp': otp},
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }

  /// Step 3 – request phone OTP. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> requestPhoneOtp(
    String token,
    String phone,
  ) async {
    final dynamic data = await _post(
      '/register/request-phone-otp',
      body: {'phone': phone},
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }

  /// Resend phone OTP. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> resendPhoneOtp(String token) async {
    final dynamic data = await _post(
      '/register/resend-phone-otp',
      body: {},
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }

  /// Step 4 – verify phone OTP. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> verifyPhoneOtp(String token, String otp) async {
    final dynamic data = await _post(
      '/register/verify-phone-otp',
      body: {'otp': otp},
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }

  /// Step 5 – submit profile. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> completeProfile(
    String token, {
    required String fullName,
    required String dateOfBirth,
    required String gender,
    required String city,
    required int preferredLanguageId,
    required int roleId,
    String? referralCode,
  }) async {
    final Map<String, dynamic> body = {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'city': city,
      'preferredLanguageId': preferredLanguageId,
      'roleId': roleId,
    };
    if (referralCode != null && referralCode.isNotEmpty) {
      body['referralCode'] = referralCode;
    }
    final dynamic data = await _post(
      '/register/profile',
      body: body,
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }

  // ─── Login ──────────────────────────────────────────────────────────────

  /// Email + password login. Returns `{accessToken, refreshToken, user}`.
  Future<Map<String, dynamic>> login(
    String email,
    String password, {
    String? deviceId,
    String? deviceName,
  }) async {
    final Map<String, dynamic> body = {'email': email, 'password': password};
    if (deviceId != null) body['deviceId'] = deviceId;
    if (deviceName != null) body['deviceName'] = deviceName;
    final dynamic data = await _post('/login', body: body);
    return data as Map<String, dynamic>;
  }

  // ─── Social login ────────────────────────────────────────────────────────

  /// Social login (google / apple). Returns either:
  ///   - `{accessToken, refreshToken, user}` for existing users, or
  ///   - `{requiresProfile: true, registrationToken, email?}` for new users.
  Future<Map<String, dynamic>> socialLogin(
    String provider,
    String idToken, {
    String? deviceId,
    String? deviceName,
  }) async {
    final Map<String, dynamic> body = {'idToken': idToken};
    if (deviceId != null) body['deviceId'] = deviceId;
    if (deviceName != null) body['deviceName'] = deviceName;
    final dynamic data = await _post('/social/$provider', body: body);
    return data as Map<String, dynamic>;
  }

  // ─── Password reset ──────────────────────────────────────────────────────

  /// Request a password-reset OTP email. Returns `{registrationToken}`.
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final dynamic data = await _post(
      '/password/forgot',
      body: {'email': email},
    );
    return data as Map<String, dynamic>;
  }

  /// Submit OTP + new password to complete the reset. Returns nothing on success.
  Future<void> resetPassword(
    String token, {
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _post(
      '/password/reset',
      body: {
        'otp': otp,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
      bearerToken: token,
    );
  }

  // ─── Social profile completion ───────────────────────────────────────────

  /// Completes a social (Google/Apple) sign-up after phone OTP verification.
  /// Returns auth tokens + user (no password step needed).
  Future<Map<String, dynamic>> completeSocialProfile(
    String token, {
    required String fullName,
    required String dateOfBirth,
    required String gender,
    required String city,
    int preferredLanguageId = 1,
    int roleId = 1,
    String? referralCode,
    String? deviceId,
    String? deviceName,
  }) async {
    final Map<String, dynamic> body = {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'city': city,
      'preferredLanguageId': preferredLanguageId,
      'roleId': roleId,
    };
    if (referralCode != null && referralCode.isNotEmpty) {
      body['referralCode'] = referralCode;
    }
    if (deviceId != null) body['deviceId'] = deviceId;
    if (deviceName != null) body['deviceName'] = deviceName;
    final dynamic data = await _post(
      '/social/complete-profile',
      body: body,
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }

  // ─── Step 6 – set password and finalise account ──────────────────────────

  /// Step 6 – set password and finalise account. Returns auth tokens + user.
  Future<Map<String, dynamic>> completeRegistration(
    String token, {
    required String password,
    required String confirmPassword,
    String? deviceId,
    String? deviceName,
  }) async {
    final Map<String, dynamic> body = {
      'password': password,
      'confirmPassword': confirmPassword,
    };
    if (deviceId != null) body['deviceId'] = deviceId;
    if (deviceName != null) body['deviceName'] = deviceName;
    final dynamic data = await _post(
      '/register/complete',
      body: body,
      bearerToken: token,
    );
    return data as Map<String, dynamic>;
  }
}
