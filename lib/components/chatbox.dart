import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

class ChatboxCard extends StatefulWidget {
  const ChatboxCard({super.key});

  @override
  State<ChatboxCard> createState() => _ChatboxCardState();
}

class _ChatboxCardState extends State<ChatboxCard> {
  final _textController = TextEditingController();
  final conversationController = Get.find<ConversationController>();

  bool _canSendMessage = false;

  final bool _waitingForResponse = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: _textController,
              onChanged: (text) {
                setState(() {
                  _canSendMessage = text.trim().isNotEmpty &&
                      !_waitingForResponse &&
                      conversationController
                          .currentConversationUuid.value.isNotEmpty;
                });
              },
              minLines: 1,
              maxLines: 15,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Type a message',
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: _canSendMessage ? _sendMessage : null,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    // todo
    final message = _textController.text.trim();
    if (message.isEmpty) {
      return;
    }
    final messageController = Get.find<MessageController>();
    var conversationUuid = conversationController.currentConversationUuid.value;

    final newMessage = Message(
      uuid: const Uuid().v4(),
      conversationUuid: conversationUuid,
      text: message,
      createdAt: DateTime.now(),
      role: MessageRole.user,
    );
    messageController.addMessage(newMessage);
    _textController.clear();
  }
}
