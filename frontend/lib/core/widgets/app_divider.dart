import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, required this.text, this.scale = 1});

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: (24 * scale).clamp(20.0, 28.0)),
      child: Row(
        children: [
          const Expanded(
            child: Divider(color: Color(0xFFE1E4E2), thickness: 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (14 * scale).clamp(12.0, 16.0),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFFC7CCCA),
                fontSize: (12 * scale).clamp(11.0, 13.0),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const Expanded(
            child: Divider(color: Color(0xFFE1E4E2), thickness: 1),
          ),
        ],
      ),
    );
  }
}
