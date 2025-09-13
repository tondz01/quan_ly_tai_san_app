// Tính toán chiều rộng popup dựa trên dữ liệu
import 'package:quan_ly_tai_san_app/screen/home/models/menu_data.dart';

double calculatePopupWidth(MenuItem item) {
  // Tìm text dài nhất trong tất cả submenu
  String longestSubItemText = '';
  if (item.reportSubItems.isNotEmpty) {
    for (var subItem in item.reportSubItems) {
      if (subItem.label.length > longestSubItemText.length) {
        longestSubItemText = subItem.label;
      }
    }
  }

  // Tìm text dài nhất trong các nhóm
  String longestGroupTitleText = '';
  String longestGroupItemText = '';

  if (item.projectGroups.isNotEmpty) {
    // Kiểm tra trong project groups
    for (var group in item.projectGroups) {
      if (group.title.length > longestGroupTitleText.length) {
        longestGroupTitleText = group.title;
      }

      for (var item in group.items) {
        if (item.label.length > longestGroupItemText.length) {
          longestGroupItemText = item.label;
        }
      }
    }
  }

  // Tính toán chiều rộng
  double subItemWidth = longestSubItemText.length * 8.0;
  double groupTitleWidth = longestGroupTitleText.length * 8.0;
  double groupItemWidth = longestGroupItemText.length * 9.0;

  double width = 60.0;
  width = width > subItemWidth ? width : subItemWidth;
  width = width > groupTitleWidth ? width : groupTitleWidth;
  width = width > groupItemWidth ? width : groupItemWidth;
  return width + 40.0;
}
