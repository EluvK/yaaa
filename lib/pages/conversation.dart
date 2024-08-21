import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/chatbox.dart';
import 'package:yaaa/components/clearcontext.dart';
import 'package:yaaa/components/conversation.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/utils/utils.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isMobile(context)
          ? null
          : const PreferredSize(
              preferredSize: Size.fromHeight(56.0),
              child: ConversationAppBar(),
            ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: const Padding(
          padding: EdgeInsets.all(2.0),
          child: Column(children: [
            Expanded(child: ConversationCard()),
            ClearContextCard(),
            ChatboxCard(),
          ]),
        ),
      ),
    );
  }
}

class ConversationAppBar extends StatefulWidget {
  const ConversationAppBar({super.key});

  @override
  State<ConversationAppBar> createState() => _ConversationAppBarState();
}

class _ConversationAppBarState extends State<ConversationAppBar> {
  final colorScheme = Get.theme.colorScheme;
  final conversationController = Get.find<ConversationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var currentAssistantName =
          conversationController.currentConversationAssistantName.value;
      return AppBar(
        title: Text(currentAssistantName),
        centerTitle: false,
        flexibleSpace: Container(color: colorScheme.surface),
        actions: [
          // todo
          IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      );
    });
  }
}
