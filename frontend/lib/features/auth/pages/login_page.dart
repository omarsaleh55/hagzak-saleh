import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/auth_colors.dart';
import '../../../core/router/app_router.dart';
import '../services/auth_service.dart';
import '../utils/email_validation.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form_card.dart';
import '../widgets/login_hero_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ── Form state ──────────────────────────────────────────────────────────────

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordHidden = true;
  bool _showRequiredEmailError = false;
  bool _isLoading = false;

  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text;

  String? get _emailErrorText => EmailValidation.errorText(
    _email,
    showRequiredMessage: _showRequiredEmailError,
  );

  bool get _canSignIn =>
      EmailValidation.isValid(_email) && _password.isNotEmpty && !_isLoading;

  // ── Google sign-in ──────────────────────────────────────────────────────────

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: AppConfig.googleWebClientId,
    scopes: <String>['email', 'profile'],
  );

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _emailFocusNode.addListener(_onEmailFocusChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onFieldChanged);
    _emailController.dispose();
    _passwordController.removeListener(_onFieldChanged);
    _passwordController.dispose();
    _emailFocusNode.removeListener(_onEmailFocusChanged);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _onFieldChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onEmailFocusChanged() {
    if (!mounted) return;
    if (!_emailFocusNode.hasFocus && _email.isEmpty) {
      setState(() => _showRequiredEmailError = true);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  // ── Email/password login ─────────────────────────────────────────────────────

  Future<void> _onSignIn() async {
    if (_isLoading) return;
    final String? errorText = _emailErrorText;
    if (errorText != null) {
      setState(() => _showRequiredEmailError = true);
      _showError(errorText);
      return;
    }
    if (_password.isEmpty) {
      _showError('Enter your password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.login(_email, _password);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onForgotPassword() {
    Navigator.pushNamed(context, AppRoutes.forgotPassword);
  }

  void _onSignUp() {
    Navigator.pushNamed(context, AppRoutes.signIn);
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordHidden = !_isPasswordHidden);
  }

  // ── Social sign-in common handler ────────────────────────────────────────────

  Future<void> _handleSocialResult(Future<bool> Function() socialCall) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final bool requiresProfile = await socialCall();
      if (!mounted) return;
      if (requiresProfile) {
        // New social user — must verify phone before completing profile.
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.phoneVerification,
          (_) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError('Sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Google sign-in ───────────────────────────────────────────────────────────

  void _onGoogleSignIn() {
    _handleSocialResult(_doGoogleSignIn);
  }

  Future<bool> _doGoogleSignIn() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) throw const AuthException('Google sign-in cancelled.');
    final GoogleSignInAuthentication auth = await account.authentication;
    final String? idToken = auth.idToken;
    if (idToken == null) {
      throw const AuthException('Failed to get Google ID token.');
    }
    return AuthService.instance.socialLogin('google', idToken);
  }

  // ── Apple sign-in ────────────────────────────────────────────────────────────

  void _onAppleSignIn() {
    _handleSocialResult(_doAppleSignIn);
  }

  Future<bool> _doAppleSignIn() async {
    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
          scopes: <AppleIDAuthorizationScopes>[
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
    final String? idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Failed to get Apple identity token.');
    }
    return AuthService.instance.socialLogin('apple', idToken);
  }

  // ── UI ───────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.surfaceContainerLowest,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeaderWithOverlappingCard(),
            const SizedBox(height: 20),
            LoginFooter(onSignUp: _onSignUp),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithOverlappingCard() {
    const double headerVisibleHeight = 150;
    const double overlapHeight = 30;

    return Stack(
      children: <Widget>[
        const LoginHeroHeader(height: headerVisibleHeight + overlapHeight),
        Column(
          children: <Widget>[
            const SizedBox(height: headerVisibleHeight),
            LoginFormCard(
              emailController: _emailController,
              passwordController: _passwordController,
              emailFocusNode: _emailFocusNode,
              passwordFocusNode: _passwordFocusNode,
              isPasswordHidden: _isPasswordHidden,
              emailErrorText: _emailErrorText,
              onTogglePasswordVisibility: _togglePasswordVisibility,
              onForgotPassword: _onForgotPassword,
              onSignIn: _canSignIn ? _onSignIn : () {},
              onGoogleSignIn: _isLoading ? () {} : _onGoogleSignIn,
              onAppleSignIn: _isLoading ? () {} : _onAppleSignIn,
              canSignIn: _canSignIn,
            ),
          ],
        ),
      ],
    );
  }
}
