import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';

class ChatboxCard extends StatefulWidget {
  const ChatboxCard({super.key});

  @override
  State<ChatboxCard> createState() => _ChatboxCardState();
}

class _ChatboxCardState extends State<ChatboxCard> {
  final FocusNode _chatBoxFocusNode = FocusNode();
  final _textController = TextEditingController();
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();
  final assistantController = Get.find<AssistantController>();

  bool _canSendMessage = false;

  late final _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  KeyEventResult _handleKeyPress(FocusNode focusNode, KeyEvent event) {
    if (event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        HardwareKeyboard.instance.isControlPressed) {
      _sendMessage();
      return KeyEventResult.handled;
    }
    // ctrl + r
    if (event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.keyR &&
        HardwareKeyboard.instance.isControlPressed) {
      print("add separator");
      _addSeparator();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    print("chatBoxFocusNode request focus");
    _chatBoxFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Column(
        children: [
          ExcludeFocus(child: buildClearContext(context)),
          buildChatBoxCard(context),
        ],
      ),
    );
  }

  Widget buildClearContext(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: ElevatedButton(
        onPressed: _addSeparator,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restart_alt),
            Text('  Clear Context'),
          ],
        ),
      ),
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
              focusNode: _focusNode,
              // autofocus: true,
              controller: _textController,
              onChanged: (text) {
                if (!HardwareKeyboard.instance.isControlPressed) {
                  print("text change, $text");
                  setState(() {
                    _canSendMessage = text.trim().isNotEmpty &&
                        !messageController.waitingForResponse &&
                        conversationController
                            .currentConversationUuid.value.isNotEmpty;
                  });
                }
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
          Column(
            children: [
              ElevatedButton(
                onPressed: _canSendMessage ? _sendMessage : null,
                child: _canSendMessage
                    ? const Icon(Icons.send)
                    : const Icon(Icons.do_not_disturb_on),
              ),
              const Text(
                "Ctrl+Enter",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (!_canSendMessage) {
      return;
    }
    final message = _textController.text.trim();
    if (message.isEmpty) {
      return;
    }
    setState(() {
      _textController.clear();
    });
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

  void _addSeparator() {
    if (messageController.waitingForResponse ||
        conversationController.currentConversationUuid.isEmpty) {
      return;
    }
    print((
      "this assistant",
      assistantController.assistantList,
      conversationController.currentConversationUuid,
      conversationController.currentConversationAssistantUuid
    ));
    Assistant? assistant = assistantController.getAssistant(
        conversationController.currentConversationAssistantUuid.string);

    if (assistant == null) {
      return;
    }

    final newPromptMessage = Message(
      uuid: const Uuid().v4(),
      conversationUuid: conversationController.currentConversationUuid.string,
      text: assistant.prompt,
      createdAt: DateTime.now(),
      role: MessageRole.system,
    );
    messageController.addMessage(newPromptMessage);
  }
}
