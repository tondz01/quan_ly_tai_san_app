import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/model/item_dropwdown_ccdc.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class DetailToolAndMaterialTransferTable extends StatefulWidget {
  final bool isEditing;
  final List<DetailToolAndMaterialTransferDto> initialDetails;
  final List<OwnershipUnitDetailDto> listOwnershipUnit;
  final List<ToolsAndSuppliesDto> allAssets;
  // Thay đổi callback type
  final Function(List<ItemDropdownDetailCcdc>)? onDataChanged;

  const DetailToolAndMaterialTransferTable(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.allAssets,
    required this.onDataChanged,
    required this.listOwnershipUnit,
  });

  @override
  State<DetailToolAndMaterialTransferTable> createState() =>
      _DetailToolAndMaterialTransferTableState();
}

class _DetailToolAndMaterialTransferTableState
    extends State<DetailToolAndMaterialTransferTable> {
  late List<DetailToolAndMaterialTransferDto> movementDetails;
  late List<ItemDropdownDetailCcdc> listAsset; // Thay đổi type
  late List<DetailAssetDto> listDetailAsset;
  late List<OwnershipUnitDetailDto> listDetailOwnershipUnit;
  late List<ItemDropdownDetailCcdc> listItemDropdownDetailAsset;
  final GlobalKey<SgEditableTableState<ItemDropdownDetailCcdc>> _tableKey =
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
    listDetailAsset =
        widget.allAssets
            .expand<DetailAssetDto>((asset) => asset.chiTietTaiSanList)
            .toList();
    listItemDropdownDetailAsset =
        widget.listOwnershipUnit.map<ItemDropdownDetailCcdc>((e) {
          final asset = getAssetByID(e.idCCDCVT);
          final detailAsset = getDetailAssetByID(e.idTsCon);

          return ItemDropdownDetailCcdc(
            id: e.id,
            idCCDCVatTu: e.idCCDCVT,
            tenCCDCVatTu: asset.ten,
            idDetaiAsset: detailAsset.id ?? '',
            tenDetailAsset:
                '${asset.ten}(${detailAsset.soKyHieu}) - ${detailAsset.namSanXuat}',
            idDonVi: e.idDonViSoHuu,
            donViTinh: asset.donViTinh,
            namSanXuat: detailAsset.namSanXuat ?? 2010,
            soLuong: e.soLuong,
            ghiChu: asset.ghiChu,
            soLuongDaBanGiao: 0,
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

    if (widget.initialDetails.isNotEmpty) {
      listAsset = getAssetsByChildAssets(
        widget.allAssets,
        widget.initialDetails,
      );
    } else {
      listAsset = [];
    }
  }

  @override
  void didUpdateWidget(DetailToolAndMaterialTransferTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDetails != widget.initialDetails &&
            widget.initialDetails.isNotEmpty ||
        oldWidget.listOwnershipUnit != widget.listOwnershipUnit) {
      movementDetails = List.from(widget.initialDetails);
      listAsset = getAssetsByChildAssets(widget.allAssets, movementDetails);
      _syncDetailAssets();
    }
    if (oldWidget.initialDetails.isNotEmpty && widget.initialDetails.isEmpty) {
      listAsset = [];
      _syncDetailAssets();
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
      final soLuongDaBanGiao = c.soLuongDaBanGiao;

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
                soLuong: c.soLuong,
                soLuongXuat: 0,
                ghiChu: asset.ghiChu,
                asset: asset,
              ),
        );
        final newDetailAsset = detailAsset.copyWith(
          soLuongXuat: c.soLuongXuat,
          soLuongDaBanGiao: soLuongDaBanGiao,
        );
        result.add(newDetailAsset);
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
            text: 'Chi tiết Ccdc - vật tư điều chuyển:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: SgEditableTable<ItemDropdownDetailCcdc>(
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
              SgEditableColumn<ItemDropdownDetailCcdc>(
                // Thay đổi generic type
                field: 'asset',
                title: 'CCDC Vật tư',
                titleAlignment: TextAlign.center,
                width: 150,
                getValue: (item) {
                  return item;
                },
                setValue: (item, value) {
                  // Copy properties
                  item.id = value.id;
                  item.idCCDCVatTu = value.idCCDCVatTu;
                  item.tenCCDCVatTu = value.tenCCDCVatTu;
                  item.idDetaiAsset = value.idDetaiAsset;
                  item.tenDetailAsset = value.tenDetailAsset;
                  item.idDonVi = value.idDonVi;
                  item.donViTinh = value.donViTinh;
                  item.namSanXuat = value.namSanXuat;
                  item.soLuong = value.soLuong;
                  item.ghiChu = value.ghiChu;
                  item.soLuongXuat = value.soLuongXuat;
                  item.soLuongDaBanGiao = value.soLuongDaBanGiao;
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
                  updateRow('asset', item.tenCCDCVatTu);
                  updateRow('don_vi_tinh', newValue.donViTinh);
                  updateRow('so_luong', newValue.soLuong);
                  updateRow('ghi_chu', newValue.ghiChu);
                  updateRow('so_luong_xuat', newValue.soLuongXuat.toString());
                  Future.microtask(() => _forceNotifyDataChanged());
                },
              ),
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'don_vi_tinh',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.donViTinh,
                setValue: (item, value) => item.donViTinh = value,
                sortValueGetter: (item) => item.donViTinh,
                isEditable: false,
              ),
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'so_luong',
                title: 'Số lượng có sẵn',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soLuong,
                setValue: (item, value) {
                  item.soLuong = value;
                },
                sortValueGetter: (item) => item.soLuong,
                isEditable: false,
              ),
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'so_luong_xuat',
                title: 'Số lượng xuất',
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
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'so_luong_da_ban_giao',
                title: 'Số lượng đã ban giao',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soLuongDaBanGiao,
                setValue: (item, value) => item.soLuongDaBanGiao = value,
                sortValueGetter: (item) => item.soLuongDaBanGiao,
                isEditable: false,
              ),
              SgEditableColumn<ItemDropdownDetailCcdc>(
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
      ngayNhap: DateTime.now(),
      donViTinh: '',
      soLuong: 0,
      giaTri: 0,
      nuocSanXuat: '',
      namSanXuat: 0,
      idCongTy: '',
      ngayTao: DateTime.now(),
      ngayCapNhat: DateTime.now(),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: false,
    );
  }
}
