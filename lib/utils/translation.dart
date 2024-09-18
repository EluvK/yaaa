import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'version': 'Yaaa Version: @version',
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
          'model_temperature': 'Temperature',
          'model_setting_notes': '''Noted:
- The BaseURL and APIKey can still be used in Defined Model Assistant, even if it's not the default model here.
- Temperature: Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
''',
          // chatbox && conversation
          'find_history': ' Chat History',
          'view_history': ' View History',
          'clear_context': ' Clear Context',
          'type_message_hint': 'Type `/` to chat...',
          // contact
          'contact': 'Contact',
          // assistant
          'assistant': 'Assistants',
          'my_assistants': 'My Assistants',
          'assistant_templates': 'Assistant Templates',
          'no_user_assistants_noted':
              'No assistant found. Try duplicating one.',
          'assistant_not_found': 'Assistant not found.',
          // edit assistant
          'edit_assistant': 'Edit Assistant `@name`',
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
          // edit conversation
          'edit_conversation': 'Edit Conversation `@name`',
          'conversation_uuid': 'Conversation UUID',
          'conversation_name': 'Conversation Name',
          'tooltip_edit_conversation': 'Edit Conversation',
          'tooltip_delete_conversation': 'Delete Conversation',
          'tooltip_duplicate_conversation': 'Duplicate Conversation',
          'tooltip_edit_assistant': 'Edit Assistant',
          'tooltip_delete_assistant': 'Delete Assistant',
          'tooltip_duplicate_assistant': 'Duplicate Assistant',
          'tooltip_like': 'Like',
          // double click
          'double_click_title': 'Double Click Check!',
          'double_click_delete_assistant_hint':
              'Click twice to delete assistant.',
          'double_click_delete_message_hint':
              'Click twice to delete message and response.',
          'double_click_delete_conversation_hint':
              'Click twice to delete conversation.',
          // conversation
          'token_usage':
              '(prompt: @promptToken tokens, completion: @completionToken tokens)',
          // others
          'information': 'Info',
          'error': 'Error',
          'copy_to_clipboard': 'Copy to Clipboard',
          'file_saved': 'File saved to @path',
          // info page
          'shortcut': 'ShortCuts',
          'shortcut_chat': 'Chat',
          'shortcut_search': 'Search',
          'shortcut_clear_context': 'Clear Context',
          'shortcut_next_conversation': 'Next Conversation',
          'shortcut_previous_conversation': 'Previous Conversation',
          'shortcut_new_conversation': 'New Conversation',
          'shortcut_settings': 'Open Settings',
          'about': 'About',
        },
        'zh_CN': {
          'version': 'Yaaa 版本: @version',
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
          'model_temperature': '模型温度',
          'model_setting_notes': '''说明
- 即使不是默认模型，BaseURL 和 APIKey 仍然可以在自定义模型助手中使用。
- 模型温度设置越高，输出会更随机；模型温度设置越低，输出会更确定。
''',
          // chatbox && conversation
          'find_history': ' 搜索历史对话',
          'view_history': ' 加载历史记录',
          'clear_context': ' 清除上下文',
          'type_message_hint': '输入消息...',
          // contact
          'contact': '对话列表',
          // assistant
          'assistant': '助手',
          'my_assistants': '自定义助手',
          'assistant_templates': '助手模板',
          'no_user_assistants_noted': '暂无自定义助手，从下列模板中复制一个吧。',
          'assistant_not_found': '未找到该助手。',
          // edit assistant
          'edit_assistant': '编辑助手 `@name`',
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
          // edit conversation
          'edit_conversation': '编辑对话 `@name`',
          'conversation_uuid': '对话 ID',
          'conversation_name': '对话名称',
          'tooltip_edit_conversation': '编辑对话',
          'tooltip_delete_conversation': '删除对话',
          'tooltip_duplicate_conversation': '复制对话',
          'tooltip_edit_assistant': '编辑助手',
          'tooltip_delete_assistant': '删除助手',
          'tooltip_duplicate_assistant': '复制助手',
          'tooltip_like': '收藏',
          // double click
          'double_click_title': '双击确认！',
          'double_click_delete_assistant_hint': '双击删除助手。',
          'double_click_delete_message_hint': '双击删除消息和回复。',
          'double_click_delete_conversation_hint': '双击删除对话。',
          // conversation
          'token_usage':
              '(提示词 Token: @promptToken, 回答 Token: @completionToken)',
          // others
          'information': '提示',
          'error': '错误',
          'copy_to_clipboard': '已复制到剪贴板',
          'file_saved': '文件已保存至 @path',
          // info page
          'shortcut': '快捷键',
          'shortcut_chat': '聊天',
          'shortcut_search': '搜索',
          'shortcut_clear_context': '清除上下文',
          'shortcut_next_conversation': '下一个对话',
          'shortcut_previous_conversation': '上一个对话',
          'shortcut_new_conversation': '新建对话',
          'shortcut_settings': '打开设置',
          'about': '关于',
        }
      };
}
