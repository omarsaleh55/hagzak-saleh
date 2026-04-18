import 'dart:convert';

import 'package:flutter/services.dart';

class SetPasswordPagePlaceholder {
  const SetPasswordPagePlaceholder({
    required this.topBar,
    required this.hero,
    required this.fields,
    required this.requirements,
    required this.securityImage,
    required this.footer,
  });

  final SetPasswordTopBarData topBar;
  final SetPasswordHeroData hero;
  final SetPasswordFieldsData fields;
  final List<SetPasswordRequirementData> requirements;
  final SetPasswordSecurityImageData securityImage;
  final SetPasswordFooterData footer;

  static Future<SetPasswordPagePlaceholder> fromAsset({
    String path = 'assets/placeholders/set_password_page.json',
  }) async {
    final String raw = await rootBundle.loadString(path);
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    return SetPasswordPagePlaceholder.fromJson(json);
  }

  factory SetPasswordPagePlaceholder.fromJson(Map<String, dynamic> json) {
    return SetPasswordPagePlaceholder(
      topBar: SetPasswordTopBarData.fromJson(
        json['top_bar'] as Map<String, dynamic>,
      ),
      hero: SetPasswordHeroData.fromJson(json['hero'] as Map<String, dynamic>),
      fields: SetPasswordFieldsData.fromJson(
        json['fields'] as Map<String, dynamic>,
      ),
      requirements: (json['requirements'] as List<dynamic>)
          .map(
            (dynamic item) => SetPasswordRequirementData.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      securityImage: SetPasswordSecurityImageData.fromJson(
        json['security_image'] as Map<String, dynamic>,
      ),
      footer: SetPasswordFooterData.fromJson(
        json['footer'] as Map<String, dynamic>,
      ),
    );
  }
}

class SetPasswordTopBarData {
  const SetPasswordTopBarData({required this.title});

  final String title;

  factory SetPasswordTopBarData.fromJson(Map<String, dynamic> json) {
    return SetPasswordTopBarData(title: json['title'] as String);
  }
}

class SetPasswordHeroData {
  const SetPasswordHeroData({
    required this.stepLabel,
    required this.titleLine1,
    required this.titleLine2,
    required this.description,
  });

  final String stepLabel;
  final String titleLine1;
  final String titleLine2;
  final String description;

  factory SetPasswordHeroData.fromJson(Map<String, dynamic> json) {
    return SetPasswordHeroData(
      stepLabel: json['step_label'] as String,
      titleLine1: json['title_line_1'] as String,
      titleLine2: json['title_line_2'] as String,
      description: json['description'] as String,
    );
  }
}

class SetPasswordFieldsData {
  const SetPasswordFieldsData({
    required this.newPasswordLabel,
    required this.newPasswordPlaceholder,
    required this.confirmPasswordLabel,
    required this.confirmPasswordPlaceholder,
    required this.strengthLabel,
    required this.strengthHint,
    required this.activeStrengthBars,
  });

  final String newPasswordLabel;
  final String newPasswordPlaceholder;
  final String confirmPasswordLabel;
  final String confirmPasswordPlaceholder;
  final String strengthLabel;
  final String strengthHint;
  final int activeStrengthBars;

  factory SetPasswordFieldsData.fromJson(Map<String, dynamic> json) {
    return SetPasswordFieldsData(
      newPasswordLabel: json['new_password_label'] as String,
      newPasswordPlaceholder: json['new_password_placeholder'] as String,
      confirmPasswordLabel: json['confirm_password_label'] as String,
      confirmPasswordPlaceholder:
          json['confirm_password_placeholder'] as String,
      strengthLabel: json['strength_label'] as String,
      strengthHint: json['strength_hint'] as String,
      activeStrengthBars: json['active_strength_bars'] as int,
    );
  }
}

class SetPasswordRequirementData {
  const SetPasswordRequirementData({
    required this.label,
    required this.met,
    this.rule,
  });

  final String label;

  /// Placeholder JSON value; UI uses live validation instead.
  final bool met;

  /// One of: `min_length_8`, `digit`, `special`, `no_whitespace`.
  final String? rule;

  factory SetPasswordRequirementData.fromJson(Map<String, dynamic> json) {
    return SetPasswordRequirementData(
      label: json['label'] as String,
      met: json['met'] as bool? ?? false,
      rule: json['rule'] as String?,
    );
  }
}

class SetPasswordSecurityImageData {
  const SetPasswordSecurityImageData({
    required this.imageUrl,
    required this.caption,
  });

  final String imageUrl;
  final String caption;

  factory SetPasswordSecurityImageData.fromJson(Map<String, dynamic> json) {
    return SetPasswordSecurityImageData(
      imageUrl: json['image_url'] as String,
      caption: json['caption'] as String,
    );
  }
}

class SetPasswordFooterData {
  const SetPasswordFooterData({
    required this.buttonLabel,
    required this.termsText,
  });

  final String buttonLabel;
  final String termsText;

  factory SetPasswordFooterData.fromJson(Map<String, dynamic> json) {
    return SetPasswordFooterData(
      buttonLabel: json['button_label'] as String,
      termsText: json['terms_text'] as String,
    );
  }
}
