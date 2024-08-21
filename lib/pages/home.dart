import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/pages/contact.dart';
import 'package:yaaa/pages/conversation.dart';

class HomePage extends GetResponsiveView {
  HomePage({super.key});
  final colorScheme = Theme.of(Get.context!).colorScheme;

  @override
  Widget? phone() {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: ConversationAppBar(),
      ),
      body: ConversationPage(),
      drawer: ContactPage(),
    );
  }

  @override
  Widget? desktop() {
    return Container(
      color: colorScheme.surface,
      child: const Row(
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
