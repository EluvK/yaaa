import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatBoxController extends GetxController {
  final chatBoxFocusNode = FocusNode(debugLabel: 'chatBoxFocusNode');
}

class SearchBoxController extends GetxController {
  final searchBoxFocusNode = FocusNode(debugLabel: 'searchBoxFocusNode');
}
