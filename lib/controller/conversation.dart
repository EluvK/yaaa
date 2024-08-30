import 'package:get/get.dart';
import 'package:yaaa/client/client.dart';
import 'package:yaaa/model/conversation.dart';

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
  }

  void setCurrentConversation(Conversation conversation) async {
    currentConversationUuid.value = conversation.uuid;
    currentConversationAssistantName.value = conversation.assistantName;
    currentConversationAssistantUuid.value = conversation.assistantUuid;
    await messageController.loadMessages(conversation.uuid);
  }

  void addConversation(Conversation conversation) {
    ConversationRepository().addConversation(conversation);
    conversationList.add(conversation);
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
}

class MessageController extends GetxController {
  final messageList = <Message>[].obs;

  bool waitingForResponse = false;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> loadMessages(String conversationUuid) async {
    print(("load message", conversationUuid));
    messageList.value =
        await ConversationRepository().getMessages(conversationUuid);
  }

  void addMessage(Message message) async {
    if (waitingForResponse) {
      return;
    }
    if (message.role == MessageRole.system) {
      // if the last message is system message, don't add another system message
      if (messageList.isNotEmpty &&
          messageList.last.role == MessageRole.system) {
        print("return because last message is system message");
        // print("last: ${messageList.last}");
        return;
      }
      // save system message to db
      await ConversationRepository().addMessage(message);
      final messages =
          await ConversationRepository().getMessages(message.conversationUuid);
      messageList.value = messages;
      return;
    }
    // save user message to db
    await ConversationRepository().addMessage(message);
    final messages =
        await ConversationRepository().getMessages(message.conversationUuid);
    messageList.value = messages;

    // print("message controller set waitingForResponse to true");
    waitingForResponse = true;

    // the message that need to be sent through api,
    // should be from the latest role.system message
    // to the latest message, copy this list
    int latestSystemMessageIndex =
        messageList.lastIndexWhere((msg) => msg.role == MessageRole.system);
    assert(latestSystemMessageIndex != -1);
    final messageListCopy = messageList.sublist(latestSystemMessageIndex);
    print(("messageTobeSent", messageListCopy));

    // todo post message and wait for response
    ClientManager().postMessage(
      messageListCopy,
      (message) {
        messageList.value = [...messages, message];
      },
      (message) {
        messageList.value = [...messages, message];
      },
      (message) async {
        // on success save response message to db
        await ConversationRepository().addMessage(message);
        final messages = await ConversationRepository()
            .getMessages(message.conversationUuid);
        messageList.value = messages;
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
  }
}
