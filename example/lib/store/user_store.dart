import 'dart:io';
import 'dart:convert';

import 'package:signals/signals.dart';
import 'package:wj_utils/h5/h5_logic.dart';

import '../api/app_api.dart';
import '../app_import.dart';
import '../dto/login_user_resp.dart';
import '../page/login/login_page.dart';

/// 用户配置
class UserStore {
  static final UserStore to = _instance;
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;

  String token = '';
  bool get hasToken => token.isNotEmpty;

  final _profile = signal<LoginUserResp>(LoginUserResp());
  late final profile = computed(() => _profile.value);
  late final id = computed(() => _profile.value.id ?? '');
  late final email = computed(() => _profile.value.email ?? '');
  late final surname = computed(() => _profile.value.surname ?? '');
  late final name = computed(() => _profile.value.name ?? '');
  late final nickName = computed(() => '${surname.value}${name.value}');
  late final headImage = computed(() => _profile.value.avatar ?? '');
  late final isSubscribe = computed(() => _profile.value.isSubscribe ?? 0);
  late final lastLoginUser = signal('');

  UserStore._internal() {
    debugPrint('user_store.dart~onInit: ');
    token = GlobalUtil.pref.getString('token') ?? 'mock_token';
    final profileJson = GlobalUtil.pref.getString('profile') ?? '{}';
    _profile.value = LoginUserResp.fromJson(jsonDecode(profileJson));
    lastLoginUser.value = GlobalUtil.pref.getString('lastLoginUser') ?? '';
    H5Logic().setupHandler('userLogout', (arguments) async {
      String tips = ListDynamic.val(arguments, 0) ?? '';
      offAndToLoginPage(tips);
    });
    H5Logic().setupHandler('webUpdateToken', (arguments) async {
      String newVal = ListDynamic.val(arguments, 0) ?? '';
      await saveToken(newVal);
    });
  }

  Future<void> saveToken(String val, [bool updateProfile = true]) async {
    if (token != val) {
      await GlobalUtil.pref.setString('token', val);
      token = val;
    }
    if (updateProfile) {
      var r = await SimpleResponse.withMock(
        LoginUserResp().toJson(),
        () => UserApi.info(),
      );
      if (!r.success) return;
      final resp = LoginUserResp.fromJson(r.data);
      await saveProfile(resp);
    }
  }

  Future<void> clearToken() async {
    debugPrint('user_store.dart~clearToken: ');
    await GlobalUtil.pref.remove('token');
    token = '';
  }

  Future<void> saveProfile(LoginUserResp val) async {
    await GlobalUtil.pref.setString('profile', jsonEncode(val));
    _profile.value = val;
    await saveLastLoginUser(val.email ?? '');
  }

  Future<void> clearProfile() async {
    debugPrint('user_store.dart~clearProfile: ');
    await GlobalUtil.pref.remove('profile');
    _profile.value = const LoginUserResp();
  }

  Future<void> saveLastLoginUser(String val) async {
    await GlobalUtil.pref.setString('lastLoginUser', val);
    lastLoginUser.value = val;
  }

  void offAndToLoginPage(String tips) async {
    AppRoutes.clearAllPush(LoginPage.routeName, {'tips': tips});
  }

  Future<void> onLogout({
    bool removeProfile = true,
    bool toLoginPage = true,
    String tips = '',
  }) async {
    debugPrint(
      'user_store.dart~onLogout: '
      'removeProfile: $removeProfile toLoginPage: $toLoginPage tips: $tips',
    );
    await SimpleResponse.withMock({}, () => UserApi.logout());
    await clearToken();
    if (removeProfile) await clearProfile();
    if (toLoginPage) {
      offAndToLoginPage(tips);
      return;
    }
    exit(0);
  }
}
