import 'app_api.dart';

class CommonApi {
  CommonApi._();

  /// 查询应用版本号
  static Future<SimpleResponse> findAppVersion() async {
    var dataRes = await AppApi().get('/common/app/version', autoToken: false);
    return SimpleResponse.fromJson(dataRes);
  }
}
