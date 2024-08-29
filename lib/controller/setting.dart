import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaaa/model/llm.dart';

class SettingController extends GetxController {
  final box = GetStorage();

  // app settings
  final themeMode = ThemeMode.system.obs;
  final fontSize = 1.0.obs;

  // model settings
  final defaultProvider = LLMProviderEnum.OpenAI.obs;
  final RxMap<String, LLMProvider> providers = {
    "openai": LLMProvider.openAI,
    "deepseek": LLMProvider.deepSeek,
  }.obs;

  static SettingController get to => Get.find<SettingController>();

  @override
  Future<void> onInit() async {
    // print('$providers');
    await getAppSetting();
    await getModelSetting();
    super.onInit();
  }

  getAppSetting() async {
    String themeText = box.read('theme') ?? 'system';
    print('read theme from box $themeText');
    try {
      themeMode.value =
          ThemeMode.values.firstWhere((e) => e.toString() == themeText);
    } catch (_) {
      print('theme not found, setting to system');
      themeMode.value = ThemeMode.system;
    }

    fontSize.value = box.read('fontSize') ?? 1.0;
    print('read fontSized from box $fontSize');
  }

  setThemeMode(ThemeMode theme) {
    print('setting theme: $theme');
    themeMode.value = theme;
    Get.changeThemeMode(themeMode.value);
    box.write('theme', themeMode.value.toString());
  }

  setFontSize(double font) {
    print('setting font: $font');
    fontSize.value = font;
    Get.forceAppUpdate();
    box.write('fontSize', fontSize.value);
  }

  getModelSetting() async {
    var readValue = box.read('providers');
    print('read providers from box $readValue');
    if (readValue != null) {
      var jsonValue = jsonDecode(readValue);
      print("getModelSetting $jsonValue");
      // providers.value = jsonDecode(readValue);
      jsonValue.forEach((key, value) {
        providers[key] = LLMProvider.fromJson(value);
      });
    }
  }

  saveModelSetting() {
    print('setModelSettingNew ${jsonEncode(providers.value)}');
    box.write('providers', jsonEncode(providers));
  }

  LLMProviderEnum getDefaultProvider() {
    String defaultProvider = box.read('defaultProvider') ?? 'OpenAI';
    return LLMProviderEnum.values.firstWhere((e) => e.name == defaultProvider);
  }

  setDefaultProvider(LLMProviderEnum? provider) {
    defaultProvider.value = provider ?? LLMProviderEnum.OpenAI;
    print('set default provider ${defaultProvider.value.name}');
    box.write('defaultProvider', defaultProvider.value.name);
  }

  List<String> getCurrentProviderList(LLMProviderEnum provider) {
    switch (provider) {
      case LLMProviderEnum.OpenAI:
        return (providers['openai'] ?? LLMProvider.openAI).model;
      case LLMProviderEnum.DeepSeek:
        return (providers['deepseek'] ?? LLMProvider.deepSeek).model;
    }
  }

  String getCurrentProviderBaseUrl(LLMProviderEnum provider) {
    switch (provider) {
      case LLMProviderEnum.OpenAI:
        return (providers['openai'] ?? LLMProvider.openAI).baseUrl;
      case LLMProviderEnum.DeepSeek:
        return (providers['deepseek'] ?? LLMProvider.deepSeek).baseUrl;
    }
  }

  setCurrentProviderBaseUrl(LLMProviderEnum provider, String url) {
    switch (provider) {
      case LLMProviderEnum.OpenAI:
        providers['openai']!.baseUrl = url;
        break;
      case LLMProviderEnum.DeepSeek:
        providers['deepseek']!.baseUrl = url;
        break;
    }
    saveModelSetting();
  }

  String? getCurrentProviderApiKey(LLMProviderEnum provider) {
    switch (provider) {
      case LLMProviderEnum.OpenAI:
        return (providers['openai'] ?? LLMProvider.openAI).apiKey;
      case LLMProviderEnum.DeepSeek:
        return (providers['deepseek'] ?? LLMProvider.deepSeek).apiKey;
    }
  }

  setCurrentProviderApiKey(LLMProviderEnum provider, String apiKey) {
    switch (provider) {
      case LLMProviderEnum.OpenAI:
        providers['openai']!.apiKey = apiKey;
        break;
      case LLMProviderEnum.DeepSeek:
        providers['deepseek']!.apiKey = apiKey;
        break;
    }
    saveModelSetting();
  }

  String getCurrentProviderDefaultModel(LLMProviderEnum provider) {
    switch (provider) {
      case LLMProviderEnum.OpenAI:
        return (providers['openai'] ?? LLMProvider.openAI).defaultModel;
      case LLMProviderEnum.DeepSeek:
        return (providers['deepseek'] ?? LLMProvider.deepSeek).defaultModel;
    }
  }

  setCurrentProviderDefaultModel(
      LLMProviderEnum provider, String defaultModel) {
    switch (provider) {
      case LLMProviderEnum.OpenAI:
        providers['openai']!.defaultModel = defaultModel;
        break;
      case LLMProviderEnum.DeepSeek:
        providers['deepseek']!.defaultModel = defaultModel;
        break;
    }
    saveModelSetting();
  }
}
