export 'store/language_store.dart';
export 'store/server_store.dart';
export 'store/theme_store.dart';

export 'util/ex_dialog.dart';
export 'util/ex_object.dart';
export 'util/ex_theme.dart';
export 'util/ex_widget.dart';
export 'util/global_util.dart';
export 'util/http_util.dart';
export 'util/media_util.dart';

export 'view/about_view.dart';
export 'view/setting_view.dart';
export 'view/qr_scan_view.dart';
export 'view/cache_image.dart';

export 'debug/debug_page.dart';

// icp备案号查询链接
const String icpQueryUrl = 'https://beian.miit.gov.cn/';

// 获取App Store更新信息
const String appStoreLookup = 'https://itunes.apple.com/cn/lookup?id=';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
