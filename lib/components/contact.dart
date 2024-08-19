import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({super.key});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (conversationController.conversationList.isEmpty) {
        return const Center(child: Text('No conversation'));
      }
      return ListView.builder(
        itemCount: conversationController.conversationList.length,
        itemBuilder: (context, index) {
          return _compConversation(
              conversationController.conversationList[index], index);
        },
      );
    });
  }

  // Widget _compNewConversation() {
  //   return Row(
  //     children: [
  //       const SizedBox(width: 8.0),
  //       ElevatedButton(
  //         onPressed: () {
  //           final newConversationUuid = const Uuid().v4();
  //           conversationController.addConversation(Conversation(
  //               name: "---",
  //               uuid: newConversationUuid,
  //               contactUuid: "contactUuid"));
  //           conversationController
  //               .setCurrentConversationUuid(newConversationUuid);
  //         },
  //         child: const Icon(Icons.add),
  //       ),
  //     ],
  //   );
  // }

  Widget _compConversation(Conversation conversation, int index) {
    return Card(
      child: ListTile(
        title: Text(conversation.name),
        subtitle: Text(conversation.assistantName),
        onTap: () {
          _funcTabConversation(index);
        },
        trailing: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                //显示一个overlay操作
                _compConversationDetail(context, index);
              },
              icon: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
              ));
        }),
      ),
    );
  }

  void _compConversationDetail(BuildContext context, int index) {
    final conversation = conversationController.conversationList[index];
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: "delete",
          child: Text('delete'.tr),
        ),
        // PopupMenuItem(
        //   value: "rename",
        //   child: Text('reName'.tr),
        // ),
      ],
    ).then((value) {
      if (value == "delete") {
        conversationController.deleteConversation(conversation.uuid);
        messageController.deleteConversationMessages(conversation.uuid);
      }
      //  else if (value == "rename") {
      //   _renameConversation(context, index);
      // }
    });
  }

  void _funcTabConversation(int index) {
    String uuid = conversationController.conversationList[index].uuid;
    conversationController.setCurrentConversationUuid(uuid);
    final messageController = Get.find<MessageController>();
    messageController.loadMessages(uuid);
    if (GetPlatform.isMobile || MediaQuery.of(context).size.width < 600) {
      Get.back();
    }
  }
}
