import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/model/conversation.dart';

class Deepseek {
  void chat(
    List<Message> messages,
    ValueChanged<Message> onStream,
    ValueChanged<Message> onSuccess,
  ) async {
    print('Deepseek chat');

    // map message to OpenAIChatCompletionChoiceMessageModel
    var openAIMessages = messages.map((e) {
      return OpenAIChatCompletionChoiceMessageModel(
        role: switch (e.role) {
          MessageRole.system => OpenAIChatMessageRole.system,
          MessageRole.assistant => OpenAIChatMessageRole.assistant,
          MessageRole.user => OpenAIChatMessageRole.user,
        },
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(e.text)
        ],
      );
    });
    var returnMessage = Message(
      uuid: const Uuid().v4(),
      conversationUuid: messages.first.conversationUuid,
      text: '',
      createdAt: DateTime.now(),
      role: MessageRole.assistant,
    );
    var chatStream = OpenAI.instance.chat
        .createStream(model: "model", messages: openAIMessages.toList());
    chatStream.listen(
      (streamEvent) async {
        if (streamEvent.choices.first.delta.content != null) {
          // todo check here. !
          returnMessage.text = returnMessage.text +
              streamEvent.choices.first.delta.content!.first!.text!;
          onStream(returnMessage);
        }
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('Done');
        onSuccess(returnMessage);
      },
    );
  }
}
