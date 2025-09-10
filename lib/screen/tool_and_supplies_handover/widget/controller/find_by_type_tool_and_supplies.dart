import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/common_filter_checkbox.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/tool_and_supplies_handover_transfer_list.dart';

// class FindByType extends StatelessWidget {
//   const FindByType({super.key, required this.provider});
//   final AssetHandoverProvider provider;

//   @override
//   Widget build(BuildContext context) {
//     return _FilterCheckboxes(
//       isCapPhat: provider.isCapPhat,
//       isDieuChuyen: provider.isDieuChuyen,
//       isThuHoi: provider.isThuHoi,
//       allCount: provider.allCount,
//       capPhatCount: provider.capPhatCount,
//       dieuChuyenCount: provider.dieuChuyenCount,
//       thuHoiCount: provider.thuHoiCount,
//     );
//   }
// }

class FindByTypeToolAndSupplies extends StatelessWidget {
  final bool isCapPhat;
  final bool isDieuChuyen;
  final bool isThuHoi;
  final int allCount;
  final int capPhatCount;
  final int dieuChuyenCount;
  final int thuHoiCount;
  final Function(FilterType, bool) onFilterChanged;
  const FindByTypeToolAndSupplies({
    super.key,
    required this.isCapPhat,
    required this.isDieuChuyen,
    required this.isThuHoi,
    required this.allCount,
    required this.capPhatCount,
    required this.dieuChuyenCount,
    required this.thuHoiCount,
    required this.onFilterChanged,
  });
  @override
  Widget build(BuildContext context) {
    // all = true khi không filter cụ thể nào được bật
    final bool isAll = !isCapPhat && !isDieuChuyen && !isThuHoi;

    // Tạo map filter states từ provider (đồng nhất id)
    final filterStates = {
      'all': isAll,
      'capPhat': isCapPhat,
      'dieuChuyen': isDieuChuyen,
      'thuHoi': isThuHoi,
    };

    // Tạo map filter counts từ provider (đồng nhất id)
    final filterCounts = {
      'all': allCount,
      'capPhat': capPhatCount,
      'dieuChuyen': dieuChuyenCount,
      'thuHoi': thuHoiCount,
    };

    // Tạo map filter colors từ FilterType enum (đồng nhất id)
    final filterColors = {
      'all': FilterType.all.activeColor,
      'capPhat': FilterType.capPhat.activeColor,
      'dieuChuyen': FilterType.dieuChuyen.activeColor,
      'thuHoi': FilterType.thuHoi.activeColor,
    };

    // Tạo options sử dụng FilterOptionBuilder
    final options = FilterOptionBuilder.createCustomOptionsWithCount(
      options: [
        {'id': 'all', 'label': 'Tất cả'},
        {'id': 'capPhat', 'label': 'Cấp phát'},
        {'id': 'dieuChuyen', 'label': 'Điều chuyển'},
        {'id': 'thuHoi', 'label': 'Thu hồi'},
      ],
      filterStates: filterStates,
      filterCounts: filterCounts,
      filterColors: filterColors,
      onFilterChanged: (id, value) {
        // Map id về FilterType enum
        FilterType? status;
        switch (id) {
          case 'all':
            status = FilterType.all;
            break;
          case 'capPhat':
            status = FilterType.capPhat;
            break;
          case 'dieuChuyen':
            status = FilterType.dieuChuyen;
            break;
          case 'thuHoi':
            status = FilterType.thuHoi;
            break;
        }

        if (status != null) {
          onFilterChanged(status, value ?? false);
        }
      },
    );

    return Expanded(
      child: CommonFilterCheckbox(
        options: options,
        checkColor: Colors.white,
        textColor: Colors.black87,
        mainAxisAlignment: MainAxisAlignment.end,
        showCount: true,
      ),
    );
  }
}
