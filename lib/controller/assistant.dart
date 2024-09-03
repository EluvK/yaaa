import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/pages/edit_assistants.dart';
import 'package:yaaa/utils/page_opener.dart';
import 'package:yaaa/utils/utils.dart';

class AssistantController extends GetxController {
  final assistantList = <Assistant>[].obs;
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();
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
      definedModel: assistant.definedModel,
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

  newAssistantConversation(Assistant assistant) async {
    final newConversationUuid = const Uuid().v4();
    final conversation = Conversation(
      name: "new ${newConversationUuid.substring(0, 8)}",
      uuid: newConversationUuid,
      assistantName: assistant.name,
      assistantUuid: assistant.uuid,
    );
    await conversationController.addConversation(conversation);

    final newPromptMessage = Message(
      uuid: const Uuid().v4(),
      conversationUuid: newConversationUuid,
      text: assistant.prompt,
      createdAt: DateTime.now(),
      role: MessageRole.system,
    );
    messageController.addMessage(newPromptMessage);
  }

  duplicationAssistantConversation(Conversation conversation) async {
    final assistant = assistantList.firstWhereOrNull(
        (element) => element.uuid == conversation.assistantUuid);
    if (assistant != null) {
      newAssistantConversation(assistant);
    } else {
      flushBar(FlushLevel.WARNING, 'error'.tr, 'assistant_not_found'.tr);
    }
  }

  editConversationAssistant(BuildContext context, Conversation conversation) {
    final assistant = assistantList.firstWhereOrNull(
        (element) => element.uuid == conversation.assistantUuid);
    if (assistant != null) {
      PageOpener.openPage(context, EditAssistantPage(assistant: assistant));
    } else {
      flushBar(FlushLevel.WARNING, 'error'.tr, 'assistant_not_found'.tr);
    }
  }
}
