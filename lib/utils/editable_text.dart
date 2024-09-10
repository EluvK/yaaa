import 'package:flutter/material.dart';

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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    text = widget.initialText;
    _controller.text = text;

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
    return isEditing
        ? TextField(
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
          )
        : Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
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
  }
}
