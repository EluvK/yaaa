import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/chatbox.dart';
import 'package:yaaa/components/conversation.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/utils/save_conversation.dart';
import 'package:yaaa/utils/utils.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isMobile(context)
          ? null
          : const PreferredSize(
              preferredSize: Size.fromHeight(56.0),
              child: ExcludeFocus(child: ConversationAppBar()),
            ),
      body: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(children: [
          ExcludeFocus(child: Expanded(child: ConversationCard())),
          ChatboxCard(),
        ]),
      ),
    );
  }
}

class ConversationAppBar extends StatefulWidget {
  const ConversationAppBar({super.key});

  @override
  State<ConversationAppBar> createState() => _ConversationAppBarState();
}

class _ConversationAppBarState extends State<ConversationAppBar> {
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      var currentAssistantName =
          conversationController.currentConversationAssistantName.value;
      return AppBar(
        title: Text(currentAssistantName),
        centerTitle: false,
        flexibleSpace: Container(color: colorScheme.surface),
        actions: [
          // todo
          IconButton(
            onPressed: () {
              if (conversationController
                  .currentConversationUuid.value.isNotEmpty) {
                final conversation =
                    conversationController.conversationList.firstWhere(
                  (element) =>
                      element.uuid ==
                      conversationController.currentConversationUuid.value,
                );
                final messages = messageController.messageList;
                SaveConversation.saveConversation(conversation, messages);
              }
            },
            icon: const Icon(Icons.save),
          ),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      );
    });
  }
}
