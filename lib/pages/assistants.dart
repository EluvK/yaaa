import 'package:flutter/material.dart';
import 'package:yaaa/components/assistants.dart';

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistants'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: AssistantsCard(),
      ),
    );
  }
}
