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
        title: const Center(child: Text('Yaaa')),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text('Yaaa'),
        // toolbarHeight: 50,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        actions: [
          // todo
          IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContactPage(),
          Flexible(child: ConversationPage()),
        ],
      ),
    );
  }
}
