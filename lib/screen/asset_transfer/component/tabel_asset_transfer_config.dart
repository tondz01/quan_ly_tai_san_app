import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TabelAssetTransferConfig {
  static List<ColumnDefinition> getColumns(UserInfoDTO userInfo) {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Phiếu ký nội sinh',
          key: 'type',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenPhieu ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày có hiệu lực',
          key: 'effective_date',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tggnTuNgay ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trình duyệt ban giám đốc',
          key: 'approver',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenTrinhDuyetGiamDoc ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài liệu duyệt',
          key: 'document',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgDownloadFile(
              url: item.duongDanFile.toString(),
              name: item.tenFile ?? '',
            ),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ký số',
          key: 'id',
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
          name: 'Thời gian giao nhận từ ngày',
          key: 'decision_date',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tggnTuNgay ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Thời gian giao nhận đến ngày',
          key: 'to_date',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tggnDenNgay ?? ''));
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
          String tenDonViGiao =
              AccountHelper.instance
                  .getDepartmentById(item.idDonViGiao ?? '')
                  ?.tenPhongBan ??
              '';
          return TableCellData(widget: Text(tenDonViGiao));
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
          String tenDonViNhan =
              AccountHelper.instance
                  .getDepartmentById(item.idDonViNhan ?? '')
                  ?.tenPhongBan ??
              '';
          return TableCellData(widget: Text(tenDonViNhan));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái phiếu',
          key: 'status',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(
            widget: ConfigViewAT.showStatus(item.trangThai ?? 0),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái ký',
          key: 'permission_signing',
          width: 170,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: AppUtility.showPermissionSigning(
              getPermissionSigning(item),
            ),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái bàn giao',
          key: 'status_document',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: AppUtility.showStatusDocument(item.trangThaiPhieu ?? 0),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Chia sẻ',
          key: 'share',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: ConfigViewAT.showShareStatus(
              item.share ?? false,
              item.nguoiTao == userInfo.tenDangNhap,
            ),
          );
        },
      ),
    ];
  }

  static int getPermissionSigning(DieuDongTaiSanDto item) {
    final userInfo = AccountHelper.instance.getUserInfo();
    final signatureFlow =
        [
              if (item.nguoiLapPhieuKyNhay == true)
                {
                  "id": item.idNguoiKyNhay,
                  "signed": item.trangThaiKyNhay == true,
                  "label":
                      "Người lập phiếu: ${AccountHelper.instance.getNhanVienById(item.idNguoiKyNhay ?? '')?.hoTen}",
                },
              {
                "id": item.idTrinhDuyetCapPhong,
                "signed": item.trinhDuyetCapPhongXacNhan == true,
                "label": "Người duyệt: ${item.tenTrinhDuyetCapPhong}",
              },
              for (int i = 0; i < (item.listSignatory?.length ?? 0); i++)
                {
                  "id": item.listSignatory![i].idNguoiKy,
                  "signed": item.listSignatory![i].trangThai == 1,
                  "label":
                      "Người ký ${i + 1}: ${item.listSignatory![i].tenNguoiKy}",
                },
              {
                "id": item.idTrinhDuyetGiamDoc,
                "signed": item.trinhDuyetGiamDocXacNhan == true,
                "label": "Người phê duyệt: ${item.tenTrinhDuyetGiamDoc}",
              },
            ]
            .where(
              (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
            )
            .toList();
    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo?.tenDangNhap,
    );
    if (currentIndex == -1) return 2;
    if (item.nguoiTao == userInfo?.tenDangNhap &&
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

  static void handleSendToSigner(
    BuildContext context,
    List<DieuDongTaiSanDto> items,
  ) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào để chia sẻ',
        isError: true,
      );
      return;
    }
    showConfirmDialog(
      context,
      type: ConfirmType.delete,
      title: 'Chia sẻ',
      message: 'Bạn có chắc muốn chia sẻ với người ký?',
      cancelText: 'Không',
      confirmText: 'Chia sẻ',
      onConfirm: () {
        final notShared = getNotSharedAndNotify(context, items);
        if (notShared.isEmpty) return;
        context.read<DieuDongTaiSanBloc>().add(
          SendToSignerEvent(context, notShared),
        );
      },
    );
  }

  static List<DieuDongTaiSanDto> getNotSharedAndNotify(
    BuildContext context,
    List<DieuDongTaiSanDto> items,
  ) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào để chia sẻ',
        isError: true,
      );
      return const [];
    }

    final List<DieuDongTaiSanDto> alreadyShared =
        items.where((e) => e.share == true).toList();
    final List<DieuDongTaiSanDto> notShared =
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
                e.tenPhieu?.trim().isNotEmpty == true
                    ? e.tenPhieu!
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

  static String getName(int type) {
    switch (type) {
      case 1:
        return 'Phiếu duyệt cấp phát tài sản';
      case 2:
        return 'Phiếu duyệt chuyển tài sản';
      case 3:
        return 'Phiếu duyệt thu hồi tài sản';
    }
    return '';
  }

  static String getStatusSigningName(DieuDongTaiSanDto item) {
    int status = TabelAssetTransferConfig.getPermissionSigning(item);
    String statusName =
        status == 2
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
    return statusName;
  }

  static String getStatusDocumentName(DieuDongTaiSanDto item) {
    String statusName =
        item.trangThaiPhieu == 0
            ? 'Chưa hoàn thành'
            : item.trangThaiPhieu == 1
            ? 'Sắp hết hạn'
            : item.trangThaiPhieu == 2
            ? 'Đã hoàn thành'
            : 'Không xác định';
    return statusName;
  }

  static String getStatus(int status) {
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Duyệt';
      case 2:
        return 'Hủy';
      case 3:
        return 'Hoàn thành';
      default:
        return '';
    }
  }
}
