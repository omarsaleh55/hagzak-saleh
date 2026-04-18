import 'package:flutter/material.dart';

import '../../features/auth/pages/forgot_password_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/phone_otp_verification_page.dart';
import '../../features/auth/pages/phone_verification_page.dart';
import '../../features/auth/pages/profile_completion_page.dart';
import '../../features/auth/pages/reset_password_page.dart';
import '../../features/auth/pages/set_password_page.dart';
import '../../features/auth/pages/sign_in_page.dart';
import '../../features/auth/pages/verification_page.dart';
import '../../features/home/pages/home_page.dart';

abstract final class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String signIn = '/sign-in';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String explore = '/explore';
  static const String venueDetail = '/venue/:id';
  static const String bookings = '/bookings';
  static const String profile = '/profile';
  static const String setPassword = '/set-password';
  static const String verification = '/verification';
  static const String phoneVerification = '/phone-verification';
  static const String phoneOtpVerification = '/phone-otp-verification';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
      case AppRoutes.verification:
        return MaterialPageRoute(builder: (_) => const VerificationPage());
      case AppRoutes.phoneVerification:
        return MaterialPageRoute(builder: (_) => const PhoneVerificationPage());
      case AppRoutes.phoneOtpVerification:
        return MaterialPageRoute(
          builder: (_) => const PhoneOtpVerificationPage(),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileCompletionPage());
      case AppRoutes.setPassword:
        return MaterialPageRoute(builder: (_) => const SetPasswordPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
