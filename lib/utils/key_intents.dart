import 'package:flutter/material.dart';

class KCallbackAction<T extends Intent> extends CallbackAction<T> {
  KCallbackAction({required void Function(T) super.onInvoke});
}

class UnFocusIntent extends Intent {
  const UnFocusIntent();
}

class SendTextIntent extends Intent {
  const SendTextIntent();
}

class ClearContextIntent extends Intent {
  const ClearContextIntent();
}

// Ctrl (+ Shift) + Tab switch to next(pre) conversation
class NextConversationIntent extends Intent {
  final bool reverse;
  const NextConversationIntent({this.reverse = false});
}
