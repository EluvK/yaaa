import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  final box = GetStorage();

  // app settings
  final themeMode = ThemeMode.system.obs;
  final fontSize = 1.0.obs;

  // model settings
  // final model = ''.obs;
  final model = Model.openAI_GPT4.obs;
  final baseUrl = ''.obs;
  final apiKey = ''.obs;

  static SettingController get to => Get.find<SettingController>();

  @override
  Future<void> onInit() async {
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
    String modelText = box.read('model') ?? 'OpenAI GPT-4';
    print('read model from box $modelText');
    try {
      model.value = Model.values.firstWhere((e) => e.name == modelText);
    } catch (_) {
      print('model not found, setting to OpenAI GPT-4');
      model.value = Model.openAI_GPT4;
    }

    String baseUrlText = box.read('baseUrl') ?? model.value.url;
    print('read baseUrl from box $baseUrlText');
    baseUrl.value = baseUrlText;

    String apiKeyText = box.read('apiKey') ?? '';
    print('read apiKey from box $apiKeyText');
    apiKey.value = apiKeyText;
  }

  setModel(Model model) {
    print('setting model: $model');
    this.model.value = model;
    box.write('model', model.name);
  }

  setBaseUrl(String url) {
    print('setting baseUrl: $url');
    baseUrl.value = url;
    box.write('baseUrl', url);
  }

  setApiKey(String key) {
    print('setting apiKey: $key');
    apiKey.value = key;
    box.write('apiKey', key);
  }
}

enum Model {
// ignore: constant_identifier_names
  openAI_GPT4,
// ignore: constant_identifier_names
  DeepSeek_Chat,
// ignore: constant_identifier_names
  DeepSeek_Code,
}

// impl url and name string for model
extension ModelExt on Model {
  String get name {
    switch (this) {
      case Model.openAI_GPT4:
        return 'OpenAI GPT-4';
      case Model.DeepSeek_Chat:
        return 'DeepSeek Chat';
      case Model.DeepSeek_Code:
        return 'DeepSeek Code';
    }
  }

  String get url {
    switch (this) {
      case Model.openAI_GPT4:
        return 'https://api.openai.com';
      case Model.DeepSeek_Chat:
        return 'https://api.deepseek.com';
      case Model.DeepSeek_Code:
        return 'https://api.deepseek.com';
    }
  }
}
