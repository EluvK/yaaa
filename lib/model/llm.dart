/// which Large Language Model that Yaaa supports
enum LLMProviderEnum {
  // ignore: constant_identifier_names
  OpenAI,
  // ignore: constant_identifier_names
  DeepSeek,
}

class LLMProvider {
  final LLMProviderEnum name;
  final List<String> model;
  String baseUrl;
  String defaultModel;
  String? apiKey;

  LLMProvider({
    required this.name,
    required this.model,
    required this.baseUrl,
    required this.defaultModel,
    this.apiKey,
  });

  static var openAI = LLMProvider(
    name: LLMProviderEnum.OpenAI,
    model: ['gpt-4o', 'gpt-4o-mini', 'gpt-4-turbo'],
    baseUrl: 'https://api.openai.com',
    defaultModel: 'gpt-4o',
    apiKey: null,
  );

  static var deepSeek = LLMProvider(
    name: LLMProviderEnum.DeepSeek,
    model: ['deepseek-chat', 'deepseek-code'],
    baseUrl: 'https://api.deepseek.com',
    defaultModel: 'deepseek-chat',
    apiKey: null,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name.name,
      'model': model,
      'apiUrl': baseUrl,
      'defaultModel': defaultModel,
      'apiKey': apiKey,
    };
  }

  factory LLMProvider.fromJson(Map<String, dynamic> json) {
    return LLMProvider(
      name: LLMProviderEnum.values.firstWhere((e) => e.name == json['name']),
      model: List<String>.from(json['model']),
      baseUrl: json['apiUrl'],
      defaultModel: json['defaultModel'],
      apiKey: json['apiKey'],
    );
  }
}
