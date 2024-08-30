import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/pages/assistants.dart';
import 'package:yaaa/pages/setting.dart';
import 'package:yaaa/utils/page_opener.dart';

final conversationController = Get.find<ConversationController>();

Map<ShortcutActivator, Intent> yaaaShortCuts = {
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.tab):
      const NextConversationIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
      LogicalKeyboardKey.tab): const NextConversationIntent(reverse: true),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
      const NewConversationIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.comma):
      const EditSettingIntent(),
};

Map<Type, Action<Intent>> yaaaActions = {
  NextConversationIntent: NextConversationAction(conversationController),
  NewConversationIntent: NewConversationAction(),
  EditSettingIntent: EditSettingAction(),
};

// Ctrl (+ Shift) + Tab switch to next(pre) conversation
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
        await controller
            .setCurrentConversation(controller.conversationList[nextIndex]);
      }
    }
  }
}

// Ctrl + N create new conversation
class NewConversationIntent extends Intent {
  const NewConversationIntent();
}

class NewConversationAction extends Action<NewConversationIntent> {
  @override
  void invoke(covariant NewConversationIntent intent) {
    print('handle new conversation $intent');
    PageOpener.openPage(Get.context!, const AssistantsPage());
  }
}

// Ctrl + , edit App setting
class EditSettingIntent extends Intent {
  const EditSettingIntent();
}

class EditSettingAction extends Action<EditSettingIntent> {
  @override
  void invoke(covariant EditSettingIntent intent) {
    print('handle new conversation $intent');
    PageOpener.openPage(Get.context!, const SettingPage());
  }
}
