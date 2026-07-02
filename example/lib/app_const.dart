class AppConst {
  AppConst._();
  // 适合UI的尺寸
  static const designWidth = 1080.0;
  static const designHeight = 2340.0;
  // App Store id
  static const String appStoreId = '';
  // 获取App Store更新信息
  static const String appStoreLookup = 'https://itunes.apple.com/cn/lookup?id=';
  // 用户协议url
  static const String agreementUrl = 'https://flutter.cn';
  // 隐私政策url
  static const String privacyUrl = 'https://flutter.cn';
  // icp备案号
  static const String icpNumber = 'AAA-BBB-CCC';
  // icp备案号查询链接
  static const String icpQueryUrl = 'https://beian.miit.gov.cn/';
  // 版权标志
  static const String copyrightCode = 'Copyright © 2006-2026 flutter.cn';

  /// 服务器列表
  static const serverList = [
    {
      'env': 'prod',
      'apiHost': 'https://flutter.cn',
      'h5Host': 'https://flutter.cn',
    },
    {
      'env': 'test',
      'apiHost': 'https://flutter.cn',
      'h5Host': 'https://flutter.cn',
    },
    {
      'env': 'dev',
      'apiHost': 'https://flutter.cn',
      'h5Host': 'https://flutter.cn',
    },
    {'env': 'custom', 'apiHost': null, 'h5Host': null},
  ];
}
