import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:yaaa/controller/conversation.dart';

final conversationController = Get.find<ConversationController>();

Map<ShortcutActivator, Intent> yaaaShortCuts = {
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.tab):
      const NextConversationIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
      LogicalKeyboardKey.tab): const NextConversationIntent(reverse: true),
};

Map<Type, Action<Intent>> yaaaActions = {
  NextConversationIntent: NextConversationAction(conversationController),
};

class NextConversationIntent extends Intent {
  final bool reverse;
  const NextConversationIntent({this.reverse = false});
}

class NextConversationAction extends Action<NextConversationIntent> {
  NextConversationAction(this.controller);

  final ConversationController controller;

  @override
  void invoke(covariant NextConversationIntent intent) async {
    print('handle switch to next conversation $intent');

    if (controller.currentConversationAssistantUuid.value != '') {
      // find next conversation to set to it
      int currentIndex = controller.conversationList.indexWhere(
          (e) => e.uuid == controller.currentConversationUuid.value);
      if (currentIndex != -1) {
        int nextIndex = (currentIndex + (intent.reverse ? -1 : 1)) %
            controller.conversationList.length;
        controller
            .setCurrentConversation(controller.conversationList[nextIndex]);
      }
    }
  }
}
