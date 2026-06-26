import 'app_api.dart';

/// 用户管理
class UserApi {
  UserApi._();

  /// 发送验证码
  /// 重置密码

  /// 用户注册
  static Future<SimpleResponse> register(
    String email,
    String password, [
    String surname = '',
    String name = '',
  ]) async {
    var dataRes = await AppApi().post(
      '/api/customer/register',
      data: {
        'email': email,
        'password': password,
        'surname': surname,
        'name': name,
      },
      autoToken: false,
    );
    return SimpleResponse.fromJson(dataRes);
  }

  /// 退出登录
  static Future<SimpleResponse> logout() async {
    var dataRes = await AppApi().post(
      '/api/customer/logout',
      options: Options(extra: {'ignoreException': true}),
    );
    return SimpleResponse.fromJson(dataRes);
  }

  /// 用户登录
  static Future<SimpleResponse> login(String email, String password) async {
    var dataRes = await AppApi().post(
      '/api/customer/login',
      data: {'email': email, 'password': password},
      autoToken: false,
    );
    return SimpleResponse.fromJson(dataRes);
  }

  /// 忘记密码
  /// 修改当前账户信息

  /// 用户信息
  static Future<SimpleResponse> info() async {
    var dataRes = await AppApi().get('/api/customer/info');
    return SimpleResponse.fromJson(dataRes);
  }
}
