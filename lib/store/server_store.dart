import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';

import '../util/global_util.dart' show GlobalUtil;

class ServerStore {
  ServerStore._();
  static final ServerStore _instance = ServerStore._();
  static ServerStore get instance => _instance;
  static ServerStore get to => _instance;

  late List<Map<String, dynamic>> serverInfoList;
  static void init(List<Map<String, dynamic>> serverInfoList) =>
      _instance._internal(serverInfoList);

  void _internal(List<Map<String, dynamic>> serverInfoList) {
    this.serverInfoList = serverInfoList;
    debugPrint('server_store.dart~_internal: ');
    _serverEnv.value = GlobalUtil.pref.getString('_serverEnv') ?? 'prod';
    if (_serverEnv.value == 'custom') {
      _serverInfo = {
        'env': 'custom',
        'apiHost': GlobalUtil.pref.getString('custom_apiHost'),
        'h5Host': GlobalUtil.pref.getString('custom_h5Host'),
      };
    } else {
      _serverInfo = this.serverInfoList.firstWhere(
        (element) => element['env'] == _serverEnv.value,
      );
    }

    checkUpdateEpoch = GlobalUtil.pref.getInt('checkUpdateEpoch') ?? 0;
  }

  /// 服务器信息
  final _serverEnv = signal('prod');
  Map<String, dynamic> _serverInfo = {};
  String get env => _serverInfo['env']?.toString() ?? '';
  String get apiHost => _serverInfo['apiHost']?.toString() ?? '';
  String get h5Host => _serverInfo['h5Host']?.toString() ?? '';

  /// 更新信息
  int checkUpdateEpoch = 0;
  bool get isFirstOpen => !GlobalUtil.pref.containsKey('checkUpdateEpoch');

  Future<void> saveServerInfo(Map<String, dynamic> val) async {
    await GlobalUtil.pref.setString('_serverEnv', val['env']);
    _serverInfo = val;
    _serverEnv.value = val['env'];
    if (val['env'] == 'custom') {
      await GlobalUtil.pref.setString('custom_apiHost', val['apiHost']);
      await GlobalUtil.pref.setString('custom_h5Host', val['h5Host']);
    }
  }
}
