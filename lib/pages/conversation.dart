import 'package:flutter/material.dart';
import 'package:yaaa/components/chatbox.dart';
import 'package:yaaa/components/clearcontext.dart';
import 'package:yaaa/components/conversation.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(children: [
        ConversationCard(),
        ClearContextCard(),
        ChatboxCard(),
      ]),
    );
  }
}
