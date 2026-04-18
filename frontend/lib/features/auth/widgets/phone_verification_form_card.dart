import 'package:flutter/material.dart';

import '../models/phone_verification_page_placeholder.dart';
import '../utils/egypt_phone_validation.dart';
import 'phone_verification_country_field.dart';
import 'phone_verification_helper_text.dart';
import 'phone_verification_label.dart';
import 'phone_verification_number_field.dart';
import 'phone_verification_send_button.dart';

class PhoneVerificationFormCard extends StatelessWidget {
  const PhoneVerificationFormCard({
    super.key,
    required this.data,
    required this.scale,
    required this.controller,
    required this.onSendCode,
  });

  final PhoneVerificationFormData data;
  final double scale;
  final TextEditingController controller;
  final VoidCallback onSendCode;

  @override
  Widget build(BuildContext context) {
    final bool valid = EgyptPhoneValidation.isValidEgyptianPhone(
      data.countryCode,
      controller.text,
    );
    final String? numberError = controller.text.isNotEmpty && !valid
        ? data.validationError
        : null;

    final double cardPadding = (16 * scale).clamp(14.0, 24.0);
    final double innerGap = (12 * scale).clamp(10.0, 16.0);
    final double fieldGap = (10 * scale).clamp(10.0, 14.0);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stackedFields = constraints.maxWidth < 310;

        return Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F3),
            borderRadius: BorderRadius.circular((12 * scale).clamp(10.0, 18.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PhoneVerificationLabel(text: data.label, scale: scale),
              SizedBox(height: innerGap),
              if (stackedFields) ...<Widget>[
                PhoneVerificationCountryField(
                  value: data.countryCode,
                  scale: scale,
                ),
                SizedBox(height: fieldGap),
                PhoneVerificationNumberField(
                  controller: controller,
                  placeholder: data.phonePlaceholder,
                  scale: scale,
                  errorText: numberError,
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 36,
                      child: PhoneVerificationCountryField(
                        value: data.countryCode,
                        scale: scale,
                      ),
                    ),
                    SizedBox(width: fieldGap),
                    Expanded(
                      flex: 64,
                      child: PhoneVerificationNumberField(
                        controller: controller,
                        placeholder: data.phonePlaceholder,
                        scale: scale,
                        errorText: numberError,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: (16 * scale).clamp(14.0, 22.0)),
              PhoneVerificationSendButton(
                label: data.buttonLabel,
                scale: scale,
                onPressed: valid ? onSendCode : null,
              ),
              SizedBox(height: innerGap),
              PhoneVerificationHelperText(text: data.helperText, scale: scale),
            ],
          ),
        );
      },
    );
  }
}
