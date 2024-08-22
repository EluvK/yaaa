import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final messageController = Get.find<MessageController>();

  bool _canSendMessage = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      child: buildChatBoxCard(context),
      onKeyEvent: (event) {
        // shift + enter
        if (event is KeyUpEvent &&
            event.logicalKey == LogicalKeyboardKey.enter &&
            HardwareKeyboard.instance.isShiftPressed) {
          if (_canSendMessage) {
            _sendMessage();
          }
          return;
        }
        if (event is KeyUpEvent &&
            event.logicalKey == LogicalKeyboardKey.keyR &&
            HardwareKeyboard.instance.isControlPressed) {
          // print("add_seperator");
          // todo
          return;
        }
      },
    );
  }

  Widget buildChatBoxCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _textController,
              onChanged: (text) {
                setState(() {
                  _canSendMessage = text.trim().isNotEmpty &&
                      !messageController.waitingForResponse &&
                      conversationController
                          .currentConversationUuid.value.isNotEmpty;
                });
              },
              minLines: 1,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                // hintText: 'Type a message',
                labelText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                // prefixIcon: Icon(Icons.person),
                // filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: _canSendMessage ? _sendMessage : null,
            child: _canSendMessage
                ? const Icon(Icons.send)
                : const Icon(Icons.do_not_disturb_on),
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
    setState(() {
      _textController.clear();
    });
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
  }
}
