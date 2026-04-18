class EmailValidation {
  EmailValidation._();

  static final RegExp _emailPattern = RegExp(
    r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
    caseSensitive: false,
  );

  static bool isValid(String value) {
    return _emailPattern.hasMatch(value.trim());
  }

  static String? errorText(String value, {bool showRequiredMessage = false}) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return showRequiredMessage ? 'Enter your email address.' : null;
    }
    if (!isValid(trimmed)) {
      return 'Use a valid email format like name@example.com.';
    }
    return null;
  }
}
