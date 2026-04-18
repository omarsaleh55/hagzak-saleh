import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ForgotPasswordFormCard extends StatelessWidget {
  const ForgotPasswordFormCard({
    super.key,
    required this.emailLabel,
    required this.emailPlaceholder,
    required this.submitLabel,
    required this.emailController,
    required this.emailFocusNode,
    required this.emailErrorText,
    required this.canSubmit,
    required this.onSubmit,
  });

  final String emailLabel;
  final String emailPlaceholder;
  final String submitLabel;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final String? emailErrorText;
  final bool canSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: AuthColors.lime),
              Expanded(
                child: Container(
                  color: AuthColors.surfaceContainerLowest,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emailLabel,
                        style: GoogleFonts.workSans(
                          color: AuthColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => onSubmit(),
                        autofillHints: const [AutofillHints.email],
                        style: GoogleFonts.workSans(
                          color: AuthColors.darkEmerald,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: emailPlaceholder,
                          hintStyle: GoogleFonts.workSans(
                            color: AuthColors.outlineVariant,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor: AuthColors.surfaceContainerLow,
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.mail_outline_rounded,
                              color: AuthColors.outline,
                              size: 20,
                            ),
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 44,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AuthColors.teal,
                              width: 1.2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.2,
                            ),
                          ),
                          errorText: emailErrorText,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSubmit ? onSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthColors.lime,
          foregroundColor: AuthColors.onLime,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              submitLabel,
              style: GoogleFonts.workSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}
