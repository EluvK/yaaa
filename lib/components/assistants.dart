import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';

class AssistantsCard extends StatefulWidget {
  const AssistantsCard({super.key});

  @override
  State<AssistantsCard> createState() => _AssistantsCardState();
}

class _AssistantsCardState extends State<AssistantsCard> {
  final assistantController = Get.find<AssistantController>();
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Assistants',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _compAssistantsMatrix(
              context,
              assistantController.assistantList
                  .where((assistant) =>
                      assistant.type == AssistantType.userdefined)
                  .toList()),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Assistants Templates',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _compAssistantsMatrix(
              context,
              assistantController.assistantList
                  .where((assistant) => assistant.type == AssistantType.system)
                  .toList()),
        ],
      );
    });
  }

  Widget _compAssistantsMatrix(
      BuildContext context, List<Assistant> assistants) {
    if (assistants.isEmpty) {
      return const Text('No assistant found. Try duplicating one.');
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        childAspectRatio: 1.618, // 宽高比
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4, // 每行显示2个卡片
        crossAxisSpacing: 16.0, // 水平间距
        mainAxisSpacing: 12.0, // 垂直间距
        children: assistants
            .map((assistant) => _compAssistantCard(context, assistant))
            .toList(),
      ),
    );
  }

  Widget _compAssistantCard(BuildContext context, Assistant assistant) {
    return Card(
      elevation: 4.0, // 卡片阴影
      child: InkWell(
        onTap: () => funcAddConversation(assistant),
        onLongPress: () => _showDetailsDialog(context, assistant),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.android, size: 20.0),
            const SizedBox(height: 3.0),
            Text(assistant.name),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Assistant assistant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(assistant.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${assistant.description}'),
              Text('Prompt: ${assistant.prompt}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            // todo Edit name, description, prompt
            TextButton(
              onPressed: () {
                assistantController.duplicateAssistant(assistant.uuid);
                Navigator.pop(context);
              },
              child: const Text('Duplicate'),
            ),
            assistant.type == AssistantType.system
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () {
                      assistantController.deleteAssistant(assistant.uuid);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
          ],
        );
      },
    );
  }

  void funcAddConversation(Assistant assistant) {
    print(("here", assistant));
    final newConversationUuid = const Uuid().v4();
    conversationController.addConversation(Conversation(
      name: "new ${newConversationUuid.substring(0, 8)}",
      uuid: newConversationUuid,
      assistantName: assistant.name,
    ));
    conversationController.setCurrentConversationUuid(newConversationUuid);

    messageController.addMessage(Message(
      uuid: const Uuid().v4(),
      conversationUuid: newConversationUuid,
      text: assistant.prompt,
      createdAt: DateTime.now(),
      role: MessageRole.system,
    ));
    Get.back();
  }
}
