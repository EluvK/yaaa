import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/pages/edit_assistants.dart';
import 'package:yaaa/utils/page_opener.dart';

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
                      assistant.type == AssistantType.userDefined)
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          double totalWidth = constraints.maxWidth;
          double cardWidth = 380.0;
          int maxCardCountPerRow = (totalWidth / cardWidth).toInt();
          // print('total $totalWidth, cardCount $maxCardCountPerRow');

          // 计算每个子组件之间的间距
          double spacing = (totalWidth - (maxCardCountPerRow * cardWidth)) /
              (maxCardCountPerRow + 1);
          return Wrap(
            spacing: spacing,
            runSpacing: 12.0,
            alignment: WrapAlignment.start,
            children: assistants.map((assistant) {
              return SizedBox(
                width: cardWidth,
                height: 124.0,
                child: _compAssistantCard(context, assistant),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _compAssistantCard(BuildContext context, Assistant assistant) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () => funcAddConversation(assistant),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 4.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.android),
                  Text(assistant.name),
                ],
              ),
              Expanded(child: Text(assistant.description)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OverflowBar(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          PageOpener.openPage(
                              context, EditAssistantPage(assistant: assistant));
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          assistantController
                              .duplicateAssistant(assistant.uuid);
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Duplicate'),
                      ),
                      TextButton.icon(
                        onPressed: assistant.type == AssistantType.system
                            ? null
                            : () {
                                assistantController
                                    .deleteAssistant(assistant.uuid);
                              },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- old
  Widget _compAssistantCardOld(BuildContext context, Assistant assistant) {
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

  void funcAddConversation(Assistant assistant) async {
    final newConversationUuid = const Uuid().v4();
    final conversation = Conversation(
      name: "new ${newConversationUuid.substring(0, 8)}",
      uuid: newConversationUuid,
      assistantName: assistant.name,
      assistantUuid: assistant.uuid,
    );
    conversationController.addConversation(conversation);
    conversationController.setCurrentConversation(conversation);
    await messageController.loadMessages(newConversationUuid);

    final newPromptMessage = Message(
      uuid: const Uuid().v4(),
      conversationUuid: newConversationUuid,
      text: assistant.prompt,
      createdAt: DateTime.now(),
      role: MessageRole.system,
    );
    messageController.addMessage(newPromptMessage);
    Get.back();
  }
}
