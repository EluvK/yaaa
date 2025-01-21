/// which Large Language Model that Yaaa supports
enum LLMProviderEnum {
  // ignore: constant_identifier_names
  OpenAI,
  // ignore: constant_identifier_names
  DeepSeek,
}

// impl extend LLMProviderEnum
extension LLMProviderEnumExtension on LLMProviderEnum {
  String get defaultBaseUrl {
    switch (this) {
      case LLMProviderEnum.OpenAI:
        return 'https://api.openai.com';
      case LLMProviderEnum.DeepSeek:
        return 'https://api.deepseek.com';
    }
  }
}

enum ModelSpecEnum {
  gpt4o,
  gpt4oMini,
  gpt4Turbo,
  deepseekChat,
  // deprecated
  deepseekCoder,
  deepseekReasoner,
}

extension ModelSpecEnumExtension on ModelSpecEnum {
  String get name {
    switch (this) {
      case ModelSpecEnum.gpt4o:
        return 'gpt-4o';
      case ModelSpecEnum.gpt4oMini:
        return 'gpt-4o-mini';
      case ModelSpecEnum.gpt4Turbo:
        return 'gpt-4-turbo';
      case ModelSpecEnum.deepseekChat:
        return 'deepseek-chat';
      case ModelSpecEnum.deepseekCoder:
        return 'deepseek-coder';
      case ModelSpecEnum.deepseekReasoner:
        return 'deepseek-reasoner';
    }
  }

  static ModelSpecEnum fromStr(String str) {
    switch (str) {
      case 'gpt-4o':
        return ModelSpecEnum.gpt4o;
      case 'gpt-4o-mini':
        return ModelSpecEnum.gpt4oMini;
      case 'gpt-4-turbo':
        return ModelSpecEnum.gpt4Turbo;
      case 'deepseek-chat':
        return ModelSpecEnum.deepseekChat;
      case 'deepseek-coder':
        return ModelSpecEnum.deepseekCoder;
      case 'deepseek-reasoner':
        return ModelSpecEnum.deepseekReasoner;
      default:
        return ModelSpecEnum.gpt4oMini;
    }
  }
}

class LLMProvider {
  final LLMProviderEnum name;
  final List<ModelSpecEnum> model;
  String baseUrl;
  ModelSpecEnum defaultModel;
  double temperature;
  String? apiKey;

  LLMProvider({
    required this.name,
    required this.model,
    required this.baseUrl,
    required this.defaultModel,
    this.temperature = 1.0,
    this.apiKey,
  });

  static var openAI = LLMProvider(
    name: LLMProviderEnum.OpenAI,
    model: [
      ModelSpecEnum.gpt4o,
      ModelSpecEnum.gpt4oMini,
      ModelSpecEnum.gpt4Turbo,
    ],
    baseUrl: LLMProviderEnum.OpenAI.defaultBaseUrl,
    defaultModel: ModelSpecEnum.gpt4o,
    apiKey: null,
  );

  static var deepSeek = LLMProvider(
    name: LLMProviderEnum.DeepSeek,
    model: [ModelSpecEnum.deepseekChat, ModelSpecEnum.deepseekReasoner],
    baseUrl: LLMProviderEnum.DeepSeek.defaultBaseUrl,
    defaultModel: ModelSpecEnum.deepseekChat,
    apiKey: null,
  );

  Map<String, dynamic> toJson() {
    var result = {
      'name': name.name,
      'model': model.map((e) => e.name).toList(),
      'apiUrl': baseUrl,
      'defaultModel': defaultModel.name,
      'temperature': temperature,
      'apiKey': apiKey,
    };
    return result;
  }

  factory LLMProvider.fromJson(Map<String, dynamic> json) {
    return LLMProvider(
      name: LLMProviderEnum.values.firstWhere((e) => e.name == json['name']),
      model: List<ModelSpecEnum>.from(
        json['model'].map((e) => ModelSpecEnumExtension.fromStr(e)),
      ),
      baseUrl: json['apiUrl'],
      defaultModel: ModelSpecEnumExtension.fromStr(json['defaultModel']),
      temperature: json['temperature'] ?? 1.0,
      apiKey: json['apiKey'],
    );
  }
}
