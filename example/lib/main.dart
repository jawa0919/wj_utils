import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'app.dart';
import 'app_const.dart';
import 'app_import.dart';
import 'route/app_routes.dart';

void main() async {
  debugPrint('main.dart~running: isProduct-${GlobalUtil.isProduct}');
  // ignore: unused_local_variable
  final wfb = WidgetsFlutterBinding.ensureInitialized();
  // wfb.deferFirstFrame();
  // wfb.resetFirstFrameSent();
  await GlobalUtil.init();
  await _initSystem();
  await _printDebugMessage();
  runApp(const App());
}

Future<void> _initSystem() async {
  ServerStore.init(AppConst.serverInfoList);
  ThemeStore.init(AppConst.colorScheme);
  LanguageStore.init({});
  AppRoutes.setPageLanguage();
  if (!GlobalUtil.isWeb) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    List<DeviceOrientation> devOri = [DeviceOrientation.portraitUp];
    await SystemChrome.setPreferredOrientations(devOri);
  }
}

Future<void> _printDebugMessage() async {
  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  if (!GlobalUtil.isProduct) {
    debugPrint('..._printDebugMessage...');
    debugPrint('tempDir: ${GlobalUtil.tempDir}');
    debugPrint('docsDir: ${GlobalUtil.docsDir}');

    debugPrint('systemVersion: ${GlobalUtil.systemVersion}');
    debugPrint('brand: ${GlobalUtil.brand}');
    debugPrint('model: ${GlobalUtil.model}');

    debugPrint('appName: ${GlobalUtil.appName}');
    debugPrint('packageName: ${GlobalUtil.appId}');
    debugPrint('buildVersion: ${GlobalUtil.buildVersion}');
    debugPrint('buildNumber: ${GlobalUtil.buildNumber}');
    debugPrint('buildSignature: ${GlobalUtil.buildSignature}');
  }
}
