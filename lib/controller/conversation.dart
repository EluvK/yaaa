import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yaaa/client/client.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/pages/edit_conversation.dart';
import 'package:yaaa/utils/page_opener.dart';

class ConversationController extends GetxController {
  final conversationList = <Conversation>[].obs;

  final currentConversationUuid = ''.obs;
  final currentConversationAssistantName = 'yaaa'.obs;
  final currentConversationAssistantUuid = ''.obs;

  static ConversationController get to => Get.find<ConversationController>();

  final messageController = Get.find<MessageController>();

  @override
  Future<void> onInit() async {
    conversationList.value =
        await ConversationRepository().getAllConversations();
    super.onInit();
    _initialized = true;
  }

  bool _initialized = false;
  Future<void> ensureInitialization() async {
    while (!_initialized) {
      await onInit();
    }
    return;
  }

  setCurrentConversation(Conversation conversation) async {
    currentConversationUuid.value = conversation.uuid;
    currentConversationAssistantName.value = conversation.assistantName;
    currentConversationAssistantUuid.value = conversation.assistantUuid;
    await messageController.loadMessages(conversation.uuid);
  }

  addConversation(Conversation conversation) async {
    ConversationRepository().addConversation(conversation);
    conversationList.add(conversation);
    await setCurrentConversation(conversation);
  }

  void deleteConversation(String uuid) {
    if (currentConversationUuid.value == uuid) {
      currentConversationUuid.value = '';
      currentConversationAssistantName.value = 'yaaa';
      currentConversationAssistantUuid.value = '';
    }
    ConversationRepository().deleteConversation(uuid);
    conversationList.removeWhere((element) => element.uuid == uuid);
  }

  void updateConversation(Conversation conversation) {
    final index = conversationList
        .indexWhere((element) => element.uuid == conversation.uuid);
    if (index != -1) {
      conversationList[index] = conversation;
      ConversationRepository().updateConversation(conversation);
    }
  }

  editContactConversation(BuildContext context, Conversation conversation) {
    PageOpener.openPage(
        context, EditConversationPage(conversation: conversation));
  }

  int likeContactConversation(Conversation conversation) {
    int newPos = conversationList.fold(
        0, (previousValue, element) => previousValue + (element.like ? 1 : 0));
    newPos = conversation.like ? newPos - 1 : newPos;
    conversationList
        .removeWhere((element) => element.uuid == conversation.uuid);
    conversationList.insert(newPos, conversation);
    conversation.like = !conversation.like;
    ConversationRepository().updateConversation(conversation);
    return newPos;
  }
}

class MessageController extends GetxController {
  final messageList = <Message>[].obs;
  final viewIndexStart = 0.obs;
  final viewIndexEnd = 0.obs;
  final focusMessageUuid = "".obs;
  final hasMore = false.obs;
  final viewMessageList = <Message>[].obs;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  late final assistantController = Get.find<AssistantController>();
  late final conversationController = Get.find<ConversationController>();

  bool waitingForResponse = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    _initialized = true;
  }

  bool _initialized = false;
  Future<void> ensureInitialization() async {
    while (!_initialized) {
      await onInit();
    }
    return;
  }

  Future<void> loadMessages(String conversationUuid) async {
    print(("load message", conversationUuid));
    messageList.value =
        await ConversationRepository().getMessages(conversationUuid);

    // separate the message list into parts conversation
    // view only last full conversation, starts with the last system message
    viewIndexStart.value = messageList
        .lastIndexWhere((message) => message.role == MessageRole.system);
    viewIndexEnd.value = messageList.length;
    hasMore.value = viewIndexStart.value != -1 && viewIndexStart.value != 0;
    viewMessageList.clear();
    for (int i = viewIndexStart.value; i < viewIndexEnd.value; i++) {
      viewMessageList.add(messageList[i]);
    }
    print('load message / viewMessageList size: ${viewMessageList.length}');
    print('load message / messageList size: ${messageList.length}');
    print('load message / viewIndexStart: ${viewIndexStart.value}');
    print('load message / viewIndexEnd: ${viewIndexEnd.value}');
  }

  loadHistory() {
    // load more history messages
    if (!hasMore.value) {
      return;
    }
    var newViewIndexStart = messageList.lastIndexWhere(
        (message) => message.role == MessageRole.system,
        viewIndexStart.value - 1);
    if (newViewIndexStart == -1 || newViewIndexStart == 0) {
      hasMore.value = false;
    }

    for (int i = viewIndexStart.value - 1; i >= newViewIndexStart; i--) {
      viewMessageList.insert(0, messageList[i]);
    }
    // focusMessageUuid.value = messageList[viewIndexStart.value].uuid;
    focusMessageUuid.value = messageList[newViewIndexStart].uuid;

    viewIndexStart.value = newViewIndexStart;
    print('load history / viewMessageList size: ${viewMessageList.length}');
    print('load history / messageList size: ${messageList.length}');
    print('load history / viewIndexStart: ${viewIndexStart.value}');
    print('load history / viewIndexEnd: ${viewIndexEnd.value}');
  }

  focusMessage(String? messageUuid) {
    messageUuid = messageUuid ??
        (focusMessageUuid.value.isEmpty
            ? messageList.last.uuid
            : focusMessageUuid.value);
    var index =
        viewMessageList.indexWhere((message) => message.uuid == messageUuid);
    print('focusMessage / messageUuid: $messageUuid ,index $index');
    if (index == -1) {
      loadHistory();
      return focusMessage(messageUuid);
    }
    // 重置所有消息的高亮状态
    for (var message in viewMessageList) {
      message.isHighlighted = false;
    }
    viewMessageList[index].isHighlighted = true;
    viewMessageList.refresh();
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  insertNewMessageOnly(Message message) async {
    await ConversationRepository().addMessage(message);
  }

  addMessageToCurrentConversation(Message message) async {
    if (message.role == MessageRole.system &&
        messageList.isNotEmpty &&
        messageList.last.role == MessageRole.system) {
      print("return because last message is system message");
      return;
    }
    await insertNewMessageOnly(message);

    // it's too heavy to fully reload, try to add message dynamically
    // // await loadHistory();
    messageList.add(message);
    viewMessageList.add(message);
    focusMessage(message.uuid);
    viewIndexEnd.value = messageList.length;
  }

  updateRespMessage(Message message) {
    messageList.last = message;
    viewMessageList.last = message;
  }

  chatSendMessage(Message message) async {
    if (waitingForResponse) {
      return;
    }
    await addMessageToCurrentConversation(message);

    // reset this value
    messageList.add(Message.emptyAssistantMessage());
    viewMessageList.add(Message.emptyAssistantMessage());
    viewIndexEnd.value = messageList.length;

    waitingForResponse = true;

    // the message that need to be sent through api,
    // should be from the latest role.system message
    // to the latest message, copy this list
    int latestSystemMessageIndex =
        messageList.lastIndexWhere((msg) => msg.role == MessageRole.system);
    assert(latestSystemMessageIndex != -1);
    final messageListCopy = messageList.sublist(latestSystemMessageIndex);
    print(("messageTobeSent", messageListCopy));

    // find the assistant setting, could have defined model
    // message.conversationUuid
    String? assistantId = conversationController.conversationList
        .firstWhereOrNull(
          (conversation) => conversation.uuid == message.conversationUuid,
        )
        ?.assistantUuid;
    DefinedModel? definedModel = assistantController.assistantList
        .firstWhereOrNull((assistant) => assistant.uuid == assistantId)
        ?.definedModel;

    ClientManager().postMessage(
      messageListCopy,
      definedModel,
      (message) {
        updateRespMessage(message);
      },
      (message) {
        updateRespMessage(message);
      },
      (message) async {
        // on success save response message to db
        updateRespMessage(message);
        await insertNewMessageOnly(message);
        focusMessage(message.uuid);

        // print("message controller set waitingForResponse to false");
        waitingForResponse = false;
      },
    );
  }

  void deleteConversationMessages(String conversationUuid) {
    ConversationRepository().deleteConversationMessages(conversationUuid);
    messageList.clear();
  }

  void deleteUserMessageAndResponse(String messageUuid) {
    // delete message of user and the response after it.
    messageList.removeWhere((message) {
      if (message.uuid == messageUuid ||
          (messageList.indexOf(message) ==
                  messageList.indexWhere((m) => m.uuid == messageUuid) + 1 &&
              message.role == MessageRole.assistant)) {
        ConversationRepository().deleteMessage(message.uuid);
        return true;
      }
      return false;
    });
    viewMessageList.removeWhere((message) {
      if (message.uuid == messageUuid ||
          (viewMessageList.indexOf(message) ==
                  viewMessageList.indexWhere((m) => m.uuid == messageUuid) +
                      1 &&
              message.role == MessageRole.assistant)) {
        ConversationRepository().deleteMessage(message.uuid);
        return true;
      }
      return false;
    });
  }
}
