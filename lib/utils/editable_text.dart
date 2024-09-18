import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaaa/utils/key_intents.dart';

class EditableTextWidget extends StatefulWidget {
  const EditableTextWidget(
      {super.key, required this.initialText, required this.onSave});

  final String initialText;
  final Function(String) onSave;

  @override
  State<EditableTextWidget> createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends State<EditableTextWidget> {
  late String text;
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(debugLabel: 'editableTextFocusNode');

  late final KCallbackAction<UnFocusIntent> _unFocusAction;
  late final Map<Type, Action<Intent>> actions = <Type, Action<Intent>>{
    UnFocusIntent: _unFocusAction,
  };

  @override
  void initState() {
    super.initState();
    text = widget.initialText;
    _controller.text = text;

    _unFocusAction =
        KCallbackAction<UnFocusIntent>(onInvoke: (UnFocusIntent intent) {
      _focusNode.unfocus();
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _saveText(_controller.text); // 当失去焦点时自动保存
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _saveText(String newValue) {
    setState(() {
      text = newValue;
      isEditing = false;
    });
    widget.onSave(newValue);
  }

  @override
  Widget build(BuildContext context) {
    var showText = Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onTap: () {
          setState(() {
            isEditing = true;
            _focusNode.requestFocus();
          });
        },
        child: Text(
          text,
        ),
      ),
    );

    var editTextField = Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.slash):
            const DoNothingAndStopPropagationTextIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
            const DoNothingAndStopPropagationTextIntent(),
        const SingleActivator(LogicalKeyboardKey.escape): const UnFocusIntent(),
      },
      child: Actions(
        actions: actions,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          onSubmitted: _saveText,
          decoration: const InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );

    return isEditing ? editTextField : showText;
  }
}
