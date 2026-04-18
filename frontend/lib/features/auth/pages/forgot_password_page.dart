import 'package:flutter/material.dart';

import '../../../core/constants/auth_colors.dart';
import '../../../core/router/app_router.dart';
import '../models/auth_placeholder_data.dart';
import '../services/auth_service.dart';
import '../utils/email_validation.dart';
import '../widgets/forgot_password_footer.dart';
import '../widgets/forgot_password_form_card.dart';
import '../widgets/forgot_password_hero.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _showRequiredEmailError = false;
  bool _isLoading = false;

  String get _email => _emailController.text.trim();

  String? get _emailErrorText => EmailValidation.errorText(
    _email,
    showRequiredMessage: _showRequiredEmailError,
  );

  bool get _canSubmit => EmailValidation.isValid(_email) && !_isLoading;

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

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onSendCode() async {
    final String? errorText = _emailErrorText;
    if (errorText != null) {
      setState(() => _showRequiredEmailError = true);
      _showInfoMessage(errorText);
      return;
    }
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.forgotPassword(_email);
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.resetPassword);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showInfoMessage(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onBackToSignIn() {
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    const data = AuthPlaceholderData.forgotPasswordPage;
    final hero = data['hero'] as Map<String, dynamic>;
    final form = data['form'] as Map<String, dynamic>;
    final backLabel = data['back_label'] as String;
    final footer = data['footer'] as String;

    return Scaffold(
      backgroundColor: AuthColors.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ForgotPasswordHero(
                          badge: hero['badge'] as String,
                          titleLine1: hero['title_line1'] as String,
                          titleLine2: hero['title_line2'] as String,
                          description: hero['description'] as String,
                        ),
                        const SizedBox(height: 40),
                        ForgotPasswordFormCard(
                          emailLabel: form['email_label'] as String,
                          emailPlaceholder: form['email_placeholder'] as String,
                          submitLabel: form['submit_label'] as String,
                          emailController: _emailController,
                          emailFocusNode: _emailFocusNode,
                          emailErrorText: _emailErrorText,
                          canSubmit: _canSubmit,
                          onSubmit: _onSendCode,
                        ),
                        const SizedBox(height: 36),
                        Center(
                          child: ForgotPasswordBackLink(
                            label: backLabel,
                            onTap: _onBackToSignIn,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Center(child: ForgotPasswordCopyright(text: footer)),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
