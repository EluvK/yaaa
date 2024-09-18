import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/utils/utils.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about'.tr),
      ),
      body: SingleChildScrollView(
        padding: dynDevicePadding(8),
        child: Column(
          children: [shortCutInfo(), const Divider(), appInfo()],
        ),
      ),
    );
  }

  Widget shortCutInfo() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'shortcut'.tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(child: Center(child: Text('shortcut_chat'.tr))),
                const TableCell(child: Center(child: KeyboardKeys('/'))),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Center(child: Text('shortcut_search'.tr))),
                const TableCell(child: Center(child: KeyboardKeys('Ctrl+F'))),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                    child: Center(child: Text('shortcut_clear_context'.tr))),
                const TableCell(child: Center(child: KeyboardKeys('Ctrl+R'))),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                    child:
                        Center(child: Text('shortcut_next_conversation'.tr))),
                const TableCell(child: Center(child: KeyboardKeys('Ctrl+Tab'))),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                    child: Center(
                        child: Text('shortcut_previous_conversation'.tr))),
                const TableCell(
                    child: Center(child: KeyboardKeys('Ctrl+Shift+Tab'))),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                    child: Center(child: Text('shortcut_new_conversation'.tr))),
                const TableCell(child: Center(child: KeyboardKeys('Ctrl+N'))),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Center(child: Text('shortcut_settings'.tr))),
                const TableCell(child: Center(child: KeyboardKeys('Ctrl+,'))),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget appInfo() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'App'.tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                const TableCell(child: Center(child: Text('⭐ Github Repo ⭐'))),
                TableCell(
                    child: TextButton.icon(
                  onPressed: () {
                    launchRepo();
                  },
                  label: const Text('eluvk/yaaa'),
                )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class KeyboardKeys extends StatelessWidget {
  final String text;

  const KeyboardKeys(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    List<String> parts = text.split('+');
    List<InlineSpan> children = [];

    for (int i = 0; i < parts.length; i++) {
      String part = parts[i].trim();
      children.add(
        WidgetSpan(
          child: Container(
            padding: dynDevicePadding(1.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              part,
            ),
          ),
        ),
      );

      if (i < parts.length - 1) {
        children.add(TextSpan(
          text: ' + ',
          style: Theme.of(context).textTheme.headlineSmall,
        ));
      }
    }

    return RichText(
      text: TextSpan(
        children: children,
      ),
    );
  }
}
