import 'package:flutter/material.dart';

import '../../app_import.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    setState(() {});
    DebugPage.start(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text('SplashPage.您好'.tr),
              const Text('You have pushed the button this many times:'),
              ...List.generate(100, (i) => Text(i.toString())),
              const Text('You have pushed the button this many times:'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension SplashPageLanguage on SplashPage {
  static final languageMap = {
    const Locale('zh', 'CN'): {'SplashPage.您好': '您好'},
    const Locale('en', 'US'): {'SplashPage.您好': 'Hello'},
    const Locale('ja', 'JP'): {'SplashPage.您好': 'こんにちは'},
    const Locale('ko', 'KR'): {'SplashPage.您好': '안녕하세요'},
  };
}
