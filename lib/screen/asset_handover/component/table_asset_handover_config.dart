import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableAssetHandoverConfig {
  static List<ColumnDefinition> getColumns(UserInfoDTO userInfo) {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số quyết định',
          key: 'quyet_dinh',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.quyetDinhDieuDongSo ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Lệnh điều động',
          key: 'lenh_dieu_dong',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.lenhDieuDong ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị giao',
          key: 'don_vi_giao',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: Text(
              AccountHelper.instance
                      .getDepartmentById(item.idDonViGiao ?? '')
                      ?.tenPhongBan ??
                  item.tenDonViGiao ??
                  '',
            ),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị nhận',
          key: 'don_vi_nhan',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: Text(
              AccountHelper.instance
                      .getDepartmentById(item.idDonViNhan ?? '')
                      ?.tenPhongBan ??
                  item.tenDonViNhan ??
                  '',
            ),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày bàn giao',
          key: 'ngay_ban_giao',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngayBanGiao ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày tạo chứng từ',
          key: 'ngay_tao_chung_tu',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngayTaoChungTu ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người lập phiếu',
          key: 'nguoi_lap_phieu',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.nguoiTao ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài liệu',
          key: 'document',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget:
                item.tenFile != null && item.tenFile!.isNotEmpty
                    ? SgDownloadFile(
                      name: item.tenFile!,
                      url: item.duongDanFile ?? '',
                    )
                    : Text('Không có tài liệu'),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái ký',
          key: 'trang_thai_ky',
          width: 170,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: AppUtility.showPermissionSigning(
              getPermissionSigning(item, userInfo),
            ),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái bàn giao',
          key: 'trang_thai_ban_giao',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: showStatusDocument(item.trangThaiPhieu ?? 0),
          );
        },
      ),

      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái phiếu',
          key: 'trang_thai_phieu',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: showStatus(item.trangThai ?? 0));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Chia sẻ',
          key: 'share',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: ConfigViewAT.showShareStatus(
              item.share == true,
              item.nguoiTao == userInfo.tenDangNhap,
            ),
          );
        },
      ),
    ];
  }

  static Widget showStatus(int status) {
    String statusText;
    Color statusColor;

    switch (status) {
      case 0:
        statusText = 'Chưa xác nhận';
        statusColor = Colors.orange;
        break;
      case 1:
        statusText = 'Đã xác nhận';
        statusColor = Colors.green;
        break;
      case 2:
        statusText = 'Đã hủy';
        statusColor = Colors.red;
        break;
      default:
        statusText = 'Không xác định';
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static Widget showPermissionSigning(AssetHandoverDto item) {
    // Logic để xác định trạng thái ký dựa trên item
    // Có thể cần thêm logic phức tạp hơn dựa trên business rules
    if (item.daiDienBenGiaoXacNhan == true &&
        item.daiDienBenNhanXacNhan == true) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Text(
          'Đã ký',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (item.daiDienBenGiaoXacNhan == true ||
        item.daiDienBenNhanXacNhan == true) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: Text(
          'Đang ký',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Text(
          'Chưa ký',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  static Widget showStatusDocument(int status) {
    String statusText;
    Color statusColor;

    switch (status) {
      case 0:
        statusText = 'Chưa bàn giao';
        statusColor = Colors.orange;
        break;
      case 1:
        statusText = 'Đã bàn giao';
        statusColor = Colors.green;
        break;
      case 2:
        statusText = 'Đã hủy';
        statusColor = Colors.red;
        break;
      default:
        statusText = 'Không xác định';
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static int getPermissionSigning(
    AssetHandoverDto item,
    UserInfoDTO userInfo,
  ) {
    final signatureFlow =
        [
              {
                "id": item.idDaiDiendonviBanHanhQD,
                "signed": item.daXacNhan == true,
              },
              {
                "id": item.idDaiDienBenGiao,
                "signed": item.daiDienBenGiaoXacNhan == true,
              },
              {
                "id": item.idDaiDienBenNhan,
                "signed": item.daiDienBenNhanXacNhan == true,
              },
              if (item.listSignatory?.isNotEmpty ?? false)
                ...(item.listSignatory
                        ?.map(
                          (e) => {
                            "id": e.idNguoiKy,
                            "signed": e.trangThai == 1,
                          },
                        )
                        .toList() ??
                    []),
            ]
            .where(
              (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
            )
            .toList();
    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo.tenDangNhap,
    );
    if (currentIndex == -1) return 2;
    if (item.idDaiDiendonviBanHanhQD == userInfo.tenDangNhap &&
        signatureFlow[currentIndex]["signed"] != -1) {
      return signatureFlow[currentIndex]["signed"] == true ? 4 : 5;
    }
    if (signatureFlow[currentIndex]["signed"] == true) return 3;
    final previousNotSigned = signatureFlow
        .take(currentIndex)
        .firstWhere((s) => s["signed"] == false, orElse: () => {});

    if (previousNotSigned.isNotEmpty) return 1;
    return 0;
  }
}
