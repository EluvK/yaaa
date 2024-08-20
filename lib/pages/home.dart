import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/pages/contact.dart';
import 'package:yaaa/pages/conversation.dart';

class HomePage extends GetResponsiveView {
  HomePage({super.key});
  final colorScheme = Theme.of(Get.context!).colorScheme;

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // AppBar 的高度
        child: Align(
          alignment: Alignment.centerLeft, // 对齐到左边
          child: SizedBox(
              width: 350.0, // 设置 AppBar 的宽度为 350
              child: AppBar(
                centerTitle: true,
                // toolbarHeight: 56,
                title: title(),
                titleTextStyle: titleStyle(),
                flexibleSpace: Container(color: colorScheme.surface),
                actions: [
                  // todo
                  IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.settings)),
                ],
              )),
        ),
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
    return TextStyle(
      color: colorScheme.inverseSurface,
      fontSize: 24,
      fontFamily: 'lxgw',
    );
  }
}
