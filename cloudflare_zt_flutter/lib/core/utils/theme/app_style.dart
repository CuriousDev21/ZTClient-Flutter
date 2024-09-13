import 'package:flutter/material.dart';

// Color palette for the app
class AppColors {
  static const primaryColor = Color(0xFF0D47A1);
  static const accentColor = Color(0xFF42A5F5);
  static const backgroundColor = Color(0xFFFFFFFF);
  static const surfaceColor = Color(0xFFF1F1F1);
  static const textColor = Color(0xFF0D47A1);
  static const errorColor = Color(0xFFFF5252);
}

// Text styles for the app
class AppTextStyles {
  static TextStyle headlineLarge = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static TextStyle headlineMedium = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static TextStyle bodyText = const TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
  );

  static TextStyle errorText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.errorColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
