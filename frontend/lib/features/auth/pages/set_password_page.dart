import 'package:flutter/material.dart';

import '../../../core/constants/auth_colors.dart';
import '../../../core/router/app_router.dart';
import '../models/set_password_page_placeholder.dart';
import '../services/auth_service.dart';
import '../utils/set_password_validation.dart';
import '../widgets/set_password_footer_action_area.dart';
import '../widgets/set_password_hero.dart';
import '../widgets/set_password_input_field.dart';
import '../widgets/set_password_match_hint.dart';
import '../widgets/set_password_requirements_grid.dart';
import '../widgets/set_password_security_image_card.dart';
import '../widgets/set_password_strength_indicator.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  late final Future<SetPasswordPagePlaceholder> _placeholderFuture;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _placeholderFuture = SetPasswordPagePlaceholder.fromAsset();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _onPasswordFieldsChanged() {
    setState(() {});
  }

  Future<void> _submitIfValid(
    List<SetPasswordRequirementData> requirements,
  ) async {
    if (_isSubmitting) return;
    final String password = _passwordController.text;
    final String confirm = _confirmController.text;
    final List<bool> met = SetPasswordValidation.requirementStates(
      password,
      requirements,
    );
    if (!SetPasswordValidation.allRequirementsMet(met) ||
        password.isEmpty ||
        password != confirm) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await AuthService.instance.completeRegistration(
        password: password,
        confirmPassword: confirm,
      );
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SetPasswordPagePlaceholder>(
      future: _placeholderFuture,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<SetPasswordPagePlaceholder> snapshot,
          ) {
            if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: AuthColors.surface,
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load set password page:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final SetPasswordPagePlaceholder data = snapshot.data!;
            final Size screenSize = MediaQuery.sizeOf(context);
            final EdgeInsets viewPadding = MediaQuery.paddingOf(context);
            final double screenWidth = screenSize.width;
            final double screenHeight = screenSize.height;
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
            final double layoutWidth = (screenWidth - (horizontalPadding * 2))
                .clamp(260.0, contentMaxWidth)
                .toDouble();
            final double scale = (layoutWidth / designWidth).clamp(
              0.9,
              isTablet
                  ? 1.28
                  : isIpad
                  ? 1.16
                  : 1.05,
            );
            final double footerBaseHeight = isTablet
                ? 164
                : isIpad
                ? 148
                : (132 * scale).clamp(124.0, 144.0);

            final String passwordText = _passwordController.text;
            final String confirmText = _confirmController.text;
            final List<bool> requirementMet =
                SetPasswordValidation.requirementStates(
                  passwordText,
                  data.requirements,
                );
            final int activeBars = SetPasswordValidation.activeBarCount(
              requirementMet,
            );
            final List<SetPasswordRequirementData> liveRequirements =
                List<SetPasswordRequirementData>.generate(
                  data.requirements.length,
                  (int i) => SetPasswordRequirementData(
                    label: data.requirements[i].label,
                    met: requirementMet[i],
                    rule: data.requirements[i].rule,
                  ),
                );
            final bool canSubmit =
                SetPasswordValidation.allRequirementsMet(requirementMet) &&
                passwordText.isNotEmpty &&
                passwordText == confirmText;

            return Scaffold(
              backgroundColor: AuthColors.surface,
              body: Stack(
                children: <Widget>[
                  Positioned.fill(child: Container(color: AuthColors.surface)),
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
                    top: (screenHeight * 0.5) - (300 * scale),
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
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        viewPadding.top + (24 * scale).clamp(20.0, 32.0),
                        horizontalPadding,
                        footerBaseHeight +
                            viewPadding.bottom +
                            (28 * scale).clamp(24.0, 36.0),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: contentMaxWidth,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SetPasswordHero(
                                stepLabel: data.hero.stepLabel,
                                titleLine1: data.hero.titleLine1,
                                titleLine2: data.hero.titleLine2,
                                description: data.hero.description,
                                scale: scale,
                              ),
                              SizedBox(height: (40 * scale).clamp(32.0, 48.0)),
                              SetPasswordInputField(
                                label: data.fields.newPasswordLabel,
                                placeholder: data.fields.newPasswordPlaceholder,
                                obscureText: _isPasswordHidden,
                                scale: scale,
                                controller: _passwordController,
                                onChanged: (_) => _onPasswordFieldsChanged(),
                                onToggleVisibility: _togglePasswordVisibility,
                              ),
                              SizedBox(height: (14 * scale).clamp(12.0, 18.0)),
                              SetPasswordStrengthIndicator(
                                label: SetPasswordValidation.strengthLabel(
                                  activeBars,
                                  passwordText,
                                ),
                                hint: SetPasswordValidation.strengthHint(
                                  activeBars,
                                  passwordText,
                                ),
                                activeCount: activeBars,
                                scale: scale,
                              ),
                              SizedBox(height: (22 * scale).clamp(18.0, 28.0)),
                              SetPasswordRequirementsGrid(
                                items: liveRequirements,
                                scale: scale,
                              ),
                              SizedBox(height: (26 * scale).clamp(22.0, 32.0)),
                              SetPasswordInputField(
                                label: data.fields.confirmPasswordLabel,
                                placeholder:
                                    data.fields.confirmPasswordPlaceholder,
                                obscureText: true,
                                scale: scale,
                                controller: _confirmController,
                                onChanged: (_) => _onPasswordFieldsChanged(),
                              ),
                              if (confirmText.isNotEmpty &&
                                  confirmText != passwordText) ...<Widget>[
                                SizedBox(height: (10 * scale).clamp(8.0, 14.0)),
                                SetPasswordMatchHint(
                                  text: 'Passwords do not match.',
                                  scale: scale,
                                ),
                              ],
                              SizedBox(height: (44 * scale).clamp(34.0, 52.0)),
                              SetPasswordSecurityImageCard(
                                imageUrl: data.securityImage.imageUrl,
                                caption: data.securityImage.caption,
                                scale: scale,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SetPasswordFooterActionArea(
                      buttonLabel: data.footer.buttonLabel,
                      termsText: data.footer.termsText,
                      scale: scale,
                      bottomInset: viewPadding.bottom,
                      maxWidth: contentMaxWidth,
                      horizontalPadding: horizontalPadding,
                      onPressed: canSubmit
                          ? () => _submitIfValid(data.requirements)
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
