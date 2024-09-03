import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/llm.dart';
import 'package:yaaa/utils/utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final settingController = Get.find<SettingController>();

  bool _skVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setting'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _appSetting(context),
            const Divider(),
            _modelSetting(context),
            // const Placeholder(),
          ],
        ),
      ),
    );
  }

  Widget _appSetting(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'app_settings'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Language
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('language'.tr),
              DropdownButton<Locale>(
                value: settingController.locale ?? Get.deviceLocale,
                onChanged: (Locale? newValue) {
                  settingController.setLocale(newValue!);
                  setState(() {});
                },
                items: const [
                  DropdownMenuItem(
                    value: Locale('en', 'US'),
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: Locale('zh', 'CN'),
                    child: Text('中文'),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ThemeMode
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('theme_mode'.tr),
              SegmentedButton(
                segments: [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text(
                      'mode_light'.tr,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                    icon: const Icon(Icons.light_mode_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text(
                      'mode_system'.tr,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                    icon: const Icon(Icons.settings_system_daydream_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text(
                      'mode_dark'.tr,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                    icon: const Icon(Icons.dark_mode_sharp),
                  ),
                ],
                selected: {settingController.themeMode.value},
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  settingController.setThemeMode(newSelection.first);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        // FontSize
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('font_scale'.tr),
              SizedBox(
                width: 280,
                child: Slider(
                  label: settingController.fontSize.value.toString(),
                  value: settingController.fontSize.value,
                  onChanged: (double newValue) {
                    settingController.setFontSize(newValue);
                    setState(() {});
                  },
                  min: 0.75,
                  max: 1.25,
                  divisions: 10,
                ),
              ),
            ],
          ),
        ),
        // Simple Contact List
        Visibility(
          visible: !isMobile(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('expand_contact_list'.tr),
                Switch(
                  value: settingController.expandContactList.value,
                  onChanged: (bool newValue) {
                    settingController.setExpandContactList(newValue);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _modelSetting(BuildContext context) {
    var cProvider = settingController.defaultProvider.value;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'default_model_settings'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButtonFormField(
            alignment: AlignmentDirectional.bottomEnd,
            decoration: InputDecoration(
              labelText: 'default_llm_provider'.tr,
            ),
            items: LLMProviderEnum.values.map(
              (e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                );
              },
            ).toList(),
            value: cProvider,
            onChanged: (value) {
              settingController.setDefaultProvider(value);
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              // default model and base url
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // choose provider default model
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        alignment: AlignmentDirectional.bottomEnd,
                        decoration: InputDecoration(
                          labelText: 'default_model'.tr,
                        ),
                        items: settingController
                            .getCurrentProviderList(cProvider)
                            .map(
                          (e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          },
                        ).toList(),
                        value: settingController
                            .getCurrentProviderDefaultModel(cProvider),
                        onChanged: (value) {
                          settingController.setCurrentProviderDefaultModel(
                            cProvider,
                            value!,
                          );
                        },
                      ),
                    ),
                  ),
                  // choose provider url
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'base_url'.tr,
                          hintText: cProvider.defaultBaseUrl,
                        ),
                        controller: TextEditingController(
                          text: settingController
                              .getCurrentProviderBaseUrl(cProvider),
                        ),
                        onChanged: (value) {
                          settingController.setCurrentProviderBaseUrl(
                            cProvider,
                            value,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // api key
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          _skVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _skVisible = !_skVisible;
                        });
                      },
                    ),
                    labelText: 'api_key'.tr,
                    hintText: 'sk-apiKey-xxxxx',
                    // helperText: 'set your api key',
                  ),
                  controller: TextEditingController(
                    text: settingController.getCurrentProviderApiKey(cProvider),
                  ),
                  obscureText: !_skVisible,
                  onChanged: (value) {
                    settingController.setCurrentProviderApiKey(
                      cProvider,
                      value,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('model_setting_notes'.tr),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
