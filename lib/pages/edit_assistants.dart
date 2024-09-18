import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/avatar.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/llm.dart';
import 'package:yaaa/utils/predefined.dart';
import 'package:yaaa/utils/utils.dart';

class EditAssistantPage extends StatelessWidget {
  final Assistant assistant;

  const EditAssistantPage({super.key, required this.assistant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_assistant'.trParams({'name': assistant.name})),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: EditAssistantCard(assistant: assistant),
      ),
    );
  }
}

class EditAssistantCard extends StatefulWidget {
  final Assistant assistant;
  const EditAssistantCard({super.key, required this.assistant});

  @override
  State<EditAssistantCard> createState() => _EditAssistantCardState();
}

class _EditAssistantCardState extends State<EditAssistantCard> {
  final assistantController = Get.find<AssistantController>();
  final settingController = Get.find<SettingController>();
  final TextEditingController _avatarTextController = TextEditingController();
  bool chooseAvatar = false;

  @override
  Widget build(BuildContext context) {
    _avatarTextController.text = widget.assistant.avatarUrl ?? '';
    return Column(
      children: [
        _basicInfo(context),
        const Divider(),
        _optionalModelInfo(context),
      ],
    );
  }

  Widget _basicInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('${'assistant_uuid'.tr}: ${widget.assistant.uuid}'),
        ),
        const Divider(),
        Padding(
          padding: dynDevicePadding(2),
          child: Row(
            children: [
              avatarContainer(
                context,
                widget.assistant.avatarUrl,
                onTap: () {
                  chooseAvatar = !chooseAvatar;
                  setState(() {});
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: editAssistantName(),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !chooseAvatar,
          child: Text(
            'edit_avatar_hint'.tr,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Visibility(
          visible: chooseAvatar,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            child: editAssistantAvatar(),
          ),
        ),
        Padding(
          padding: dynDevicePadding(2),
          child: editAssistantDescription(),
        ),
        Padding(
          padding: dynDevicePadding(2),
          child: editAssistantPrompt(),
        ),
        // maybe add some optional ai model settings here
      ],
    );
  }

  Widget editAssistantAvatar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'edit_avatar_info'.tr,
          style: const TextStyle(fontSize: 12),
        ),
        Container(
          padding: dynDevicePadding(2),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double totalWidth = constraints.maxWidth;
              double cardWidth = 48.0;
              int maxCardCountPerRow = min(
                  (totalWidth / cardWidth).toInt(), predefinedAvatar.length);
              // print('total $totalWidth, cardCount $maxCardCountPerRow');
              // 计算每个子组件之间的间距
              double spacing = (totalWidth - (maxCardCountPerRow * cardWidth)) /
                  (maxCardCountPerRow + 1);
              return Wrap(
                spacing: spacing,
                runSpacing: 12.0,
                alignment: WrapAlignment.start,
                children: predefinedAvatar.map((avatar) {
                  return avatarContainer(
                    context,
                    avatar.url,
                    size: cardWidth,
                    onTap: () {
                      _avatarTextController.text = avatar.url;
                      widget.assistant.avatarUrl = avatar.url;
                      assistantController.updateAssistant(widget.assistant);
                      setState(() {});
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
        TextFormField(
          controller: _avatarTextController,
          decoration: InputDecoration(
            labelText: 'assistant_avatar_url'.tr,
          ),
          onChanged: (value) {
            widget.assistant.avatarUrl = value.isEmpty ? null : value;
            assistantController.updateAssistant(widget.assistant);
          },
        ),
        const Divider()
      ],
    );
  }

  Widget editAssistantName() {
    return TextFormField(
      initialValue: widget.assistant.name,
      decoration: InputDecoration(
        labelText: 'assistant_name'.tr,
      ),
      onChanged: (value) {
        widget.assistant.name = value;
        assistantController.updateAssistant(widget.assistant);
      },
    );
  }

  Widget editAssistantDescription() {
    return TextFormField(
      initialValue: widget.assistant.description,
      decoration: InputDecoration(
        labelText: 'assistant_description'.tr,
      ),
      onChanged: (value) {
        widget.assistant.description = value;
        assistantController.updateAssistant(widget.assistant);
      },
    );
  }

  Widget editAssistantPrompt() {
    return TextFormField(
      maxLines: 13,
      initialValue: widget.assistant.prompt,
      decoration: InputDecoration(
        labelText: 'assistant_prompt'.tr,
      ),
      onChanged: (value) {
        widget.assistant.prompt = value;
        assistantController.updateAssistant(widget.assistant);
      },
    );
  }

  Widget _optionalModelInfo(BuildContext context) {
    var useUniqueModel = widget.assistant.definedModel.enable;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              widget.assistant.definedModel.enable = !useUniqueModel;
              assistantController.updateAssistant(widget.assistant);
              setState(() {});
            },
            label:
                Text('${'set_as_defined'.tr} ${useUniqueModel ? '✅' : '🔧'}'),
            icon: useUniqueModel
                ? const Icon(Icons.keyboard_arrow_down_outlined)
                : const Icon(Icons.keyboard_arrow_right_outlined),
          ),
        ),
        Padding(
          padding: dynDevicePadding(2),
          child: Visibility(
            visible: useUniqueModel,
            child: Column(
              children: isMobile()
                  ? [
                      editAssistantDefinedModelProvider(),
                      editAssistantDefinedModelName(),
                      editAssistantDefinedModelTemperature(),
                    ]
                  : [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(child: editAssistantDefinedModelProvider()),
                          Flexible(child: editAssistantDefinedModelName()),
                        ],
                      ),
                      editAssistantDefinedModelTemperature(),
                    ],
            ),
          ),
        ),
      ],
    );
  }

  Widget editAssistantDefinedModelProvider() {
    return Padding(
      padding: dynDevicePadding(2),
      child: DropdownButtonFormField(
        alignment: AlignmentDirectional.bottomEnd,
        decoration: InputDecoration(
          labelText: 'assistant_llm_provider'.tr,
        ),
        items: LLMProviderEnum.values.map(
          (e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.name),
            );
          },
        ).toList(),
        value: widget.assistant.definedModel.provider,
        onChanged: (value) {
          if (value != null) {
            if (widget.assistant.definedModel.provider != value) {
              widget.assistant.definedModel.provider = value;
              widget.assistant.definedModel.modelName =
                  settingController.getCurrentProviderList(value).first;
            }
          } else {
            widget.assistant.definedModel.enable = false;
          }
          assistantController.updateAssistant(widget.assistant);
          setState(() {});
        },
      ),
    );
  }

  Widget editAssistantDefinedModelName() {
    var cProvider = widget.assistant.definedModel.provider;
    return Padding(
      padding: dynDevicePadding(2),
      child: DropdownButtonFormField(
        alignment: AlignmentDirectional.bottomEnd,
        decoration: InputDecoration(
          labelText: 'assistant_default_model'.tr,
        ),
        items: settingController.getCurrentProviderList(cProvider).map(
          (e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          },
        ).toList(),
        value: widget.assistant.definedModel.modelName,
        onChanged: (value) {
          if (value != null) {
            widget.assistant.definedModel.modelName = value;
          } else {
            widget.assistant.definedModel.enable = false;
          }
          assistantController.updateAssistant(widget.assistant);
          setState(() {});
        },
      ),
    );
  }

  Widget editAssistantDefinedModelTemperature() {
    return Padding(
      padding: dynDevicePadding(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('model_temperature'.tr),
          SizedBox(
            width: 280,
            child: Slider(
              label: widget.assistant.definedModel.temperature.toString(),
              value: widget.assistant.definedModel.temperature,
              onChanged: (double newValue) {
                widget.assistant.definedModel.temperature = newValue;
                assistantController.updateAssistant(widget.assistant);
                setState(() {});
              },
              min: 0.0,
              max: 2.0,
              divisions: 20,
            ),
          ),
        ],
      ),
    );
  }
}
