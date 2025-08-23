import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../../model/chi_tiet_dieu_dong_tai_san.dart';

abstract class AssetHandoverColumns {
  static Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return ColorValue.silverGray;
      case 1:
        return ColorValue.lightAmber;
      case 2:
        return ColorValue.mediumGreen;
      case 3:
        return ColorValue.lightBlue;
      case 4:
        return ColorValue.forestGreen;
      case 5:
        return ColorValue.brightRed;
      default:
        return ColorValue.paleRose;
    }
  }

  static String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Sẵn sàng';
      case 2:
        return 'Xác nhận';
      case 3:
        return 'Trình Duyệt';
      case 4:
        return 'Hoàn thành';
      case 5:
        return 'Hủy';
      default:
        return '';
    }
  }

  static Widget buildMovementDetails(List<ChiTietDieuDongTaiSan> movementDetails) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: movementDetails.map(buildMovementDetailItem).toList(),
          ),
        ),
      ),
    );
  }

  static Widget buildMovementDetailItem(ChiTietDieuDongTaiSan detail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: ColorValue.paleRose,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SGText(
        text: detail.tenTaiSan,
        size: 12,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.left,
      ),
    );
  }

  static Widget buildActions(BuildContext context, AssetHandoverDto item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildActionButton(
          icon: Icons.visibility,
          color: Colors.green,
          tooltip: 'Xem',
          onPressed: () => showDocument(context, item),
        ),
        const SizedBox(width: 8),
        buildActionButton(
          icon: Icons.delete,
          color: Colors.red,
          tooltip: item.trangThai != 0 ? null : 'Xóa',
          onPressed: null,
          disabled: item.trangThai != 0,
        ),
      ],
    );
  }

  static Widget buildActionButton({
    required IconData icon,
    required MaterialColor color,
    String? tooltip,
    VoidCallback? onPressed,
    bool disabled = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: disabled ? Colors.grey.shade50 : color.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: disabled ? Colors.grey.shade200 : color.shade200,
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        tooltip: tooltip,
        color: disabled ? Colors.grey : color.shade700,
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: const EdgeInsets.all(4),
      ),
    );
  }

  static Widget buildStatus(int status) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: getStatusColor(status),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text: getStatusText(status),
          size: 12,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  static void showDocument(BuildContext context, AssetHandoverDto item) {
    // Tạo data với thông tin menu selection
    Map<String, dynamic> navigationData = {
      'AssetHandoverDto': item,
      'menuSelection': {
        'selectedIndex': 8, // Index của "Bàn giao tài sản"
        'selectedSubIndex': 0, // Index của "Biên bản bàn giao tài sản"
      },
    };

    context.go(AppRoute.assetHandover.path, extra: navigationData);
    Navigator.of(context).pop();
  }
}
