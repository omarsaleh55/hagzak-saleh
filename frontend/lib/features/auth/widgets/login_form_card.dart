import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../models/auth_placeholder_data.dart';

class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordHidden,
    required this.emailErrorText,
    required this.onTogglePasswordVisibility,
    required this.onForgotPassword,
    required this.onSignIn,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
    required this.canSignIn,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordHidden;
  final String? emailErrorText;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignIn;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;
  final bool canSignIn;

  @override
  Widget build(BuildContext context) {
    const data = AuthPlaceholderData.loginPage;
    final hero = data['hero'] as Map<String, dynamic>;
    final form = data['form'] as Map<String, dynamic>;
    final divider = data['divider'] as Map<String, dynamic>;
    final socialButtons = data['social_buttons'] as List<dynamic>;

    return Container(
      decoration: BoxDecoration(
        color: AuthColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hero['title'] as String,
            style: GoogleFonts.lexend(
              color: AuthColors.darkEmerald,
              fontWeight: FontWeight.w700,
              fontSize: 26,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hero['subtitle'] as String,
            style: GoogleFonts.workSans(
              color: AuthColors.onSurfaceVariant,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField(
            label: form['email_label'] as String,
            hint: form['email_placeholder'] as String,
            controller: emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline_rounded,
            errorText: emailErrorText,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(passwordFocusNode),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: form['password_label'] as String,
            hint: form['password_placeholder'] as String,
            controller: passwordController,
            focusNode: passwordFocusNode,
            obscureText: isPasswordHidden,
            prefixIcon: Icons.lock_outline_rounded,
            suffixIcon: isPasswordHidden
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixTap: onTogglePasswordVisibility,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSignIn(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: Text(
                form['forgot_password'] as String,
                style: GoogleFonts.workSans(
                  color: AuthColors.teal,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppPrimaryButton(
            onPressed: canSignIn ? onSignIn : null,
            label: form['sign_in_label'] as String,
          ),
          AppDivider(text: divider['text'] as String),
          _buildSocialButton(
            onTap: onGoogleSignIn,
            label: socialButtons[0]['label'] as String,
            icon: SvgPicture.asset(
              'assets/icons/google.svg',
              width: 24,
              height: 24,
            ),
            backgroundColor: AuthColors.surfaceContainerLowest,
            textColor: AuthColors.onSurface,
            borderColor: AuthColors.borderFaint,
          ),
          const SizedBox(height: 12),
          _buildSocialButton(
            onTap: onAppleSignIn,
            label: socialButtons[1]['label'] as String,
            icon: const FaIcon(
              FontAwesomeIcons.apple,
              size: 26,
              color: Colors.white,
            ),
            backgroundColor: const Color(0xFF1C1C1E),
            textColor: Colors.white,
            chevronColor: Colors.white54,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String label,
    required Widget icon,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    Color? chevronColor,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: chevronColor ?? AuthColors.outlineVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required IconData prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    String? errorText,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.workSans(
            color: AuthColors.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: GoogleFonts.workSans(
            color: AuthColors.darkEmerald,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.workSans(
              color: AuthColors.outlineVariant,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            filled: true,
            fillColor: AuthColors.surfaceContainerLow,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(prefixIcon, color: AuthColors.outline, size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(
                        suffixIcon,
                        color: AuthColors.outline,
                        size: 20,
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 44),
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
              borderSide: const BorderSide(color: AuthColors.teal, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }
}
