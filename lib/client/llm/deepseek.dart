// ignore_for_file: avoid_print

import 'package:get_storage/get_storage.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/model/conversation.dart' as yaaa_model;

class Deepseek {
  void chat(
    List<yaaa_model.Message> messages,
    ValueChanged<yaaa_model.Message> onStream,
    ValueChanged<yaaa_model.Message> onError,
    ValueChanged<yaaa_model.Message> onSuccess,
  ) async {
    print('Deepseek chat');

    var apiKey = GetStorage().read('apiKey') ?? 'sk-your-api-key';
    var baseUrl = GetStorage().read('baseUrl') ?? 'https://api.openai.com';
    var client = OpenAIClient(apiKey: apiKey, baseUrl: baseUrl);
    // final client =
    //     OpenAIClient(apiKey: "SK_TEST", baseUrl: "http://localhost:2335");

    // map message to OpenAIChatCompletionChoiceMessageModel
    List<ChatCompletionMessage> sendMessages = messages.map((e) {
      return switch (e.role) {
        yaaa_model.MessageRole.system =>
          ChatCompletionMessage.system(content: e.text),
        yaaa_model.MessageRole.assistant =>
          ChatCompletionMessage.assistant(content: e.text),
        yaaa_model.MessageRole.user => ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(e.text)),
      };
    }).toList();
    var returnMessage = yaaa_model.Message(
      uuid: const Uuid().v4(),
      conversationUuid: messages.first.conversationUuid,
      text: '',
      createdAt: DateTime.now(),
      role: yaaa_model.MessageRole.assistant,
    );
    var chatStream = client.createChatCompletionStream(
      request: CreateChatCompletionRequest(
        // todo fetch with conversation context. or settings
        model: const ChatCompletionModel.modelId("model"),
        messages: sendMessages,
      ),
    );
    chatStream.listen(
      (streamEvent) async {
        print("Received stream event: $streamEvent");
        if (streamEvent.choices.first.delta.content != null) {
          // todo check here. !
          print(returnMessage.text);
          returnMessage.text =
              returnMessage.text + streamEvent.choices.first.delta.content!;
          onStream(returnMessage);
        } else {
          print("Content is null");
        }
        if (streamEvent.usage != null) {
          //
          print("Usage: ${streamEvent.usage}");
          returnMessage.usage = yaaa_model.Usage(
            promptTokens: streamEvent.usage!.promptTokens,
            completionTokens: streamEvent.usage!.completionTokens ?? -1,
            totalTokens: streamEvent.usage!.totalTokens,
          );
        }
      },
      onError: (error) {
        // var error_msg = "$error";
        // print('$error_msg');
        print('Error: $error');
        returnMessage.text = "$error";
        onError(returnMessage);
      },
      onDone: () {
        print('Done');
        returnMessage.createdAt = DateTime.now();
        onSuccess(returnMessage);
      },
    );
  }
}
