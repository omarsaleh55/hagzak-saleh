import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import '../models/verification_page_placeholder.dart';
import '../services/auth_service.dart';
import '../services/registration_session.dart';
import '../widgets/otp_input_row.dart';
import '../widgets/resend_code_section.dart';
import '../widgets/verification_action_button.dart';
import '../widgets/verification_header.dart';
import '../widgets/verification_pitch_graphic.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late final Future<VerificationPagePlaceholder> _placeholderFuture;
  String _otpValue = '';
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _placeholderFuture = VerificationPagePlaceholder.fromAsset();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onVerify() async {
    if (_isVerifying) return;
    final VerificationPagePlaceholder placeholder = await _placeholderFuture;
    if (_otpValue.length != placeholder.otp.length) return;
    setState(() => _isVerifying = true);
    try {
      await AuthService.instance.verifyOtp(_otpValue);
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.phoneVerification);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _onResend() async {
    if (_isResending) return;
    setState(() => _isResending = true);
    try {
      await AuthService.instance.resendOtp();
      if (!mounted) return;
      _showInfo('A new verification code was sent to your email.');
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VerificationPagePlaceholder>(
      future: _placeholderFuture,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<VerificationPagePlaceholder> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final VerificationPagePlaceholder data = snapshot.data!;
            // Use the actual email from the session if available.
            final String email =
                RegistrationSession.instance.email ?? data.header.email;
            final bool canVerify =
                _otpValue.length == data.otp.length && !_isVerifying;
            final double screenWidth = MediaQuery.sizeOf(context).width;
            final bool isTablet = screenWidth >= 900;
            final bool isIpad = screenWidth >= 600 && screenWidth < 900;
            final double contentMaxWidth = isTablet
                ? 720
                : isIpad
                ? 560
                : 420;
            final double horizontalPadding = isTablet
                ? 28
                : isIpad
                ? 20
                : 10;

            return Scaffold(
              backgroundColor: const Color(0xFFF3F4F5),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    const double designWidth = 390;
                    final double bodyWidth =
                        constraints.maxWidth < contentMaxWidth
                        ? constraints.maxWidth
                        : contentMaxWidth;
                    final double scale = (bodyWidth / designWidth).clamp(
                      0.72,
                      1.7,
                    );

                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding * scale,
                            (isIpad || isTablet ? 26 : 22) * scale,
                            horizontalPadding * scale,
                            (isIpad || isTablet ? 16 : 10) * scale,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              VerificationHeader(
                                title: data.header.title,
                                descriptionPrefix:
                                    data.header.descriptionPrefix,
                                email: email,
                                descriptionSuffix:
                                    data.header.descriptionSuffix,
                                scale: scale,
                              ),
                              SizedBox(height: 28 * scale),
                              OtpInputRow(
                                length: data.otp.length,
                                placeholder: data.otp.placeholder,
                                scale: scale,
                                onChanged: (String otp) {
                                  if (!mounted || otp == _otpValue) return;
                                  setState(() => _otpValue = otp);
                                },
                                onCompleted: _onVerify,
                              ),
                              SizedBox(height: 24 * scale),
                              ResendCodeSection(
                                question: data.resend.question,
                                actionLabel: _isResending
                                    ? 'Sending…'
                                    : data.resend.action,
                                scale: scale,
                                onResend: _isResending ? () {} : _onResend,
                              ),
                              SizedBox(
                                height: (isIpad || isTablet ? 40 : 34) * scale,
                              ),
                              VerificationPitchGraphic(
                                timerPrefix: data.timer.prefix,
                                timerValue: data.timer.value,
                                maxWidth:
                                    (isTablet
                                        ? 500
                                        : isIpad
                                        ? 420
                                        : 342) *
                                    scale,
                                maxHeight:
                                    (isTablet
                                        ? 424
                                        : isIpad
                                        ? 356
                                        : 290) *
                                    scale,
                                minWidth: 212.09 * scale,
                                minHeight: 180 * scale,
                              ),
                              SizedBox(
                                height: (isIpad || isTablet ? 22 : 18) * scale,
                              ),
                              VerificationActionButton(
                                label: _isVerifying
                                    ? 'Verifying…'
                                    : data.action.label,
                                scale: scale,
                                onPressed: canVerify ? _onVerify : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
    );
  }
}
