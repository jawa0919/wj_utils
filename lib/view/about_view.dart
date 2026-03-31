import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals/signals_flutter.dart';

import '../wj_utils.dart';

class AboutView extends StatefulWidget {
  final String icpNumber;
  final String copyrightCode;
  const AboutView({
    super.key,
    required this.icpNumber,
    required this.copyrightCode,
  });

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AboutView.关于'.tr), centerTitle: true),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 100.w, 16.w, 50.w),
            child: FlutterLogo(size: 500.w),
          ).onHackerTap(() => {}),
          Text(
            GlobalUtil.appName,
            style: TextStyle(fontSize: 88.w, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10, width: double.maxFinite),
          Text(
            'AboutView.版本'.trArgs([GlobalUtil.buildVersion]),
            style: TextStyle(fontSize: 36.w),
          ),
          const SizedBox(height: 10),
          Text('AboutView.反馈信息'.tr, style: TextStyle(fontSize: 36.w)),
          const SizedBox(height: 10),
          Spacer(),
          Text(
            'AboutView.《资质证书1》'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 6),
          Text(
            'AboutView.《资质证书2》'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 6),
          LanguageStore.to.isChinese.watch(context)
              ? Text(
                  'ICP备案号: ${widget.icpNumber}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ).onTap(() {
                  GlobalUtil.openSystemBrowser(icpQueryUrl);
                })
              : Container(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 12.0),
              child: Text(
                widget.copyrightCode,
                style: TextStyle(fontSize: 36.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension AboutViewLanguage on AboutView {
  static final languageMap = {
    const Locale('zh', 'CN'): {
      'AboutView.关于': '关于',
      'AboutView.版本': '版本: %s',
      'AboutView.反馈信息': '反馈信息',
      'AboutView.《资质证书1》': '《资质证书1》',
      'AboutView.《资质证书2》': '《资质证书2》',
      'AboutView.ICP备案号: %s': 'ICP备案号: %s',
    },
    const Locale('en', 'US'): {
      'AboutView.关于': 'About',
      'AboutView.版本': 'Version: %s',
      'AboutView.反馈信息': 'Feedback Information',
      'AboutView.《资质证书1》': 'Qualification Certificate 1',
      'AboutView.《资质证书2》': 'Qualification Certificate 2',
      'AboutView.ICP备案号: %s': 'ICP Record Number: %s',
    },
    const Locale('ja', 'JP'): {
      'AboutView.关于': 'について',
      'AboutView.版本': 'バージョン: %s',
      'AboutView.反馈信息': 'フィードバック情報',
      'AboutView.《资质证书1》': '資格証明書1',
      'AboutView.《资质证书2》': '資格証明書2',
      'AboutView.ICP备案号: %s': 'ICP登録番号: %s',
    },
    const Locale('ko', 'KR'): {
      'AboutView.关于': '정보',
      'AboutView.版本': '버전: %s',
      'AboutView.反馈信息': '피드백 정보',
      'AboutView.《资质证书1》': '자격 증명서1',
      'AboutView.《资质证书2》': '자격 증명서2',
      'AboutView.ICP备案号: %s': 'ICP 등록 번호: %s',
    },
  };
}
