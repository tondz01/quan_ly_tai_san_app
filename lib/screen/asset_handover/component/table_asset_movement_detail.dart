import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';

class TableAssetMovementDetail extends StatefulWidget {
  final List<ChiTietDieuDongTaiSan>? listDetailAssetMobilization;
  final List<DetailAssetHandoverDto>? listDetailAssetHandover;
  final bool isDetail;
  final bool isEditing;
  final Function(List<ChiTietDieuDongTaiSan>)? onDataChanged;
  const TableAssetMovementDetail({
    super.key,
    this.listDetailAssetMobilization,
    this.listDetailAssetHandover,
    this.isEditing = false,
    this.isDetail = false,
    this.onDataChanged,
  });

  @override
  State<TableAssetMovementDetail> createState() =>
      _TableAssetMovementDetailState();
}

class _TableAssetMovementDetailState extends State<TableAssetMovementDetail> {
  List<DropdownMenuItem<dynamic>> items = [];
  List<DropdownMenuItem<dynamic>> hienTrangItems = [];
  List<ChiTietDieuDongTaiSan> listDetailAssetMobilization = [];
  bool isExpanded = true;
  
  // Cache HienTrang lookup để tránh O(n) search mỗi lần render
  late final Map<int, HienTrang> _hienTrangCache;
  late final HienTrang _defaultHienTrang;

  @override
  void initState() {
    super.initState();
    _initHienTrangCache();
    _initHienTrangItems();
    _syncDetailAssets();
  }

  /// Khởi tạo cache cho HienTrang lookup - O(1) thay vì O(n)
  void _initHienTrangCache() {
    _hienTrangCache = {
      for (final ht in AppUtility.listHienTrang) ht.id: ht,
    };
    _defaultHienTrang = AppUtility.listHienTrang.isNotEmpty
        ? AppUtility.listHienTrang.first
        : HienTrang(id: 0, name: '');
  }

  /// Khởi tạo dropdown items cho HienTrang
  void _initHienTrangItems() {
    hienTrangItems = AppUtility.listHienTrang
        .map(
          (hienTrang) => DropdownMenuItem<dynamic>(
            value: hienTrang,
            child: Text(hienTrang.name),
          ),
        )
        .toList();
  }

  @override
  void didUpdateWidget(covariant TableAssetMovementDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra thay đổi bằng cách so sánh reference và length
    final listDetailAssetHandoverChanged = 
        widget.listDetailAssetHandover != oldWidget.listDetailAssetHandover ||
        (widget.listDetailAssetHandover?.length ?? 0) != 
            (oldWidget.listDetailAssetHandover?.length ?? 0);
    
    final listDetailAssetMobilizationChanged = 
        widget.listDetailAssetMobilization != oldWidget.listDetailAssetMobilization ||
        (widget.listDetailAssetMobilization?.length ?? 0) != 
            (oldWidget.listDetailAssetMobilization?.length ?? 0);
    
    if (listDetailAssetHandoverChanged || listDetailAssetMobilizationChanged) {
      _syncDetailAssets();
    }
  }

  /// Đồng bộ dữ liệu dropdown và danh sách hiển thị trong bảng
  void _syncDetailAssets() {
    if (!mounted) return;
    
    // Tạo dropdown items từ danh sách tài sản điều động
    items = widget.listDetailAssetMobilization
            ?.map(
              (e) => DropdownMenuItem<dynamic>(
                value: e,
                child: Text(e.tenTaiSan),
              ),
            )
            .toList() ??
        [];

    // Nếu là chế độ xem chi tiết, map từ listDetailAssetHandover
    if (widget.isDetail) {
      final list = <ChiTietDieuDongTaiSan>[];
      final mobilizationList = widget.listDetailAssetMobilization ?? [];
      
      // Tạo map để lookup nhanh hơn O(1) thay vì O(n)
      final mobilizationMap = <String, ChiTietDieuDongTaiSan>{};
      for (final e in mobilizationList) {
        if (e.idTaiSan.isNotEmpty) {
          mobilizationMap[e.idTaiSan] = e;
        }
      }
      
      for (final d in widget.listDetailAssetHandover ?? []) {
        if (d.idTaiSan == null || d.idTaiSan!.isEmpty) continue;
        
        // Tìm trong map trước, nếu không có thì tìm trong list
        ChiTietDieuDongTaiSan? chiTiet = mobilizationMap[d.idTaiSan!];
        
        chiTiet ??= mobilizationList.firstWhere(
            (e) => e.idTaiSan == d.idTaiSan,
            orElse: () => ChiTietDieuDongTaiSan.empty(),
          );
        
        // Nếu tìm thấy, copy dữ liệu từ DetailAssetHandoverDto vào ChiTietDieuDongTaiSan
        if (chiTiet.idTaiSan.isNotEmpty) {
          // Tạo bản copy và cập nhật các giá trị từ DetailAssetHandoverDto
          final updatedChiTiet = ChiTietDieuDongTaiSan(
            id: chiTiet.id,
            idDieuDongTaiSan: chiTiet.idDieuDongTaiSan,
            soQuyetDinh: chiTiet.soQuyetDinh,
            tenPhieu: chiTiet.tenPhieu,
            idTaiSan: chiTiet.idTaiSan,
            tenTaiSan: chiTiet.tenTaiSan.isNotEmpty ? chiTiet.tenTaiSan : (d.tenTaiSan ?? ''),
            donViTinh: chiTiet.donViTinh.isNotEmpty ? chiTiet.donViTinh : (d.donViTinh ?? ''),
            hienTrang: d.hienTrang ?? chiTiet.hienTrang,
            soLuong: d.soLuong ?? chiTiet.soLuong,
            ghiChu: d.moTa ?? chiTiet.ghiChu,
            kyHieu: chiTiet.kyHieu,
            soKyHieu: chiTiet.soKyHieu,
            namSanXuat: chiTiet.namSanXuat,
            ngayTao: chiTiet.ngayTao,
            ngayCapNhat: chiTiet.ngayCapNhat,
            nguoiTao: chiTiet.nguoiTao,
            nguoiCapNhat: chiTiet.nguoiCapNhat,
            isActive: chiTiet.isActive,
          );
          list.add(updatedChiTiet);
        } else {
          // Nếu không tìm thấy trong mobilization list, tạo từ DetailAssetHandoverDto
          final newChiTiet = ChiTietDieuDongTaiSan(
            id: d.id ?? '',
            idDieuDongTaiSan: d.quyetDinhDieuDongSo ?? '',
            soQuyetDinh: d.quyetDinhDieuDongSo ?? '',
            tenPhieu: '',
            idTaiSan: d.idTaiSan ?? '',
            tenTaiSan: d.tenTaiSan ?? '',
            donViTinh: d.donViTinh ?? '',
            hienTrang: d.hienTrang ?? 0,
            soLuong: d.soLuong ?? 0,
            ghiChu: d.moTa ?? '',
            kyHieu: d.kyHieu ?? '',
            soKyHieu: d.soKyHieu ?? '',
            namSanXuat: d.namSanXuat ?? '',
            ngayTao: d.ngayTao ?? AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
            ngayCapNhat: d.ngayCapNhat ?? AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
            nguoiTao: d.nguoiTao ?? '',
            nguoiCapNhat: d.nguoiCapNhat ?? '',
            isActive: d.isActive ?? true,
          );
          list.add(newChiTiet);
        }
      }
      
      setState(() {
        listDetailAssetMobilization = list;
      });
    } else {
      // Chế độ editing: sử dụng trực tiếp listDetailAssetMobilization
      setState(() {
        listDetailAssetMobilization = widget.listDetailAssetMobilization ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Chi tiết tài sản điều chuyển',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Thu gọn' : 'Mở rộng',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isExpanded ? Colors.grey[600] : Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: SgEditableTable<ChiTietDieuDongTaiSan>(
              key: ValueKey('${listDetailAssetMobilization.length}_${widget.isDetail}_${widget.listDetailAssetHandover?.length ?? 0}'),
              initialData: listDetailAssetMobilization,
              createEmptyItem: ChiTietDieuDongTaiSan.empty,
              rowHeight: 40.0,
              headerBackgroundColor: Colors.grey.shade50,
              oddRowBackgroundColor: Colors.white,
              evenRowBackgroundColor: Colors.white,
              showVerticalLines: false,
              showHorizontalLines: true,
              addRowText: 'Thêm một dòng',
              isEditing: widget.isEditing, // Pass the editing state
              subtractedSize: 150,
              onDataChanged: (data) {
                widget.onDataChanged?.call(data);
              },
              columns: [
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'asset',
                  title: 'Tên tài sản',
                  titleAlignment: TextAlign.center,
                  width: 120,
                  // Hiển thị tên tài sản trong cell
                  getValue: (item) => item,
                  // Khi chọn item từ dropdown, copy dữ liệu vào row hiện tại
                  setValue: (item, value) {
                    // Ép kiểu value về ChiTietDieuDongTaiSan để type-safe
                    if (value is! ChiTietDieuDongTaiSan) return;
                    
                    final selectedAsset = value;
                    item.idDieuDongTaiSan = selectedAsset.tenTaiSan;
                    item.soQuyetDinh = selectedAsset.soQuyetDinh;
                    item.tenPhieu = selectedAsset.tenPhieu;
                    item.idTaiSan = selectedAsset.idTaiSan;
                    item.tenTaiSan = selectedAsset.tenTaiSan;
                    item.donViTinh = selectedAsset.donViTinh;
                    item.hienTrang = selectedAsset.hienTrang;
                    item.soLuong = selectedAsset.soLuong;
                    item.ghiChu = selectedAsset.ghiChu;
                  },
                  sortValueGetter: (item) => item.tenTaiSan,
                  editor: EditableCellEditor.dropdown,
                  dropdownItems: items,
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'unit',
                  title: 'Đơn vị tính',
                  titleAlignment: TextAlign.center,
                  width: 50,
                  getValue: (item) => item.donViTinh,
                  setValue: (item, value) {},
                  sortValueGetter: (item) => item.donViTinh,
                  isEditable: false,
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'quantity',
                  title: 'Số lượng',
                  titleAlignment: TextAlign.center,
                  width: 50,
                  getValue: (item) => item.soLuong,
                  setValue: (item, value) {
                    item.soLuong = 1;
                  },
                  sortValueGetter: (item) => item.soLuong,
                  isEditable: false,
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'condition',
                  title: 'Tình trạng kỹ thuật',
                  titleAlignment: TextAlign.center,
                  isEditable: true,
                  width: 50,
                  // O(1) lookup từ cache thay vì O(n) firstWhere
                  getValue: (item) => 
                      (_hienTrangCache[item.hienTrang] ?? _defaultHienTrang).name,
                  setValue: (item, value) {
                    if (value is! HienTrang) return;
                    item.hienTrang = value.id;
                  },
                  // O(1) lookup từ cache
                  getValueWithIndex: (item, rowIndex) =>
                      _hienTrangCache[item.hienTrang] ?? _defaultHienTrang,
                  sortValueGetter: (item) =>
                      (_hienTrangCache[item.hienTrang] ?? _defaultHienTrang).name,
                  editor: EditableCellEditor.dropdown,
                  dropdownItems: hienTrangItems,
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'node',
                  title: 'Ghi chú',
                  titleAlignment: TextAlign.center,
                  width: 100,
                  getValue: (item) => item.ghiChu,
                  setValue: (item, value) {
                    item.ghiChu = value;
                  },
                  sortValueGetter: (item) => item.ghiChu,
                ),
              ],
            ),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
