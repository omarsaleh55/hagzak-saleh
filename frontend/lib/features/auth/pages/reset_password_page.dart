import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';
import '../../../core/router/app_router.dart';
import '../models/set_password_page_placeholder.dart';
import '../services/auth_service.dart';
import '../services/registration_session.dart';
import '../utils/set_password_validation.dart';
import '../widgets/otp_input_row.dart';
import '../widgets/set_password_input_field.dart';
import '../widgets/set_password_match_hint.dart';
import '../widgets/set_password_requirements_grid.dart';
import '../widgets/set_password_strength_indicator.dart';

/// Shown after the user requests a password-reset email.
/// The user enters the 6-digit OTP from their email plus their new password.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isSubmitting = false;
  String _otp = '';

  // Hard-coded requirements matching the backend's passwordSchema.
  static const List<SetPasswordRequirementData> _requirements =
      <SetPasswordRequirementData>[
        SetPasswordRequirementData(
          label: 'At least 8 characters',
          met: false,
          rule: 'min_length_8',
        ),
        SetPasswordRequirementData(
          label: 'At least one number',
          met: false,
          rule: 'digit',
        ),
        SetPasswordRequirementData(
          label: 'At least one special character',
          met: false,
          rule: 'special',
        ),
        SetPasswordRequirementData(
          label: 'No spaces',
          met: false,
          rule: 'no_whitespace',
        ),
      ];

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onFieldChanged() => setState(() {});

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  Future<void> _onSubmit() async {
    if (_isSubmitting) return;
    if (_otp.length != 6) {
      _showError('Please enter the 6-digit code from your email.');
      return;
    }
    final String password = _passwordController.text;
    final String confirm = _confirmController.text;
    final List<bool> met = SetPasswordValidation.requirementStates(
      password,
      _requirements,
    );
    if (!SetPasswordValidation.allRequirementsMet(met) || password != confirm) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await AuthService.instance.resetPassword(
        otp: _otp,
        newPassword: password,
        confirmPassword: confirm,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully. Please sign in.'),
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String email = RegistrationSession.instance.email ?? 'your email';
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final EdgeInsets viewPadding = MediaQuery.paddingOf(context);
    final bool isTablet = screenWidth >= 900;
    final bool isIpad = screenWidth >= 600 && screenWidth < 900;
    final double contentMaxWidth = isTablet
        ? 720
        : isIpad
        ? 600
        : 430;
    final double horizontalPadding = isTablet
        ? 40
        : isIpad
        ? 32
        : 24;
    const double designWidth = 390;
    final double layoutWidth = (screenWidth - horizontalPadding * 2).clamp(
      260.0,
      contentMaxWidth,
    );
    final double scale = (layoutWidth / designWidth).clamp(
      0.9,
      isTablet
          ? 1.28
          : isIpad
          ? 1.16
          : 1.05,
    );

    final String password = _passwordController.text;
    final String confirm = _confirmController.text;
    final List<bool> met = SetPasswordValidation.requirementStates(
      password,
      _requirements,
    );
    final int bars = SetPasswordValidation.activeBarCount(met);
    final List<SetPasswordRequirementData> liveRequirements =
        List<SetPasswordRequirementData>.generate(
          _requirements.length,
          (int i) => SetPasswordRequirementData(
            label: _requirements[i].label,
            rule: _requirements[i].rule,
            met: met[i],
          ),
        );
    final bool canSubmit =
        _otp.length == 6 &&
        SetPasswordValidation.allRequirementsMet(met) &&
        password.isNotEmpty &&
        password == confirm &&
        !_isSubmitting;

    return Scaffold(
      backgroundColor: AuthColors.surface,
      body: Stack(
        children: <Widget>[
          // Background blobs
          Positioned(
            top: -96 * scale,
            right: -96 * scale,
            child: Container(
              width: 384 * scale,
              height: 384 * scale,
              decoration: BoxDecoration(
                color: AuthColors.darkEmerald.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.5 - 300 * scale,
            left: -180 * scale,
            child: Container(
              width: 600 * scale,
              height: 600 * scale,
              decoration: BoxDecoration(
                color: AuthColors.teal.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Scrollable content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                viewPadding.top + (24 * scale).clamp(20.0, 32.0),
                horizontalPadding,
                (120 * scale).clamp(100.0, 140.0) + viewPadding.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AuthColors.darkEmerald,
                        onPressed: () => Navigator.maybePop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(height: (20 * scale).clamp(16.0, 28.0)),

                      // Header
                      Text(
                        'Reset password',
                        style: GoogleFonts.lexend(
                          color: AuthColors.darkEmerald,
                          fontWeight: FontWeight.w700,
                          fontSize: (26 * scale).clamp(22.0, 32.0),
                        ),
                      ),
                      SizedBox(height: (8 * scale).clamp(6.0, 12.0)),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.workSans(
                            color: AuthColors.onSurfaceVariant,
                            fontSize: (14 * scale).clamp(13.0, 16.0),
                          ),
                          children: <InlineSpan>[
                            const TextSpan(
                              text: 'Enter the 6-digit code sent to ',
                            ),
                            TextSpan(
                              text: email,
                              style: GoogleFonts.workSans(
                                color: AuthColors.darkEmerald,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: ', then choose a new password.',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: (32 * scale).clamp(26.0, 40.0)),

                      // OTP label
                      Text(
                        'VERIFICATION CODE',
                        style: GoogleFonts.workSans(
                          color: AuthColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          fontSize: (12 * scale).clamp(11.0, 14.0),
                          letterSpacing: 0.9,
                        ),
                      ),
                      SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
                      OtpInputRow(
                        length: 6,
                        placeholder: '0',
                        scale: scale,
                        onChanged: (String v) => setState(() => _otp = v),
                      ),

                      SizedBox(height: (32 * scale).clamp(26.0, 40.0)),

                      // New password
                      SetPasswordInputField(
                        label: 'NEW PASSWORD',
                        placeholder: 'Enter new password',
                        obscureText: _isPasswordHidden,
                        scale: scale,
                        controller: _passwordController,
                        onChanged: (_) => _onFieldChanged(),
                        onToggleVisibility: () => setState(
                          () => _isPasswordHidden = !_isPasswordHidden,
                        ),
                      ),
                      SizedBox(height: (14 * scale).clamp(12.0, 18.0)),
                      SetPasswordStrengthIndicator(
                        label: SetPasswordValidation.strengthLabel(
                          bars,
                          password,
                        ),
                        hint: SetPasswordValidation.strengthHint(
                          bars,
                          password,
                        ),
                        activeCount: bars,
                        scale: scale,
                      ),
                      SizedBox(height: (22 * scale).clamp(18.0, 28.0)),
                      SetPasswordRequirementsGrid(
                        items: liveRequirements,
                        scale: scale,
                      ),
                      SizedBox(height: (26 * scale).clamp(22.0, 32.0)),

                      // Confirm password
                      SetPasswordInputField(
                        label: 'CONFIRM PASSWORD',
                        placeholder: 'Re-enter new password',
                        obscureText: true,
                        scale: scale,
                        controller: _confirmController,
                        onChanged: (_) => _onFieldChanged(),
                      ),
                      if (confirm.isNotEmpty &&
                          confirm != password) ...<Widget>[
                        SizedBox(height: (10 * scale).clamp(8.0, 14.0)),
                        SetPasswordMatchHint(
                          text: 'Passwords do not match.',
                          scale: scale,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Fixed bottom button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: AuthColors.surface,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                viewPadding.bottom + 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: SizedBox(
                    width: double.infinity,
                    height: (54 * scale).clamp(50.0, 60.0),
                    child: ElevatedButton(
                      onPressed: canSubmit ? _onSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AuthColors.teal,
                        disabledBackgroundColor: AuthColors.teal.withValues(
                          alpha: 0.4,
                        ),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            (14 * scale).clamp(12.0, 18.0),
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isSubmitting ? 'Resetting…' : 'Reset Password',
                        style: GoogleFonts.workSans(
                          fontWeight: FontWeight.w600,
                          fontSize: (16 * scale).clamp(14.0, 18.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
