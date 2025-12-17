import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/model/item_dropwdown_ccdc.dart';
import 'package:quan_ly_tai_san_app/common/table/detail_editable_table.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class DetailCcdcTransferTable extends StatefulWidget {
  final bool isEditing;
  final List<DetailToolAndMaterialTransferDto> movementDetails;
  final List<DetailSubppliesHandoverDto> initialDetailsSuppliesHandover;
  final List<OwnershipUnitDetailDto> listOwnershipUnit;
  final List<ToolsAndSuppliesDto> allAssets;
  // Thay đổi callback type
  final Function(List<ItemDropdownDetailCcdc>)? onDataChanged;

  const DetailCcdcTransferTable(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.movementDetails,
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
  int _tableKeyValue = 0; // Key để force rebuild table khi movementDetails thay đổi

  bool _isInitialized = false;

  void _forceNotifyDataChanged() {
    if (_isInitialized && widget.onDataChanged != null) {
      widget.onDataChanged?.call(List.from(listAsset));
    }
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
    // Build dropdown source list from movement details + master CCDC list
    listItemDropdownDetailAsset = getAssetsByChildAssets(
      widget.allAssets,
      movementDetails,
    );

    if (widget.initialDetailsSuppliesHandover.isNotEmpty) {
      // Nếu đã có dữ liệu bàn giao trước đó thì map theo listDetailSubppliesHandover
      listAsset = getAssetsByHandoverDetails(
        widget.initialDetailsSuppliesHandover,
        movementDetails,
      );
    } else if (widget.movementDetails.isNotEmpty) {
      // Ngược lại dùng toàn bộ danh sách chi tiết điều động làm source
      listAsset = List.from(listItemDropdownDetailAsset);
    } else {
      listAsset = [];
    }
  }

  @override
  void initState() {
    super.initState();

    // Khởi tạo các biến late trước
    listDetailAsset = [];
    listAsset = [];
    listDetailOwnershipUnit = [];
    listItemDropdownDetailAsset = [];
    movementDetails = List.from(widget.movementDetails);
    // Đồng bộ dữ liệu chi tiết tài sản
    _syncDetailAssets();

    // Gọi onDataChanged tự động khi component được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isInitialized = true;
      _forceNotifyDataChanged();
    });
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
      if (_isInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _forceNotifyDataChanged();
        });
      }
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
        if (_isInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _forceNotifyDataChanged();
          });
        }
        return;
      }
    }

    // Xử lý khi movementDetails thay đổi
    if (oldWidget.movementDetails != widget.movementDetails) {
      movementDetails = List.from(widget.movementDetails);
      _syncDetailAssets();
      if (widget.movementDetails.isEmpty) {
        listAsset = [];
      } else {
        listAsset = List.from(getAssetsByChildAssets(widget.allAssets, movementDetails));
      }
      // Tăng key value để force rebuild table
      _tableKeyValue++;
      setState(() {});
      if (_isInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _forceNotifyDataChanged();
        });
      }
    }
  }

  // Cập nhật getAssetsByChildAssets để trả về List<ItemDropdownDetailAsset>
  List<ItemDropdownDetailCcdc> getAssetsByChildAssets(
    List<ToolsAndSuppliesDto> allAssets,
    List<DetailToolAndMaterialTransferDto> chiTietDieuDong,
  ) {
    // Map nhanh asset theo id để lấy thêm thông tin (đơn vị tính, ghi chú...)
    final Map<String, ToolsAndSuppliesDto> idToAsset = {
      for (final a in allAssets) a.id: a,
    };
    final result = <ItemDropdownDetailCcdc>[];

    for (final c in chiTietDieuDong) {
      final asset = idToAsset[c.idCCDCVatTu] ?? toolAndSuppliesNull();

      final ten =
          (c.tenCCDCVatTu?.isNotEmpty ?? false) ? c.tenCCDCVatTu! : asset.ten;
      final namSX = c.namSanXuat ?? asset.namSanXuat;
      final donViTinh = c.donViTinh ?? asset.donViTinh;

      final tenDetail =
          ten.isNotEmpty ? '$ten - (${c.idChiTietCCDCVatTu}) - $namSX' : c.idChiTietCCDCVatTu;

      result.add(
        ItemDropdownDetailCcdc(
          id: c.id,
          idCCDCVatTu: c.idCCDCVatTu,
          tenCCDCVatTu: ten,
          idDetaiAsset: c.idChiTietCCDCVatTu,
          tenDetailAsset: tenDetail,
          idDonVi: asset.idDonVi,
          donViTinh: donViTinh,
          namSanXuat: namSX,
          soKyHieu: asset.soKyHieu,
          kyHieu: asset.kyHieu,
          // soLuong: c.soLuongXuat < 0 ? c.soLuongXuat : c.soLuongXuat - c.soLuongDaBanGiao,
          soLuong: widget.isEditing ? c.soLuongConLai ?? 0: c.soLuongXuat,
          soLuongDaBanGiao: c.soLuongDaBanGiao,
          soLuongConLai: c.soLuongConLai ?? 0,
          soLuongXuat: 0,
          ghiChu: c.ghiChu.isNotEmpty ? c.ghiChu : asset.ghiChu,
          asset: asset,
          chiTietDieuDongCCDCVatTuDTO: c,
        ),
      );
    }
    return result;
  }

  // Map dữ liệu từ danh sách bàn giao (DetailSubppliesHandoverDto) sang dữ liệu bảng
  List<ItemDropdownDetailCcdc> getAssetsByHandoverDetails(
    List<DetailSubppliesHandoverDto> details,
    List<DetailToolAndMaterialTransferDto> chiTietDieuDong,
  ) {
    final result = <ItemDropdownDetailCcdc>[];
    for (final d in details) {
      final detail = chiTietDieuDong.firstWhere((element) {
        return element.id == d.idChiTietDieuDong;
      }, orElse: () => DetailToolAndMaterialTransferDto.empty());
      // Tìm item dropdown theo id chi tiết CCDC VT đã lưu trong bàn giao
      final soLuong = detail.soLuongXuat - detail.soLuongDaBanGiao;
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
            soLuong: soLuong,
            soLuongConLai: detail.soLuongConLai ?? 0,
            ghiChu: asset.ghiChu,
            soKyHieu: asset.soKyHieu,
            kyHieu: asset.kyHieu,
            asset: asset,
          );
        },
      );
      final mapped = dropdownItem.copyWith(
        soLuong: soLuong,
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
            // Sử dụng ValueKey với _tableKeyValue để force rebuild khi movementDetails thay đổi
            key: ValueKey<int>(_tableKeyValue),
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
              // Update local state
              listAsset = List.from(data);
              // Notify parent without setState to avoid rebuild loop
              // The table will rebuild itself when needed
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
                  item.donViTinh =
                      AccountHelper.instance
                          .getUnitById(value.idDonVi)
                          ?.tenDonVi ??
                      '';
                  item.namSanXuat = value.namSanXuat;
                  item.soKyHieu = value.soKyHieu;
                  item.kyHieu = value.kyHieu;
                  item.soLuong = value.soLuongXuat - value.soLuongDaBanGiao;
                  item.ghiChu = value.ghiChu;
                  item.soLuongXuat = value.soLuongXuat;
                  item.asset = value.asset;
                },
                sortValueGetter: (item) => item.tenCCDCVatTu,
                isCellEditableDecider: (item, rowIndex) => true,
                editor: EditableCellEditor.searchableDropdown,
                searchableDropdownOptions: listItemDropdownDetailAsset,
                displayStringForOption: (option) => (option as ItemDropdownDetailCcdc).tenDetailAsset,
                onValueChanged: (item, rowIndex, newValue, updateRow) {
                  final selectedItem = newValue as ItemDropdownDetailCcdc;
                  updateRow('don_vi_tinh', selectedItem.donViTinh);
                  updateRow('so_luong', selectedItem.soLuong);
                  updateRow('ghi_chu', selectedItem.ghiChu);
                  updateRow('so_luong_xuat', selectedItem.soLuongXuat.toString());

                  Future.microtask(() => _forceNotifyDataChanged());
                },
              ),
              DetailEditableColumn<ItemDropdownDetailCcdc>(
                field: 'don_vi_tinh',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue:
                    (item) =>
                        AccountHelper.instance
                            .getUnitById(item.donViTinh)
                            ?.tenDonVi ??
                        '',
                setValue: (item, value) => item.donViTinh = value,
                sortValueGetter:
                    (item) =>
                        AccountHelper.instance
                            .getUnitById(item.donViTinh)
                            ?.tenDonVi ??
                        '',
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
        return 'Chờ xử lý';
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
