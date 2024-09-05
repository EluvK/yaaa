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
        padding: dynDevicePadding(4),
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
          padding: dynDevicePadding(2),
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
          padding: dynDevicePadding(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('language'.tr),
              DropdownButton<Locale>(
                value: settingController.locale.value,
                onChanged: (Locale? newValue) {
                  settingController.setLocale(newValue!);
                  setState(() {});
                },
                items: const [
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: Locale('zh'),
                    child: Text('中文'),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ThemeMode
        Padding(
          padding: dynDevicePadding(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('theme_mode'.tr),
              SegmentedButton(
                segments: [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    tooltip: 'mode_light'.tr,
                    icon: const Icon(Icons.light_mode_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    tooltip: 'mode_system'.tr,
                    value: ThemeMode.system,
                    icon: const Icon(Icons.settings_applications_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    tooltip: 'mode_dark'.tr,
                    icon: const Icon(Icons.dark_mode_sharp),
                  ),
                ],
                showSelectedIcon: false,
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
          padding: dynDevicePadding(4),
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
          visible: !isMobile(),
          child: Padding(
            padding: dynDevicePadding(4),
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
          padding: dynDevicePadding(2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'default_model_settings'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: dynDevicePadding(1),
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
          padding: dynDevicePadding(1),
          child: Column(
            children: [
              // default model and base url
              isMobile()
                  ? Column(
                      children: [
                        // choose provider default model
                        _editProviderDefaultModel(cProvider),
                        // choose provider url
                        _editProviderBaseUrl(cProvider),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // choose provider default model
                        Flexible(
                          flex: 2,
                          child: _editProviderDefaultModel(cProvider),
                        ),
                        // choose provider url
                        Flexible(
                          flex: 3,
                          child: _editProviderBaseUrl(cProvider),
                        ),
                      ],
                    ),
              // api key
              _editAPIKey(cProvider),
            ],
          ),
        ),
        Padding(
          padding: dynDevicePadding(4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('model_setting_notes'.tr),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _editProviderDefaultModel(LLMProviderEnum cProvider) {
    return Padding(
      padding: dynDevicePadding(2),
      child: DropdownButtonFormField(
        alignment: AlignmentDirectional.bottomEnd,
        decoration: InputDecoration(
          labelText: 'default_model'.tr,
        ),
        items: settingController.getCurrentProviderList(cProvider).map(
          (e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          },
        ).toList(),
        value: settingController.getCurrentProviderDefaultModel(cProvider),
        onChanged: (value) {
          settingController.setCurrentProviderDefaultModel(
            cProvider,
            value!,
          );
        },
      ),
    );
  }

  Widget _editProviderBaseUrl(LLMProviderEnum cProvider) {
    return Padding(
      padding: dynDevicePadding(2),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'base_url'.tr,
          hintText: cProvider.defaultBaseUrl,
        ),
        controller: TextEditingController(
          text: settingController.getCurrentProviderBaseUrl(cProvider),
        ),
        onChanged: (value) {
          settingController.setCurrentProviderBaseUrl(
            cProvider,
            value,
          );
        },
      ),
    );
  }

  Widget _editAPIKey(LLMProviderEnum cProvider) {
    return Padding(
      padding: dynDevicePadding(2),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(_skVisible ? Icons.visibility : Icons.visibility_off),
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
    );
  }
}
