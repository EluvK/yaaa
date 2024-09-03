import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/avatar.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/pages/assistants.dart';
import 'package:yaaa/utils/page_opener.dart';
import 'package:yaaa/utils/utils.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({super.key});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  final conversationController = Get.find<ConversationController>();
  final messageController = Get.find<MessageController>();
  final assistantController = Get.find<AssistantController>();
  final settingController = Get.find<SettingController>();
  int _selectedIndex = -1;
  int _moreInfoIndex = -1;

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
          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
          : null,
      child: settingController.getExpandContactList()
          ? _compConversationCardExpanded(conversation, index)
          : _compConversationCard(conversation, index),
    );
  }

  Widget _compConversationCard(Conversation conversation, int index) {
    return avatarContainer(
      context,
      assistantController.assistantList
          .firstWhereOrNull(
              (element) => element.uuid == conversation.assistantUuid)
          ?.avatarUrl,
      size: 48,
      onTap: () {
        _funcTabConversation(index);
      },
      color: _selectedIndex == index ? Colors.blue.shade100 : Colors.white,
    );
  }

  Widget _compConversationCardExpanded(Conversation conversation, int index) {
    Widget cardExpanded = ListTile(
      title: Text(conversation.assistantName),
      subtitle: Text(conversation.name),
      onTap: () {
        _funcTabConversation(index);
      },
      leading: avatarContainer(
        context,
        assistantController.assistantList
            .firstWhereOrNull(
                (element) => element.uuid == conversation.assistantUuid)
            ?.avatarUrl,
        size: 36,
      ),
      trailing: Builder(builder: (context) {
        return IconButton(
            onPressed: () {
              _moreInfoIndex = (_moreInfoIndex == index) ? -1 : index;
              setState(() {});
              // _compConversationDetail(context, index);
            },
            icon: Icon(
              (_moreInfoIndex == index)
                  ? Icons.arrow_drop_up
                  : Icons.more_horiz,
              color: Theme.of(context).colorScheme.primary,
            ));
      }),
    );

    if (index == _moreInfoIndex) {
      return Column(
        children: [
          cardExpanded,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    conversationController.editContactConversation(
                        context, conversation);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    assistantController.editConversationAssistant(
                        context, conversation);
                  },
                  icon: const Icon(Icons.assistant)),
              IconButton(
                  onPressed: () {
                    assistantController
                        .duplicationAssistantConversation(conversation);
                    _moreInfoIndex = -1;
                    // actually not need setState to refresh,
                    // if success to duplicate, the conversation will be added to the list and set to current.
                    // setState(() {});
                  },
                  icon: const Icon(Icons.copy)),
              IconButton(
                  onPressed: () {
                    conversationController
                        .deleteConversation(conversation.uuid);
                  },
                  icon: const Icon(Icons.delete)),
            ],
          )
        ],
      );
    }

    return cardExpanded;
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

  void _funcTabConversation(int index) async {
    Conversation conversation = conversationController.conversationList[index];
    conversationController.setCurrentConversation(conversation);

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
        title: Text('contact'.tr),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              PageOpener.openPage(context, const AssistantsPage());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class HiddenContactButton extends StatefulWidget {
  const HiddenContactButton({super.key});

  @override
  State<HiddenContactButton> createState() => _HiddenContactButtonState();
}

class _HiddenContactButtonState extends State<HiddenContactButton> {
  bool _isButtonVisible = false;
  final settingController = Get.find<SettingController>();
  late bool _isContactExpanded = settingController.getExpandContactList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isButtonVisible = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isButtonVisible = false;
        });
      },
      child: AnimatedOpacity(
          opacity: _isButtonVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isContactExpanded = !_isContactExpanded;
                settingController.setExpandContactList(_isContactExpanded);
              });
            },
            child: SizedBox(
              width: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isContactExpanded
                        ? Icons.chevron_left
                        : Icons.chevron_right,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
