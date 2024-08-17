import 'package:flutter/material.dart';
import 'package:yaaa/components/chatbox.dart';
import 'package:yaaa/components/conversation.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        const ConversationCard(),
        const SizedBox(height: 16.0),
        ElevatedButton(
          // onPressed: () {},
          onPressed: _addSeparator,
          child: const Icon(Icons.wrap_text),
        ),
        const ChatboxCard(),
      ]),
    );
  }

  void _addSeparator() {
    // todo
  }
}
