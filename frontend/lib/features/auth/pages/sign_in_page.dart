import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_social_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/auth_placeholder_data.dart';
import '../services/auth_service.dart';
import '../utils/email_validation.dart';
import '../widgets/sign_in_footer.dart';
import '../widgets/sign_in_hero.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _showRequiredEmailError = false;
  bool _isLoading = false;
  bool _isSocialLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: AppConfig.googleWebClientId,
    scopes: <String>['email', 'profile'],
  );

  String get _email => _emailController.text.trim();

  String? get _emailErrorText => EmailValidation.errorText(
    _email,
    showRequiredMessage: _showRequiredEmailError,
  );

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _emailFocusNode.addListener(_onEmailFocusChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    _emailFocusNode.removeListener(_onEmailFocusChanged);
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
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

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onContinue() async {
    if (_isLoading) return;
    final String? errorText = _emailErrorText;
    if (errorText != null) {
      setState(() => _showRequiredEmailError = true);
      _showError(errorText);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.requestOtp(_email);
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.verification);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Social sign-in ──────────────────────────────────────────────────────────

  Future<void> _handleSocialResult(Future<bool> Function() socialCall) async {
    if (_isSocialLoading) return;
    setState(() => _isSocialLoading = true);
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
      _showInfoMessage(e.message);
    } catch (_) {
      if (!mounted) return;
      _showInfoMessage('Sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isSocialLoading = false);
    }
  }

  void _onGoogleSignIn() {
    _handleSocialResult(() async {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw const AuthException('Google sign-in cancelled.');
      }
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null) {
        throw const AuthException('Failed to get Google ID token.');
      }
      return AuthService.instance.socialLogin('google', idToken);
    });
  }

  void _onAppleSignIn() {
    _handleSocialResult(() async {
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
    });
  }

  void _onSignUp() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFCFB),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double viewportWidth = constraints.maxWidth;
            final bool isTablet = viewportWidth >= 900;
            final bool isIpad = viewportWidth >= 600 && viewportWidth < 900;
            final double horizontalPadding = isTablet
                ? 36
                : isIpad
                ? 28
                : 24;
            final double contentMaxWidth = isTablet
                ? 980
                : isIpad
                ? 720
                : 430;
            const double designWidth = 390;
            final double scaleBasis = isTablet
                ? 420
                : isIpad
                ? 400
                : (viewportWidth - (horizontalPadding * 2)).clamp(300.0, 390.0);
            final double scale = (scaleBasis / designWidth).clamp(
              0.9,
              isTablet
                  ? 1.08
                  : isIpad
                  ? 1.02
                  : 0.98,
            );
            final double topPadding =
                (isTablet
                    ? 52
                    : isIpad
                    ? 44
                    : 40) *
                scale;
            final double bottomPadding = (isTablet ? 40 : 32) * scale;
            final double minScrollHeight =
                constraints.maxHeight - topPadding - bottomPadding;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minScrollHeight > 0 ? minScrollHeight : 0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                    child: isTablet
                        ? _buildTabletLayout(scale)
                        : _buildMobileLayout(scale),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(double scale) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignInHero(scale: scale),
          SizedBox(height: (38 * scale).clamp(32.0, 46.0)),
          _buildLoginCard(scale),
          SizedBox(height: (28 * scale).clamp(24.0, 36.0)),
          SignInFooter(onSignUp: _onSignUp, scale: scale),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(double scale) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 960),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: (48 * scale).clamp(36.0, 56.0)),
              child: SignInHero(scale: scale),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoginCard(scale),
                SizedBox(height: (24 * scale).clamp(20.0, 30.0)),
                SignInFooter(onSignUp: _onSignUp, scale: scale),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(double scale) {
    final form =
        (AuthPlaceholderData.signInPage['form'] as Map<String, dynamic>);
    final socialButtons =
        (AuthPlaceholderData.signInPage['social_buttons'] as List<dynamic>);
    final divider =
        (AuthPlaceholderData.signInPage['divider'] as Map<String, dynamic>);

    return AppCard(
      padding: EdgeInsets.all((24 * scale).clamp(20.0, 28.0)),
      child: Column(
        children: [
          AppTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            label: form['email_label'] as String,
            hintText: form['email_placeholder'] as String,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.email],
            errorText: _emailErrorText,
            onSubmitted: (_) => _onContinue(),
            scale: scale,
          ),
          SizedBox(height: (24 * scale).clamp(20.0, 28.0)),
          AppPrimaryButton(
            onPressed: _isLoading || !EmailValidation.isValid(_email)
                ? null
                : _onContinue,
            label: _isLoading
                ? 'Please wait…'
                : form['continue_label'] as String,
            scale: scale,
          ),
          AppDivider(text: divider['text'] as String, scale: scale),
          AppGoogleButton(
            onPressed: _onGoogleSignIn,
            label: socialButtons[0]['label'] as String,
            scale: scale,
          ),
          SizedBox(height: (12 * scale).clamp(10.0, 16.0)),
          AppAppleButton(
            onPressed: _onAppleSignIn,
            label: socialButtons[1]['label'] as String,
            scale: scale,
          ),
        ],
      ),
    );
  }
}
