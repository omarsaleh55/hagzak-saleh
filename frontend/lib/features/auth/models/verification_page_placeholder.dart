import 'dart:convert';

import 'package:flutter/services.dart';

class VerificationPagePlaceholder {
  const VerificationPagePlaceholder({
    required this.topBar,
    required this.header,
    required this.otp,
    required this.resend,
    required this.timer,
    required this.action,
  });

  final VerificationTopBarData topBar;
  final VerificationHeaderData header;
  final VerificationOtpData otp;
  final VerificationResendData resend;
  final VerificationTimerData timer;
  final VerificationActionData action;

  static Future<VerificationPagePlaceholder> fromAsset({
    String path = 'assets/placeholders/verification_page.json',
  }) async {
    final String raw = await rootBundle.loadString(path);
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    return VerificationPagePlaceholder.fromJson(json);
  }

  factory VerificationPagePlaceholder.fromJson(Map<String, dynamic> json) {
    return VerificationPagePlaceholder(
      topBar: VerificationTopBarData.fromJson(
        json['top_bar'] as Map<String, dynamic>,
      ),
      header: VerificationHeaderData.fromJson(
        json['header'] as Map<String, dynamic>,
      ),
      otp: VerificationOtpData.fromJson(json['otp'] as Map<String, dynamic>),
      resend: VerificationResendData.fromJson(
        json['resend'] as Map<String, dynamic>,
      ),
      timer: VerificationTimerData.fromJson(
        json['timer'] as Map<String, dynamic>,
      ),
      action: VerificationActionData.fromJson(
        json['action'] as Map<String, dynamic>,
      ),
    );
  }
}

class VerificationTopBarData {
  const VerificationTopBarData({required this.title});

  final String title;

  factory VerificationTopBarData.fromJson(Map<String, dynamic> json) {
    return VerificationTopBarData(title: json['title'] as String);
  }
}

class VerificationHeaderData {
  const VerificationHeaderData({
    required this.title,
    required this.descriptionPrefix,
    required this.email,
    required this.descriptionSuffix,
  });

  final String title;
  final String descriptionPrefix;
  final String email;
  final String descriptionSuffix;

  factory VerificationHeaderData.fromJson(Map<String, dynamic> json) {
    return VerificationHeaderData(
      title: json['title'] as String,
      descriptionPrefix: json['description_prefix'] as String,
      email: json['email'] as String,
      descriptionSuffix: json['description_suffix'] as String,
    );
  }
}

class VerificationOtpData {
  const VerificationOtpData({
    required this.length,
    required this.placeholder,
    required this.prefill,
  });

  final int length;
  final String placeholder;
  final List<String> prefill;

  factory VerificationOtpData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawPrefill = json['prefill'] as List<dynamic>? ?? [];
    return VerificationOtpData(
      length: json['length'] as int,
      placeholder: json['placeholder'] as String,
      prefill: rawPrefill.map((dynamic value) => value.toString()).toList(),
    );
  }
}

class VerificationResendData {
  const VerificationResendData({required this.question, required this.action});

  final String question;
  final String action;

  factory VerificationResendData.fromJson(Map<String, dynamic> json) {
    return VerificationResendData(
      question: json['question'] as String,
      action: json['action'] as String,
    );
  }
}

class VerificationTimerData {
  const VerificationTimerData({required this.prefix, required this.value});

  final String prefix;
  final String value;

  factory VerificationTimerData.fromJson(Map<String, dynamic> json) {
    return VerificationTimerData(
      prefix: json['prefix'] as String,
      value: json['value'] as String,
    );
  }
}

class VerificationActionData {
  const VerificationActionData({required this.label});

  final String label;

  factory VerificationActionData.fromJson(Map<String, dynamic> json) {
    return VerificationActionData(label: json['label'] as String);
  }
}
