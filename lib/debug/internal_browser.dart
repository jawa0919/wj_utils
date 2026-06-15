import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InternalBrowser extends InAppBrowser {
  InternalBrowser();

  @override
  Future onBrowserCreated() async {
    debugPrint('Browser Created!');
  }

  @override
  Future onLoadStart(url) async {
    debugPrint('Started $url');
  }

  @override
  Future onLoadStop(url) async {
    debugPrint('Stopped $url');
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    debugPrint("Can't load ${request.url}.. Error: ${error.description}");
  }

  @override
  void onProgressChanged(progress) {
    debugPrint('Progress: $progress');
  }

  @override
  void onExit() {
    debugPrint('Browser closed!');
  }
}
