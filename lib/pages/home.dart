import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/pages/contact.dart';
import 'package:yaaa/pages/conversation.dart';

class HomePage extends GetResponsiveView {
  HomePage({super.key});

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
    return const HomePageDesktop();
  }
}

class HomePageDesktop extends StatelessWidget {
  const HomePageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
}
