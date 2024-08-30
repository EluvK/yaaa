import 'package:get/get.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

Future<void> initConversation() async {
  final conversationController = Get.find<ConversationController>();
  var currentConversationUuid =
      conversationController.currentConversationUuid.value;
  print(('[init] currentConversationUuid', currentConversationUuid));
  print(('[init] conversationList', conversationController.conversationList));
  if (conversationController.conversationList.isNotEmpty &&
      conversationController.currentConversationUuid.value.isEmpty) {
    Conversation firstConversation =
        conversationController.conversationList.first;
    currentConversationUuid = firstConversation.uuid;
    await conversationController.setCurrentConversation(firstConversation);
    print(("[init] _compConversation", currentConversationUuid));
  }
}
