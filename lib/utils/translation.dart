import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // settings
          'setting': 'Setting',
          'app_settings': 'App Settings',
          'language': 'Language',
          'theme_mode': 'ThemeMode',
          'mode_light': 'Light',
          'mode_system': 'System',
          'mode_dark': 'Dark',
          'font_scale': 'Font Scale',
          'expand_contact_list': 'Expand Contact List',
          'default_model_settings': 'Default Model Settings',
          'default_llm_provider': 'Default LLM Provider',
          'default_model': 'Default Model',
          'base_url': 'Base URL',
          'api_key': 'API Key',
          'model_setting_notes':
              '- The BaseURL and APIKey can still be used in Defined Model Assistant, even if it\'s not the default model here.',
          // chatbox
          'clear_context': ' Clear Context',
          'type_message_hint': 'Type a message...',
          // contact
          'contact': 'Contact',
          // assistant
          'assistant': 'Assistants',
          'my_assistants': 'My Assistants',
          'assistant_templates': 'Assistant Templates',
          'no_user_assistants_noted':
              'No assistant found. Try duplicating one.',
          // edit assistant
          'edit_assistant': 'Edit `@name`',
          'assistant_uuid': 'Assistant UUID',
          'edit_avatar_hint': '  👆 Tap to edit avatar',
          'edit_avatar_info': 'choose one or edit Avatar Url Directly',
          'assistant_avatar_url': 'Assistant Avatar URL',
          'assistant_name': 'Assistant Name',
          'assistant_description': 'Description',
          'assistant_prompt': 'Prompt',
          'set_as_defined': 'Set Defined Model',
          'assistant_llm_provider': 'LLM Provider',
          'assistant_default_model': 'Default Model',
          // double click
          'double_click_title': 'Double Click Check!',
          'double_click_delete_assistant_hint':
              'Click twice to delete assistant.',
          'double_click_delete_message_hint':
              'Click twice to delete message and response.',
          // conversation
          'token_usage':
              '(prompt: @promptToken tokens, completion: @completionToken tokens)',
          // others
          'information': 'Info',
          'copy_to_clipboard': 'Copy to Clipboard',
          'file_saved': 'File saved to @path',
        },
        'zh_CN': {
          // settings
          'setting': '设置',
          'app_settings': '应用设置',
          'language': '语言',
          'theme_mode': '主题模式',
          'mode_light': '亮色',
          'mode_system': '跟随系统',
          'mode_dark': '暗色',
          'font_scale': '字体缩放',
          'expand_contact_list': '展开对话列表',
          'default_model_settings': '默认模型设置',
          'default_llm_provider': '默认 LLM 提供商',
          'default_model': '默认模型',
          'base_url': '接口 URL',
          'api_key': 'API 密钥',
          'model_setting_notes': '- 即使不是默认模型，BaseURL 和 APIKey 仍然可以在自定义模型助手中使用。',
          // chatbox
          'clear_context': ' 清除上下文',
          'type_message_hint': '输入消息...',
          // contact
          'contact': '对话列表',
          // assistant
          'assistant': '助手',
          'my_assistants': '自定义助手',
          'assistant_templates': '助手模板',
          'no_user_assistants_noted': '暂无自定义助手，从下列模板中复制一个吧。',
          // edit assistant
          'edit_assistant': '编辑 `@name`',
          'assistant_uuid': '助手 ID',
          'edit_avatar_hint': '  👆 点击编辑头像',
          'edit_avatar_info': '选择一个或直接编辑头像 URL',
          'assistant_avatar_url': '助手头像 URL',
          'assistant_name': '助手名称',
          'assistant_description': '描述',
          'assistant_prompt': '提示词',
          'set_as_defined': '设为自定义模型',
          'assistant_llm_provider': '语言模型提供商',
          'assistant_default_model': '默认模型',
          // double click
          'double_click_title': '双击确认！',
          'double_click_delete_assistant_hint': '双击删除助手。',
          'double_click_delete_message_hint': '双击删除消息和回复。',
          // conversation
          'token_usage':
              '(提示词 Token: @promptToken, 回答 Token: @completionToken)',
          // others
          'information': '提示',
          'copy_to_clipboard': '已复制到剪贴板',
          'file_saved': '文件已保存至 @path',
        }
      };
}
