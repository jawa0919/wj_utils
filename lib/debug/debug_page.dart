import 'package:flutter/material.dart';

import 'package:dio_log_plus/dio_log_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../util/global_util.dart';
import '../view/qr_scan_view.dart';
import 'internal_browser.dart';
import 'server_host_page.dart';
import 'storage_show_page.dart';
import 'theme_color_show_page.dart';
import 'url_schemes_page.dart';

class DebugPage extends StatefulWidget {
  static bool debugFlag = !GlobalUtil.isProduct;
  const DebugPage({super.key});

  static void start(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DebugPage()),
    );
  }

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    showDebugBtn(context);
    return Scaffold(
      appBar: AppBar(title: const Text('DebugPage')),
      extendBody: false,
      body: Card(
        margin: const EdgeInsets.all(16),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              TextButton(
                child: const Text('更换服务器'),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ServerHostPage()),
                  );
                },
              ),
              TextButton(
                child: const Text('存储展示'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StorageShowPage(),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('颜色展示'),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ThemeColorShowPage(),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('常用快捷跳转'),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const URLSchemesPage(),
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  var f = TextEditingController(text: 'https://flutter.cn/');
                  return ListTile(
                    title: Text('内置浏览器'),
                    subtitle: TextField(controller: f),
                    trailing: IconButton(
                      onPressed: () async {
                        final browser = InternalBrowser();
                        final settings = InAppBrowserClassSettings(
                          browserSettings: InAppBrowserSettings(),
                          webViewSettings: InAppWebViewSettings(),
                        );
                        await browser.openUrlRequest(
                          urlRequest: URLRequest(url: WebUri(f.text)),
                          settings: settings,
                        );
                      },
                      icon: Icon(Icons.near_me),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('二维码扫描'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QrScanView()),
                  ).then((value) {
                    if (value != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('scanning result:value=$value')),
                      );
                    }
                  });
                },
              ),
              TextButton(child: const Text('消息推送'), onPressed: () async {}),
              TextButton(child: const Text('文件上传测试'), onPressed: () async {}),
              TextButton(child: const Text('文件下载测试'), onPressed: () async {}),
              SizedBox(),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
