import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/model/assistant.dart';

class EditAssistantPage extends StatelessWidget {
  final Assistant assistant;

  const EditAssistantPage({super.key, required this.assistant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit `${assistant.name}`"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: EditAssistantCard(assistant: assistant),
      ),
    );
  }
}

class EditAssistantCard extends StatefulWidget {
  final Assistant assistant;
  const EditAssistantCard({super.key, required this.assistant});

  @override
  State<EditAssistantCard> createState() => _EditAssistantCardState();
}

class _EditAssistantCardState extends State<EditAssistantCard> {
  final assistantController = Get.find<AssistantController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Assistant UUID: ${widget.assistant.uuid}"),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: editAssistantName(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: editAssistantDescription(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: editAssistantPrompt(),
        ),
        // maybe add some optional ai model settings here
      ],
    );
  }

  Widget editAssistantName() {
    return TextFormField(
      initialValue: widget.assistant.name,
      decoration: const InputDecoration(
        labelText: 'Assistant Name',
      ),
      onChanged: (value) {
        widget.assistant.name = value;
        assistantController.updateAssistant(widget.assistant);
      },
    );
  }

  Widget editAssistantDescription() {
    return TextFormField(
      initialValue: widget.assistant.description,
      decoration: const InputDecoration(
        labelText: 'Description',
      ),
      onChanged: (value) {
        widget.assistant.description = value;
        assistantController.updateAssistant(widget.assistant);
      },
    );
  }

  Widget editAssistantPrompt() {
    return TextFormField(
      maxLines: 13,
      initialValue: widget.assistant.prompt,
      decoration: const InputDecoration(
        labelText: 'Prompt',
      ),
      onChanged: (value) {
        widget.assistant.prompt = value;
        assistantController.updateAssistant(widget.assistant);
      },
    );
  }
}
