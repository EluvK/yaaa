import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isMobile(BuildContext context) {
  return GetPlatform.isMobile || MediaQuery.of(context).size.width < 600;
}
