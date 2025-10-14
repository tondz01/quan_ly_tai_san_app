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
        builder:
            (item) =>
                TableCellData(widget: Text(item.quyetDinhDieuDongSo ?? '')),
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
        builder: (item) => TableCellData(widget: Text(item.nguoiTao ?? '')),
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
                getPermissionSigning(item, userInfo),
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
        return 'Đã hủy';
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
    switch (status) {
      case 0:
        return 'Chưa ký';
      case 1:
        return 'Chưa đến lượt ký';
      case 2:
        return 'Đã ký';
      case 3:
        return 'Đã ký & tạo';
      case 4:
        return 'Cần ký & tạo';
      default:
        return 'Cần ký';
    }
  }

  static int getPermissionSigning(
    ToolAndSuppliesHandoverDto item,
    UserInfoDTO userInfo,
  ) {
    final flow =
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
                      (e) => {"id": e.idNguoiKy, "signed": e.trangThai == 1},
                    )
                    .toList() ??
                []),
        ].where((s) => (s["id"] as String?)?.isNotEmpty == true).toList();
    final current = flow.indexWhere((s) => s["id"] == userInfo.tenDangNhap);
    if (current == -1) return 2;
    if (item.idDaiDiendonviBanHanhQD == userInfo.tenDangNhap &&
        flow[current]["signed"] != -1) {
      return flow[current]["signed"] == true ? 4 : 5;
    }
    if (flow[current]["signed"] == true) return 3;
    final prevNotSigned = flow
        .take(current)
        .firstWhere((s) => s["signed"] == false, orElse: () => {});
    if (prevNotSigned.isNotEmpty) return 1;
    return 0;
  }

  static List<ToolAndSuppliesHandoverDto> getNotSharedAndNotify(
    List<ToolAndSuppliesHandoverDto> items,
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

    final List<ToolAndSuppliesHandoverDto> alreadyShared =
        items.where((e) => e.share == true).toList();
    final List<ToolAndSuppliesHandoverDto> notShared =
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
                e.banGiaoCCDCVatTu?.trim().isNotEmpty == true
                    ? e.banGiaoCCDCVatTu!
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

  static void handleSendToSigner(
    List<ToolAndSuppliesHandoverDto> items,
    BuildContext context,
  ) {
    // Xác nhận và chỉ gửi những phiếu chưa share
    showConfirmDialog(
      context,
      type: ConfirmType.delete,
      title: 'Chia sẻ',
      message: 'Bạn có chắc muốn chia sẻ với người ký?',
      cancelText: 'Không',
      confirmText: 'Chia sẻ',
      onConfirm: () {
        final notShared = getNotSharedAndNotify(items, context);
        if (notShared.isEmpty) return;
        context.read<ToolAndSuppliesHandoverBloc>().add(
          SendToSignerAsetHandoverEvent(context, notShared),
        );
      },
    );
  }
}
