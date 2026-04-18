import 'dart:convert';

import 'package:flutter/services.dart';

class PhoneVerificationPagePlaceholder {
  const PhoneVerificationPagePlaceholder({
    required this.topBar,
    required this.hero,
    required this.form,
    required this.features,
    required this.footer,
  });

  final PhoneVerificationTopBarData topBar;
  final PhoneVerificationHeroData hero;
  final PhoneVerificationFormData form;
  final List<PhoneVerificationFeatureData> features;
  final PhoneVerificationFooterData footer;

  static Future<PhoneVerificationPagePlaceholder> fromAsset({
    String path = 'assets/placeholders/phone_verification_page.json',
  }) async {
    final String raw = await rootBundle.loadString(path);
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    return PhoneVerificationPagePlaceholder.fromJson(json);
  }

  factory PhoneVerificationPagePlaceholder.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawFeatures =
        json['features'] as List<dynamic>? ?? <dynamic>[];
    return PhoneVerificationPagePlaceholder(
      topBar: PhoneVerificationTopBarData.fromJson(
        json['top_bar'] as Map<String, dynamic>,
      ),
      hero: PhoneVerificationHeroData.fromJson(
        json['hero'] as Map<String, dynamic>,
      ),
      form: PhoneVerificationFormData.fromJson(
        json['form'] as Map<String, dynamic>,
      ),
      features: rawFeatures
          .map(
            (dynamic item) => PhoneVerificationFeatureData.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      footer: PhoneVerificationFooterData.fromJson(
        json['footer'] as Map<String, dynamic>,
      ),
    );
  }
}

class PhoneVerificationTopBarData {
  const PhoneVerificationTopBarData({required this.title});

  final String title;

  factory PhoneVerificationTopBarData.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationTopBarData(title: json['title'] as String);
  }
}

class PhoneVerificationHeroData {
  const PhoneVerificationHeroData({
    required this.titleLine1,
    required this.titleLine2,
    required this.description,
  });

  final String titleLine1;
  final String titleLine2;
  final String description;

  factory PhoneVerificationHeroData.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationHeroData(
      titleLine1: json['title_line_1'] as String,
      titleLine2: json['title_line_2'] as String,
      description: json['description'] as String,
    );
  }
}

class PhoneVerificationFormData {
  const PhoneVerificationFormData({
    required this.label,
    required this.countryCode,
    required this.phonePlaceholder,
    required this.buttonLabel,
    required this.helperText,
    required this.validationError,
  });

  final String label;
  final String countryCode;
  final String phonePlaceholder;
  final String buttonLabel;
  final String helperText;
  final String validationError;

  factory PhoneVerificationFormData.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationFormData(
      label: json['label'] as String,
      countryCode: json['country_code'] as String,
      phonePlaceholder: json['phone_placeholder'] as String,
      buttonLabel: json['button_label'] as String,
      helperText: json['helper_text'] as String,
      validationError:
          json['validation_error'] as String? ??
          'Use a valid Egyptian mobile number (10, 11, 12, or 15 prefix) with +20.',
    );
  }
}

class PhoneVerificationFeatureData {
  const PhoneVerificationFeatureData({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String icon;

  factory PhoneVerificationFeatureData.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationFeatureData(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
  }
}

class PhoneVerificationFooterData {
  const PhoneVerificationFooterData({required this.imageUrl});

  final String imageUrl;

  factory PhoneVerificationFooterData.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationFooterData(imageUrl: json['image_url'] as String);
  }
}
