import 'package:get/get.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

void initConversation() {
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();
  var currentConversationUuid =
      conversationController.currentConversationUuid.value;
  print(('[init] currentConversationUuid', currentConversationUuid));
  print(('[init] conversationList', conversationController.conversationList));
  if (conversationController.conversationList.isNotEmpty &&
      conversationController.currentConversationUuid.value.isEmpty) {
    Conversation firstConversation =
        conversationController.conversationList.first;
    currentConversationUuid = firstConversation.uuid;
    conversationController.setCurrentConversation(
        firstConversation.uuid, firstConversation.assistantName);
    messageController.loadMessages(currentConversationUuid);
    print(("[init] _compConversation", currentConversationUuid));
  }
}
