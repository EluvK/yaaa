import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

class ConversationCard extends StatefulWidget {
  const ConversationCard({super.key});

  @override
  State<ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  final _conversationScrollController = ScrollController();

  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var currentConversationUuid =
          conversationController.currentConversationUuid.value;
      if (conversationController.conversationList.isNotEmpty &&
          conversationController.currentConversationUuid.value.isEmpty) {
        currentConversationUuid =
            conversationController.conversationList.first.uuid;
        conversationController
            .setCurrentConversationUuid(currentConversationUuid);
        messageController.loadMessages(currentConversationUuid);
        print(("build _compConversation", currentConversationUuid));
        // return const Center(child: CircularProgressIndicator());
      }
      if (currentConversationUuid.isEmpty) {
        // todo maybe add some quick guide module
        return const Expanded(child: Text('No conversation'));
      }
      return Expanded(
          child: _buildConversation(conversationController.conversationList
              .firstWhere(
                  (element) => element.uuid == currentConversationUuid)));
    });
  }

  Widget _buildConversation(Conversation conversation) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListView.builder(
          shrinkWrap: true,
          controller: _conversationScrollController,
          itemCount: messageController.messageList.length,
          itemBuilder: (context, index) {
            return _compMessage(messageController.messageList[index]);
          },
        ),
      ],
    );
  }

  Widget _compMessage(Message message) {
    return ListTile(
      title: Text(message.text),
      subtitle: Text(message.createdAt.toString()),
    );
  }
}
