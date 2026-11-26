import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppText.fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navyDeep),
        scaffoldBackgroundColor: AppColors.surface,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.fieldFocus,
          selectionColor: Color(0x552F63A0),
          selectionHandleColor: AppColors.fieldFocus,
        ),
      );
}
