import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableToolAndSuppliesHandoverConfig {
  static List<ColumnDefinition> getColumns(UserInfoDTO userInfo) {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số quyết định',
          key: 'quyet_dinh',
          width: 150,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.id ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Lệnh điều động',
          key: 'lenh_dieu_dong',
          width: 150,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.lenhDieuDong ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày bàn giao',
          key: 'ngay_ban_giao',
          width: 150,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.ngayBanGiao ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày tạo chứng từ',
          key: 'ngay_tao_chung_tu',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(widget: Text(item.ngayTaoChungTu ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị giao',
          key: 'don_vi_giao',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(
              widget: Text(
                AccountHelper.instance
                        .getDepartmentById(item.idDonViGiao ?? '')
                        ?.tenPhongBan ??
                    item.tenDonViGiao ??
                    '',
              ),
            ),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị nhận',
          key: 'don_vi_nhan',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(
              widget: Text(
                AccountHelper.instance
                        .getDepartmentById(item.idDonViNhan ?? '')
                        ?.tenPhongBan ??
                    item.tenDonViNhan ??
                    '',
              ),
            ),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người lập phiếu',
          key: 'nguoi_lap_phieu',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(
              widget: Text(
                AccountHelper.instance
                        .getNhanVienById(item.nguoiTao ?? '')
                        ?.hoTen ??
                    '',
              ),
            ),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài liệu',
          key: 'document',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(
              widget:
                  (item.tenFile?.isNotEmpty ?? false)
                      ? SgDownloadFile(
                        name: item.tenFile!,
                        url: item.duongDanFile ?? '',
                      )
                      : const Text('Không có tài liệu'),
            ),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái ký',
          key: 'trang_thai_ky',
          width: 170,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(
              widget: AppUtility.showPermissionSigning(
                getPermissionSigning(item),
              ),
            ),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái phiếu',
          key: 'trang_thai_phieu',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(
              widget: showStatusHandover(item.trangThaiPhieu ?? 0),
            ),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái',
          key: 'trang_thai',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(widget: showStatus(item.trangThai ?? 0)),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Chia sẻ',
          key: 'share',
          width: 150,
          flex: 1,
        ),
        builder:
            (item) => TableCellData(
              widget: ConfigViewAT.showShareStatus(
                item.share == true,
                item.nguoiTao == userInfo.tenDangNhap,
              ),
            ),
      ),
    ];
  }

  static Widget showStatus(int status) {
    Color c;
    switch (status) {
      case 0:
        c = ColorValue.silverGray;
        break;
      case 1:
        c = ColorValue.amber;
        break;
      case 2:
        c = ColorValue.lightBlue;
        break;
      case 3:
        c = ColorValue.coral;
        break;
      case 4:
        c = ColorValue.forestGreen;
        break;
      default:
        c = ColorValue.darkGrey;
    }
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: c,
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
        return 'Hoàn thành';
      case 4:
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  static Widget showStatusHandover(int status) {
    Color c;
    switch (status) {
      case 0:
        c = Colors.orange;
        break;
      case 1:
        c = Colors.red;
        break;
      case 2:
        c = Colors.green;
        break;
      default:
        c = Colors.grey;
    }
    return Container(
      constraints: BoxConstraints(maxHeight: 48.0),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: c,
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

  static String getPermissionSigningText(int status) {
    return status == 2
        ? 'Không được phép ký'
        : status == 1
        ? 'Chưa đến lượt ký'
        : status == 3
        ? 'Đã ký'
        : status == 4
        ? 'Đã ký & tạo'
        : status == 5
        ? 'Cần ký & tạo'
        : 'Cần ký';
  }

  static int getPermissionSigning(ToolAndSuppliesHandoverDto item) {
    final signatureFlow =
        [
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
              {"id": item.idGiamDoc, "signed": item.giamDocKy == true},
            ]
            .where(
              (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
            )
            .toList();
    final userInfo = AccountHelper.instance.getUserInfo();
    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo?.tenDangNhap,
    );
    if (currentIndex == -1) return 2;

    // Lấy trạng thái ký của user hiện tại (đảm bảo type safety)
    final currentSigned = signatureFlow[currentIndex]["signed"] as bool;

    // Nếu user là người tạo và có trong signatureFlow
    if (item.nguoiTao == userInfo?.tenDangNhap) {
      return currentSigned == true ? 4 : 5;
    }

    // Nếu đã ký rồi
    if (currentSigned == true) return 3;

    // Kiểm tra xem có người ký trước chưa ký không
    final previousNotSigned = signatureFlow
        .take(currentIndex)
        .firstWhere((s) => (s["signed"] as bool) == false, orElse: () => {});

    if (previousNotSigned.isNotEmpty) return 1;
    return 0;
  }

  static List<ToolAndSuppliesHandoverDto> getNotSharedAndNotify(
    List<ToolAndSuppliesHandoverDto> items,
    BuildContext context,
  ) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào để trình duyệt',
        isError: true,
      );
      return const [];
    }

    final List<ToolAndSuppliesHandoverDto> alreadyShared =
        items.where((e) => e.share == true).toList();
    final List<ToolAndSuppliesHandoverDto> notShared =
        items.where((e) => e.share != true).toList();
    if (notShared.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Các phiếu này đều đã được trình duyệt',
        isError: true,
      );
      return const [];
    }
    if (alreadyShared.isNotEmpty) {
      final String names = alreadyShared
          .map(
            (e) =>
                e.banGiaoCCDCVatTu?.trim().isNotEmpty == true
                    ? e.banGiaoCCDCVatTu!
                    : (e.id ?? ''),
          )
          .where((s) => s.isNotEmpty)
          .join(', ');
      if (names.isNotEmpty) {
        AppUtility.showSnackBar(
          context,
          'Các phiếu đã được trình duyệt: $names',
          isError: true,
        );
      } else {
        AppUtility.showSnackBar(
          context,
          'Có phiếu đã được trình duyệt trong danh sách chọn',
          isError: true,
        );
      }
    }
    return notShared;
  }

  static void handleSendToSigner(
    List<ToolAndSuppliesHandoverDto> items,
    BuildContext context,
  ) {
    // Xác nhận và chỉ gửi những phiếu chưa share
    showConfirmDialog(
      context,
      type: ConfirmType.delete,
      title: 'Trình duyệt',
      message: 'Bạn có chắc muốn trình duyệt cho người ký?',
      cancelText: 'Không',
      confirmText: 'Trình duyệt',
      onConfirm: () {
        final notShared = getNotSharedAndNotify(items, context);
        if (notShared.isEmpty) return;
        context.read<ToolAndSuppliesHandoverBloc>().add(
          SendToSignerAsetHandoverEvent(context, notShared),
        );
      },
    );
  }

  static bool isCheckShowShare(List<ToolAndSuppliesHandoverDto> items) {
    if (items.isEmpty) {
      return false;
    }
    final hasSharedItems = items.any((e) => e.share == true);

    if (hasSharedItems) {
      return false;
    }

    return items.any((e) => e.share != true);
  }

  /// Kiểm tra xem người dùng hiện tại có thể ký các mục đã chọn hay không
  /// Chỉ có thể kiểm tra ký cho một mục duy nhất
  /// Trả về true nếu có thể ký, false nếu không thể ký
  static bool canSign(List<ToolAndSuppliesHandoverDto> items) {
    final userInfo = AccountHelper.instance.getUserInfo();
    if (userInfo == null || items.length != 1) {
      return false;
    }

    final item = items.first;
    final signatureFlow = _buildSignatureFlow(item);

    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo.tenDangNhap,
    );

    if (currentIndex == -1 || signatureFlow[currentIndex]["signed"] == true) {
      return false;
    }

    return signatureFlow.take(currentIndex).every((s) => s["signed"] == true);
  }

  static List<Map<String, dynamic>> _buildSignatureFlow(
    ToolAndSuppliesHandoverDto item,
  ) {
    return [
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
                      (e) => {"id": e.idNguoiKy, "signed": e.trangThai == 1},
                    )
                    .toList() ??
                []),
          {"id": item.idGiamDoc, "signed": item.giamDocKy == true},
        ]
        .where(
          (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
        )
        .map((step) => Map<String, dynamic>.from(step))
        .toList();
  }

  /// Kiểm tra xem có hiển thị nút xóa hay không
  /// Trả về true nếu:
  /// - Người dùng là admin, hoặc
  /// - Trạng thái = 0 và người dùng là người tạo
  static bool isCheckShowDelete(ToolAndSuppliesHandoverDto item) {
    final userInfo = AccountHelper.instance.getUserInfo();
    if (userInfo == null) return false;

    return userInfo.tenDangNhap == 'admin' ||
        (item.trangThai == 0 && item.nguoiTao == userInfo.tenDangNhap);
  }
}
