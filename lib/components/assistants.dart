import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/avatar.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/pages/edit_assistants.dart';
import 'package:yaaa/utils/double_click.dart';
import 'package:yaaa/utils/page_opener.dart';
import 'package:yaaa/utils/utils.dart';

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
          Padding(
            padding: dynDevicePadding(4),
            child: Text(
              'my_assistants'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _compAssistantsMatrix(
              context,
              assistantController.assistantList
                  .where((assistant) =>
                      assistant.type == AssistantType.userDefined)
                  .toList()),
          Padding(
            padding: dynDevicePadding(4),
            child: Text(
              'assistant_templates'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      return Text('no_user_assistants_noted'.tr);
    }
    return Container(
      padding: dynDevicePadding(1),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double totalWidth = constraints.maxWidth;
          double cardWidth = isMobile() ? 160.0 : 300.0;
          int maxCardCountPerRow = (totalWidth / cardWidth).toInt();
          // print('total $totalWidth, cardCount $maxCardCountPerRow');

          // 计算每个子组件之间的间距
          double spacing = (totalWidth - (maxCardCountPerRow * cardWidth)) /
              (maxCardCountPerRow + 1);
          return Center(
            child: Wrap(
              spacing: spacing,
              runSpacing: 12.0,
              alignment: WrapAlignment.start,
              children: assistants.map((assistant) {
                return SizedBox(
                  width: cardWidth,
                  height: (isMobile() ? 112 : 136),
                  child: _compAssistantCard(context, assistant),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _compAssistantCard(BuildContext context, Assistant assistant) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          assistantController.newAssistantConversation(assistant);
          Get.back();
        },
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  avatarContainer(context, assistant.avatarUrl,
                      size: isMobile() ? 30 : 40),
                  Text(assistant.name),
                ],
              ),
            ),
            // Expanded(child: Text(assistant.description)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    PageOpener.openPage(
                        context, EditAssistantPage(assistant: assistant));
                  },
                  icon: const Icon(Icons.edit),
                  tooltip: 'tooltip_edit_assistant'.tr,
                ),
                IconButton(
                  onPressed: () {
                    assistantController.duplicateAssistant(assistant.uuid);
                  },
                  icon: const Icon(Icons.copy),
                  tooltip: 'tooltip_duplicate_assistant'.tr,
                ),
                DoubleClickButton(
                  buttonBuilder: (onPressed) => IconButton(
                    onPressed: assistant.type == AssistantType.system
                        ? null
                        : onPressed,
                    icon: const Icon(Icons.delete),
                    tooltip: 'tooltip_delete_assistant'.tr,
                  ),
                  onDoubleClick: () {
                    assistantController.deleteAssistant(assistant.uuid);
                  },
                  firstClickHint: 'double_click_delete_assistant_hint'.tr,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
