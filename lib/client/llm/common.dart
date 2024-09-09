import 'package:openai_dart/openai_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:yaaa/model/conversation.dart' as yaaa_model;

class ModelParam {
  String baseUrl;
  String? apiKey;
  String modelName;
  double temperature;

  ModelParam({
    required this.baseUrl,
    required this.apiKey,
    required this.modelName,
    required this.temperature,
  });
}

void commonOpenAIClientChat(
  ModelParam param,
  List<yaaa_model.Message> messages,
  Function(yaaa_model.Message) onStream,
  Function(yaaa_model.Message) onError,
  Function(yaaa_model.Message) onSuccess,
) {
  var client = OpenAIClient(apiKey: param.apiKey, baseUrl: param.baseUrl);

  // map message to OpenAIChatCompletionChoiceMessageModel
  List<ChatCompletionMessage> sendMessages = messages.map((e) {
    return switch (e.role) {
      yaaa_model.MessageRole.system =>
        ChatCompletionMessage.system(content: e.text),
      yaaa_model.MessageRole.assistant =>
        ChatCompletionMessage.assistant(content: e.text),
      yaaa_model.MessageRole.user => ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(e.text)),
    };
  }).toList();
  var returnMessage = yaaa_model.Message(
    uuid: const Uuid().v4(),
    conversationUuid: messages.first.conversationUuid,
    text: '',
    createdAt: DateTime.now(),
    role: yaaa_model.MessageRole.assistant,
  );
  var chatStream = client.createChatCompletionStream(
    request: CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(param.modelName),
      messages: sendMessages,
      temperature: param.temperature,
    ),
  );
  chatStream.listen(
    (streamEvent) async {
      // print("Received stream event: $streamEvent");
      if (streamEvent.choices.first.delta.content != null) {
        // todo check here. !
        print(returnMessage.text);
        returnMessage.text =
            returnMessage.text + streamEvent.choices.first.delta.content!;
        onStream(returnMessage);
      } else {
        print("Content is null");
      }
      if (streamEvent.usage != null) {
        print("Usage: ${streamEvent.usage}");
        returnMessage.usage = yaaa_model.Usage(
          promptTokens: streamEvent.usage!.promptTokens,
          completionTokens: streamEvent.usage!.completionTokens ?? -1,
          totalTokens: streamEvent.usage!.totalTokens,
        );
      }
    },
    onError: (error) {
      // var error_msg = "$error";
      // print('$error_msg');
      print('Error: $error');
      returnMessage.text = "$error";
      onError(returnMessage);
    },
    onDone: () {
      print('Done');
      returnMessage.createdAt = DateTime.now();
      onSuccess(returnMessage);
    },
  );
}
