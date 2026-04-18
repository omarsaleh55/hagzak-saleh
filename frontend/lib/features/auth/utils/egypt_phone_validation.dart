/// Frontend checks for Egyptian numbers: country code +20 and national mobile format.
class EgyptPhoneValidation {
  EgyptPhoneValidation._();

  /// True when the country selector label reflects Egypt / +20.
  static bool countryLabelIndicatesEgypt(String countryLabel) {
    final String compact = countryLabel.toUpperCase().replaceAll(
      RegExp(r'\s'),
      '',
    );
    if (compact.contains('+20')) {
      return true;
    }
    if (countryLabel.toUpperCase().contains('EGYPT')) {
      return true;
    }
    // "EG" as a short code (e.g. "EG +20")
    final RegExp egToken = RegExp(r'(^|\s)EG(\s|$|\+)', caseSensitive: false);
    return egToken.hasMatch(countryLabel);
  }

  /// Validates [numberInput] together with [countryLabel] (must show Egypt).
  ///
  /// Accepts:
  /// - 10-digit national mobile (1xxxxxxxxx with 10/11/12/15 operator prefix)
  /// - 11 digits with leading 0 (domestic style)
  /// - Full international digits starting with 20 (12+ digits)
  /// - Optional `0020` prefix
  static bool isValidEgyptianPhone(String countryLabel, String numberInput) {
    if (!countryLabelIndicatesEgypt(countryLabel)) {
      return false;
    }
    final String digits = numberInput.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return false;
    }

    if (digits.startsWith('0020') && digits.length >= 14) {
      return _isValidNationalMobile(digits.substring(4));
    }
    if (digits.startsWith('20') && digits.length >= 12) {
      return _isValidNationalMobile(digits.substring(2));
    }
    if (digits.length == 11 && digits.startsWith('0')) {
      return _isValidNationalMobile(digits.substring(1));
    }
    if (digits.length == 10) {
      return _isValidNationalMobile(digits);
    }
    return false;
  }

  /// Egyptian mobile: 10 digits, operator blocks 10, 11, 12, 15.
  static bool _isValidNationalMobile(String ten) {
    if (ten.length != 10) {
      return false;
    }
    return ten.startsWith('10') ||
        ten.startsWith('11') ||
        ten.startsWith('12') ||
        ten.startsWith('15');
  }
}
