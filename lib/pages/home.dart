import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/contact.dart';
import 'package:yaaa/controller/chatbox.dart';
import 'package:yaaa/controller/shortcuts.dart';
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

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // chatbox focus node from controller
    final chatBoxController = Get.find<ChatBoxController>();
    final chatboxFocusNode = chatBoxController.chatBoxFocusNode;

    return Shortcuts.manager(
      manager: LoggingShortcutManager(),
      child: Shortcuts(
        shortcuts: yaaaShortCuts(chatboxFocusNode),
        child: Actions(
          dispatcher: LoggingActionDispatcher(),
          actions: yaaaActions,
          child: Container(
            color: colorScheme.surface,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContactPage(),
                HiddenContactButton(),
                Flexible(child: ConversationPage()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// some debug code , not very useful...

/// A ShortcutManager that logs all keys that it handles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    // print('Handled shortcut $event in $context with result $result');
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);
    return null;
  }
}
