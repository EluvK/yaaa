import 'package:flutter/material.dart';
import 'package:yaaa/utils/utils.dart';

class PageOpener {
  // 静态方法，用于打开页面
  static void openPage(BuildContext context, Widget page, {double? sizeRate}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // 如果是移动端，或者屏幕宽度较小，则全屏打开
    if (isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    } else {
      // 否则，弹出悬浮窗口
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: screenWidth * (sizeRate ?? 0.8),
                height: screenHeight * (sizeRate ?? 0.8),
                child: page,
              ),
            ),
          );
        },
      );
    }
  }
}
