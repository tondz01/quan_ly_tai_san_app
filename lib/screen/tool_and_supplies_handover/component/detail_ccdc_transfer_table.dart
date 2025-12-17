import 'dart:developer';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/model/item_dropwdown_ccdc.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
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
  
  // Cache để tối ưu hiệu năng
  Map<String, ToolsAndSuppliesDto>? _assetCache;
  Map<String, ItemDropdownDetailCcdc>? _dropdownItemCache;
  Map<String, String>? _unitNameCache;
  ToolsAndSuppliesDto? _nullAssetCache;

  void _forceNotifyDataChanged() {
    if (_isInitialized && widget.onDataChanged != null) {
      widget.onDataChanged?.call(List.from(listAsset));
    }
  }

  // Cache asset lookup để tối ưu hiệu năng
  void _buildAssetCache() {
    _assetCache = {for (final a in widget.allAssets) a.id: a};
  }

  ToolsAndSuppliesDto getAssetByID(String idAsset) {
    _assetCache ??= {for (final a in widget.allAssets) a.id: a};
    return _assetCache![idAsset] ?? _getNullAsset();
  }

  DetailAssetDto getDetailAssetByID(String idAsset) {
    if (listDetailAsset.isEmpty) return DetailAssetDto.empty();
    // Cache không cần thiết vì listDetailAsset hiếm khi thay đổi và nhỏ
    return listDetailAsset.firstWhere(
      (item) => item.id == idAsset,
      orElse: () => DetailAssetDto.empty(),
    );
  }

  // Cache null asset để tránh tạo object mới mỗi lần
  ToolsAndSuppliesDto _getNullAsset() {
    _nullAssetCache ??= toolAndSuppliesNull();
    return _nullAssetCache!;
  }

  // Cache unit name lookup
  String _getUnitName(String idDonVi) {
    _unitNameCache ??= {};
    if (_unitNameCache!.containsKey(idDonVi)) {
      return _unitNameCache![idDonVi]!;
    }
    final unitName = AccountHelper.instance
            .getUnitById(idDonVi)
            ?.tenDonVi ??
        '';
    _unitNameCache![idDonVi] = unitName;
    return unitName;
  }

  void _syncDetailAssets() {
    // Build asset cache trước
    _buildAssetCache();
    
    // Build dropdown source list from movement details + master CCDC list
    listItemDropdownDetailAsset = getAssetsByChildAssets(
      widget.allAssets,
      movementDetails,
    );

    // Build dropdown item cache để tối ưu lookup
    _dropdownItemCache = {
      for (final item in listItemDropdownDetailAsset) item.id: item
    };

    // KHÔNG cập nhật listAsset ở đây nữa
    // Việc cập nhật listAsset sẽ được xử lý trong didUpdateWidget
    // để tránh duplicate và đảm bảo logic đúng
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
    
    bool needsSync = false;
    bool needsRebuild = false;
    bool invalidateCaches = false;

    // Khi danh sách ownership hoặc assets thay đổi, đồng bộ lại dữ liệu dropdown
    // CHỈ sync dropdown, KHÔNG rebuild table để tránh mất focus
    final ownershipChanged =
        oldWidget.listOwnershipUnit != widget.listOwnershipUnit;
    final assetsChanged = oldWidget.allAssets != widget.allAssets;
    if (ownershipChanged || assetsChanged) {
      needsSync = true;
      invalidateCaches = true;
      // CHỈ sync dropdown, không set needsRebuild
    }

    // Xử lý khi movementDetails thay đổi
    // Cần rebuild table vì data structure thay đổi
    if (oldWidget.movementDetails != widget.movementDetails) {
      movementDetails = List.from(widget.movementDetails);
      needsSync = true;
      needsRebuild = true;
      invalidateCaches = true;
    }

    // Ưu tiên dữ liệu từ initialDetailsSuppliesHandover nếu có
    final handoverChanged = oldWidget.initialDetailsSuppliesHandover !=
        widget.initialDetailsSuppliesHandover;
    
    // Invalidate caches trước khi sync
    if (invalidateCaches) {
      _assetCache = null;
      _dropdownItemCache = null;
      _unitNameCache = null;
    }
    
    // Đảm bảo listItemDropdownDetailAsset được cập nhật trước khi map dữ liệu
    if (needsSync) {
      _syncDetailAssets();
    }

    // Cập nhật listAsset dựa trên handover hoặc movementDetails
    // Ưu tiên dữ liệu từ initialDetailsSuppliesHandover nếu có
    if (handoverChanged && widget.initialDetailsSuppliesHandover.isNotEmpty) {
      // Ưu tiên dữ liệu từ initialDetailsSuppliesHandover
      listAsset = getAssetsByHandoverDetails(
        widget.initialDetailsSuppliesHandover,
        movementDetails,
      );
      needsRebuild = true; // Cần rebuild vì data thay đổi
    } else if (oldWidget.movementDetails != widget.movementDetails) {
      // Cập nhật từ movementDetails khi movementDetails thay đổi
      if (widget.movementDetails.isEmpty) {
        listAsset = [];
      } else if (widget.initialDetailsSuppliesHandover.isNotEmpty) {
        // Nếu có handover data, ưu tiên dùng handover
        listAsset = getAssetsByHandoverDetails(
          widget.initialDetailsSuppliesHandover,
          movementDetails,
        );
      } else {
        // Không có handover data, dùng movementDetails
        listAsset = List.from(getAssetsByChildAssets(widget.allAssets, movementDetails));
      }
      // needsRebuild đã được set ở trên
    } else if (needsSync && widget.initialDetailsSuppliesHandover.isNotEmpty) {
      // Khi chỉ có needsSync (ownership/assets changed) nhưng có handover data
      // Cần cập nhật lại listAsset từ handover để đảm bảo dữ liệu đúng
      listAsset = getAssetsByHandoverDetails(
        widget.initialDetailsSuppliesHandover,
        movementDetails,
      );
      // KHÔNG rebuild table để tránh mất focus
    } else if (needsSync && widget.movementDetails.isNotEmpty) {
      // Khi chỉ có needsSync và không có handover data, cập nhật từ movementDetails
      listAsset = List.from(getAssetsByChildAssets(widget.allAssets, movementDetails));
      // KHÔNG rebuild table để tránh mất focus
    }

    // Chỉ rebuild table khi thực sự cần thiết
    if (needsRebuild) {
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

  // Cập nhật getAssetsByChildAssets để trả về List<ItemDropdownDetailCcdc>
  List<ItemDropdownDetailCcdc> getAssetsByChildAssets(
    List<ToolsAndSuppliesDto> allAssets,
    List<DetailToolAndMaterialTransferDto> chiTietDieuDong,
  ) {
    // Sử dụng cache nếu có, nếu không thì build từ allAssets
    final idToAsset = _assetCache ?? {for (final a in allAssets) a.id: a};
    final nullAsset = _getNullAsset();
    
    // Sử dụng List.generate để tối ưu và tránh null elements
    return List.generate(
      chiTietDieuDong.length,
      (i) {
        final c = chiTietDieuDong[i];
        final asset = idToAsset[c.idCCDCVatTu] ?? nullAsset;

        final ten = (c.tenCCDCVatTu?.isNotEmpty ?? false) 
            ? c.tenCCDCVatTu! 
            : asset.ten;
        final namSX = c.namSanXuat ?? asset.namSanXuat;
        final donViTinh = c.donViTinh ?? asset.donViTinh;

        final tenDetail = ten.isNotEmpty 
            ? '$ten - (${c.idChiTietCCDCVatTu}) - $namSX' 
            : c.idChiTietCCDCVatTu;

        return ItemDropdownDetailCcdc(
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
          soLuong: widget.isEditing ? (c.soLuongConLai ?? 0) : c.soLuongXuat,
          soLuongDaBanGiao: c.soLuongDaBanGiao,
          soLuongConLai: c.soLuongConLai ?? 0,
          soLuongXuat: 0,
          ghiChu: c.ghiChu.isNotEmpty ? c.ghiChu : asset.ghiChu,
          asset: asset,
          chiTietDieuDongCCDCVatTuDTO: c,
        );
      },
      growable: false, // Fixed-size list để tối ưu memory
    );
  }

  // Map dữ liệu từ danh sách bàn giao (DetailSubppliesHandoverDto) sang dữ liệu bảng
  List<ItemDropdownDetailCcdc> getAssetsByHandoverDetails(
    List<DetailSubppliesHandoverDto> details,
    List<DetailToolAndMaterialTransferDto> chiTietDieuDong,
  ) {
    if (kDebugMode) {
      log('getAssetsByHandoverDetails: mapping ${details.length} items');
    }
    
    final result = <ItemDropdownDetailCcdc>[];
    
    for (final d in details) {
      // Tìm chi tiết điều động tương ứng
      final detail = chiTietDieuDong.firstWhere(
        (element) => element.id == d.idChiTietDieuDong,
        orElse: () => DetailToolAndMaterialTransferDto.empty(),
      );
      
      // Tính toán số lượng dựa trên chế độ editing
      final soLuong = widget.isEditing 
          ? (detail.soLuongConLai ?? 0)
          : detail.soLuongXuat;
      
      // Số lượng bàn giao từ dữ liệu handover (luôn lấy từ d.soLuong)
      final soluongBG = d.soLuong;
      
      // Ghi chú: luôn ưu tiên từ d.ghiChu (kể cả khi rỗng), fallback về asset.ghiChu nếu d.ghiChu là null
      final ghiChuFromHandover = d.ghiChu ?? '';
      
      // Tìm item trong dropdown list sử dụng cache
      ItemDropdownDetailCcdc? dropdownItem;
      dropdownItem = _dropdownItemCache?[d.iddieudongccdcvattu];
      
      if (dropdownItem == null) {
        // Nếu không tìm thấy trong dropdown, tạo item mới từ dữ liệu gốc
        final asset = getAssetByID(d.idCCDCVatTu);
        final fallbackGhiChu = ghiChuFromHandover.isNotEmpty 
            ? ghiChuFromHandover 
            : (asset.ghiChu.isNotEmpty ? asset.ghiChu : '');
        
        dropdownItem = ItemDropdownDetailCcdc(
          id: d.id,
          idCCDCVatTu: d.idCCDCVatTu,
          tenCCDCVatTu: asset.ten.isNotEmpty ? asset.ten : (d.tenVatTu ?? ''),
          idDetaiAsset: d.idChiTietCCDCVatTu,
          tenDetailAsset: asset.ten.isNotEmpty
              ? '${asset.ten} - (${d.idChiTietCCDCVatTu}) - ${detail.namSanXuat ?? asset.namSanXuat}'
              : d.idChiTietCCDCVatTu,
          idDonVi: asset.idDonVi,
          donViTinh: d.donViTinh ?? detail.donViTinh ?? asset.donViTinh,
          namSanXuat: detail.namSanXuat ?? asset.namSanXuat,
          soLuong: soLuong,
          soLuongConLai: detail.soLuongConLai ?? 0,
          ghiChu: fallbackGhiChu,
          soKyHieu: d.soKyHieu ?? detail.soKyHieu ?? asset.soKyHieu,
          kyHieu: d.kyHieu ?? detail.kyHieu ?? asset.kyHieu,
          soLuongXuat: soluongBG,
          asset: asset,
          chiTietDieuDongCCDCVatTuDTO: detail,
        );
      }
      
      // Tạo item cuối cùng với dữ liệu từ handover
      // Lưu ý: copyWith sử dụng ?? operator, nên nếu ghiChu là '', nó sẽ không được cập nhật
      // Do đó, nếu d.ghiChu là null hoặc rỗng, ta giữ nguyên giá trị từ dropdownItem
      final mapped = ghiChuFromHandover.isNotEmpty
          ? dropdownItem.copyWith(
              soLuong: soLuong,
              donViTinh: d.donViTinh ?? detail.donViTinh ?? dropdownItem.donViTinh,
              soLuongXuat: soluongBG,
              ghiChu: ghiChuFromHandover,
            )
          : dropdownItem.copyWith(
              soLuong: soLuong,
              donViTinh: d.donViTinh ?? detail.donViTinh ?? dropdownItem.donViTinh,
              soLuongXuat: soluongBG,
            );
      
      result.add(mapped);
    }
    
    if (kDebugMode) {
      log('getAssetsByHandoverDetails: mapped ${result.length} items');
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
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'asset',
                title: 'CCDC Vật tư',
                titleAlignment: TextAlign.center,
                width: 150,
                isEditable: widget.isEditing,
                getValue: (item) {
                  // Sử dụng cache để tìm item nhanh hơn
                  if (_dropdownItemCache != null) {
                    final match = _dropdownItemCache!.values.firstWhere(
                      (e) => e.idDetaiAsset == item.idDetaiAsset,
                      orElse: () => item,
                    );
                    return match;
                  }
                  // Fallback nếu cache chưa có
                  return listItemDropdownDetailAsset.firstWhere(
                    (e) => e.idDetaiAsset == item.idDetaiAsset,
                    orElse: () => item,
                  );
                },
                getValueWithIndex: (item, rowIndex) {
                  // When viewing, display the readable text. When editing, return the dropdown value
                  if (widget.isEditing) {
                    if (_dropdownItemCache != null) {
                      final match = _dropdownItemCache!.values.firstWhere(
                        (e) => e.idDetaiAsset == item.idDetaiAsset,
                        orElse: () => item,
                      );
                      return match;
                    }
                    return listItemDropdownDetailAsset.firstWhere(
                      (e) => e.idDetaiAsset == item.idDetaiAsset,
                      orElse: () => item,
                    );
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
                  item.donViTinh = _getUnitName(value.idDonVi);
                  item.namSanXuat = value.namSanXuat;
                  item.soKyHieu = value.soKyHieu;
                  item.kyHieu = value.kyHieu;
                  item.soLuong = value.soLuong;
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
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'don_vi_tinh',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => _getUnitName(item.donViTinh),
                setValue: (item, value) => item.donViTinh = value,
                sortValueGetter: (item) => _getUnitName(item.donViTinh),
                isEditable: false,
              ),
              SgEditableColumn<ItemDropdownDetailCcdc>(
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
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'so_luong_xuat',
                title: 'Số lượng bàn giao',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue:
                    (item) =>
                        item.soLuongXuat,
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
                isCellEditableDecider: (item, rowIndex) => true,
              ),
              SgEditableColumn<ItemDropdownDetailCcdc>(
                field: 'ghi_chu',
                title: 'Ghi chú',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.ghiChu,
                setValue: (item, value) => item.ghiChu = value,
                sortValueGetter: (item) => item.ghiChu,
                isEditable: widget.isEditing,
                isCellEditableDecider: (item, rowIndex) => true,
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
