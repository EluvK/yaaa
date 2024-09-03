import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

class EditConversationPage extends StatelessWidget {
  final Conversation conversation;
  const EditConversationPage({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_assistant'.trParams({'name': conversation.name})),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: EditConversationCard(conversation: conversation),
      ),
    );
  }
}

class EditConversationCard extends StatefulWidget {
  final Conversation conversation;
  const EditConversationCard({super.key, required this.conversation});

  @override
  State<EditConversationCard> createState() => _EditConversationCardState();
}

class _EditConversationCardState extends State<EditConversationCard> {
  final conversationController = Get.find<ConversationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _conversationInfo(context),
        const Divider(),
        _assistantInfo(context),
      ],
    );
  }

  Widget _conversationInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('${'conversation_uuid'.tr}: ${widget.conversation.uuid}'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _editConversationName(),
        )
      ],
    );
  }

  Widget _editConversationName() {
    return TextFormField(
      initialValue: widget.conversation.name,
      decoration: InputDecoration(
        labelText: 'conversation_name'.tr,
      ),
      onChanged: (value) {
        widget.conversation.name = value;
        conversationController.updateConversation(widget.conversation);
      },
    );
  }

  Widget _assistantInfo(BuildContext context) {
    // todo?
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [],
        )
      ],
    );
  }
}
