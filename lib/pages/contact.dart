import 'package:flutter/material.dart';
import 'package:yaaa/components/contact.dart';
import 'package:yaaa/pages/assistants.dart';
import 'package:yaaa/pages/setting.dart';
import 'package:yaaa/utils/page_opener.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 350),
      // constraints: const BoxConstraints(
      //   minWidth: 200,
      //   maxWidth: 300,
      // ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const ContactCard(), // for contact list
          // const SizedBox(height: 20),
          ListTile(
            title: const Text('Assistants'),
            leading: const Icon(Icons.line_axis),
            onTap: () => PageOpener.openPage(context, const AssistantsPage()),
          ),
          ListTile(
            title: const Text('Setting'),
            leading: const Icon(Icons.settings),
            onTap: () => PageOpener.openPage(context, const SettingPage()),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
