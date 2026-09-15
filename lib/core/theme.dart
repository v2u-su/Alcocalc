import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const bar = Color(0xFF222C35);
  static const bg = Color(0xFF2E3A45);
  static const surface = Color(0xFF39454F);
  static const field = Color(0xFF33404A);
  static const fieldInner = Color(0xFF1F272E);
  static const teal = Color(0xFF4CC0BA);
  static const amber = Color(0xFFD9A431);
  static const text = Color(0xFFEDF1F4);
  static const textDim = Color(0xFFA3B1BC);
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.teal,
      secondary: AppColors.amber,
      surface: AppColors.surface,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    dialogTheme: const DialogThemeData(backgroundColor: AppColors.surface),
    splashFactory: InkRipple.splashFactory,
  );
}
