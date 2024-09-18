import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/chatbox.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/utils/key_intents.dart';
import 'package:yaaa/utils/utils.dart';

class ChatboxCard extends StatefulWidget {
  const ChatboxCard({super.key});

  @override
  State<ChatboxCard> createState() => _ChatboxCardState();
}

class _ChatboxCardState extends State<ChatboxCard> {
  final _textController = TextEditingController();
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();
  final assistantController = Get.find<AssistantController>();
  final chatBoxController = Get.find<ChatBoxController>();
  late final FocusNode _focusNode; // get from chatBoxController

  bool _canSendMessage = false;

  late final KCallbackAction<UnFocusIntent> _unFocusAction;
  late final KCallbackAction<ClearContextIntent> _clearContextAction;
  late final KCallbackAction<SendTextIntent> _sendTextAction;
  late final Map<Type, Action<Intent>> actions = <Type, Action<Intent>>{
    UnFocusIntent: _unFocusAction,
    ClearContextIntent: _clearContextAction,
    SendTextIntent: _sendTextAction,
  };

  @override
  void initState() {
    super.initState();
    print("chatBoxFocusNode request focus");
    _focusNode = chatBoxController.chatBoxFocusNode;

    _unFocusAction =
        KCallbackAction<UnFocusIntent>(onInvoke: (UnFocusIntent intent) {
      _focusNode.unfocus();
    });
    _clearContextAction = KCallbackAction<ClearContextIntent>(
      onInvoke: (ClearContextIntent intent) {
        _addSeparator();
      },
    );
    _sendTextAction = KCallbackAction<SendTextIntent>(
      onInvoke: (SendTextIntent intent) {
        _sendMessage();
      },
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
      setState(() {});
      }
    });
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
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: _addSeparator,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restart_alt),
            Text('clear_context'.tr),
          ],
        ),
      ),
    );
  }

  Widget buildChatBoxCard(BuildContext context) {
    var chatTextField = TextField(
      focusNode: _focusNode,
      controller: _textController,
      onChanged: (text) {
        print("text change, $text");
        setState(() {
          _canSendMessage = text.trim().isNotEmpty &&
              !messageController.waitingForResponse &&
              conversationController.currentConversationUuid.value.isNotEmpty;
        });
      },
      minLines: 1,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: 'type_message_hint'.tr,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        // prefixIcon: const Icon(Icons.keyboard),
        // filled: true,
      ),
    );
    return Padding(
      padding: dynDevicePadding(4),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Shortcuts(
              shortcuts: <ShortcutActivator, Intent>{
                const SingleActivator(LogicalKeyboardKey.slash):
                    const DoNothingAndStopPropagationTextIntent(),
                const SingleActivator(LogicalKeyboardKey.escape):
                    const UnFocusIntent(),
                LogicalKeySet(
                        LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
                    const ClearContextIntent(),
                LogicalKeySet(
                        LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
                    const SendTextIntent()
              },
              child: Actions(actions: actions, child: chatTextField),
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
    messageController.chatSendMessage(newMessage);
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
    messageController.addMessageToCurrentConversation(newPromptMessage);
  }
}
