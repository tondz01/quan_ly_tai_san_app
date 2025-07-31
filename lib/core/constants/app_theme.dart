import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class AppTheme {
  // Material 3 Ocean Blue Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorValue.oceanBlue,
      primary: ColorValue.oceanBlue,
      secondary: ColorValue.lightOceanBlue,
      tertiary: ColorValue.tealAccent,
      background: Colors.white,
      surface: Colors.white,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: ColorValue.oceanBlue,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorValue.oceanBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorValue.oceanBlue,
        side: BorderSide(color: ColorValue.oceanBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorValue.oceanBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: ColorValue.oceanBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade700),
      floatingLabelStyle: TextStyle(color: ColorValue.oceanBlue),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorValue.oceanBlue,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(ColorValue.lightOceanBlue.withOpacity(0.2)),
      dataRowColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return ColorValue.lightOceanBlue.withOpacity(0.1);
          }
          return null;
        },
      ),
      dividerThickness: 1,
      columnSpacing: 16,
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.bold, 
        color: ColorValue.oceanBlue,
      ),
      dataTextStyle: const TextStyle(
        color: Colors.black87,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: ColorValue.lightOceanBlue.withOpacity(0.2),
      disabledColor: Colors.grey.shade300,
      selectedColor: ColorValue.oceanBlue,
      secondarySelectedColor: ColorValue.oceanBlue,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      labelStyle: TextStyle(color: ColorValue.oceanBlue),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    iconTheme: IconThemeData(
      color: ColorValue.oceanBlue,
      size: 24,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: ColorValue.oceanBlue,
      unselectedLabelColor: Colors.grey.shade700,
      indicatorColor: ColorValue.oceanBlue,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ColorValue.oceanBlue,
      circularTrackColor: ColorValue.lightOceanBlue.withOpacity(0.2),
      linearTrackColor: ColorValue.lightOceanBlue.withOpacity(0.2),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: ColorValue.oceanBlue,
      unselectedItemColor: Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: ColorValue.lightOceanBlue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );

  // Table Styles for SgTable and SgEditableTable
  static TableStyle get tableStyle => TableStyle(
    headerBackgroundColor: ColorValue.oceanBlue,
    headerTextColor: Colors.white,
    oddRowBackgroundColor: Colors.white,
    evenRowBackgroundColor: ColorValue.lightOceanBlue.withOpacity(0.05),
    selectedRowColor: ColorValue.lightOceanBlue.withOpacity(0.2),
    gridLineColor: Colors.grey.shade300,
    borderRadius: 8.0,
    elevation: 2.0,
    rowHeight: 48.0,
  );
}

class TableStyle {
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color oddRowBackgroundColor;
  final Color evenRowBackgroundColor;
  final Color selectedRowColor;
  final Color gridLineColor;
  final double borderRadius;
  final double elevation;
  final double rowHeight;

  const TableStyle({
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.oddRowBackgroundColor,
    required this.evenRowBackgroundColor,
    required this.selectedRowColor,
    required this.gridLineColor,
    required this.borderRadius,
    required this.elevation,
    required this.rowHeight,
  });
}
