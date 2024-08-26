import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/controller/setting.dart';

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
        child: Column(
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
            child: Text('App Settings'),
          ),
        ),
        // add column if more settings
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            verticalDirection: VerticalDirection.up,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ThemeMode'),
              SegmentedButton(
                segments: const [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.settings_system_daydream_sharp),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
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
      ],
    );
  }

  Widget _modelSetting(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Model Settings'),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                alignment: AlignmentDirectional.bottomEnd,
                decoration: const InputDecoration(
                  labelText: 'Model',
                ),
                items: Model.values.map(
                  (e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    );
                  },
                ).toList(),
                value: settingController.model.value,
                onChanged: (value) {
                  settingController.setModel(value ?? Model.openAI_GPT4);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Base URL',
                  hintText: 'https://api.openai.com',
                ),
                controller: TextEditingController(
                  text: settingController.baseUrl.value,
                ),
                onChanged: (value) {
                  settingController.setBaseUrl(value);
                },
              ),
            ),
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
                  hintText: 'sk-your-api-key',
                ),
                controller: TextEditingController(
                  text: settingController.apiKey.value,
                ),
                obscureText: !_skVisible,
                onChanged: (value) {
                  settingController.setApiKey(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
