import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yaaa/controller/chatbox.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/model/conversation.dart';
import 'package:yaaa/utils/key_intents.dart';
import 'package:yaaa/utils/utils.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final messageController = Get.find<MessageController>();

  final searchBoxController = Get.find<SearchBoxController>();
  late final FocusNode _focusNode; // get from chatBoxController
  final TextEditingController _controller = TextEditingController();
  String _lastSearchKey = "";

  late final KCallbackAction<NextConversationIntent> _switchConversationAction;
  late final Map<Type, Action<Intent>> actions = <Type, Action<Intent>>{
    NextConversationIntent: _switchConversationAction,
  };

  @override
  void initState() {
    super.initState();
    print("chatBoxFocusNode request focus");
    _focusNode = searchBoxController.searchBoxFocusNode;

    _switchConversationAction = KCallbackAction<NextConversationIntent>(
        onInvoke: (NextConversationIntent intent) {
      Actions.invoke<NextConversationIntent>(context, intent);
      print('invoke search box next conversation');
      setState(() {});
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile() ? 250 : 500,
      child: _searchBox(),
    );
  }

  Widget _searchBox() {
    var searchField = SearchField<Message>(
      suggestions: messageController.messageList
          .map(
            (message) => SearchFieldListItem<Message>(
              message.text,
              item: message,
            ),
          )
          .toList(),
      controller: _controller,
      onSearchTextChanged: (query) {
        _lastSearchKey = query;
        print("onSearchTextChanged, $query");
        List<Message> filter;
        query = query.trim();
        // todo can add some commands and operator here.
        filter = messageController.messageList
            .where((message) =>
                message.text.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return filter
            .map((message) =>
                SearchFieldListItem<Message>(message.text, item: message))
            .toList();
      },
      searchInputDecoration: SearchInputDecoration(
        hintText: 'find_history'.tr,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _lastSearchKey.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  _lastSearchKey = "";
                },
              )
            : null,
      ),
      onSuggestionTap: (SearchFieldListItem<Message> item) {
        _controller.text = _lastSearchKey;
        // print("onSuggestionTap, ${item.item?.uuid}");
        messageController.focusMessage(item.item?.uuid);
      },
      focusNode: _focusNode,
      dynamicHeight: true,
    );

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.slash):
            const DoNothingAndStopPropagationTextIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.tab):
            const NextConversationIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
                LogicalKeyboardKey.tab):
            const NextConversationIntent(reverse: true),
      },
      child: Actions(actions: actions, child: searchField),
    );
  }
}
