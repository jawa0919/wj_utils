import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  /// 主题色
  static const primaryColor = Color(0xFF5856D7);

  /// 次级主题色
  static const secondaryColor = Color(0xFF8A88E0);

  /// 错误色
  static const errorColor = Color(0xFFD54941);

  /// 背景色
  static const surfaceColor = Color(0xFFF3F3F3);

  /// 主字体颜色
  static const onSurfaceColor = Color.fromRGBO(0, 0, 0, 0.9);

  /// 次级背景色
  static const surfaceContainerColor = Color(0xFFFFFFFF);

  /// 次级主字体颜色
  static const onSecondaryContainerColor = Color.fromRGBO(0, 0, 0, 0.6);

  /// 半透明背景色
  static const scrimColor = Color.fromRGBO(0, 0, 0, 0.26);

  /// 轮廓色
  static const outlineColor = Color(0xFFC5C5C5);

  /// 轮廓色变体
  static const outlineVariantColor = Color(0xFFDCDCDC);

  /// 真白颜色
  static const trueBlack = Color(0xFF000000);

  /// 真黑颜色
  static const trueWhite = Color(0xFFFFFFFF);

  /// 真透明颜色
  static const trueTransparent = Color(0x00000000);

  static final colorScheme = ColorScheme.fromSeed(seedColor: primaryColor)
      .copyWith(
        primary: primaryColor,

        secondary: secondaryColor,

        error: errorColor,

        surface: surfaceColor,
        onSurface: onSurfaceColor,

        surfaceContainerHighest: surfaceColor,
        surfaceContainerHigh: surfaceColor,
        surfaceContainer: surfaceContainerColor,
        surfaceContainerLow: surfaceContainerColor,
        surfaceContainerLowest: surfaceContainerColor,
        onSurfaceVariant: onSecondaryContainerColor,

        scrim: scrimColor,

        outline: outlineColor,
        outlineVariant: outlineVariantColor,
      );
}
