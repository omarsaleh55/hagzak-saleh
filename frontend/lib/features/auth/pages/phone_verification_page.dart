import 'package:flutter/material.dart';

import '../../../core/constants/auth_colors.dart';
import '../../../core/router/app_router.dart';
import '../models/phone_verification_page_placeholder.dart';
import '../services/auth_service.dart';
import '../utils/egypt_phone_validation.dart';
import '../widgets/phone_verification_feature_grid.dart';
import '../widgets/phone_verification_form_card.dart';
import '../widgets/phone_verification_hero.dart';
import '../widgets/phone_verification_top_bar.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  late final Future<PhoneVerificationPagePlaceholder> _placeholderFuture;
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _placeholderFuture = PhoneVerificationPagePlaceholder.fromAsset();
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  Future<void> _onSendCode(PhoneVerificationFormData form) async {
    if (_isLoading) return;
    if (!EgyptPhoneValidation.isValidEgyptianPhone(
      form.countryCode,
      _phoneController.text,
    )) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.requestPhoneOtp(_phoneController.text.trim());
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.phoneOtpVerification);
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PhoneVerificationPagePlaceholder>(
      future: _placeholderFuture,
      builder:
          (
            BuildContext context,
            AsyncSnapshot<PhoneVerificationPagePlaceholder> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final PhoneVerificationPagePlaceholder data = snapshot.data!;
            return Scaffold(
              backgroundColor: AuthColors.surface,
              appBar: PhoneVerificationTopBar(
                title: data.topBar.title,
                scale: 1.0,
                onBack: () => Navigator.maybePop(context),
              ),
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double viewportWidth = constraints.maxWidth;
                  final bool isTablet = viewportWidth >= 900;
                  final bool isIpad =
                      viewportWidth >= 600 && viewportWidth < 900;
                  final double contentMaxWidth = isTablet
                      ? 760
                      : isIpad
                      ? 560
                      : 360;
                  final double horizontalPadding = isTablet
                      ? 36
                      : isIpad
                      ? 30
                      : 22;
                  const double designWidth = 360;
                  final double contentWidth = viewportWidth < contentMaxWidth
                      ? viewportWidth
                      : contentMaxWidth;
                  final double scale = (contentWidth / designWidth).clamp(
                    0.96,
                    isTablet
                        ? 1.22
                        : isIpad
                        ? 1.12
                        : 1.02,
                  );
                  final double topPadding = isTablet
                      ? 24
                      : isIpad
                      ? 22
                      : 18;
                  final double heroGap = (26 * scale).clamp(22.0, 34.0);
                  final double cardGap = (22 * scale).clamp(18.0, 30.0);
                  final double bottomInset = MediaQuery.paddingOf(
                    context,
                  ).bottom;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          topPadding,
                          horizontalPadding,
                          bottomInset + 24,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: contentMaxWidth,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                PhoneVerificationHero(
                                  titleLine1: data.hero.titleLine1,
                                  titleLine2: data.hero.titleLine2,
                                  description: data.hero.description,
                                  scale: scale,
                                ),
                                SizedBox(height: heroGap),
                                PhoneVerificationFormCard(
                                  data: data.form,
                                  scale: scale,
                                  controller: _phoneController,
                                  onSendCode: _isLoading
                                      ? () {}
                                      : () => _onSendCode(data.form),
                                ),
                                SizedBox(height: cardGap),
                                PhoneVerificationFeatureGrid(
                                  items: data.features,
                                  scale: scale,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
    );
  }
}
