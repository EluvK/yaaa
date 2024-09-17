import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yaaa/components/markdown_message.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/utils/double_click.dart';
import 'package:yaaa/utils/utils.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    bool isUser = widget.message.role == MessageRole.user;
    bool isAssistant = widget.message.role == MessageRole.assistant;

    Widget? leading;
    Widget? trailing;
    if (isMobile()) {
      leading = isUser
          ? const Icon(Icons.person, size: 20)
          : isAssistant
              ? const Icon(Icons.smart_toy, size: 20)
              : const Icon(Icons.settings, size: 20);
    } else {
      leading = isUser
          ? const SizedBox(width: 25)
          : isAssistant
              ? const Icon(Icons.smart_toy, size: 25)
              : const Icon(Icons.settings, size: 25);
      trailing = isUser
          ? const Icon(Icons.person, size: 25)
          : const SizedBox(width: 25);
    }

    var message = ListTile(
      leading: leading,
      trailing: trailing,
      contentPadding: dynDevicePaddingSymmetric(horizontal: 2),
      minLeadingWidth: 2.0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primaryContainer
              : isAssistant
                  ? colorScheme.secondaryContainer
                  : colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownRenderer(data: widget.message.text),
            const SizedBox(height: 5),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // !this row have a little big minimum width because of this timestamp, use expanded can avoid it.
                Expanded(
                  child: Text(
                      widget.message.createdAt.toString().split('.')[0] +
                          (widget.message.usage != null
                              ? 'token_usage'.trParams({
                                  'promptToken': widget
                                      .message.usage!.promptTokens
                                      .toString(),
                                  'completionToken': widget
                                      .message.usage!.completionTokens
                                      .toString()
                                })
                              : ''),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ),
                Visibility(
                  visible: widget.message.role == MessageRole.user,
                  child: DoubleClickButton(
                    buttonBuilder: (onPressed) => IconButton(
                      // if is wait for response, delete should be banned for a moment.
                      onPressed: messageController.waitingForResponse
                          ? null
                          : onPressed,
                      icon: const Icon(Icons.delete, size: 16),
                    ),
                    onDoubleClick: () {
                      messageController
                          .deleteUserMessageAndResponse(widget.message.uuid);
                    },
                    firstClickHint: 'double_click_delete_message_hint'.tr,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.message.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('copy_to_clipboard'.tr)));
                  },
                  icon: const Icon(Icons.copy, size: 16),
                )
              ],
            ),
          ],
        ),
      ),
    );

    return Container(
      color: widget.message.isHighlighted
          ? colorScheme.onInverseSurface
          : Colors.transparent,
      child: message,
    );
  }
}
