import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/utils/utils.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({super.key});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (conversationController.conversationList.isEmpty) {
        return const Center(child: Text('No conversation'));
      }
      _selectedIndex = conversationController.conversationList.indexWhere(
          (element) =>
              element.uuid ==
              conversationController.currentConversationUuid.value);
      return ListView.builder(
        itemCount: conversationController.conversationList.length,
        itemBuilder: (context, index) {
          return _compConversation(
              conversationController.conversationList[index], index);
        },
      );
    });
  }

  Widget _compConversation(Conversation conversation, int index) {
    return Card(
      color: _selectedIndex == index
          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.2)
          : null,
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
    Conversation conversation = conversationController.conversationList[index];
    String uuid = conversation.uuid;
    conversationController.setCurrentConversation(
        uuid, conversation.assistantName);

    messageController.loadMessages(uuid);
    if (isMobile(context)) {
      Get.back();
    }
  }
}

class ContactBar extends StatefulWidget {
  const ContactBar({super.key});

  @override
  State<ContactBar> createState() => _ContactBarState();
}

class _ContactBarState extends State<ContactBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: AppBar(
        centerTitle: true,
        title: const Text('Contact'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/assistants');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
