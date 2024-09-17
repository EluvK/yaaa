import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yaaa/components/message.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({super.key});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final messageController = Get.find<MessageController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var viewMessages = messageController.viewMessageList;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Visibility(
              visible: messageController.hasMore.value,
              child: ElevatedButton(
                  onPressed: () {
                    messageController.loadHistory();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_upward),
                      Text('view_history'.tr)
                    ],
                  )),
            ),
          ),
          // test code
          Visibility(
            visible: false,
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      messageController.focusMessage(
                          messageController.viewMessageList.first.uuid);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.arrow_upward), Text('up')],
                    )),
                ElevatedButton(
                    onPressed: () {
                      messageController.focusMessage(
                          messageController.viewMessageList.last.uuid);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.arrow_downward), Text('down')],
                    )),
              ],
            ),
          ),
          Expanded(child: messageView(viewMessages)),
        ],
      );
    });
  }

  Widget messageView(List<Message> viewMessages) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print('3');
    //   messageController.focusMessage(null);
    // });

    return ScrollablePositionedList.builder(
      itemScrollController: messageController.itemScrollController,
      scrollOffsetController: messageController.scrollOffsetController,
      itemPositionsListener: messageController.itemPositionsListener,
      scrollOffsetListener: messageController.scrollOffsetListener,
      itemCount: viewMessages.length,
      itemBuilder: (context, index) {
        var message = viewMessages[index];
        if (message.role == MessageRole.system && index != 0) {
          return Column(
            children: [
              const Divider(),
              MessageCard(message: message),
            ],
          );
        }
        return MessageCard(message: message);
      },
    );
  }
}
