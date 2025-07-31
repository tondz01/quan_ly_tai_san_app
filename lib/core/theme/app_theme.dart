import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorValue.primaryBlue,
        brightness: Brightness.light,
        primary: ColorValue.primaryBlue,
        onPrimary: Colors.white,
        secondary: ColorValue.accentCyan,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: ColorValue.neutral900,
        background: ColorValue.neutral50,
        onBackground: ColorValue.neutral900,
        error: ColorValue.error,
        onError: Colors.white,
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ColorValue.neutral900,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ColorValue.neutral900,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: ColorValue.primaryBlue,
          size: 24,
        ),
      ),
      
      // ElevatedButton theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorValue.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: ColorValue.primaryBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // OutlinedButton theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorValue.primaryBlue,
          side: BorderSide(color: ColorValue.primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // TextButton theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorValue.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // IconButton theme
      // iconButtonTheme: IconButtonThemeData(
      //   style: IconButton.styleFrom(
      //     foregroundColor: ColorValue.primaryBlue,
      //     backgroundColor: ColorValue.neutral100,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     padding: const EdgeInsets.all(8),
      //   ),
      // ),
      
      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorValue.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: ColorValue.neutral300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // InputDecoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorValue.neutral50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorValue.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorValue.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorValue.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorValue.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorValue.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(
          color: ColorValue.neutral500,
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          color: ColorValue.neutral700,
          fontSize: 14,
        ),
      ),
      
      // BottomNavigationBar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: ColorValue.primaryBlue,
        unselectedItemColor: ColorValue.neutral500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // NavigationRail theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(
          color: ColorValue.primaryBlue,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: ColorValue.neutral500,
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: ColorValue.primaryBlue,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: ColorValue.neutral500,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: ColorValue.primaryLightBlue.withOpacity(0.2),
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: ColorValue.neutral200,
        thickness: 1,
        space: 1,
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: ColorValue.neutral100,
        selectedColor: ColorValue.primaryLightBlue,
        disabledColor: ColorValue.neutral200,
        labelStyle: TextStyle(
          color: ColorValue.neutral700,
          fontSize: 12,
        ),
        secondaryLabelStyle: TextStyle(
          color: ColorValue.primaryBlue,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ColorValue.primaryBlue,
        linearTrackColor: ColorValue.neutral200,
        circularTrackColor: ColorValue.neutral200,
      ),
      
      // SnackBar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ColorValue.neutral800,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          color: ColorValue.neutral900,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: ColorValue.neutral700,
          fontSize: 14,
        ),
      ),
      
      // BottomSheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      
      // PopupMenuButton theme
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          color: ColorValue.neutral700,
          fontSize: 14,
        ),
      ),
      
      // Tooltip theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ColorValue.neutral800,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      
      // DataTable theme
      dataTableTheme: DataTableThemeData(
        headingTextStyle: TextStyle(
          color: ColorValue.neutral900,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        dataTextStyle: TextStyle(
          color: ColorValue.neutral700,
          fontSize: 14,
        ),
        headingRowColor: MaterialStateProperty.all(ColorValue.neutral50),
        dataRowColor: MaterialStateProperty.all(Colors.white),
        dividerThickness: 1,
        columnSpacing: 16,
        horizontalMargin: 16,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorValue.primaryBlue,
        brightness: Brightness.dark,
        primary: ColorValue.primaryBlue,
        onPrimary: Colors.white,
        secondary: ColorValue.accentCyan,
        onSecondary: Colors.white,
        surface: ColorValue.neutral800,
        onSurface: Colors.white,
        background: ColorValue.neutral900,
        onBackground: Colors.white,
        error: ColorValue.error,
        onError: Colors.white,
      ),
    );
  }
} 