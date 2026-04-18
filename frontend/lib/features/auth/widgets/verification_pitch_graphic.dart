import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'verification_timer_badge.dart';

class VerificationPitchGraphic extends StatefulWidget {
  const VerificationPitchGraphic({
    super.key,
    required this.timerPrefix,
    required this.timerValue,
    this.maxWidth = 342,
    this.maxHeight = 290,
    this.minWidth = 212.09,
    this.minHeight = 180,
  });

  final String timerPrefix;

  /// Initial countdown as `mm:ss` (e.g. `01:59`); also accepts `h:mm:ss`.
  final String timerValue;
  final double maxWidth;
  final double maxHeight;
  final double minWidth;
  final double minHeight;

  @override
  State<VerificationPitchGraphic> createState() =>
      _VerificationPitchGraphicState();
}

class _VerificationPitchGraphicState extends State<VerificationPitchGraphic> {
  Timer? _timer;
  late int _remainingSeconds;

  static int _parseDurationSeconds(String value) {
    final String trimmed = value.trim();
    final List<String> parts = trimmed.split(':');
    if (parts.length == 2) {
      final int minutes = int.tryParse(parts[0]) ?? 0;
      final int seconds = int.tryParse(parts[1]) ?? 0;
      return (minutes * 60 + seconds).clamp(0, 24 * 3600);
    }
    if (parts.length == 3) {
      final int hours = int.tryParse(parts[0]) ?? 0;
      final int minutes = int.tryParse(parts[1]) ?? 0;
      final int seconds = int.tryParse(parts[2]) ?? 0;
      return (hours * 3600 + minutes * 60 + seconds).clamp(0, 48 * 3600);
    }
    return (int.tryParse(trimmed) ?? 0).clamp(0, 24 * 3600);
  }

  static String _formatMmSs(int totalSeconds) {
    final int safe = totalSeconds < 0 ? 0 : totalSeconds;
    final int minutes = safe ~/ 60;
    final int seconds = safe % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _parseDurationSeconds(widget.timerValue);
    if (_remainingSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    }
  }

  @override
  void didUpdateWidget(covariant VerificationPitchGraphic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timerValue != widget.timerValue) {
      _timer?.cancel();
      _timer = null;
      _remainingSeconds = _parseDurationSeconds(widget.timerValue);
      if (_remainingSeconds > 0) {
        _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
      }
    }
  }

  void _onTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    if (_remainingSeconds <= 0) {
      timer.cancel();
      return;
    }
    setState(() => _remainingSeconds--);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const svgContent =
        '''<svg width="100" height="100" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="5" y="5" width="90" height="90" rx="2" stroke="#012D1D" stroke-width="1.2"></rect>
<circle cx="50" cy="50" r="15" stroke="#012D1D" stroke-width="1.2"></circle>
<line x1="5" y1="50" x2="95" y2="50" stroke="#012D1D" stroke-width="1.2"></line>
<rect x="30" y="5" width="40" height="15" stroke="#012D1D" stroke-width="1.2"></rect>
<rect x="30" y="80" width="40" height="15" stroke="#012D1D" stroke-width="1.2"></rect>
</svg>''';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        final double effectiveMinWidth = widget.minWidth > availableWidth
            ? availableWidth
            : widget.minWidth;
        final double targetWidth = availableWidth < widget.maxWidth
            ? availableWidth
            : widget.maxWidth;
        final double containerWidth = targetWidth.clamp(
          effectiveMinWidth,
          widget.maxWidth,
        );

        final double widthDenominator = widget.maxWidth - effectiveMinWidth;
        final double widthRatio = widthDenominator <= 0
            ? 1
            : (containerWidth - effectiveMinWidth) / widthDenominator;
        final double containerHeight =
            widget.minHeight +
            ((widget.maxHeight - widget.minHeight) * widthRatio);

        return Center(
          child: SizedBox(
            width: containerWidth,
            height: containerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: containerWidth,
                  height: containerHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E8E8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: 0.22,
                      child: SvgPicture.string(
                        svgContent,
                        width: (containerWidth * 0.33).clamp(92.0, 132.0),
                        height: (containerWidth * 0.33).clamp(92.0, 132.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  child: VerificationTimerBadge(
                    prefix: widget.timerPrefix,
                    value: _formatMmSs(_remainingSeconds),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
