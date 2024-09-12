import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: constant_identifier_names
const String VERSION =
    String.fromEnvironment('APP_VERSION', defaultValue: 'debug');

// ignore: constant_identifier_names
const String APP_BUILD_NUMBER =
    String.fromEnvironment('APP_BUILD_NUMBER', defaultValue: '0');

// ignore: constant_identifier_names
const String REPO_URL = 'https://github.com/eluvk/yaaa';
Future<void> launchRepo() async {
  if (!await launchUrl(Uri.parse(REPO_URL))) {
    throw Exception('Could not launch $REPO_URL');
  }
}

bool isMobile() {
  return GetPlatform.isMobile || Get.width < 600;
}

EdgeInsets dynDevicePadding(double rate) {
  if (isMobile()) {
    return EdgeInsets.all(2.0 * rate);
  } else {
    return EdgeInsets.all(4.0 * rate);
  }
}

EdgeInsets dynDevicePaddingSymmetric(
    {double horizontal = 0.0, double vertical = 0.0}) {
  if (isMobile()) {
    return EdgeInsets.symmetric(
        horizontal: 2.0 * horizontal, vertical: 2.0 * vertical);
  } else {
    return EdgeInsets.symmetric(
        horizontal: 4.0 * horizontal, vertical: 4.0 * vertical);
  }
}

// ignore: constant_identifier_names
enum FlushLevel { OK, INFO, WARNING }

void flushBar(
  FlushLevel level,
  String? title,
  String? message,
) {
  Color? color;
  IconData? icon;
  switch (level) {
    case FlushLevel.OK:
      color = Colors.green.shade300;
      icon = Icons.check_box_sharp;
      break;
    case FlushLevel.INFO:
      color = Colors.blue.shade300;
      icon = Icons.info_outline;
      break;
    case FlushLevel.WARNING:
      color = Colors.orange.shade300;
      icon = Icons.error_outline;
      break;
  }
  Flushbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 2),
    icon: Icon(icon, size: 28, color: color),
    margin: const EdgeInsets.all(12.0),
    borderRadius: BorderRadius.circular(8.0),
    leftBarIndicatorColor: color,
  ).show(Get.context!);
}
