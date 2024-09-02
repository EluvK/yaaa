import 'package:flutter/material.dart';
import 'package:yaaa/components/contact.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/pages/assistants.dart';
import 'package:yaaa/pages/setting.dart';
import 'package:yaaa/utils/page_opener.dart';
import 'package:get/get.dart';
import 'package:yaaa/utils/utils.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final settingController = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return settingController.getExpandContactList()
          ? _buildExpandContact(context)
          : _buildContact(context);
    });
  }

  Container _buildExpandContact(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.only(right: 2.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(25)),
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
            child: ListTile(
              title: Text('assistant'.tr),
              leading: const Icon(Icons.assistant),
            ),
            onPressed: () =>
                PageOpener.openPage(context, const AssistantsPage()),
          ),
          TextButton(
            child: ListTile(
              title: Text('setting'.tr),
              leading: const Icon(Icons.settings),
            ),
            onPressed: () => PageOpener.openPage(context, const SettingPage()),
          ),
          const Divider(),
          TextButton(
            onPressed: () {
              // open github repo
              // Flushbar(
              //   title: "information".tr,
              //   message: '${'version'.trParams({'version': VERSION})}\nhttps://www.github.com/eluvk/yaaa',
              //   duration: const Duration(seconds: 2),
              //   icon: Icon(Icons.info_outline,
              //       size: 28, color: Colors.green.shade300),
              //   margin: const EdgeInsets.all(12.0),
              //   borderRadius: BorderRadius.circular(8.0),
              //   leftBarIndicatorColor: Colors.green.shade300,
              // ).show(Get.context!);
            },
            child: ListTile(
              title: Text('version'.trParams({'version': VERSION})),
              leading: const Icon(Icons.info),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildContact(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.only(right: 2.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.3),
            blurRadius: 7,
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 90),
      child: Column(
        children: [
          const Expanded(child: ContactCard()), // for contact list
          IconButton(
            // icon: const Icon(Icons.line_axis),
            icon: const Icon(Icons.assistant),
            onPressed: () =>
                PageOpener.openPage(context, const AssistantsPage()),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => PageOpener.openPage(context, const SettingPage()),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
