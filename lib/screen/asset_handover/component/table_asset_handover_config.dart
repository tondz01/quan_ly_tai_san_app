// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
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
          return TableCellData(widget: Text(item.id ?? ''));
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
        ),
        builder: (item) {
          return TableCellData(widget: Text(AccountHelper.instance.getNhanVienById(item.nguoiTao ?? '')?.hoTen?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài liệu',
          key: 'document',
          width: 150,
          flex: 1,
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
          name: 'Trạng thái phiếu',
          key: 'trang_thai_phieu',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: showStatusHandover(item.trangThaiPhieu ?? 0),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái',
          key: 'trang_thai',
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
          name: 'Trình duyệt',
          key: 'share',
          width: 150,
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
    Color statusColor;
    switch (status) {
      case 0:
        statusColor = ColorValue.silverGray;
        break;
      case 1:
        statusColor = ColorValue.amber;
        break;
      case 2:
        statusColor = ColorValue.lightBlue;
        break;
      case 3:
        statusColor = ColorValue.coral;
        break;
      case 4:
        statusColor = ColorValue.forestGreen;
        break;
      default:
        statusColor = ColorValue.darkGrey;
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        getStatusText(status),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Duyệt';
      case 2:
        return 'Hủy';
      case 3:
        return 'Đã hủy';
      case 4:
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  static Widget showStatusHandover(int status) {
    Color statusColor;

    switch (status) {
      case 0:
        statusColor = Colors.orange;
        break;
      case 1:
        statusColor = Colors.red;
        break;
      case 2:
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        getStatusHandoverText(status),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static String getStatusHandoverText(int status) {
    switch (status) {
      case 0:
        return 'Chưa hoàn thành';
      case 1:
        return 'Sắp hết hạn';
      case 2:
        return 'Đã hoàn thành';
      default:
        return 'Không xác định';
    }
  }

  static void handleSendToSigner(
    List<AssetHandoverDto> items,
    BuildContext context,
  ) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào cần trình duyệt',
        isError: true,
      );
      return;
    }

    showConfirmDialog(
      context,
      type: ConfirmType.delete,
      title: 'Trình duyệt',
      message: 'Bạn có chắc muốn trình duyệt với người ký?',
      cancelText: 'Không',
      confirmText: 'Trình duyệt',
      onConfirm: () {
        final notShared = getNotSharedAndNotify(items, context);
        if (notShared.isEmpty) return;
        context.read<AssetHandoverBloc>().add(
          SendToSignerAsetHandoverEvent(context, notShared),
        );
      },
    );
  }

  static List<AssetHandoverDto> getNotSharedAndNotify(
    List<AssetHandoverDto> items,
    BuildContext context,
  ) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào để chia sẻ',
        isError: true,
      );
      return const [];
    }

    final List<AssetHandoverDto> alreadyShared =
        items.where((e) => e.share == true).toList();
    final List<AssetHandoverDto> notShared =
        items.where((e) => e.share != true).toList();
    if (notShared.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Các phiếu này đều đã được chia sẻ',
        isError: true,
      );
      return const [];
    }
    if (alreadyShared.isNotEmpty) {
      final String names = alreadyShared
          .map(
            (e) =>
                e.quyetDinhDieuDongSo?.trim().isNotEmpty == true
                    ? e.quyetDinhDieuDongSo!
                    : (e.id ?? ''),
          )
          .where((s) => s.isNotEmpty)
          .join(', ');
      if (names.isNotEmpty) {
        AppUtility.showSnackBar(
          context,
          'Các phiếu đã được chia sẻ: $names',
          isError: true,
        );
      } else {
        AppUtility.showSnackBar(
          context,
          'Có phiếu đã được chia sẻ trong danh sách chọn',
          isError: true,
        );
      }
    }
    return notShared;
  }

  static int getPermissionSigning(AssetHandoverDto item, UserInfoDTO userInfo) {
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
