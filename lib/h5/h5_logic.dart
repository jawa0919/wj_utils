import 'dart:async';

import 'package:flutter/material.dart';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:signals/signals.dart';

import '../util/ex_object.dart';
import '../util/media_util.dart';

class H5Logic {
  static final H5Logic to = _instance;
  static final H5Logic _instance = H5Logic._internal();
  factory H5Logic() => _instance;
  H5Logic._internal() {
    debugPrint('dart.dart~onInit: ');
  }

  late StreamSubscription<bool> keyboardSubscription;

  void initState() {
    keyboardSubscription = KeyboardVisibilityController().onChange.listen(
      appKeyboardVisibility,
    );
  }

  void onReady(BuildContext context) {
    debugPrint('h5_logic.dart~onReady: ');
    // LoadingPage.show(context);
  }

  var initialUrl = signal('', debugLabel: 'initialUrl');
  late final initialUrlRequest = computed(
    () => URLRequest(url: WebUri(initialUrl.value)),
  );

  InAppWebViewController? webController;
  InAppWebViewSettings get initialSettings => InAppWebViewSettings(
    // cacheEnabled: false,
    // clearCache: true,
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    useHybridComposition: true,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
    upgradeKnownHostsToHTTPS: false,
    // applicationNameForUserAgent: AppStorage.appUserAgent,
    // allowsBackForwardNavigationGestures: false,
    // useOnDownloadStart: true,
  );

  /// 当前url
  var currentUrl = signal('', debugLabel: 'currentUrl');

  /// 状态normal/loading/error
  var status = signal('normal');

  /// 屏幕信息
  // var isDarkMode = signal(false);
  // var devicePixelRatio = signal(0.0);
  // var mediaQuerySize = signal(Size.zero);
  // var mediaQueryPadding = signal(EdgeInsets.zero);
  // var isLandscape = signal(false);
  var isFullScreen = signal(true);

  void onClose() {
    debugPrint('h5_logic.dart~onClose: ');
    keyboardSubscription.cancel();
  }

  void addHandler() {
    debugPrint('h5_logic.dart~addHandler: ');
    webController?.addJavaScriptHandler(
      handlerName: 'userLogout',
      callback: (List<dynamic> arguments) async {
        EasyDebounce.debounce(
          'logout-debounce',
          const Duration(milliseconds: 200),
          () => handleLogout(arguments),
        );
        return true;
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'webUpdateToken',
      callback: (List<dynamic> arguments) async {
        String token = ListDynamic.val(arguments, 0) ?? '';
        if (token.isEmpty) return false;
        // await UserStore.to.saveToken(token);
        return true;
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'closeWindow',
      callback: (List<dynamic> arguments) {
        // AppRoutes.popOrExit();
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'appScreenInfo',
      callback: (List<dynamic> arguments) {
        var screenInfo = {
          // 'isDark': ThemeStore.to.isDark.value,
          // 'displayWidth': AppStorage.displayWidth,
          // 'displayHeight': AppStorage.displayHeight,
          // 'windowWidth': AppStorage.windowWidth,
          // 'windowHeight': AppStorage.windowHeight,
          // 'devicePixelRatio': AppStorage.devicePixelRatio,
          // 'viewPaddingRight': AppStorage.viewPaddingRight,
          // 'viewPaddingTop': AppStorage.viewPaddingTop,
          // 'viewPaddingLeft': AppStorage.viewPaddingLeft,
          // 'viewPaddingBottom': AppStorage.viewPaddingBottom,
          'isFullScreen': isFullScreen.value,
        };
        debugPrint('screenInfo: $screenInfo');
        return screenInfo;
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'setFullScreen',
      callback: (List<dynamic> arguments) {
        var val = ListDynamic.val<bool>(arguments, 0) ?? false;
        isFullScreen.value = val;
        if (val) {
          appScreenInfoChange({
            // 'isDark': ThemeStore.to.isDark.value,
            // 'displayWidth': AppStorage.displayWidth,
            // 'displayHeight': AppStorage.displayHeight,
            // 'windowWidth': AppStorage.windowWidth,
            // 'windowHeight': AppStorage.windowHeight,
            // 'devicePixelRatio': AppStorage.devicePixelRatio,
            // 'viewPaddingRight': AppStorage.viewPaddingRight,
            // 'viewPaddingTop': AppStorage.viewPaddingTop,
            // 'viewPaddingLeft': AppStorage.viewPaddingLeft,
            // 'viewPaddingBottom': AppStorage.viewPaddingBottom,
            // 'isFullScreen': isFullScreen.value,
          });
        }
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'clearWebCache',
      callback: (List<dynamic> arguments) {
        InAppWebViewController.clearAllCache();
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'saveNetImageToPhotosAlbum',
      callback: (List<dynamic> arguments) async {
        debugPrint('h5_logic.dart~saveNetImageToPhotosAlbum: $arguments');
        String url = ListDynamic.val(arguments, 0) ?? '';
        String name = ListDynamic.val(arguments, 1) ?? '';
        return await MediaUtil.saveNetImageToPhotosAlbum(url, name);
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'saveNetMediaToPhotosAlbum',
      callback: (List<dynamic> arguments) async {
        debugPrint('h5_logic.dart~saveNetMediaToPhotosAlbum: $arguments');
        String url = ListDynamic.val(arguments, 0) ?? '';
        String name = ListDynamic.val(arguments, 1) ?? '';
        return await MediaUtil.saveNetMediaToPhotosAlbum(url, name);
      },
    );
    webController?.addJavaScriptHandler(
      handlerName: 'chooseAlbumImage',
      callback: (List<dynamic> arguments) async {
        var img = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (img == null) return null;
        debugPrint('chooseAlbumImage: ${img.path}');
        debugPrint('chooseAlbumImage: ${img.name}');
        String fileType = img.name.split('.').last.toLowerCase();
        return {
          'path': img.path,
          'name': img.name,
          'bytes': await img.readAsBytes(),
          'length': await img.length(),
          'mimeType': img.mimeType ?? 'image/$fileType',
        };
      },
    );
  }

  void appTokenChange(String token) {
    dispatchEvent('appTokenChange', {'token': token});
  }

  void appScreenInfoChange(Map<String, dynamic> json) {
    dispatchEvent('appScreenInfoChange', json);
  }

  void appKeyboardVisibility(bool visible) {
    dispatchEvent('appKeyboardVisibility', {'visible': visible});
  }

  void handleLogout(List<dynamic> arguments) async {
    String tips = ListDynamic.val(arguments, 0) ?? '';
    // UserStore.to.onLogout(removeProfile: true, toLoginPage: true, tips: tips);
  }

  void dispatchEvent(String type, Map<String, dynamic> detail) {
    var map = {'detail': detail};
    var script = "window.dispatchEvent(new CustomEvent('$type', $map))";
    debugPrint('h5_logic.dart~dispatchEvent: \n$script');
    webController?.evaluateJavascript(source: script);
  }
}
