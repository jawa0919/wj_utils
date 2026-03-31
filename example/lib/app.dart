import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals/signals_flutter.dart';

import 'app_const.dart';
import 'app_import.dart';
import 'route/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(AppConst.designWidth, AppConst.designHeight),
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: !GlobalUtil.isProduct,
        title: GlobalUtil.appName,

        routerConfig: AppRoutes.routerConfig..observers?.add(ExDialog.observer),
        builder: (context, child) {
          child = ExDialog.builder(context, child);
          return child;
        },

        theme: ThemeStore.to.lightTheme.value,
        darkTheme: ThemeStore.to.darkTheme.value,
        themeMode: ThemeStore.to.themeMode.watch(context),

        supportedLocales: LanguageStore.to.supportedLocales,
        locale: LanguageStore.to.locale.watch(context),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
