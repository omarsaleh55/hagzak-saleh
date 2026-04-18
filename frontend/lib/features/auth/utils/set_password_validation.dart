import '../models/set_password_page_placeholder.dart';

/// Frontend password checks aligned with [SetPasswordRequirementData] rules.
class SetPasswordValidation {
  SetPasswordValidation._();

  static const int maxBars = 4;

  static String? inferRuleFromLabel(String label) {
    final String l = label.toLowerCase();
    if (l.contains('8') && l.contains('character')) {
      return 'min_length_8';
    }
    if (l.contains('number') || l.contains('digit')) {
      return 'digit';
    }
    if (l.contains('special')) {
      return 'special';
    }
    if (l.contains('no') && l.contains('space')) {
      return 'no_whitespace';
    }
    return null;
  }

  static String? _ruleFor(SetPasswordRequirementData item) {
    return item.rule ?? inferRuleFromLabel(item.label);
  }

  static bool _ruleMet(String rule, String password) {
    switch (rule) {
      case 'min_length_8':
        return password.length >= 8;
      case 'digit':
        return RegExp(r'\d').hasMatch(password);
      case 'special':
        return RegExp(r'[^A-Za-z0-9\s]').hasMatch(password);
      case 'no_whitespace':
        return !RegExp(r'\s').hasMatch(password);
      default:
        return false;
    }
  }

  /// One entry per [requirements] row (same order).
  static List<bool> requirementStates(
    String password,
    List<SetPasswordRequirementData> requirements,
  ) {
    return requirements
        .map((SetPasswordRequirementData r) {
          final String? rule = _ruleFor(r);
          if (rule == null) {
            return false;
          }
          return _ruleMet(rule, password);
        })
        .toList(growable: false);
  }

  static int activeBarCount(List<bool> met) {
    return met.where((bool m) => m).length.clamp(0, maxBars);
  }

  static bool allRequirementsMet(List<bool> met) =>
      met.isNotEmpty && met.every((bool m) => m);

  static String strengthLabel(int bars, String password) {
    if (password.isEmpty) {
      return 'Strength: —';
    }
    switch (bars.clamp(0, maxBars)) {
      case 0:
        return 'Strength: Too weak';
      case 1:
        return 'Strength: Weak';
      case 2:
        return 'Strength: Fair';
      case 3:
        return 'Strength: Good';
      default:
        return 'Strength: Strong';
    }
  }

  static String strengthHint(int bars, String password) {
    if (password.isEmpty) {
      return 'Enter a password';
    }
    final int pct = ((bars / maxBars) * 100).round();
    return '$pct% Secure';
  }
}
