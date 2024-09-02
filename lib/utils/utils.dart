import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: constant_identifier_names
const String VERSION = '0.0.1-alpha';

bool isMobile(BuildContext context) {
  return GetPlatform.isMobile || MediaQuery.of(context).size.width < 600;
}
