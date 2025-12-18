import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../repository/chi_tiet_dieu_dong_tai_san_repository.dart';

class AssetTransferMovementTable extends StatefulWidget {
  final bool isEditing;
  final List<ChiTietDieuDongTaiSan> initialDetails;
  final List<AssetManagementDto> allAssets;
  final Function(List<AssetManagementDto>)? onDataChanged;

  const AssetTransferMovementTable(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.allAssets,
    required this.onDataChanged,
  });

  @override
  State<AssetTransferMovementTable> createState() =>
      _AssetTransferMovementTableState();
}

class _AssetTransferMovementTableState
    extends State<AssetTransferMovementTable> {
  late List<ChiTietDieuDongTaiSan> movementDetails;
  List<DropdownMenuItem<dynamic>> hienTrangItems = [];
  late List<AssetManagementDto> listAsset;
  final repo = ChiTietDieuDongTaiSanRepository();
  final GlobalKey<SgEditableTableState<AssetManagementDto>> _tableKey =
      GlobalKey();

  void _forceNotifyDataChanged() {
    widget.onDataChanged?.call(List.from(listAsset));
  }

  // Cache HienTrang lookup để tránh O(n) search mỗi lần render
  late final Map<int, CurrentStatus> _hienTrangCache;
  late final CurrentStatus _defaultHienTrang;

  @override
  void initState() {
    super.initState();
    _initHienTrangCache();
    _initHienTrangItems();
    if (widget.initialDetails.isNotEmpty) {
      listAsset = getAssetsByChildAssets(
        widget.allAssets,
        widget.initialDetails,
      );
    } else {
      listAsset = [];
    }
    movementDetails = List.from(widget.initialDetails);
  }

    /// Khởi tạo cache cho HienTrang lookup - O(1) thay vì O(n)
  void _initHienTrangCache() {
    final listHienTrang = AccountHelper.instance.getCurrentStatus();
    _hienTrangCache = {
      for (final ht in listHienTrang ?? []) ht.id: ht,
    };
    _defaultHienTrang = listHienTrang?.isNotEmpty ?? false
        ? listHienTrang?.first ?? CurrentStatus.empty() : CurrentStatus.empty();
  }

  /// Khởi tạo dropdown items cho HienTrang
  void _initHienTrangItems() {
    final listHienTrang = AccountHelper.instance.getCurrentStatus();
    hienTrangItems = listHienTrang
        ?.map(
          (hienTrang) => DropdownMenuItem<dynamic>(
            value: hienTrang,
            child: Text(hienTrang.tenHTKT ?? ''),
          ),
        )
        .toList() ??
        [];
  }

  /// Tìm CurrentStatus từ dropdown items để đảm bảo cùng reference
  CurrentStatus? _findHienTrangFromItems(int? id) {
    if (id == null) return null;
    for (final item in hienTrangItems) {
      if (item.value is CurrentStatus) {
        final status = item.value as CurrentStatus;
        if (status.id == id) {
          return status;
        }
      }
    }
    return null;
  }

  @override
  void didUpdateWidget(AssetTransferMovementTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDetails != widget.initialDetails &&
        widget.initialDetails.isNotEmpty) {
      movementDetails = List.from(widget.initialDetails);
      listAsset = getAssetsByChildAssets(widget.allAssets, movementDetails);
    }
    if (oldWidget.initialDetails.isNotEmpty && widget.initialDetails.isEmpty) {
      listAsset = [];
    }
  }

  List<AssetManagementDto> getAssetsByChildAssets(
    List<AssetManagementDto> allAssets,
    List<ChiTietDieuDongTaiSan> chiTietDieuDong,
  ) {
    // Map nhanh id -> Asset
    final Map<String, AssetManagementDto> idToAsset = {
      for (final a in allAssets)
        if (a.id != null) a.id!: a,
    };

    // Duyệt theo thứ tự child, cho phép trùng lặp để có thể thêm nhiều dòng
    final result = <AssetManagementDto>[];
    for (final c in chiTietDieuDong) {
      final id = c.idTaiSan;
      final asset = idToAsset[id];
      if (asset != null) {
        // Tạo bản sao để tránh tham chiếu chung
        result.add(asset);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const SGText(
            text: 'Chi tiết tài sản điều chuyển:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: SgEditableTable<AssetManagementDto>(
            key: _tableKey,
            initialData: listAsset,
            createEmptyItem: AssetManagementDto.empty,
            rowHeight: 40.0,
            headerBackgroundColor: Colors.grey.shade50,
            oddRowBackgroundColor: Colors.white,
            evenRowBackgroundColor: Colors.white,
            showVerticalLines: false,
            showHorizontalLines: true,
            addRowText: 'Thêm một dòng',
            isEditing: widget.isEditing, // Pass the editing state
            omittedSize: 130,
            onDataChanged: (data) {
              // Cập nhật local state
              setState(() {
                listAsset = List.from(data);
              });
              log("call onDataChanged ${jsonEncode(listAsset)}");
              // Thông báo thay đổi lên parent
              widget.onDataChanged?.call(data);
            },
            columns: [
              SgEditableColumn<AssetManagementDto>(
                field: 'asset',
                title: 'Tài sản',
                titleAlignment: TextAlign.center,
                width: 120,
                getValue: (item) => item,
                setValue: (item, value) {
                  if (value is AssetManagementDto) {
                    item.id = value.id;
                    item.tenTaiSan = value.tenTaiSan;
                    item.donViTinh = value.donViTinh;
                    item.soLuong = value.soLuong;
                    item.hienTrang = value.hienTrang;
                    item.ghiChu = value.ghiChu ?? '';
                    item.idDonViHienThoi = value.idDonViHienThoi;
                    item.moTa = value.nuocSanXuat;
                  }
                  log('setValue: ${item.tenTaiSan}');
                },
                sortValueGetter: (item) => item.tenTaiSan,
                isCellEditableDecider: (item, rowIndex) => true,
                editor: EditableCellEditor.searchableDropdown,
                searchableDropdownOptions: widget.allAssets,
                displayStringForOption: (option) => (option as AssetManagementDto).tenTaiSan ?? '',
                onValueChanged: (item, rowIndex, newValue, updateRow) {
                  if (newValue is AssetManagementDto) {
                    log('onValueChanged: ${newValue.tenTaiSan}, rowIndex: $rowIndex');

                    // Cập nhật đầy đủ thông tin của item trong listAsset
                    if (rowIndex < listAsset.length) {
                      final updatedItem = listAsset[rowIndex];
                      updatedItem.id = newValue.id;
                      updatedItem.tenTaiSan = '${newValue.id} - ${newValue.tenTaiSan}';
                      updatedItem.donViTinh = newValue.donViTinh;
                      updatedItem.soLuong = newValue.soLuong;
                      updatedItem.hienTrang = newValue.hienTrang;
                      updatedItem.ghiChu = newValue.ghiChu ?? '';
                      updatedItem.idDonViHienThoi = newValue.idDonViHienThoi;

                      log('Updated item in listAsset: ${updatedItem.id} - ${updatedItem.tenTaiSan}');
                    }

                    // Cập nhật các cột khác
                    updateRow('don_vi_tinh', newValue.donViTinh);
                    updateRow('so_luong', newValue.soLuong);
                    // Chuyển đổi int ID thành CurrentStatus object từ cache
                    final hienTrangObj = _hienTrangCache[newValue.hienTrang] ?? _defaultHienTrang;
                    updateRow('condition', hienTrangObj);
                    updateRow('ghi_chu', newValue.ghiChu ?? '');

                    // Force rebuild để hiển thị đúng item đã chọn
                    setState(() {});

                    // Force trigger onDataChanged để parent nhận được thay đổi
                    Future.microtask(() => _forceNotifyDataChanged());
                  }
                },
              ),
              SgEditableColumn<AssetManagementDto>(
                field: 'don_vi_tinh',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.donViTinh,
                setValue: (item, value) => item.donViTinh = value,
                sortValueGetter: (item) => item.donViTinh,
                isEditable: false,
              ),
              SgEditableColumn<AssetManagementDto>(
                field: 'so_luong',
                title: 'Số lượng',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soLuong,
                setValue: (item, value) {
                  item.soLuong = value;
                },
                sortValueGetter: (item) => item.soLuong,
                isEditable: false,
              ),
              SgEditableColumn<AssetManagementDto>(
                  field: 'condition',
                  title: 'Tình trạng kỹ thuật',
                  titleAlignment: TextAlign.center,
                  isEditable: true,
                  width: 50,
                  // Tìm từ items để đảm bảo cùng reference với dropdown items
                  getValue: (item) => 
                      _findHienTrangFromItems(item.hienTrang) ?? 
                      (hienTrangItems.isNotEmpty && hienTrangItems.first.value is CurrentStatus
                          ? hienTrangItems.first.value as CurrentStatus
                          : _defaultHienTrang),
                  setValue: (item, value) {
                    if (value is! CurrentStatus) return;
                    item.hienTrang = value.id ?? 0;
                  },
                  // Tìm từ items để đảm bảo cùng reference
                  getValueWithIndex: (item, rowIndex) =>
                      _findHienTrangFromItems(item.hienTrang) ?? 
                      (hienTrangItems.isNotEmpty && hienTrangItems.first.value is CurrentStatus
                          ? hienTrangItems.first.value as CurrentStatus
                          : _defaultHienTrang),
                  sortValueGetter: (item) =>
                      (_hienTrangCache[item.hienTrang] ?? _defaultHienTrang).tenHTKT,
                  editor: EditableCellEditor.dropdown,
                  dropdownItems: hienTrangItems,
                ),
              SgEditableColumn<AssetManagementDto>(
                field: 'ghi_chu',
                title: 'Ghi chú',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.ghiChu,
                setValue: (item, value) => item.ghiChu = value,
                sortValueGetter: (item) => item.ghiChu,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getHienTrang(int hienTrang) {
    switch (hienTrang) {
      case 0:
        return 'Đang sử dụng';
      case 1:
        return 'Chờ xử lý';
      case 2:
        return 'Không sử dụng';
      case 3:
        return 'Hỏng';
      default:
        return '';
    }
  }
}
