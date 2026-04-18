import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otp_digit_field.dart';

/// A row of OTP digit boxes backed by a single hidden [TextField].
///
/// Using one real input field means:
/// - Paste works out of the box (the OS paste menu fills all digits at once).
/// - Backspace naturally deletes the last digit.
/// - No complex focus management needed.
/// - No pre-filled / default values are shown.
///
/// [onCompleted] fires automatically when the user has entered all digits,
/// enabling auto-submit without pressing a button.
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({
    super.key,
    required this.length,
    required this.placeholder,
    this.scale = 1,
    required this.onChanged,
    this.onCompleted,
  });

  final int length;
  final String placeholder;
  final double scale;

  /// Called every time the OTP value changes.
  final ValueChanged<String> onChanged;

  /// Called once when all [length] digits have been entered.
  final VoidCallback? onCompleted;

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final String value = _controller.text;
    if (value == _otp) return;
    _otp = value;
    widget.onChanged(value);
    if (mounted) setState(() {});
    // Auto-submit when all digits are entered.
    if (value.length == widget.length) {
      // Dismiss keyboard so the UI feels "done".
      _focusNode.unfocus();
      widget.onCompleted?.call();
    }
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double fieldWidth = 48.0 * widget.scale;
        double fieldHeight = 56.0 * widget.scale;
        double spacing = 10.79 * widget.scale;
        double edgePadding = 24.02 * widget.scale;

        final double requiredWidth =
            (2 * edgePadding) +
            (widget.length * fieldWidth) +
            ((widget.length - 1) * spacing);

        if (requiredWidth > constraints.maxWidth) {
          final double shrink = constraints.maxWidth / requiredWidth;
          fieldWidth *= shrink;
          fieldHeight *= shrink;
          spacing *= shrink;
          edgePadding *= shrink;
        }

        final bool hasFocus = _focusNode.hasFocus;
        // The "active" box is the one where the next digit will land.
        final int activeIndex = _otp.length.clamp(0, widget.length - 1);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: edgePadding),
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: <Widget>[
              // ── Visual digit boxes ────────────────────────────────────────
              Row(
                children: List<Widget>.generate(widget.length, (int i) {
                  final String digit = i < _otp.length ? _otp[i] : '';
                  final bool isActive =
                      hasFocus &&
                      (i == activeIndex ||
                          (i == widget.length - 1 &&
                              _otp.length == widget.length));
                  return Padding(
                    padding: EdgeInsets.only(
                      right: i == widget.length - 1 ? 0 : spacing,
                    ),
                    child: OtpDigitField(
                      digit: digit,
                      placeholder: widget.placeholder,
                      width: fieldWidth,
                      height: fieldHeight,
                      isActive: isActive,
                    ),
                  );
                }),
              ),

              // ── Hidden real TextField ─────────────────────────────────────
              // Wrapped in Opacity(0) so every rendered pixel — including
              // cursor, selection handles, and the green triangle that the
              // platform draws — is completely invisible.
              // The widget is still interactive: taps focus it, the keyboard
              // opens, and paste works via the OS clipboard menu.
              Positioned.fill(
                child: Opacity(
                  opacity: 0.0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLength: widget.length,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    enableSuggestions: false,
                    autocorrect: false,
                    showCursor: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
