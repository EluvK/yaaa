import 'package:yaaa/model/assistant.dart';
import 'package:yaaa/model/conversation.dart';

class Avatar {
  final String name;
  final String url;

  Avatar({required this.name, required this.url});
}

// predefined avatars
final List<Avatar> predefinedAvatar = [
  Avatar(
      name: 'translate',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/translate.png'),
  Avatar(
      name: 'github',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/github.png'),
  Avatar(
      name: 'programmer',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/programmer.png'),
  Avatar(
      name: 'android',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/android.png'),
  Avatar(
      name: 'front_dev',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/front_dev.png'),
  Avatar(
      name: 'location',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/location.png'),
  Avatar(
      name: 'rust',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/rust.png'),
  Avatar(
      name: 'shell',
      url:
          'https://pub-5e558c4b947049949194c0096be6a4ca.r2.dev/avatar/shell.png'),
];

// predefined assistants
final List<Assistant> predefinedAssistant = [
  Assistant(
    name: 'Rust 语言专家',
    uuid: '6546beb9-acc5-4cf7-bf05-a8bdf0360e20',
    type: AssistantType.system,
    description: '替代：stackoverflow',
    prompt:
        '我希望你充当 Rust 语言专家。我会告诉你我的需求，你会告诉我如何实现它们。我希望你用更好的方法、更好的代码、更好的库和框架来实现我的需求。我希望你只回复代码，别无其他，不要写解释除非我特别询问你解释代码。',
    avatarUrl:
        predefinedAvatar.firstWhere((element) => element.name == 'rust').url,
    definedModel: DefinedModel.defaultDisable(),
  ),
  Assistant(
    name: '文本生成',
    uuid: 'a46fa66e-9a33-4b04-90c0-7a11870f9e2d',
    type: AssistantType.system,
    description: '',
    prompt:
        '我希望你充当文本生成器。我会告诉你一些模板，它们可能是代码可能是配置项，然后会告诉你一些需要生成的变量内容，你会根据模板和变量生成文本。我希望你只回复生成的文本，别无其他，不要写解释。我可能会分多次告诉你，比如第一次告诉你模板，第二次告诉你需要需要生成替换的内容，此时你可以简单回复我请告知我需要替换的文本即可。',
    avatarUrl:
        predefinedAvatar.firstWhere((element) => element.name == 'android').url,
    definedModel: DefinedModel.defaultDisable(),
  ),
  Assistant(
    name: 'Shell 命令行专家',
    uuid: '5d87954f-ffc6-4fa0-b2d0-898a369bb565',
    type: AssistantType.system,
    description: '替代：stackoverflow',
    prompt:
        '我希望你充当 Shell 命令行专家。我会告诉你我的需求，你会告诉我如何实现它们。我希望你用更好的方法、更好的更简洁的代码、来实现我的需求。我希望你只回复代码，别无其他，不要写解释除非我特别询问你解释代码。',
    avatarUrl:
        predefinedAvatar.firstWhere((element) => element.name == 'shell').url,
    definedModel: DefinedModel.defaultDisable(),
  ),
  Assistant(
    name: '高级前端开发',
    uuid: '30f276ef-7c35-452a-83cc-2ef53ee35415',
    type: AssistantType.system,
    description: '替代：stackoverflow',
    prompt:
        '我希望你充当高级前端开发者。我会告诉你我的需求，你会告诉我如何实现它们。我希望你用更好的方法、更好的代码、更好的库和框架来实现我的需求。我希望你只回复代码，别无其他，不要写解释除非我特别询问你解释代码。',
    avatarUrl: predefinedAvatar
        .firstWhere((element) => element.name == 'front_dev')
        .url,
    definedModel: DefinedModel.defaultDisable(),
  ),
  Assistant(
    name: '英语翻译和改进',
    uuid: '0170fd5d-2b08-4837-a88a-775df27d86b1',
    type: AssistantType.system,
    description: '替代：语法，谷歌翻译',
    prompt:
        '我希望你充当英语翻译、拼写纠正和改进者。我会用任何语言和你说话，你会检测语言，翻译它，并用英语回答我文本的纠正和改进版本。我希望你用更漂亮、更优雅、更高级的英语单词和句子替换我的单词和句子。保持含义不变，但使它们更具文学性。我希望你只回复纠正、改进，别无其他，不要写解释。',
    avatarUrl: predefinedAvatar
        .firstWhere((element) => element.name == 'translate')
        .url,
    definedModel: DefinedModel.defaultDisable(),
  ),
  Assistant(
    name: '旅游向导',
    uuid: '596c02e9-edf4-4ef8-bbbe-06b058c4ad59',
    type: AssistantType.system,
    description: '',
    prompt:
        '我希望你充当我的旅行向导。我会写下我的位置，然后你建议我附近可以参观的地方。在某些情况下，我还会告诉你我要参观的地方类型。你还会建议我靠近我的第一个位置的类似地方。',
    avatarUrl: predefinedAvatar
        .firstWhere((element) => element.name == "location")
        .url,
    definedModel: DefinedModel.defaultDisable(),
  ),
];

// predefined conversations
final List<Conversation> predefinedConversation = [
  Conversation(
    uuid: 'c5e52ce2-8e21-4bd0-bfc2-4d8c9e827386',
    name: 'Guide to Yaaa',
    assistantName: 'Example',
    assistantUuid: '91d1eccd-b848-4513-a99b-a80f3bb4d0f0',
  ),
];

// predefined messages
final List<Message> predefinedMessage = [
  Message(
    uuid: 'fcda2ee8-91a5-445f-9c79-abb2820f2d91',
    conversationUuid: 'c5e52ce2-8e21-4bd0-bfc2-4d8c9e827386',
    text: 'Hello, I am a guide to Yaaa. How can I help you?',
    createdAt: DateTime.now(),
    role: MessageRole.system,
  ),
  Message(
    uuid: '699720c2-9a19-44ee-ba93-8d1075f8d6c7',
    conversationUuid: 'c5e52ce2-8e21-4bd0-bfc2-4d8c9e827386',
    text: 'How to use this App?',
    createdAt: DateTime.now(),
    role: MessageRole.user,
  ),
  Message(
    uuid: '4a31f5fb-e5e8-473d-b3aa-870ecd8cc350',
    conversationUuid: 'c5e52ce2-8e21-4bd0-bfc2-4d8c9e827386',
    text: '''
1. Choose the default model at setting page (shortcut: `Ctrl + ,`) and configure the API key and base URL.\n
2. Duplicate/Edit the assistant from the assistant page (shortcut: `Ctrl + N`)\n
3. Create a new conversation to certain assistant.\n
4. Start chatting with the assistant.\n
''',
    createdAt: DateTime.now(),
    role: MessageRole.assistant,
  ),
];
