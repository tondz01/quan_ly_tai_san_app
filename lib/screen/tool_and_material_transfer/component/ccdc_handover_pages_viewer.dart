// ignore_for_file: depend_on_referenced_packages

import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_tai_san_app/common/model/signe_info.dart';
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:path/path.dart' as path;

class CcdcHandoverPagesViewer {
  // Kích thước A4: 800 x 1131.43 (tỷ lệ 210:297)
  static const double _a4Width = 800.0;
  static const double _a4Height = 800.0 * (297 / 210); // ~1131.43
  static const double _headerHeight = 64.0; // Chiều cao header
  static const double _padding = 16.0; // Padding xung quanh

  static void showPopup(BuildContext context, ToolAndMaterialTransferDto item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Tính toán kích thước popup dựa trên kích thước A4
    // Popup width = A4 width + padding
    // Popup height = Header + A4 height + padding
    final calculatedWidth = _a4Width + (_padding * 2);
    final calculatedHeight = _headerHeight + _a4Height + (_padding * 2);

    // Đảm bảo popup không vượt quá màn hình
    final popupWidth = math.min(calculatedWidth, screenWidth * 0.98);
    final popupHeight = math.min(calculatedHeight, screenHeight * 0.98);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: popupWidth,
            height: popupHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: _ToolAndSuppliesHandoverPagesViewerContent(item: item),
          ),
        );
      },
    );
  }
}

class _ToolAndSuppliesHandoverPagesViewerContent extends StatefulWidget {
  final ToolAndMaterialTransferDto item;

  const _ToolAndSuppliesHandoverPagesViewerContent({required this.item});

  @override
  State<_ToolAndSuppliesHandoverPagesViewerContent> createState() =>
      _ToolAndSuppliesHandoverPagesViewerContentState();
}

class _ToolAndSuppliesHandoverPagesViewerContentState
    extends State<_ToolAndSuppliesHandoverPagesViewerContent>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  final ToolAndSuppliesHandoverRepository _repository =
      ToolAndSuppliesHandoverRepository();
  final ToolAndSuppliesHandoverProvider _provider =
      ToolAndSuppliesHandoverProvider();

  List<ToolAndSuppliesHandoverDto> _listHandover = [];
  Map<String, List<DetailSubppliesHandoverDto>> detailsMap =
      {}; // Map để lưu chi tiết theo id
  Set<int> loadingDetailsIndices = {}; // Track which items are loading details
  int _currentPage = 0;
  bool _isLoading = true;
  bool _hasLoadedData = false; // Flag để đảm bảo chỉ gọi API 1 lần
  String? _errorMessage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    loadingDetailsIndices.clear();
    detailsMap.clear();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted || _hasLoadedData) return; // Đảm bảo chỉ gọi API 1 lần

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // CHỈ GỌI API 1 LẦN KHI LOAD BAN ĐẦU - không gọi lại khi chuyển page
      // Gọi API với params: page=0, size=9999, searchTerm=id biên bản điều chuyển, trangThai=-1
      final response = await _repository.getDataWithPagination(
        0, // Backend dùng 0-based index
        9999,
        widget.item.id ?? '', // searchTerm = id biên bản điều chuyển
        -1, // trangThai = -1 (tất cả)
        false, // isByUserId = false để lấy tất cả biên bản bàn giao liên quan đến biên bản điều chuyển
      );

      if (!mounted) return;

      if (response['status_code'] == 200) {
        final data = response['data'] as List<dynamic>;
        // Filter để chỉ lấy các biên bản bàn giao có lenhDieuDong == id biên bản điều chuyển
        // Đảm bảo lấy đúng biên bản BÀN GIAO, không phải biên bản điều chuyển
        _listHandover =
            data
                .cast<ToolAndSuppliesHandoverDto>()
                .where((item) => item.lenhDieuDong == widget.item.id)
                .toList();

        setState(() {
          _isLoading = false;
          _hasLoadedData = true; // Đánh dấu đã load xong
        });

        // Load chi tiết cho page đầu tiên
        if (_listHandover.isNotEmpty) {
          _loadDetailsForPage(0);
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể tải dữ liệu';
        });
      }
    } catch (e) {
      SGLog.error("Error loading handover data", e.toString());
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi: ${e.toString()}';
      });
    }
  }

  // Load chi tiết biên bản bàn giao cho từng page
  // CHỈ LOAD CHI TIẾT - KHÔNG GỌI API getDataWithPagination
  Future<void> _loadDetailsForPage(int index) async {
    if (index < 0 || index >= _listHandover.length) return;

    final item = _listHandover[index];
    final itemId = item.id ?? '';

    // Đã load rồi hoặc đang load
    if (detailsMap.containsKey(itemId) ||
        loadingDetailsIndices.contains(index)) {
      return;
    }

    // Nếu đã có chiTietBanGiaoTaiSan trong item, dùng luôn
    if (item.listDetailSubppliesHandover != null &&
        item.listDetailSubppliesHandover!.isNotEmpty) {
      if (mounted) {
        setState(() {
          detailsMap[itemId] = item.listDetailSubppliesHandover!;
        });
      }
      return;
    }

    // Mark as loading
    if (mounted) {
      setState(() {
        loadingDetailsIndices.add(index);
      });
    }

    // try {
    //   // Load chi tiết từ API - dùng lenhDieuDong (id điều chuyển) như trong getListDetailAssetMobilization
    //   // API nhận iddieudongtaisan, nên dùng lenhDieuDong (id của biên bản điều chuyển)
    //   await _provider.getListDetailAssetMobilization(item.lenhDieuDong ?? '');

    //   if (mounted) {
    //     // Lấy chi tiết từ provider
    //     final details = _provider.dataDetailAssetHandover ?? [];
    //     setState(() {
    //       detailsMap[itemId] = details.cast<DetailSubppliesHandoverDto>();
    //       loadingDetailsIndices.remove(index);
    //     });
    //   }
    // } catch (e) {
    //   SGLog.error("Error loading details for page $index", e.toString());
    //   if (mounted) {
    //     setState(() {
    //       detailsMap[itemId] = item.listDetailSubppliesHandover ?? [];
    //       loadingDetailsIndices.remove(index);
    //     });
    //   }
    // }
  }

  // Preload chi tiết cho các page xung quanh để tối ưu performance
  // CHỈ LOAD CHI TIẾT - KHÔNG GỌI API getDataWithPagination
  void _preloadNearbyPages(int currentIndex) {
    // Preload page trước (chỉ load chi tiết, không gọi API)
    if (currentIndex > 0) {
      _loadDetailsForPage(currentIndex - 1);
    }
    // Preload page sau (chỉ load chi tiết, không gọi API)
    if (currentIndex + 1 < _listHandover.length) {
      _loadDetailsForPage(currentIndex + 1);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < _listHandover.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildHeader() {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.description, color: Colors.blue.shade700, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Danh sách biên bản bàn giao',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            // Hiển thị pagination info
            if (_listHandover.isNotEmpty)
              Row(
                children: [
                  IconButton(
                    onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                    icon: const Icon(Icons.chevron_left),
                    color:
                        _currentPage > 0
                            ? Colors.blue.shade700
                            : Colors.grey.shade400,
                  ),
                  Text(
                    '${_currentPage + 1}/${_listHandover.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        _currentPage < _listHandover.length - 1
                            ? _goToNextPage
                            : null,
                    icon: const Icon(Icons.chevron_right),
                    color:
                        _currentPage < _listHandover.length - 1
                            ? Colors.blue.shade700
                            : Colors.grey.shade400,
                  ),
                ],
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close, color: Colors.blue.shade700),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Focus(
      autofocus: kIsWeb, // Tự động focus trên web để nhận keyboard events
      onKeyEvent: (node, event) {
        // Hỗ trợ điều hướng bằng phím mũi tên trên web
        if (kIsWeb && event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _goToPreviousPage();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _goToNextPage();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Đang tải danh sách biên bản bàn giao...',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : _errorMessage != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadData,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    )
                    : _listHandover.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không có biên bản bàn giao nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                    : RepaintBoundary(
                      child: PageView.builder(
                        controller: _pageController,
                        // Trên web, sử dụng AlwaysScrollableScrollPhysics để đảm bảo có thể drag bằng chuột
                        // Kết hợp với PageScrollPhysics để có hiệu ứng page snap
                        physics:
                            kIsWeb
                                ? const AlwaysScrollableScrollPhysics(
                                  parent: PageScrollPhysics(),
                                )
                                : const PageScrollPhysics(),
                        allowImplicitScrolling: false,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          // Chỉ update state khi cần thiết
                          if (_currentPage != index) {
                            setState(() {
                              _currentPage = index;
                            });
                            // CHỈ PRELOAD CHI TIẾT - KHÔNG GỌI API
                            // Khi chuyển page, chỉ load chi tiết của page đó và page xung quanh
                            // KHÔNG gọi lại API getDataWithPagination
                            _loadDetailsForPage(index);
                            _preloadNearbyPages(index);
                          }
                        },
                        itemCount: _listHandover.length,
                        itemBuilder: (context, index) {
                          return RepaintBoundary(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _PageViewItem(
                                index: index,
                                item: _listHandover[index],
                                itemTransfers: widget.item,
                                itemsDetail:
                                    detailsMap[_listHandover[index].id ?? ''] ??
                                    _listHandover[index]
                                        .listDetailSubppliesHandover ??
                                    [],
                                isLoading: loadingDetailsIndices.contains(
                                  index,
                                ),
                                onLoadDetails: () => _loadDetailsForPage(index),
                                provider: _provider,
                                pageController: _pageController,
                                totalPages: _listHandover.length,
                                onPageChanged: (int newIndex) {
                                  if (newIndex != _currentPage) {
                                    setState(() {
                                      _currentPage = newIndex;
                                    });
                                    _loadDetailsForPage(newIndex);
                                    _preloadNearbyPages(newIndex);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

// Widget tối ưu cho từng page item trong PageView
// Sử dụng AutomaticKeepAliveClientMixin để giữ state khi scroll
class _PageViewItem extends StatefulWidget {
  final int index;
  final ToolAndSuppliesHandoverDto item;
  final ToolAndMaterialTransferDto  itemTransfers; // Lấy chi tiết điều chuyển từ biên bản bàn giao
  final List<DetailSubppliesHandoverDto> itemsDetail;
  final bool isLoading;
  final VoidCallback onLoadDetails;
  final ToolAndSuppliesHandoverProvider provider;
  final PageController? pageController;
  final ValueChanged<int>? onPageChanged;
  final int totalPages;

  const _PageViewItem({
    required this.index,
    required this.item,
    required this.itemTransfers,
    required this.itemsDetail,
    required this.isLoading,
    required this.onLoadDetails,
    required this.provider,
    this.pageController,
    this.onPageChanged,
    required this.totalPages,
  });

  @override
  State<_PageViewItem> createState() => _PageViewItemState();
}

class _PageViewItemState extends State<_PageViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Nếu đang load chi tiết
    if (widget.isLoading || widget.itemsDetail.isEmpty) {
      if (!widget.isLoading) {
        // Trigger load nếu chưa bắt đầu load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onLoadDetails();
        });
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Đang tải chi tiết biên bản...',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Biên bản: ${widget.item.banGiaoCCDCVatTu ?? widget.item.id ?? ""}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    List<DetailSubppliesHandoverDto> listDetailSubppliesHandover =
        (widget.item.listDetailSubppliesHandover ?? []).map((e) {
          final foundDetail =
              widget.itemTransfers.detailToolAndMaterialTransfers
                  ?.where((element) => element.id == e.idChiTietDieuDong)
                  .firstOrNull;

          return e.copyWith(
            chiTietDieuDongCCDCVatTuDTO:
                foundDetail != null
                    ? foundDetail.copyWith(soLuong: e.soLuong)
                    : e.chiTietDieuDongCCDCVatTuDTO,
          );
        }).toList();

    // Hiển thị biên bản bàn giao bằng ContractPage.assetHandoverPageV2
    return RepaintBoundary(
      child: _AssetHandoverPreviewContent(
        item: widget.item,
        itemsDetail: listDetailSubppliesHandover,
        provider: widget.provider,
        pageController: widget.pageController,
        totalPages: widget.totalPages,
        currentIndex: widget.index,
        onHorizontalDrag:
            widget.onPageChanged != null
                ? (direction) {
                  // direction: -1 = left (next), 1 = right (previous)
                  final newIndex =
                      direction < 0 ? widget.index + 1 : widget.index - 1;
                  if (newIndex >= 0) {
                    widget.onPageChanged?.call(newIndex);
                  }
                }
                : null,
      ),
    );
  }
}

// Widget để hiển thị preview biên bản bàn giao trong PageView
// Dùng logic từ previewDocumentHandover nhưng không showDialog
// Tối ưu với cache để tránh tính lại
class _AssetHandoverPreviewContent extends StatefulWidget {
  final ToolAndSuppliesHandoverDto item;
  final List<DetailSubppliesHandoverDto> itemsDetail;
  final ToolAndSuppliesHandoverProvider provider;
  final PageController? pageController;
  final ValueChanged<int>? onHorizontalDrag;
  final int totalPages;
  final int currentIndex;

  const _AssetHandoverPreviewContent({
    required this.item,
    required this.itemsDetail,
    required this.provider,
    this.pageController,
    this.onHorizontalDrag,
    required this.totalPages,
    required this.currentIndex,
  });

  @override
  State<_AssetHandoverPreviewContent> createState() =>
      _AssetHandoverPreviewContentState();
}

class _AssetHandoverPreviewContentState
    extends State<_AssetHandoverPreviewContent> {
  // Cache các giá trị tính toán để tránh tính lại nhiều lần
  List<SigneInfo>? _cachedSigneInfo;
  String? _cachedItemId;
  String? _cachedUrlChuKyNhay;
  String? _cachedUrlChuKyThuong;
  String? _cachedIdNguoiKy;
  String? _cachedTenNguoiKy;
  int? _cachedPin;
  bool? _cachedIsSavePin;
  bool? _cachedIsKyNhay;
  bool? _cachedIsKyThuong;
  bool? _cachedIsKySo;
  NhanVien? _cachedNhanVien;

  String getChucVu(String idUser) {
    final nhanVien = AccountHelper.instance.getNhanVienById(idUser);
    final chucVu = AccountHelper.instance.getChucVuById(
      nhanVien?.chucVuId ?? '',
    );
    return chucVu?.tenChucVu ?? '';
  }

  String getDonVi(String idUser) {
    final nhanVien = AccountHelper.instance.getNhanVienById(idUser);
    final donVi = AccountHelper.instance.getDepartmentById(
      nhanVien?.phongBanId ?? '',
    );
    return donVi?.tenPhongBan ?? '';
  }

  bool isCheckKho(String idnhanvien) {
    final nhanVien = AccountHelper.instance.getNhanVienById(idnhanvien);
    final phongBan = AccountHelper.instance.getDepartmentById(
      nhanVien?.phongBanId ?? '',
    );
    return phongBan?.isKho == true;
  }

  List<SigneInfo> _buildSigneInfoList() {
    // Cache listSigneInfo để tránh tính lại
    if (_cachedSigneInfo != null && _cachedItemId == widget.item.id) {
      return _cachedSigneInfo!;
    }

    final listSigneInfo = <SigneInfo>[
      SigneInfo(
        idNhanVien: widget.item.idDaiDienBenGiao ?? '',
        title: 'Đại diện đơn vị bên giao',
        hoTen: widget.item.tenDaiDienBenGiao ?? '',
        chucVu: getChucVu(widget.item.idDaiDienBenGiao ?? ''),
        donVi:
            isCheckKho(widget.item.idDaiDienBenGiao ?? '')
                ? AccountHelper.instance
                        .getDepartmentById(widget.item.idDonViGiao ?? '')
                        ?.tenPhongBan ??
                    ''
                : getDonVi(widget.item.idDaiDienBenGiao ?? ''),
      ),
      SigneInfo(
        idNhanVien: widget.item.idDaiDienBenNhan ?? '',
        title: 'Đại diện đơn vị bên nhận',
        hoTen: widget.item.tenDaiDienBenNhan ?? '',
        chucVu: getChucVu(widget.item.idDaiDienBenNhan ?? ''),
        donVi:
            isCheckKho(widget.item.idDaiDienBenNhan ?? '')
                ? AccountHelper.instance
                        .getDepartmentById(widget.item.idDonViNhan ?? '')
                        ?.tenPhongBan ??
                    ''
                : getDonVi(widget.item.idDaiDienBenNhan ?? ''),
      ),
      for (int i = 0; i < (widget.item.listSignatory?.length ?? 0); i++)
        SigneInfo(
          idNhanVien: widget.item.listSignatory?[i].idNguoiKy ?? '',
          title: 'Đại diện ký ${i + 1}',
          hoTen: widget.item.listSignatory?[i].tenNguoiKy ?? '',
          chucVu: getChucVu(widget.item.listSignatory?[i].idNguoiKy ?? ''),
          donVi: getDonVi(widget.item.listSignatory?[i].idNguoiKy ?? ''),
        ),
      SigneInfo(
        idNhanVien: widget.item.idGiamDoc ?? '',
        title: 'Giám đốc ký duyệt',
        hoTen: widget.item.tenGiamDoc ?? '',
        chucVu: getChucVu(widget.item.idGiamDoc ?? ''),
        donVi: getChucVu(widget.item.idGiamDoc ?? ''),
      ),
    ];

    _cachedSigneInfo = listSigneInfo;
    _cachedItemId = widget.item.id;
    return listSigneInfo;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = AccountHelper.instance.getUserInfo();
    if (userInfo == null) {
      return const Center(child: Text('Không có thông tin người dùng'));
    }

    // Cache các giá trị để tránh tính lại
    if (_cachedItemId != widget.item.id) {
      final nhanVien = widget.provider.getNhanVien(
        idNhanVien: userInfo.tenDangNhap,
      );
      final tenFileChuKyNhay = path.basename(nhanVien.chuKyNhay.toString());
      final tenFileChuKyThuong = path.basename(nhanVien.chuKyThuong.toString());

      _cachedNhanVien = nhanVien;
      _cachedUrlChuKyNhay =
          '${Config.baseUrl}/api/upload/download/$tenFileChuKyNhay';
      _cachedUrlChuKyThuong =
          '${Config.baseUrl}/api/upload/download/$tenFileChuKyThuong';
      _cachedIdNguoiKy = userInfo.tenDangNhap;
      _cachedTenNguoiKy = userInfo.hoTen;
      _cachedPin = int.tryParse(nhanVien.pin ?? '') ?? 0;
      _cachedIsSavePin = nhanVien.savePin ?? false;
      _cachedIsKyNhay = nhanVien.kyNhay ?? false;
      _cachedIsKyThuong = nhanVien.kyThuong ?? false;
      _cachedIsKySo = nhanVien.kySo ?? false;
      _cachedItemId = widget.item.id;
    }

    final listSigneInfo = _buildSigneInfoList();

    // Hiển thị CommonContract trực tiếp trong PageView (không showDialog)
    Widget contractWidget = CommonContract(
      contractPages: [
        A4Canvas(
          marginsMm: const EdgeInsets.all(20),
          scale: 1.0,
          maxWidth: 800,
          maxHeight: 800 * (297 / 210),
          child: ContractPage.toolAndSuppliesHandoverPageV2(
            widget.item,
            widget.itemsDetail,
            listSigneInfo,
          ),
        ),
      ],
      signatureList: [_cachedUrlChuKyNhay!, _cachedUrlChuKyThuong!],
      idTaiLieu: widget.item.id.toString(),
      idNguoiKy: _cachedIdNguoiKy!,
      tenNguoiKy: _cachedTenNguoiKy!,
      nhanVien: _cachedNhanVien!,
      pin: _cachedPin!,
      isSavePin: _cachedIsSavePin!,
      isShowKy: false, // Không hiển thị nút ký trong PageView
      isKyNhay: _cachedIsKyNhay!,
      isKyThuong: _cachedIsKyThuong!,
      isKySo: _cachedIsKySo!,
      showHeader: false,
    );

    // Trên web, wrap trong GestureDetector để xử lý drag ngang
    // Cho phép drag ngang đi qua để PageView xử lý, nhưng vẫn cho phép scroll dọc trong CommonContract
    if (kIsWeb && widget.pageController != null) {
      return _WebDragHandler(
        pageController: widget.pageController!,
        currentIndex: widget.currentIndex,
        totalPages: widget.totalPages,
        child: contractWidget,
      );
    }

    return contractWidget;
  }
}

// Widget để xử lý drag ngang trên web
// Cho phép drag ngang để chuyển page mượt mà, nhưng vẫn cho phép scroll dọc trong CommonContract
class _WebDragHandler extends StatefulWidget {
  final Widget child;
  final PageController pageController;
  final int currentIndex;
  final int totalPages;

  const _WebDragHandler({
    required this.child,
    required this.pageController,
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  State<_WebDragHandler> createState() => _WebDragHandlerState();
}

class _WebDragHandlerState extends State<_WebDragHandler> {
  double? _dragStartX;
  double? _dragStartY;
  bool _isHorizontalDrag = false;
  double _dragOffset = 0.0;
  double? _initialPage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      // Detect khi bắt đầu drag
      onPanStart: (details) {
        _dragStartX = details.globalPosition.dx;
        _dragStartY = details.globalPosition.dy;
        _isHorizontalDrag = false;
        _dragOffset = 0.0;
        // Lưu page hiện tại để tính toán offset
        if (widget.pageController.hasClients) {
          _initialPage = widget.pageController.page;
        }
      },
      // Track drag để xác định hướng và cập nhật PageView real-time
      onPanUpdate: (details) {
        if (_dragStartX == null || _dragStartY == null) return;

        final deltaX = details.globalPosition.dx - _dragStartX!;
        final deltaY = (details.globalPosition.dy - _dragStartY!).abs();
        final deltaXAbs = deltaX.abs();

        // Xác định hướng drag
        if (!_isHorizontalDrag && deltaXAbs > 10 && deltaXAbs > deltaY * 1.5) {
          _isHorizontalDrag = true;
        }

        // Nếu là drag ngang, cập nhật PageView trong quá trình drag
        if (_isHorizontalDrag &&
            widget.pageController.hasClients &&
            _initialPage != null) {
          // Tính offset dựa trên drag distance
          // Drag sang trái (deltaX < 0) = next page, drag sang phải (deltaX > 0) = previous page
          final normalizedOffset =
              -deltaX / screenWidth; // Đảo ngược để drag trái = tăng page
          final newPage = (_initialPage! + normalizedOffset).clamp(
            0.0,
            (widget.totalPages - 1).toDouble(),
          );

          // Cập nhật PageView mượt mà trong quá trình drag
          // Sử dụng position để điều khiển scroll offset trực tiếp
          final position = widget.pageController.position;
          if (position.hasContentDimensions) {
            final pageWidth = position.viewportDimension;
            widget.pageController.jumpTo(newPage * pageWidth);
          }
          _dragOffset = normalizedOffset;
        }
      },
      // Khi kết thúc drag, animate đến page gần nhất hoặc page tiếp theo dựa trên velocity
      onPanEnd: (details) {
        if (_isHorizontalDrag &&
            widget.pageController.hasClients &&
            _initialPage != null) {
          final velocity = details.velocity.pixelsPerSecond.dx;
          final velocityAbs = velocity.abs();

          int targetPage = _initialPage!.round();

          // Nếu drag nhanh (velocity > 500), chuyển page dựa trên hướng drag
          if (velocityAbs > 500) {
            if (velocity < 0) {
              // Drag sang trái nhanh - next page
              targetPage = (_initialPage! + 1).round();
            } else {
              // Drag sang phải nhanh - previous page
              targetPage = (_initialPage! - 1).round();
            }
          } else if (_dragOffset.abs() > 0.3) {
            // Nếu drag đủ xa (> 30% màn hình), chuyển page
            if (_dragOffset < 0) {
              targetPage = (_initialPage! + 1).round();
            } else {
              targetPage = (_initialPage! - 1).round();
            }
          }

          // Đảm bảo targetPage trong phạm vi hợp lệ
          targetPage = targetPage.clamp(0, widget.totalPages - 1);

          // Animate đến page đích với animation mượt mà
          if (targetPage != _initialPage!.round()) {
            widget.pageController.animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            );
          } else {
            // Nếu không chuyển page, animate về page hiện tại
            widget.pageController.animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        }

        _dragStartX = null;
        _dragStartY = null;
        _isHorizontalDrag = false;
        _dragOffset = 0.0;
        _initialPage = null;
      },
      // Cho phép gesture đi qua để CommonContract vẫn có thể scroll dọc
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
