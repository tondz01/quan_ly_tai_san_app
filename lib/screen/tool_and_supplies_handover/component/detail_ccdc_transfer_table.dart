import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/model/item_dropwdown_ccdc.dart';
import 'package:quan_ly_tai_san_app/common/table/detail_editable_table.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class DetailCcdcTransferTable extends StatefulWidget {
  final bool isEditing;
  final List<DetailToolAndMaterialTransferDto> initialDetails;
  final List<DetailSubppliesHandoverDto> initialDetailsSuppliesHandover;
  final List<OwnershipUnitDetailDto> listOwnershipUnit;
  final List<ToolsAndSuppliesDto> allAssets;
  // Thay đổi callback type
  final Function(List<ItemDropdownDetailCcdc>)? onDataChanged;

  const DetailCcdcTransferTable(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.allAssets,
    required this.onDataChanged,
    required this.listOwnershipUnit,
    this.initialDetailsSuppliesHandover = const [],
  });

  @override
  State<DetailCcdcTransferTable> createState() =>
      _DetailCcdcTransferTableState();
}

class _DetailCcdcTransferTableState extends State<DetailCcdcTransferTable> {
  late List<DetailToolAndMaterialTransferDto> movementDetails;
  late List<ItemDropdownDetailCcdc> listAsset; // Thay đổi type
  late List<DetailAssetDto> listDetailAsset;
  late List<OwnershipUnitDetailDto> listDetailOwnershipUnit;
  late List<ItemDropdownDetailCcdc> listItemDropdownDetailAsset;
  final GlobalKey<DetailEditableTableState<ItemDropdownDetailCcdc>> _tableKey =
      GlobalKey(); // Thay đổi generic type

  void _forceNotifyDataChanged() {
    widget.onDataChanged?.call(List.from(listAsset));
  }

  ToolsAndSuppliesDto getAssetByID(String idAsset) {
    if (widget.allAssets.isNotEmpty) {
      return widget.allAssets.firstWhere(
        (item) => item.id == idAsset,
        orElse: () => toolAndSuppliesNull(),
      );
    } else {
      return toolAndSuppliesNull();
    }
  }

  DetailAssetDto getDetailAssetByID(String idAsset) {
    if (listDetailAsset.isNotEmpty) {
      return listDetailAsset.firstWhere((item) {
        return item.id == idAsset;
      }, orElse: () => DetailAssetDto.empty());
    } else {
      return DetailAssetDto.empty();
    }
  }

  void _syncDetailAssets() {
    if (widget.initialDetailsSuppliesHandover.isNotEmpty) {
      listAsset = getAssetsByHandoverDetails(
        widget.initialDetailsSuppliesHandover,
        movementDetails,
      );
    } else if (widget.initialDetails.isNotEmpty) {
      listAsset = getAssetsByChildAssets(
        widget.allAssets,
        widget.initialDetails,
      );
    } else {
      listAsset = [];
    }
    listDetailAsset =
        widget.allAssets
            .expand<DetailAssetDto>((asset) => asset.chiTietTaiSanList)
            .toList();
    listItemDropdownDetailAsset =
        movementDetails.map<ItemDropdownDetailCcdc>((e) {
          final asset = getAssetByID(e.idCCDCVatTu);
          final detailAsset = getDetailAssetByID(e.idChiTietCCDCVatTu);
          return ItemDropdownDetailCcdc(
            id: e.id,
            idCCDCVatTu: e.idCCDCVatTu,
            tenCCDCVatTu: asset.ten,
            idDetaiAsset: detailAsset.id ?? '',
            tenDetailAsset:
                '${asset.ten}(${detailAsset.soKyHieu}) - ${detailAsset.namSanXuat}',
            idDonVi: asset.idDonVi,
            donViTinh: asset.donViTinh,
            namSanXuat: detailAsset.namSanXuat ?? 2010,
            soLuong: e.soLuongXuat,
            soLuongXuat: 0,
            ghiChu: asset.ghiChu,
            asset: asset,
          );
        }).toList();
  }

  @override
  void initState() {
    super.initState();

    // Khởi tạo các biến late trước
    listDetailAsset = [];
    listDetailOwnershipUnit = [];
    listItemDropdownDetailAsset = [];
    movementDetails = List.from(widget.initialDetails);

    // Đồng bộ dữ liệu chi tiết tài sản
    _syncDetailAssets();
  }

  @override
  void didUpdateWidget(DetailCcdcTransferTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi danh sách ownership hoặc assets thay đổi, đồng bộ lại dữ liệu dropdown
    final ownershipChanged =
        oldWidget.listOwnershipUnit != widget.listOwnershipUnit;
    final assetsChanged = oldWidget.allAssets != widget.allAssets;
    if (ownershipChanged || assetsChanged) {
      _syncDetailAssets();
    }

    // Ưu tiên dữ liệu từ initialDetailsSuppliesHandover nếu có
    if (oldWidget.initialDetailsSuppliesHandover !=
        widget.initialDetailsSuppliesHandover) {
      if (widget.initialDetailsSuppliesHandover.isNotEmpty) {
        _syncDetailAssets();
        listAsset = getAssetsByHandoverDetails(
          widget.initialDetailsSuppliesHandover,
          movementDetails,
        );
        setState(() {});
        return;
      }
    }

    if (oldWidget.initialDetails != widget.initialDetails &&
        widget.initialDetails.isNotEmpty) {
      movementDetails = List.from(widget.initialDetails);
      _syncDetailAssets();
      listAsset = getAssetsByChildAssets(widget.allAssets, movementDetails);
      setState(() {});
      return;
    }
    if (oldWidget.initialDetails.isNotEmpty && widget.initialDetails.isEmpty) {
      _syncDetailAssets();
      listAsset = [];
      setState(() {});
    }
  }

  // Cập nhật getAssetsByChildAssets để trả về List<ItemDropdownDetailAsset>
  List<ItemDropdownDetailCcdc> getAssetsByChildAssets(
    List<ToolsAndSuppliesDto> allAssets,
    List<DetailToolAndMaterialTransferDto> chiTietDieuDong,
  ) {
    final Map<String, ToolsAndSuppliesDto> idToAsset = {
      for (final a in allAssets) a.id: a,
    };
    final result = <ItemDropdownDetailCcdc>[];

    for (final c in chiTietDieuDong) {
      final id = c.idChiTietCCDCVatTu;
      log('Check số lượng: ${c.soLuongXuat - c.soLuongDaBanGiao}');

      final idAsset = getDetailAssetByID(id);
      if (idAsset.idTaiSan == null) {
        continue;
      }
      final asset = idToAsset[idAsset.idTaiSan];
      if (asset != null) {
        // Tìm ItemDropdownDetailAsset tương ứng
        final detailAsset = listItemDropdownDetailAsset.firstWhere(
          (element) => element.idDetaiAsset == id,
          orElse:
              () => ItemDropdownDetailCcdc(
                id: '',
                idCCDCVatTu: id,
                tenCCDCVatTu: asset.ten,
                idDetaiAsset: '',
                tenDetailAsset: '$id - ${asset.ten}',
                idDonVi: asset.idDonVi,
                donViTinh: asset.donViTinh,
                namSanXuat: 2010,
                soLuong: c.soLuongXuat - c.soLuongDaBanGiao,
                soLuongXuat: 0,
                ghiChu: asset.ghiChu,
                asset: asset,
              ),
        );
        final newDetailAsset = detailAsset.copyWith(soLuongXuat: 0);
        result.add(newDetailAsset);
      }
    }
    return result;
  }

  // Map dữ liệu từ danh sách bàn giao (DetailSubppliesHandoverDto) sang dữ liệu bảng
  List<ItemDropdownDetailCcdc> getAssetsByHandoverDetails(
    List<DetailSubppliesHandoverDto> details,
    List<DetailToolAndMaterialTransferDto> chiTietDieuDong,
  ) {
    log('Check số lượng [getAssetsByHandoverDetails]: ${chiTietDieuDong}');
    final result = <ItemDropdownDetailCcdc>[];
    for (final d in details) {
      final detail = chiTietDieuDong.firstWhere(
        (element) {
          log('Check số lượng [getAssetsByHandoverDetails]: ${element.id} - ${d.idChiTietDieuDong}');
        return element.id == d.idChiTietDieuDong;
        },
        orElse: () => DetailToolAndMaterialTransferDto.empty(),
      );
      log('Check số lượng [getAssetsByHandoverDetails]: ${jsonEncode(detail)}');

      log(
        'Check số lượng [getAssetsByHandoverDetails]: ${detail.soLuongXuat} - ${detail.soLuongDaBanGiao} = ${detail.soLuongXuat - detail.soLuongDaBanGiao}',
      );
      // Tìm item dropdown theo id chi tiết CCDC VT đã lưu trong bàn giao
      final dropdownItem = listItemDropdownDetailAsset.firstWhere(
        (element) => element.id == d.iddieudongccdcvattu,
        orElse: () {
          // Nếu không tìm thấy trong dropdown, cố gắng dựng từ dữ liệu gốc
          final asset = getAssetByID(detail.idCCDCVatTu);
          return ItemDropdownDetailCcdc(
            id: d.id,
            idCCDCVatTu: d.idCCDCVatTu,
            tenCCDCVatTu: asset.ten,
            idDetaiAsset: d.idChiTietCCDCVatTu,
            tenDetailAsset:
                asset.ten.isNotEmpty
                    ? '${asset.ten}(${detail.soKyHieu}) - ${detail.namSanXuat}'
                    : d.idChiTietCCDCVatTu,
            idDonVi: asset.idDonVi,
            donViTinh: asset.donViTinh,
            namSanXuat: detail.namSanXuat ?? 2010,
            soLuong: detail.soLuongXuat - detail.soLuongDaBanGiao,
            ghiChu: asset.ghiChu,
            asset: asset,
          );
        },
      );

      // Cập nhật số lượng theo dữ liệu bàn giao
      final mapped = dropdownItem.copyWith(
        donViTinh: detail.donViTinh,
        soLuongXuat: d.soLuong,
        // soLuongDaBanGiao: d.soLuong,
      );
      result.add(mapped);
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
            text: 'Chi tiết Ccdc - vật tư điều chuyển:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: DetailEditableTable<ItemDropdownDetailCcdc>(
            // Thay đổi generic type
            key: _tableKey,
            initialData: listAsset,
            createEmptyItem: () => ItemDropdownDetailCcdc.empty(),
            rowHeight: 40.0,
            headerBackgroundColor: Colors.grey.shade50,
            oddRowBackgroundColor: Colors.white,
            evenRowBackgroundColor: Colors.white,
            showVerticalLines: false,
            showHorizontalLines: true,
            addRowText: 'Thêm một dòng',
            isEditing: widget.isEditing,
            omittedSize: 130,
            onDataChanged: (data) {
              setState(() {
                listAsset = List.from(data);
              });
              widget.onDataChanged?.call(data);
            },
            columns: [
              DetailEditableColumn<ItemDropdownDetailCcdc>(
                field: 'asset',
                title: 'CCDC Vật tư',
                titleAlignment: TextAlign.center,
                width: 150,
                isEditable: widget.isEditing,
                getValue: (item) {
                  // Fallback: return the matching dropdown item if possible
                  final match = listItemDropdownDetailAsset.firstWhere(
                    (e) => e.idDetaiAsset == item.idDetaiAsset,
                    orElse: () => item,
                  );
                  return match;
                },
                getValueWithIndex: (item, rowIndex) {
                  // When viewing, display the readable text. When editing, return the dropdown value
                  if (widget.isEditing) {
                    final match = listItemDropdownDetailAsset.firstWhere(
                      (e) => e.idDetaiAsset == item.idDetaiAsset,
                      orElse: () => item,
                    );
                    return match;
                  }
                  return item.tenDetailAsset;
                },
                setValue: (item, value) {
                  item.id = value.id;
                  item.idCCDCVatTu = value.idCCDCVatTu;
                  item.tenCCDCVatTu = value.tenCCDCVatTu;
                  item.idDetaiAsset = value.idDetaiAsset;
                  item.tenDetailAsset = value.tenDetailAsset;
                  item.idDonVi = value.idDonVi;
                  item.donViTinh = value.donViTinh;
                  item.namSanXuat = value.namSanXuat;
                  item.soLuong = value.soLuongXuat - value.soLuongDaBanGiao;
                  item.ghiChu = value.ghiChu;
                  item.soLuongXuat = value.soLuongXuat;
                  item.asset = value.asset;
                },
                sortValueGetter: (item) => item.tenCCDCVatTu,
                isCellEditableDecider: (item, rowIndex) => true,
                editor: EditableCellEditor.dropdown,
                dropdownItems: [
                  for (final element in listItemDropdownDetailAsset)
                    DropdownMenuItem<ItemDropdownDetailCcdc>(
                      value: element,
                      child: Text(element.tenDetailAsset),
                    ),
                ],
                onValueChanged: (item, rowIndex, newValue, updateRow) {
                  updateRow('don_vi_tinh', newValue.donViTinh);
                  updateRow('so_luong', newValue.soLuong);
                  updateRow('ghi_chu', newValue.ghiChu);
                  updateRow('so_luong_xuat', newValue.soLuongXuat.toString());

                  Future.microtask(() => _forceNotifyDataChanged());
                },
              ),
              DetailEditableColumn<ItemDropdownDetailCcdc>(
                field: 'don_vi_tinh',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.donViTinh,
                setValue: (item, value) => item.donViTinh = value,
                sortValueGetter: (item) => item.donViTinh,
                isEditable: false,
              ),
              DetailEditableColumn<ItemDropdownDetailCcdc>(
                field: 'so_luong',
                title: 'Số lượng cần bàn giao',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soLuong,
                setValue: (item, value) {
                  item.soLuong = value;
                },
                sortValueGetter: (item) => item.soLuong,
                isEditable: false,
              ),
              DetailEditableColumn<ItemDropdownDetailCcdc>(
                field: 'so_luong_xuat',
                title: 'Số lượng bàn giao',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue:
                    (item) =>
                        item.soLuongXuat, // Cần thêm field này vào ItemDropdownDetailAsset
                inputType: TextInputType.number,
                onValueChanged: (item, rowIndex, value, updateRow) {
                  if (value == null || value == '') {
                    item.soLuongXuat = 0;
                    return;
                  }
                  if (int.parse(value) > item.soLuong) {
                    AppUtility.showSnackBar(
                      context,
                      "Số lượng xuất không được lớn hơn số lượng có sẵn",
                      isError: true,
                    );
                    item.soLuongXuat = item.soLuong;
                    updateRow('so_luong_xuat', item.soLuongXuat);
                  } else {
                    item.soLuongXuat = int.parse(value);
                  }
                },
                setValue: (item, value) {
                  if (value == null || value == '') {
                    item.soLuongXuat = 0;
                    return;
                  }
                  if (int.parse(value) > item.soLuong) {
                    return;
                  }
                  item.soLuongXuat = int.parse(value);
                },
                sortValueGetter: (item) => item.soLuongXuat,
                isEditable: widget.isEditing,
              ),
              DetailEditableColumn<ItemDropdownDetailCcdc>(
                field: 'ghi_chu',
                title: 'Ghi chú',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.ghiChu,
                setValue: (item, value) => item.ghiChu = value,
                sortValueGetter: (item) => item.ghiChu,
                isEditable: false,
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
        return 'Chờ sử lý';
      case 2:
        return 'Không sử dụng';
      case 3:
        return 'Hỏng';
      default:
        return '';
    }
  }

  ToolsAndSuppliesDto toolAndSuppliesNull() {
    return ToolsAndSuppliesDto(
      id: '',
      ten: '',
      idDonVi: '',
      tenDonVi: '',
      idNhomCCDC: '',
      tenNhomCCDC: '',
      idLoaiCCDCCon: '',
      ngayNhap: AppUtility.formatFromISOString(DateTime.now().toString()),
      donViTinh: '',
      soLuong: 0,
      giaTri: 0,
      nuocSanXuat: '',
      namSanXuat: 0,
      idCongTy: '',
      ngayTao: AppUtility.formatFromISOString(DateTime.now().toString()),
      ngayCapNhat: AppUtility.formatFromISOString(DateTime.now().toString()),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: false,
    );
  }
}
