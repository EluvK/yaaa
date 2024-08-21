import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/markdown_message.dart';

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

  final colorScheme = Get.theme.colorScheme;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var currentConversationUuid =
          conversationController.currentConversationUuid.value;
      if (currentConversationUuid.isEmpty) {
        // todo maybe add some quick guide module
        return const Center(child: Text('No conversation'));
      }
      return _buildConversation(conversationController.conversationList
          .firstWhere((element) => element.uuid == currentConversationUuid));
    });
  }

  Widget _buildConversation(Conversation conversation) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _conversationScrollController,
      itemCount: messageController.messageList.length,
      itemBuilder: (context, index) {
        return _compMessage(messageController.messageList[index]);
      },
    );
  }

  Widget _compMessage(Message message) {
    bool isUser = message.role == MessageRole.user;
    return ListTile(
      leading: isUser
          ? const SizedBox(width: 25)
          : const Icon(Icons.computer, size: 25),
      trailing: isUser
          ? const Icon(Icons.person, size: 25)
          : const SizedBox(width: 25),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primaryContainer
              : colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownRenderer(data: message.text),
            const SizedBox(height: 5),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // !this row have a little big minimum width because of this timestamp, use expanded can avoid it.
                Expanded(
                  child: Text(message.createdAt.toString().split('.')[0],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')));
                    },
                    icon: const Icon(Icons.copy, size: 16))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
