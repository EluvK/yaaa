import 'dart:convert';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/model/conversation.dart';

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
    Flushbar(
      title: "information".tr,
      message: 'file_saved'.trParams({'path': filePath}),
      duration: const Duration(seconds: 2),
      icon: Icon(Icons.check_box_sharp, size: 28, color: Colors.green.shade300),
      margin: const EdgeInsets.all(12.0),
      borderRadius: BorderRadius.circular(8.0),
      leftBarIndicatorColor: Colors.green.shade300,
    ).show(Get.context!);
  }
}
