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
        title: Center(child: title()),
        titleTextStyle: titleStyle(),
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
        // toolbarHeight: 50,
        title: title(),
        titleTextStyle: titleStyle(),
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

  Widget title() {
    return const Text('Yaaa');
  }

  TextStyle titleStyle() {
    return const TextStyle(
      color: Colors.black87,
      fontSize: 24,
      fontFamily: 'lxgw',
    );
  }
}
