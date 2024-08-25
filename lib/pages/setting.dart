import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final box = GetStorage();

  // model settings
  String _model = '';
  String _baseUrl = '';
  String _apiKey = '';

  // app settings
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _model = box.read('model') ?? 'gpt-4';
    _baseUrl = box.read('baseUrl') ?? 'https://api.openai.com';
    _apiKey = box.read('apiKey') ?? 'sk-your-api-key';
    print('model: $_model, baseUrl: $_baseUrl, apiKey: $_apiKey');

    _darkMode = box.read('darkMode') ?? false;

    setState(() {});
  }

  void _saveSettings() {
    box.write('model', _model);
    box.write('baseUrl', _baseUrl);
    box.write('apiKey', _apiKey);
    print('save setting model: $_model, baseUrl: $_baseUrl, apiKey: $_apiKey');

    box.write('darkMode', _darkMode);
    print('save setting darkMode: $_darkMode');
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('App Settings'),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) {
              _darkMode = value;
              _saveSettings();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _modelSetting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Model Settings'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Model',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'gpt-4',
                  child: Text('OpenAI GPT-4'),
                ),
                DropdownMenuItem(
                  value: 'deepseek-chat',
                  child: Text('DeepSeek Chat'),
                ),
                DropdownMenuItem(
                  value: 'deepseek-code',
                  child: Text('DeepSeek Code'),
                ),
              ],
              value: _model,
              onChanged: (value) {
                _model = value?.toString() ?? '';
                _saveSettings();
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
              controller: TextEditingController(text: _baseUrl),
              onChanged: (value) {
                _baseUrl = value;
                _saveSettings();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'sk-your-api-key',
              ),
              controller: TextEditingController(text: _apiKey),
              onChanged: (value) {
                _apiKey = value;
                _saveSettings();
              },
            ),
          ),
        ],
      ),
    );
  }
}
