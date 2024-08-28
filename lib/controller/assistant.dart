import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/assistant.dart';

class AssistantController extends GetxController {
  final assistantList = <Assistant>[].obs;
  final conversationController = Get.find<ConversationController>();
  static AssistantController get to => Get.find<AssistantController>();

  @override
  Future<void> onInit() async {
    assistantList.value = await AssistantRepository().getAllAssistants();
    super.onInit();
  }

  void duplicateAssistant(String uuid) {
    final assistant =
        assistantList.firstWhere((element) => element.uuid == uuid);
    final newAssistant = Assistant(
      name: "${assistant.name} copy",
      uuid: const Uuid().v4(),
      type: AssistantType.userDefined,
      description: assistant.description,
      prompt: assistant.prompt,
      avatarUrl: assistant.avatarUrl,
    );
    AssistantRepository().insert(newAssistant);
    assistantList.add(newAssistant);
  }

  void deleteAssistant(String uuid) {
    AssistantRepository().delete(uuid);
    assistantList.removeWhere((element) => element.uuid == uuid);
  }

  Assistant? getAssistant(String uuid) {
    return assistantList.firstWhereOrNull(
      (element) => element.uuid == uuid,
    );
  }

  void updateAssistant(Assistant assistant) {
    final index =
        assistantList.indexWhere((element) => element.uuid == assistant.uuid);
    if (index != -1) {
      assistantList[index] = assistant;
      AssistantRepository().update(assistant);
    }

    // update Assistant will update corresponding conversations
    for (var conversation in conversationController.conversationList) {
      if (conversation.assistantUuid == assistant.uuid) {
        conversation.assistantName = assistant.name;
        conversationController.updateConversation(conversation);
      }
    }
  }
}
