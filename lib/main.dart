import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/conversation.dart';
// import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/pages/home.dart';
import 'package:yaaa/pages/assistants.dart';
import 'package:yaaa/pages/setting.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConversationController());
    Get.put(MessageController());
    Get.put(AssistantController());

// debug print all messages
    // ConversationRepository().showAllDatabases();
    // ConversationRepository().printAllMessages();

// debug print all assistants
    // AssistantRepository().printAllAssistants();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/setting', page: () => const SettingPage()),
        GetPage(name: '/assistants', page: () => const AssistantsPage()),
      ],
      theme: ThemeData(
        fontFamily: 'lxgw',
      ),
    );
  }
}
