import 'package:flutter/material.dart';

/// Palet warna diambil dari frame Figma "Ruang Karya".
abstract final class AppColors {
  // Navy: header login, tombol utama, judul
  static const navy = Color(0xFF14284B);
  static const navyDeep = Color(0xFF0F1F3D);
  static const navyRing = Color(0xFF1F3C6A);

  // Biru muda: latar halaman & ilustrasi
  static const sky = Color(0xFF5E8FBF);
  static const mist = Color(0xFFB7D1E8);
  static const surface = Color(0xFFEAF2FB);
  static const card = Color(0xFFF6FAFF);

  // Input
  static const fieldBorder = Color(0xFFA9C0D8);
  static const fieldFocus = Color(0xFF2F63A0);

  // Teks
  static const textPrimary = Color(0xFF0F1E3A);
  static const textMuted = Color(0xFF66768C);
  static const textHint = Color(0xFF8FA0B5);
  static const link = Color(0xFF1F4E8C);

  // Status
  static const error = Color(0xFFB3261E);
  static const success = Color(0xFF1F5F3D);
}
