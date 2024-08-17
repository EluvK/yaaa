import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/pages/contact.dart';
import 'package:yaaa/pages/conversation.dart';

class HomePage extends GetResponsiveView {
  HomePage({super.key});

  @override
  Widget? phone() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page For Phone'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/assistants');
              // addConversation();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const ConversationPage(),
      drawer: const ContactPage(),
    );
  }

  @override
  Widget? desktop() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Row(
        children: [
          ContactPage(),
          ConversationPage(),
        ],
      ),
    );
  }
}
