import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/client/llm/deepseek.dart';
import 'package:yaaa/client/llm/openai.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/model/llm.dart';

class ClientManager {
  static final ClientManager _instance = ClientManager._internal();

  factory ClientManager() {
    return _instance;
  }

  ClientManager._internal();

  void postMessage(
    List<Message> messages,
    DefinedModel? definedModel,
    ValueChanged<Message> onStream,
    ValueChanged<Message> onError,
    ValueChanged<Message> onSuccess,
  ) {
    final settingController = Get.find<SettingController>();
    LLMProviderEnum provider = settingController.getDefaultProvider();
    if (definedModel != null && definedModel.enable) {
      provider = definedModel.provider;
    }

    switch (provider) {
      case LLMProviderEnum.OpenAI:
        OpenAI().chat(messages, definedModel, onStream, onError, onSuccess);
        break;
      case LLMProviderEnum.DeepSeek:
        Deepseek().chat(messages, definedModel, onStream, onError, onSuccess);
        break;
      default:
        break;
    }
  }
}
