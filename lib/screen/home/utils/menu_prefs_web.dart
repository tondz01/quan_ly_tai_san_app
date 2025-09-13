import 'dart:html' as html;

int? getSelectedIndex() {
  final v = html.window.localStorage['MENU_SELECTED_INDEX'];
  if (v == null) return null;
  return int.tryParse(v);
}

int? getSelectedSubIndex() {
  final v = html.window.localStorage['MENU_SELECTED_SUB_INDEX'];
  if (v == null) return null;
  return int.tryParse(v);
}

void setSelection(int selectedIndex, int selectedSubIndex) {
  html.window.localStorage['MENU_SELECTED_INDEX'] = selectedIndex.toString();
  html.window.localStorage['MENU_SELECTED_SUB_INDEX'] = selectedSubIndex.toString();
} 