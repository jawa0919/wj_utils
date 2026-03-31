import 'dart:io';

import 'package:go_router/go_router.dart';

import '../app_import.dart';
import '../page/splash/splash_page.dart';
import '../page/login/login_page.dart';
import '../page/home/home_page.dart';
import 'route_error_page.dart';

class AppRoutes {
  AppRoutes._();
  static final routerConfig = GoRouter(
    initialLocation: SplashPage.routeName,
    // initialLocation: MainPage.routeName,
    // initialLocation: H5Page.routeName,
    errorBuilder: (context, state) => RouteErrorPage(),
    routes: [
      GoRoute(
        path: SplashPage.routeName,
        name: SplashPage.routeName,
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(
        path: LoginPage.routeName,
        name: LoginPage.routeName,
        builder: (context, state) => LoginPage(),
        // redirect: (context, state) {
        //   if (UserStore.to.hasToken) {
        //     UserStore.to.saveToken(UserStore.to.token);
        //     // return MainPage.routeName;
        //     return H5Page.routeName;
        //   }
        //   return null;
        // },
      ),
      // GoRoute(
      //   path: RegisterPage.routeName,
      //   name: RegisterPage.routeName,
      //   builder: (context, state) => RegisterPage(),
      // ),
      GoRoute(
        path: HomePage.routeName,
        name: HomePage.routeName,
        builder: (context, state) => HomePage(),
      ),
      // GoRoute(
      //   path: AboutPage.routeName,
      //   name: AboutPage.routeName,
      //   builder: (context, state) => AboutPage(),
      // ),
      // GoRoute(
      //   path: DebugPage.routeName,
      //   name: DebugPage.routeName,
      //   builder: (context, state) => DebugPage(),
      // ),
      // GoRoute(
      //   path: ProfilePage.routeName,
      //   name: ProfilePage.routeName,
      //   builder: (context, state) => ProfilePage(),
      // ),
      // GoRoute(
      //   path: SettingPage.routeName,
      //   name: SettingPage.routeName,
      //   builder: (context, state) => SettingPage(),
      // ),
      // GoRoute(
      //   path: H5Page.routeName,
      //   name: H5Page.routeName,
      //   builder: (context, state) =>
      //       H5Page(url: MapDynamic.val(state.extra, 'url') ?? H5Routes.home),
      // ),
    ],
  );

  ///
  /// Navigator.of(context).pushNamed('/routeName')
  ///
  static Future<T?> push<T>(String to, [Object? args]) {
    return routerConfig.push<T>(to, extra: args);
  }

  ///
  /// Navigator.of(context).popAndPushNamed('/routeName')
  ///
  static Future<T?> popAndPush<T>(String to, [Object? args, Object? result]) {
    routerConfig.pop(result);
    return routerConfig.push<T>(to, extra: args);
  }

  ///
  /// Navigator.of(context).pop()
  ///
  static void pop<T extends Object?>([T? result]) {
    routerConfig.pop(result);
  }

  ///
  /// Navigator.of(context).pushNamedAndRemoveUntil('/routeName')
  ///
  static Future<T?> clearAllPush<T>(String to, [Object? args]) {
    while (routerConfig.canPop() == true) {
      routerConfig.pop();
    }
    return routerConfig.pushReplacement(to, extra: args);
  }

  static void go<T>(String to, [Object? args]) {
    routerConfig.go(to, extra: args);
  }

  static void popOrExit<T extends Object?>([T? result]) {
    AppRoutes.routerConfig.canPop()
        ? AppRoutes.routerConfig.pop(result)
        : exit(0);
  }

  static void setPageLanguage() {
    LanguageStore.to.addLanguageMap(SplashPageLanguage.languageMap);
  }
}

// class H5Routes {
//   H5Routes._();

//   static Future<T?> push<T>(String url) {
//     return AppRoutes.push(H5Page.routeName, {'url': url});
//   }

//   /// 主页面
//   static const String _home = '/';
//   static String get home => H5Page.formateH5Url(_home);

//   /// 订阅页面
//   // static const String _subscriptions = '/subscriptions';
//   // static get subscriptions => formateH5Url(_subscriptions);
//   static String get subscriptions =>
//       'https://developer.apple.com/cn/app-store/subscriptions/';
// }
