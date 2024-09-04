import 'package:flutter/material.dart';
import 'package:yaaa/components/assistants.dart';
import 'package:get/get.dart';
import 'package:yaaa/utils/utils.dart';

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('assistant'.tr),
      ),
      body: SingleChildScrollView(
        padding: dynDevicePadding(4),
        child: const AssistantsCard(),
      ),
    );
  }
}
