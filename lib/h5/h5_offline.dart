import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

/// H5离线网页服务
/// - 固定目录：current（当前服务）、next（升级临时目录）
/// - 启动时若有 next，则自动替换 current
/// - 升级仅解压到 next，需手动调用 restartServer 或 startServer 应用
class H5Offline {
  static final Map<int, H5Offline> _cache = <int, H5Offline>{};
  factory H5Offline([int port = 24399]) {
    return _cache.putIfAbsent(port, () => H5Offline._internal(port));
  }
  H5Offline._internal(this.port);

  final int port;
  String _homePath = '';
  HttpServer? _server;
  String serverUrl = '';
  String _currentVersion = '';

  Future<void> _initPath() async {
    if (_homePath.isNotEmpty) return;
    final sDir = await getApplicationSupportDirectory();
    _homePath = p.join(sDir.path, 'h5_offline_$port');
    await Directory(_homePath).create(recursive: true);
  }

  Future<void> _extractZip(String zipPath, String destDir) async {
    final zipFile = File(zipPath);
    final bytes = zipFile.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    await extractArchiveToDisk(archive, destDir);
  }

  Future<String> _readVersionFile(String dirPath) async {
    final file = File(p.join(dirPath, '.version'));
    if (file.existsSync()) return file.readAsStringSync();
    return '';
  }

  Future<void> _writeVersionFile(String dirPath, String version) async {
    final file = File(p.join(dirPath, '.version'));
    await file.writeAsString(version);
  }

  Future<String> getCurrentVersion() async {
    if (_currentVersion.isNotEmpty) return _currentVersion;
    await _initPath();
    final currentDir = Directory(p.join(_homePath, 'current'));
    if (await currentDir.exists()) {
      _currentVersion = await _readVersionFile(currentDir.path);
    }
    return _currentVersion;
  }

  Future<String> getPendingVersion() async {
    await _initPath();
    final nextDir = Directory(p.join(_homePath, 'next'));
    if (!await nextDir.exists()) return '';
    return await _readVersionFile(nextDir.path);
  }

  Future<bool> hasDeployment() async {
    await _initPath();
    return await Directory(p.join(_homePath, 'current')).exists();
  }

  Future<bool> hasPendingUpdate() async {
    await _initPath();
    return await Directory(p.join(_homePath, 'next')).exists();
  }

  Future<String> startServer() async {
    debugPrint('h5_offline.dart~startServer: ');
    await _initPath();
    await _applyUpdateIfNeeded();
    final currentDir = Directory(p.join(_homePath, 'current'));
    if (!await currentDir.exists()) {
      throw Exception('No H5 deployment found. Please update first.');
    }
    await stopServer();
    return await serveDist(currentDir.path);
  }

  Future<void> _applyUpdateIfNeeded() async {
    await _initPath();
    final nextDir = Directory(p.join(_homePath, 'next'));
    if (!await nextDir.exists()) return;

    final currentDir = Directory(p.join(_homePath, 'current'));
    if (await currentDir.exists()) {
      await currentDir.delete(recursive: true);
    }
    await nextDir.rename(currentDir.path);
    _currentVersion = await _readVersionFile(currentDir.path);
  }

  Future<bool> updateDist(String zipPath, String tag) async {
    debugPrint('h5_offline.dart~updateDist: $zipPath $tag');
    await _initPath();
    final nextDir = Directory(p.join(_homePath, 'next'));
    if (await nextDir.exists()) {
      await nextDir.delete(recursive: true);
    }
    await nextDir.create(recursive: true);
    await _extractZip(zipPath, nextDir.path);

    final indexFile = File(p.join(nextDir.path, 'index.html'));
    if (!await indexFile.exists()) {
      await nextDir.delete(recursive: true);
      throw Exception('ZIP does not contain index.html');
    }

    await _writeVersionFile(nextDir.path, tag);
    return true;
  }

  Future<void> stopServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      serverUrl = '';
    }
  }

  Future<String> restartServer() async {
    await stopServer();
    return await startServer();
  }

  Future<String> serveDist(String distPath) async {
    final staticHandler = createStaticHandler(
      distPath,
      defaultDocument: 'index.html',
      listDirectories: true,
      useHeaderBytesForContentType: true,
    );
    Pipeline pipeline = const Pipeline();
    pipeline = pipeline.addMiddleware(
      logRequests(
        logger: (message, isError) {
          if (!isError) return;
          debugPrint('h5_offline.dart~logRequests: $isError $message');
        },
      ),
    );
    final handler = pipeline.addHandler((Request request) async {
      var response = await staticHandler(request);
      if (response.statusCode == 404) return Response.found('/');
      return response;
    });
    _server = await serve(handler, InternetAddress.anyIPv4, port);
    serverUrl = 'http://${_server?.address.host}:${_server?.port}';
    return serverUrl;
  }
}
