import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yaaa/controller/chatbox.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final messageController = Get.find<MessageController>();

  final searchBoxController = Get.find<SearchBoxController>();
  late final FocusNode _focusNode; // get from chatBoxController

  @override
  void initState() {
    super.initState();
    print("chatBoxFocusNode request focus");
    _focusNode = searchBoxController.searchBoxFocusNode;

    _focusNode.addListener(() {
      // if (!_focusNode.hasFocus) {
      setState(() {});
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 8.0),
        child: _searchBox(),
      ),
    );
  }

  SearchField<Message> _searchBox() {
    return SearchField<Message>(
      suggestions: messageController.messageList
          .map(
            (message) => SearchFieldListItem<Message>(
              message.text,
              item: message,
            ),
          )
          .toList(),
      onSubmit: (val) => {print(val)},
      onSuggestionTap: (SearchFieldListItem<Message> item) {
        print("onSuggestionTap, ${item.item?.uuid}");
        messageController.focusMessage(item.item?.uuid);
      },
      focusNode: _focusNode,
      dynamicHeight: true,
    );
  }
}
