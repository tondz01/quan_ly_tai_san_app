import 'menu_prefs_stub.dart'
    if (dart.library.html) 'menu_prefs_web.dart' as impl;

class MenuSelection {
  final int selectedIndex;
  final int selectedSubIndex;
  const MenuSelection(this.selectedIndex, this.selectedSubIndex);
}

class MenuPrefs {
  static const String keySelectedIndex = 'MENU_SELECTED_INDEX';
  static const String keySelectedSubIndex = 'MENU_SELECTED_SUB_INDEX';

  static int? getSelectedIndex() => impl.getSelectedIndex();
  static int? getSelectedSubIndex() => impl.getSelectedSubIndex();
  static void setSelection(int selectedIndex, int selectedSubIndex) =>
      impl.setSelection(selectedIndex, selectedSubIndex);
} 