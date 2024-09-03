import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/utils/utils.dart';

class SaveConversation {
  static Future<void> saveConversation(
      Conversation conversation, List<Message> messages) async {
    // Save the conversation to the database
    var fileContent = jsonEncode({
      'conversation': conversation.toMap(),
      'messages': messages.map((e) => e.toMap()).toList(),
    });
    print(fileContent);
    Uint8List bytes = utf8.encode(fileContent);

    var fileName = '${conversation.assistantName}_${DateTime.now()}'
        .replaceAll(' ', '_')
        .replaceAll(':', '');

    String filePath = await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      ext: 'json',
      mimeType: MimeType.text,
    );

    print('file saved');
    flushBar(FlushLevel.OK, "information".tr,
        'file_saved'.trParams({'path': filePath}));
  }
}
