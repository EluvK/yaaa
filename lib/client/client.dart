import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:yaaa/client/deepseek.dart';
import 'package:yaaa/model/conversation.dart';

class Client {
  static final Client _instance = Client._internal();

  factory Client() {
    return _instance;
  }

  Client._internal() {
    // try read from settings
    OpenAI.apiKey = "SK_TEST";
    OpenAI.baseUrl = "https://api.openai.com";
  }

  void postMessage(
    List<Message> messages,
    ValueChanged<Message> onStream,
    ValueChanged<Message> onSuccess,
  ) {
    Deepseek().chat(messages, onStream, onSuccess);
  }
}
