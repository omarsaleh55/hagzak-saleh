/// All placeholder / mock values for the Sign-In page in JSON format.
/// Replace values here when connecting to a real backend.
abstract final class AuthPlaceholderData {
  static const Map<String, dynamic> signInPage = {
    'brand': {
      'name': 'SIGN UP',
      'logo_text': 'PP',
      'tagline': 'TIME TO STEP UP',
    },
    'hero': {'heading_line1': 'READY TO', 'heading_line2': 'PLAY?'},
    'form': {
      'email_label': 'EMAIL ADDRESS',
      'email_placeholder': 'coach@pitchside.com',
      'continue_label': 'CONTINUE',
    },
    'divider': {'text': 'OR'},
    'social_buttons': [
      {'id': 'google', 'label': 'Sign in with Google', 'type': 'google'},
      {'id': 'apple', 'label': 'Sign in with Apple', 'type': 'apple'},
    ],
    'footer': {'question': 'Already have an account?', 'action': 'Sign in'},
    'badge': {'text': 'ELITE ACCESS'},
    'user': {'avatar_url': null, 'display_name': 'Guest'},
  };

  static const Map<String, dynamic> loginPage = {
    'header': {
      'title': 'PITCH PRESENCE',
      'subtitle': 'ELITE COURT RESERVATIONS',
    },
    'hero': {
      'title': 'Sign In',
      'subtitle': 'Access your squad and upcoming matches.',
    },
    'form': {
      'email_label': 'EMAIL ADDRESS',
      'email_placeholder': 'coach@example.com',
      'password_label': 'SECURITY KEY',
      'password_placeholder': '••••••••',
      'forgot_password': 'Forgot Password?',
      'sign_in_label': 'SIGN IN',
    },
    'divider': {'text': 'OR CONTINUE WITH'},
    'social_buttons': [
      {'id': 'google', 'label': 'Sign in with Google', 'type': 'google'},
      {'id': 'apple', 'label': 'Sign in with Apple', 'type': 'apple'},
    ],
    'footer': {'question': 'New to the squad?', 'action': 'Sign Up'},
  };

  static const Map<String, dynamic> forgotPasswordPage = {
    'top_bar': {'title': 'FORGET PASSWORD', 'logo_text': 'PP'},
    'hero': {
      'badge': 'RECOVERY MODE',
      'title_line1': 'FORGOT',
      'title_line2': 'PASSWORD?',
      'description':
          'No worries, coach. Enter your email and we\'ll send you a code to get back in the game.',
    },
    'form': {
      'email_label': 'COACH EMAIL ADDRESS',
      'email_placeholder': 'name@club.com',
      'submit_label': 'Send Verification Code',
    },
    'back_label': 'BACK TO SIGN IN',
    'footer': 'PITCH PRESENCE ELITE ANALYTICS & BOOKING SYSTEMS © 2024',
  };
}
