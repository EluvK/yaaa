import 'package:flutter/material.dart';
import 'package:yaaa/components/contact.dart';
import 'package:yaaa/pages/assistants.dart';
import 'package:yaaa/pages/setting.dart';
import 'package:yaaa/utils/page_opener.dart';
import 'package:get/get.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.only(right: 4.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.3),
            blurRadius: 7,
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 350),
      child: Column(
        children: [
          const ContactBar(),
          const Expanded(child: ContactCard()), // for contact list
          TextButton(
            child:  ListTile(
              title: Text('assistant'.tr),
              leading: const Icon(Icons.line_axis),
            ),
            onPressed: () =>
                PageOpener.openPage(context, const AssistantsPage()),
          ),
          TextButton(
            child:  ListTile(
              title: Text('setting'.tr),
              leading: const Icon(Icons.settings),
            ),
            onPressed: () => PageOpener.openPage(context, const SettingPage()),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
