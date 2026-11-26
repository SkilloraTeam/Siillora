import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gaya teks. Font: Plus Jakarta Sans (lihat README di bawah untuk cara
/// memasangnya). Kalau font belum dipasang, Flutter otomatis pakai font bawaan.
abstract final class AppText {
  static const fontFamily = 'PlusJakartaSans';

  static const _base = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
  );

  static final headline = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.16,
    letterSpacing: -0.6,
    color: Colors.white,
  );

  static final brand = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.mist,
  );

  static final onDarkBody = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFC9D8EA),
  );

  static final title = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    height: 1.2,
  );

  static final sectionTitle = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static final subtitle = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static final body = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  static final label = _base.copyWith(fontSize: 12.5, fontWeight: FontWeight.w700);

  static final input = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);

  static final hint = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static final button = _base.copyWith(
    fontSize: 13.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.8,
    color: Colors.white,
  );

  static final link = _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: AppColors.link,
  );

  static final error = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );
}
