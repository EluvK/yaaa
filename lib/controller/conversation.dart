import 'package:get/get.dart';
import 'package:yaaa/model/conversation.dart';

class ConversationController extends GetxController {
  final conversationList = <Conversation>[].obs;

  final currentConversationUuid = ''.obs;

  static ConversationController get to => Get.find<ConversationController>();

  @override
  void onInit() async {
    conversationList.value = await ConversationRepository().getAllConversations();
    super.onInit();
  }

  void setCurrentConversationUuid(String uuid) {
    currentConversationUuid.value = uuid;
  }

  void addConversation(Conversation conversation) {
    ConversationRepository().addConversation(conversation);
    conversationList.add(conversation);
  }

  void deleteConversation(String uuid) {
    if (currentConversationUuid.value == uuid) {
      currentConversationUuid.value = '';
    }
    ConversationRepository().deleteConversation(uuid);
    conversationList.removeWhere((element) => element.uuid == uuid);
  }
}

class MessageController extends GetxController {
  final messageList = <Message>[].obs;

  Future<void> loadMessages(String conversationUuid) async {
    print(("load message", conversationUuid));
    messageList.value =
        await ConversationRepository().getMessages(conversationUuid);
  }

  void addMessage(Message message) async {
    await ConversationRepository().addMessage(message);
    final messages =
        await ConversationRepository().getMessages(message.conversationUuid);
    messageList.value = messages;

    // todo post message and wait for response
  }

  void deleteConversationMessages(String conversationUuid) {
    ConversationRepository().deleteConversationMessages(conversationUuid);
    messageList.clear();
  }
}
