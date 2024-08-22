import 'package:get/get.dart';
import 'package:yaaa/client/client.dart';
import 'package:yaaa/model/conversation.dart';

class ConversationController extends GetxController {
  final conversationList = <Conversation>[].obs;

  final currentConversationUuid = ''.obs;
  final currentConversationAssistantName = 'yaaa'.obs;

  static ConversationController get to => Get.find<ConversationController>();

  @override
  Future<void> onInit() async {
    conversationList.value =
        await ConversationRepository().getAllConversations();
    super.onInit();
  }

  void setCurrentConversation(String uuid, String name) {
    currentConversationUuid.value = uuid;
    currentConversationAssistantName.value = name;
  }

  void addConversation(Conversation conversation) {
    ConversationRepository().addConversation(conversation);
    conversationList.add(conversation);
  }

  void deleteConversation(String uuid) {
    if (currentConversationUuid.value == uuid) {
      currentConversationUuid.value = '';
      currentConversationAssistantName.value = 'yaaa';
    }
    ConversationRepository().deleteConversation(uuid);
    conversationList.removeWhere((element) => element.uuid == uuid);
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
    // save user message to db
    await ConversationRepository().addMessage(message);
    final messages =
        await ConversationRepository().getMessages(message.conversationUuid);
    messageList.value = messages;

    // for prompt message, no need to do the rest.
    if (message.role == MessageRole.system) {
      return;
    }
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
}
