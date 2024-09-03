import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/utils/utils.dart';

class DoubleClickButton<T extends ButtonStyleButton> extends StatefulWidget {
  final Widget Function(VoidCallback onPressed) buttonBuilder;
  final VoidCallback onDoubleClick;
  final String firstClickHint;
  final Duration resetDuration;

  const DoubleClickButton({
    super.key,
    required this.buttonBuilder,
    required this.onDoubleClick,
    required this.firstClickHint,
    this.resetDuration = const Duration(seconds: 2),
  });

  @override
  State<DoubleClickButton> createState() => _DoubleClickButtonState();
}

class _DoubleClickButtonState extends State<DoubleClickButton> {
  int _clickCount = 0;
  Timer? _resetTimer;

  void _handleButtonClick() {
    setState(() {
      _clickCount++;
      if (_clickCount == 1) {
        flushBar(
            FlushLevel.WARNING, 'double_click_hint'.tr, widget.firstClickHint);
        _startResetTimer();
      } else if (_clickCount == 2) {
        _resetTimer?.cancel();
        widget.onDoubleClick();
        _clickCount = 0; // 重置计数器
      }
    });
  }

  void _startResetTimer() {
    _resetTimer?.cancel();
    _resetTimer = Timer(widget.resetDuration, () {
      setState(() {
        _clickCount = 0;
      });
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buttonBuilder(_handleButtonClick);
  }
}
