import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yaaa/client/llm/common.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/model/llm.dart';

class OpenAI {
  void chat(
    List<Message> messages,
    DefinedModel? definedModel,
    ValueChanged<Message> onStream,
    ValueChanged<Message> onError,
    ValueChanged<Message> onSuccess,
  ) async {
    print('OpenAI chat');

    final settingController = Get.find<SettingController>();
    final baseUrl =
        settingController.getCurrentProviderBaseUrl(LLMProviderEnum.OpenAI);
    final apiKey =
        settingController.getCurrentProviderApiKey(LLMProviderEnum.OpenAI);
    var model = settingController
        .getCurrentProviderDefaultModel(LLMProviderEnum.OpenAI);
    var temperature =
        settingController.getCurrentProviderTemperature(LLMProviderEnum.OpenAI);
    if (definedModel != null && definedModel.enable) {
      model = definedModel.modelName;
      temperature = definedModel.temperature;
    }

    final param = ModelParam(
      baseUrl: baseUrl,
      apiKey: apiKey,
      modelName: model,
      temperature: temperature,
    );
    commonOpenAIClientChat(param, messages, onStream, onError, onSuccess);
  }
}
