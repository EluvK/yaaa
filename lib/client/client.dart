import 'package:flutter/material.dart';
import 'package:yaaa/client/llm/deepseek.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';

class ClientManager {
  static final ClientManager _instance = ClientManager._internal();

  factory ClientManager() {
    return _instance;
  }

  ClientManager._internal() {
    // try read from settings
    // var openAiCLient = OpenAIClient(
    //   apiKey: "SK_TEST",
    //   baseUrl: "https://api.openai.com",
    // );
  }

  void postMessage(
    List<Message> messages,
    DefinedModel? definedModel,
    ValueChanged<Message> onStream,
    ValueChanged<Message> onError,
    ValueChanged<Message> onSuccess,
  ) {
    Deepseek().chat(messages, definedModel, onStream, onError, onSuccess);
  }
}
