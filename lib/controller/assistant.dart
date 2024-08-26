import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/model/assistant.dart';

class AssistantController extends GetxController {
  final assistantList = <Assistant>[].obs;

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
        name: assistant.name,
        uuid: const Uuid().v4(),
        type: AssistantType.userDefined,
        description: assistant.description,
        prompt: assistant.prompt);
    AssistantRepository().insert(newAssistant);
    assistantList.add(newAssistant);
  }

  void deleteAssistant(String uuid) {
    AssistantRepository().delete(uuid);
    assistantList.removeWhere((element) => element.uuid == uuid);
  }

  Assistant? getAssistant(String uuid) {
    // for (var ass in assistantList) {
    //   print(("  = ", ass.name));
    //   print(("  = ", ass.description));
    //   print(("  = ", ass.uuid));
    // }
    return assistantList.firstWhereOrNull(
      (element) => element.uuid == uuid,
    );
  }
}
