import 'package:flutter/material.dart';

import '../../app_import.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              Text('LoginPage.您好'.tr),
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

extension LoginPageLanguage on LoginPage {
  static final languageMap = {
    const Locale('zh', 'CN'): {'LoginPage.您好': '您好'},
    const Locale('en', 'US'): {'LoginPage.您好': 'Hello'},
    const Locale('ja', 'JP'): {'LoginPage.您好': 'こんにちは'},
    const Locale('ko', 'KR'): {'LoginPage.您好': '안녕하세요'},
  };
}
