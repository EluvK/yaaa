import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yaaa/controller/assistant.dart';
import 'package:yaaa/controller/chatbox.dart';
import 'package:yaaa/controller/conversation.dart';
import 'package:yaaa/controller/setting.dart';
import 'package:yaaa/pages/home.dart';
import 'package:yaaa/pages/assistants.dart';
import 'package:yaaa/pages/setting.dart';
import 'package:yaaa/utils/init.dart';
import 'package:yaaa/utils/translation.dart';

void main() async {
  await GetStorage.init('YaaaGetStorage');

  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Get.putAsync(() async {
    final controller = SettingController();
    return controller;
  });
  await Get.putAsync(() async {
    final controller = MessageController();
    return controller;
  });
  await Get.putAsync(() async {
    final controller = ConversationController();
    return controller;
  });
  await Get.putAsync(() async {
    final controller = AssistantController();
    return controller;
  });
  await Get.putAsync(() async {
    final controller = ChatBoxController();
    return controller;
  });

  // should init before app start
  final settingController = Get.find<SettingController>();
  await settingController.ensureInitialization();

  //! v0.0.4 compromise , could delete in the future
  await settingController.fix004Migrate();

  // init conversation message
  await initConversation();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();
    ThemeMode themeMode = settingController.themeMode.value;
    print('load themeMode: $themeMode');

    double fontSize = settingController.fontSize.value;
    print('load fontSize: $fontSize');
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaler
        .clamp(minScaleFactor: fontSize, maxScaleFactor: fontSize + 0.1);

    var locale = settingController.locale.value;
    print('load locale: $locale');

    var app = GetMaterialApp(
      translations: Translation(),
      locale: locale,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/setting', page: () => const SettingPage()),
        GetPage(name: '/assistants', page: () => const AssistantsPage()),
      ],
      theme: FlexThemeData.light(
        scheme: FlexScheme.blumineBlue,
        // scheme: FlexScheme.blueM3,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
        ),
        tones: FlexTones.material(Brightness.light).onMainsUseBW(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: 'lxgw',
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.blumineBlue,
        // scheme: FlexScheme.aquaBlue,
        // scheme: FlexScheme.deepBlue,
        // scheme: FlexScheme.bahamaBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 14,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
        ),
        tones: FlexTones.material(Brightness.dark).onMainsUseBW(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: 'lxgw',
      ),
      themeMode: themeMode,
    );

    return MediaQuery(
      data: mediaQueryData.copyWith(textScaler: scale),
      child: app,
    );
  }
}
