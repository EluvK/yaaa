import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/llm.dart';

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
        title: const Text('Setting'),
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
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'App Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ThemeMode'),
              SegmentedButton(
                segments: const [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text(
                      'Light',
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                    icon: Icon(Icons.light_mode_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text(
                      'System',
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                    icon: Icon(Icons.settings_system_daydream_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text(
                      'Dark',
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                    icon: Icon(Icons.dark_mode_sharp),
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
              const Text('FontScale'),
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
      ],
    );
  }

  Widget _modelSetting(BuildContext context) {
    var cProvider = settingController.defaultProvider.value;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Default Model Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButtonFormField(
            alignment: AlignmentDirectional.bottomEnd,
            decoration: const InputDecoration(
              labelText: 'Default LLM Provider',
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
                        decoration: const InputDecoration(
                          labelText: 'Default Model',
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
                        decoration: const InputDecoration(
                          labelText: 'Base URL',
                          hintText: 'https://api.openai.com',
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
                    labelText: 'API Key',
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
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
                '- The BaseURL and APIKey can still be used in Defined Model Assistant, even if it\'s not the default model here.'),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
