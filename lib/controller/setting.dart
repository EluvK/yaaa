import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaaa/model/llm.dart';

class SettingController extends GetxController {
  final box = GetStorage('YaaaGetStorage');

  // app settings
  final themeMode = ThemeMode.system.obs;
  final fontSize = 1.0.obs;
  final locale = const Locale('en').obs;
  final expandContactList = true.obs;

  // model settings
  final defaultProvider = LLMProviderEnum.OpenAI.obs;
  final RxMap<String, LLMProvider> providers = {
    "openai": LLMProvider.openAI,
    "deepseek": LLMProvider.deepSeek,
  }.obs;

  static SettingController get to => Get.find<SettingController>();

  // v0.0.4 migrate box container to YaaaGetStorage
  fix004Migrate() async {
    print('========start fix004 Migrate========');
    String? tryReadTheme = box.read('theme');
    print('tryReadTheme $tryReadTheme');
    if (tryReadTheme != null) {
      print('migrate has been done');
      return;
    }

    await GetStorage.init('GetStorage');
    final oldBox = GetStorage('GetStorage');

    // get app setting:
    String themeText = oldBox.read('theme') ?? 'system';
    print('read theme from old_box $themeText');
    try {
      themeMode.value =
          ThemeMode.values.firstWhere((e) => e.toString() == themeText);
    } catch (e) {
      print('theme not found, setting to system $e');
      themeMode.value = ThemeMode.system;
    }

    fontSize.value = oldBox.read('fontSize') ?? 1.0;
    print('read fontSized from old_box $fontSize');

    String? localeLanguage =
        oldBox.read('locale') ?? Get.deviceLocale?.languageCode;
    if (localeLanguage != null) {
      locale.value = Locale(localeLanguage);
    }
    // locale = oldBox.read('locale') ?? Get.deviceLocale;
    print('read locale from old_box $locale');

    expandContactList.value = oldBox.read('expandContactList') ?? true;

    var readValue = oldBox.read('providers');
    print('read providers from old_box $readValue');
    if (readValue != null) {
      var jsonValue = jsonDecode(readValue);
      print("getModelSetting $jsonValue");
      // providers.value = jsonDecode(readValue);
      jsonValue.forEach((key, value) {
        providers[key] = LLMProvider.fromJson(value);
      });
    }

    // v0.0.4 fix v0.0.3 code typo
    if (providers['deepseek']?.model.contains('deepseek-code') ?? false) {
      providers['deepseek']?.model.remove('deepseek-code');
      providers['deepseek']?.model.add('deepseek-coder');
    }

    print('============migrate finish============');
    saveAppSetting();
    saveModelSetting();
  }

  @override
  Future<void> onInit() async {
    print('setting controller onInit');
    await getAppSetting();
    await getModelSetting();
    super.onInit();
    _initialized = true;
  }

  bool _initialized = false;
  Future<void> ensureInitialization() async {
    while (!_initialized) {
      await onInit();
    }
    return;
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

    String? localeLanguage =
        box.read('locale') ?? Get.deviceLocale?.languageCode;
    if (localeLanguage != null) {
      locale.value = Locale(localeLanguage);
    }
    // locale = box.read('locale') ?? Get.deviceLocale;
    print('read locale from box $locale');

    expandContactList.value = box.read('expandContactList') ?? true;
  }

  saveAppSetting() {
    box.write('theme', themeMode.value.toString());
    box.write('fontSize', fontSize.value);
    box.write('locale', locale.value.languageCode);
    box.write('expandContactList', expandContactList.value);
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

  setLocale(Locale locale) {
    print('setting locale: $locale');
    this.locale.value = locale;
    Get.updateLocale(locale);
    box.write('locale', locale.languageCode);
  }

  setExpandContactList(bool expand) {
    print('setting expand contact list: $expand');
    expandContactList.value = expand;
    box.write('expandContactList', expandContactList.value);
  }

  bool getExpandContactList() {
    return expandContactList.value;
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
