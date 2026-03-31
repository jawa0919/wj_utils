import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../wj_utils.dart';

class SettingView extends StatefulWidget {
  final String appStoreId;
  final String icpNumber;
  final String copyrightCode;
  const SettingView({
    super.key,
    required this.appStoreId,
    required this.icpNumber,
    required this.copyrightCode,
  });

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SettingView.设置'.tr), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 主题设置
            _buildSettingSection(
              title: 'SettingView.系统设置'.tr,
              children: [
                Watch((c) {
                  final themeMode = ThemeStore.to.themeMode.value;
                  String themeText;

                  switch (themeMode) {
                    case ThemeMode.system:
                      themeText = 'SettingView.跟随系统'.tr;
                      break;
                    case ThemeMode.light:
                      themeText = 'SettingView.浅色主题'.tr;
                      break;
                    case ThemeMode.dark:
                      themeText = 'SettingView.深色主题'.tr;
                      break;
                  }

                  return ListTile(
                    title: Text('SettingView.主题模式'.tr),
                    subtitle: Text(themeText),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // 主题切换实现
                      _showThemeDialog();
                    },
                  );
                }),

                Watch((c) {
                  return ListTile(
                    title: Text('SettingView.语言'.tr),
                    subtitle: Text('language.name'.tr),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // 语言切换实现
                      _showLanguageDialog();
                    },
                  );
                }),
              ],
            ),

            // 账户设置
            _buildSettingSection(
              title: 'SettingView.账户设置'.tr,
              children: [
                ListTile(
                  title: Text('SettingView.账号注销'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 账号注销实现
                  },
                ),
              ],
            ),

            // 隐私设置
            _buildSettingSection(
              title: 'SettingView.隐私设置'.tr,
              children: [
                ListTile(
                  title: Text('SettingView.个人信息收集清单'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 个人信息收集清单实现
                  },
                ),
                ListTile(
                  title: Text('SettingView.第三方个人信息共享清单'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 第三方个人信息共享清单实现
                  },
                ),
                ListTile(
                  title: Text('SettingView.权限管理'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 权限管理实现
                  },
                ),
              ],
            ),

            // 关于
            _buildSettingSection(
              title: 'SettingView.关于应用'.tr,
              children: [
                ListTile(
                  title: Text('SettingView.检查更新'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 检查更新实现
                    ExDialog.showLoading('SettingView.正在检查更新'.tr);
                    Future.delayed(const Duration(seconds: 2), () {
                      ExDialog.dismiss();
                      ExDialog.showToastCenter('SettingView.已经是最新版本了'.tr);
                      // if (GlobalUtil.isIOS) {
                      //   GlobalUtil.openSystemBrowser(
                      //     appStoreLookup + widget.appStoreId,
                      //   );
                      //   return;
                      // }
                    });
                  },
                ),
                ListTile(
                  title: Text('SettingView.关于'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // 关于实现
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutView(
                          icpNumber: widget.icpNumber,
                          copyrightCode: widget.copyrightCode,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // 构建设置分组
  Widget _buildSettingSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Column(children: children),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // 主题切换对话框
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('SettingView.选择主题'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              String modeText;

              switch (mode) {
                case ThemeMode.system:
                  modeText = 'SettingView.跟随系统'.tr;
                  break;
                case ThemeMode.light:
                  modeText = 'SettingView.浅色主题'.tr;
                  break;
                case ThemeMode.dark:
                  modeText = 'SettingView.深色主题'.tr;
                  break;
              }

              return RadioGroup<ThemeMode>(
                groupValue: ThemeStore.to.themeMode.value,
                onChanged: (value) {
                  if (value != null) {
                    ThemeStore.to.saveThemeMode(value);
                  }
                  Navigator.pop(context);
                },
                child: RadioListTile<ThemeMode>(
                  title: Text(modeText),
                  value: mode,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // 语言切换对话框
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('SettingView.选择语言'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageStore.to.supportedLanguageNames
                .map((locale, languageText) {
                  return MapEntry(
                    locale,
                    RadioGroup<Locale>(
                      groupValue: LanguageStore.to.locale.value,
                      onChanged: (value) {
                        if (value != null) {
                          final index = LanguageStore.to.supportedLocales
                              .indexOf(value);
                          LanguageStore.to.saveLanguageIndex(index);
                        }
                        Navigator.pop(context);
                      },
                      child: RadioListTile<Locale>(
                        title: Text(languageText),
                        value: locale,
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),
        );
      },
    );
  }
}

extension SettingViewLanguage on SettingView {
  static final languageMap = {
    const Locale('zh', 'CN'): {
      'SettingView.设置': '设置',
      'SettingView.系统设置': '系统设置',

      'SettingView.主题模式': '主题模式',
      'SettingView.跟随系统': '跟随系统',
      'SettingView.浅色主题': '浅色主题',
      'SettingView.深色主题': '深色主题',
      'SettingView.选择主题': '选择主题',

      'SettingView.语言': '语言',
      'SettingView.选择语言': '选择语言',

      'SettingView.账户设置': '账户设置',
      'SettingView.账号注销': '账号注销',

      'SettingView.隐私设置': '隐私设置',
      'SettingView.个人信息收集清单': '个人信息收集清单',
      'SettingView.第三方个人信息共享清单': '第三方个人信息共享清单',
      'SettingView.权限管理': '权限管理',

      'SettingView.关于应用': '关于应用',
      'SettingView.检查更新': '检查更新',
      'SettingView.正在检查更新': '正在检查更新',
      'SettingView.已经是最新版本了': '已经是最新版本了',
      'SettingView.关于': '关于',
    },
    const Locale('en', 'US'): {
      'SettingView.设置': 'Setting',
      'SettingView.系统设置': 'System Settings',

      'SettingView.主题模式': 'Theme Mode',
      'SettingView.跟随系统': 'Follow System',
      'SettingView.浅色主题': 'Light Theme',
      'SettingView.深色主题': 'Dark Theme',
      'SettingView.选择主题': 'Select Theme',

      'SettingView.语言': 'Language',
      'SettingView.选择语言': 'Select Language',

      'SettingView.账户设置': 'Account Settings',
      'SettingView.账号注销': 'Logout',

      'SettingView.隐私设置': 'Privacy Settings',
      'SettingView.个人信息收集清单': 'Personal Information Collection List',
      'SettingView.第三方个人信息共享清单':
          'Third-Party Personal Information Sharing List',
      'SettingView.权限管理': 'Permission Management',

      'SettingView.关于应用': 'About the App',
      'SettingView.检查更新': 'Check for Updates',
      'SettingView.正在检查更新': 'Checking for Updates',
      'SettingView.已经是最新版本了': 'Already up-to-date',
      'SettingView.关于': 'About',
    },
    const Locale('ja', 'JP'): {
      'SettingView.设置': '設定',
      'SettingView.系统设置': 'システム設定',

      'SettingView.主题模式': 'テーマモード',
      'SettingView.跟随系统': 'システムに従う',
      'SettingView.浅色主题': 'ライトテーマ',
      'SettingView.深色主题': 'ダークテーマ',
      'SettingView.选择主题': 'テーマを選択',

      'SettingView.语言': '言語',
      'SettingView.选择语言': '言語を選択',

      'SettingView.账户设置': 'アカウント設定',
      'SettingView.账号注销': 'ログアウト',

      'SettingView.隐私设置': 'プライバシー設定',
      'SettingView.个人信息收集清单': '個人情報収集清单',
      'SettingView.第三方个人信息共享清单': '第三者個人情報共有清单',
      'SettingView.权限管理': '権限管理',

      'SettingView.关于应用': 'アプリについて',
      'SettingView.检查更新': '更新を確認',
      'SettingView.正在检查更新': '更新を確認中',
      'SettingView.已经是最新版本了': '最新バージョンです',
      'SettingView.关于': 'について',
    },
    const Locale('ko', 'KR'): {
      'SettingView.设置': '설정',
      'SettingView.系统设置': '시스템 설정',

      'SettingView.主题模式': '테마 모드',
      'SettingView.跟随系统': '시스템 따라가기',
      'SettingView.浅色主题': '라이트 테마',
      'SettingView.深色主题': '다크 테마',
      'SettingView.选择主题': '테마 선택',

      'SettingView.语言': '언어',
      'SettingView.选择语言': '언어 선택',

      'SettingView.账户设置': '계정 설정',
      'SettingView.账号注销': '로그아웃',

      'SettingView.隐私设置': '개인정보 설정',
      'SettingView.个人信息收集清单': '개인정보 수집 목록',
      'SettingView.第三方个人信息共享清单': '제3자 개인정보 공유 목록',
      'SettingView.权限管理': '권한 관리',

      'SettingView.关于应用': '앱 정보',
      'SettingView.检查更新': '업데이트 확인',
      'SettingView.正在检查更新': '업데이트 확인 중',
      'SettingView.已经是最新版本了': '최신 버전입니다',
      'SettingView.关于': '정보',
    },
  };
}
