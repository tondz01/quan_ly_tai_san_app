import 'dart:ui';

abstract class ColorValue {
  // Material Design Light Blue Palette
  static const Color primaryLightBlue = Color(0xFF81D4FA); // Light Blue 200
  static const Color primaryBlue = Color(0xFF42A5F5); // Blue 400
  static const Color primaryDarkBlue = Color(0xFF1976D2); // Blue 700
  static const Color primaryVeryDarkBlue = Color(0xFF0D47A1); // Blue 900
  
  // Accent colors
  static const Color accentCyan = Color(0xFF00BCD4); // Cyan 500
  static const Color accentLightCyan = Color(0xFF80DEEA); // Cyan 200
  
  // Neutral colors
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50); // Green 500
  static const Color warning = Color(0xFFFF9800); // Orange 500
  static const Color error = Color(0xFFF44336); // Red 500
  static const Color info = Color(0xFF2196F3); // Blue 500
  
  // Legacy colors (keeping for backward compatibility)
  static const Color oldLavender = Color(0xFF714B67);
  static const Color tealBlue = Color(0xFF017E84);
  static const Color limeYellow = Color(0xFFE7E93D);
  static const Color paleRose = Color(0xFFE6DDD3);
  static const Color silverGray = Color(0xFFC0C0C0);
  static const Color lightAmber = Color(0xFFFFD580);
  static const Color mediumGreen = Color(0xFF4CAF50);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color brightRed = Color(0xFFF44336);
  static const Color coral = Color(0xFFFF7043);
  static const Color forestGreen = Color(0xFF388E3C);
}
