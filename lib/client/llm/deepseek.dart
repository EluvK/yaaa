// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart' as yaaa_model;
import 'package:yaaa/model/llm.dart';

class Deepseek {
  void chat(
    List<yaaa_model.Message> messages,
    DefinedModel? definedModel,
    ValueChanged<yaaa_model.Message> onStream,
    ValueChanged<yaaa_model.Message> onError,
    ValueChanged<yaaa_model.Message> onSuccess,
  ) async {
    print('Deepseek chat');

    final settingController = Get.find<SettingController>();
    final baseUrl =
        settingController.getCurrentProviderBaseUrl(LLMProviderEnum.DeepSeek);
    final apiKey =
        settingController.getCurrentProviderApiKey(LLMProviderEnum.DeepSeek);
    var model = settingController
        .getCurrentProviderDefaultModel(LLMProviderEnum.DeepSeek);
    if (definedModel != null && definedModel.enable) {
      model = definedModel.modelName;
    }

    var client = OpenAIClient(apiKey: apiKey, baseUrl: baseUrl);

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
        model: ChatCompletionModel.modelId(model),
        messages: sendMessages,
      ),
    );
    chatStream.listen(
      (streamEvent) async {
        // print("Received stream event: $streamEvent");
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
