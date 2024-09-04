import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yaaa/client/llm/common.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/model/llm.dart';

class Deepseek {
  void chat(
    List<Message> messages,
    DefinedModel? definedModel,
    ValueChanged<Message> onStream,
    ValueChanged<Message> onError,
    ValueChanged<Message> onSuccess,
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

    commonOpenAIClientChat(
        apiKey, baseUrl, model, messages, onStream, onError, onSuccess);
  }
}
