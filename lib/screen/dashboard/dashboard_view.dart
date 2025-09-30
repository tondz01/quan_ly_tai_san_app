import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart' as graphic;
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_text_style.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:quan_ly_tai_san_app/core/enum/type_size_screen.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/pie_with_legend.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/scrollable_bar_chart.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/horizontal_progress_chart.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/repository/dashboard_reponsitory.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final DashboardRepository _dashboardRepository = DashboardRepository();

  // Asset status data
  List<dynamic> _assetStatusData = [];
  bool _isLoadingAssetStatus = false;
  String? _assetStatusError;

  // CCDC status data
  List<dynamic> _ccdcStatusData = [];
  bool _isLoadingCcdcStatus = false;
  String? _ccdcStatusError;

  // Asset group distribution data
  Map<String, dynamic> _assetGroupData = {};
  List<String> _availableGroups = [];
  String? _selectedGroup;
  bool _isLoadingAssetGroup = false;
  String? _assetGroupError;

  // CCDC group distribution data
  Map<String, dynamic> _ccdcGroupData = {};
  List<String> _availableCcdcGroups = [];
  String? _selectedCcdcGroup;
  bool _isLoadingCcdcGroup = false;
  String? _ccdcGroupError;

  // Asset depreciation data
  List<dynamic> _depreciationData = [];
  bool _isLoadingDepreciation = false;
  String? _depreciationError;
  int _displayCount = 20; // Default display count

  @override
  void initState() {
    super.initState();
    _loadAssetStatusData();
    _loadCcdcStatusData();
    _loadAssetGroupData();
    _loadCcdcGroupData();
    _loadDepreciationData();
  }

  Future<void> _loadAssetStatusData() async {
    setState(() {
      _isLoadingAssetStatus = true;
      _assetStatusError = null;
    });

    try {
      final result = await _dashboardRepository.getAssetStatusData();

      if (result['status_code'] == 200) {
        setState(() {
          _assetStatusData = result['data'] ?? [];
          _isLoadingAssetStatus = false;
        });
      } else {
        setState(() {
          _assetStatusError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingAssetStatus = false;
        });
      }
    } catch (e) {
      setState(() {
        _assetStatusError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingAssetStatus = false;
      });
    }
  }

  Future<void> _loadCcdcStatusData() async {
    setState(() {
      _isLoadingCcdcStatus = true;
      _ccdcStatusError = null;
    });

    try {
      final result = await _dashboardRepository.getCcdcStatusData();

      if (result['status_code'] == 200) {
        setState(() {
          _ccdcStatusData = result['data'] ?? [];
          _isLoadingCcdcStatus = false;
        });
      } else {
        setState(() {
          _ccdcStatusError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingCcdcStatus = false;
        });
      }
    } catch (e) {
      setState(() {
        _ccdcStatusError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingCcdcStatus = false;
      });
    }
  }

  Future<void> _loadAssetGroupData() async {
    setState(() {
      _isLoadingAssetGroup = true;
      _assetGroupError = null;
    });

    try {
      final result = await _dashboardRepository.getAssetGroupDistributionData();

      if (result['status_code'] == 200) {
        setState(() {
          _assetGroupData = result['data'] ?? {};
          _availableGroups =
              _assetGroupData.keys.where((key) {
                final groupData = _assetGroupData[key] as List<dynamic>?;
                return groupData != null && groupData.isNotEmpty;
              }).toList();
          _selectedGroup =
              _availableGroups.isNotEmpty ? _availableGroups.first : null;
          _isLoadingAssetGroup = false;
        });
      } else {
        setState(() {
          _assetGroupError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingAssetGroup = false;
        });
      }
    } catch (e) {
      setState(() {
        _assetGroupError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingAssetGroup = false;
      });
    }
  }

  Future<void> _loadCcdcGroupData() async {
    setState(() {
      _isLoadingCcdcGroup = true;
      _ccdcGroupError = null;
    });

    try {
      final result = await _dashboardRepository.getCcdcGroupDistributionData();

      if (result['status_code'] == 200) {
        setState(() {
          _ccdcGroupData = result['data'] ?? {};
          _availableCcdcGroups =
              _ccdcGroupData.keys.where((key) {
                final groupData = _ccdcGroupData[key] as List<dynamic>?;
                return groupData != null && groupData.isNotEmpty;
              }).toList();
          _selectedCcdcGroup =
              _availableCcdcGroups.isNotEmpty
                  ? _availableCcdcGroups.first
                  : null;
          _isLoadingCcdcGroup = false;
        });
      } else {
        setState(() {
          _ccdcGroupError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingCcdcGroup = false;
        });
      }
    } catch (e) {
      setState(() {
        _ccdcGroupError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingCcdcGroup = false;
      });
    }
  }

  Future<void> _loadDepreciationData() async {
    setState(() {
      _isLoadingDepreciation = true;
      _depreciationError = null;
    });

    try {
      final result = await _dashboardRepository.getAssetDepreciationData();

      if (result['status_code'] == 200) {
        setState(() {
          _depreciationData = result['data'] ?? [];
          _isLoadingDepreciation = false;
        });
      } else {
        setState(() {
          _depreciationError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingDepreciation = false;
        });
      }
    } catch (e) {
      setState(() {
        _depreciationError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingDepreciation = false;
      });
    }
  }

  // Dữ liệu mẫu từ API
  final Map<String, dynamic> apiData = {
    "success": true,
    "message": "Lấy thống kê dashboard thành công",
    "data": {
      "giaTriTheoCongTy": [
        {"congTy": "Công ty ABC", "soLuong": 9, "tongGiaTri": 1.7050715103E10},
      ],
      "taiSanTheoTrangThaiPhanTram": [
        {
          "trangThai": "Đang sử dụng",
          "soLuong": 8,
          "tongGiaTri": 3.050715103E9,
          "phanTramSoLuong": 88.89,
          "phanTramGiaTri": 17.89,
        },
        {
          "trangThai": "Mất",
          "soLuong": 1,
          "tongGiaTri": 1.4E10,
          "phanTramSoLuong": 11.11,
          "phanTramGiaTri": 82.11,
        },
      ],
      "taiSanTheoLoai": [],
      "taiSanTheoTrangThai": [
        {
          "trangThai": "Đang sử dụng",
          "soLuong": 8,
          "tongGiaTri": 3.050715103E9,
        },
        {"trangThai": "Mất", "soLuong": 1, "tongGiaTri": 1.4E10},
      ],
      "taiSanTheoDuAnPhanTram": [],
      "taiSanTheoCongTyPhanTram": [
        {
          "congTy": "Công ty ABC",
          "soLuong": 9,
          "tongGiaTri": 1.7050715103E10,
          "phanTramSoLuong": 100.00,
          "phanTramGiaTri": 100.0,
        },
      ],
      "ccdcTheoPhongBan": [
        {
          "phongBan": "Phân xưởng Cơ giới -Cơ khí 1",
          "tongSoLuong": 139,
          "tongGiaTri": 5.5175E8,
        },
      ],
      "tongTaiSan": 9,
      "taiSanTheoLoaiConPhanTram": [
        {
          "ten": "Máy",
          "idLoaiTaiSan": "TS_MMTB",
          "tenLoai": "Máy",
          "soLuong": 4,
          "tongGiaTri": 1.4001255555E10,
          "phanTramSoLuong": 44.44,
          "phanTramGiaTri": 82.12,
        },
      ],
      "taiSanTheoNhomPhanTram": [
        {
          "ten": "Máy móc, Trang thiết bị",
          "soLuong": 8,
          "tongGiaTri": 3.050715103E9,
          "phanTramSoLuong": 88.89,
          "phanTramGiaTri": 17.89,
        },
      ],
      "top5TaiSanGiaTriCao": [
        {
          "TenTaiSan": "Nhà thờ 120 tỏi của HL",
          "NguyenGia": 1.4E10,
          "IdLoaiTaiSan": null,
          "IdNhomTaiSan": "NT",
          "HienTrang": 4,
        },
        {
          "TenTaiSan": "Trạm BA 560 KVA (22)-6/0,4-0,23 KV",
          "NguyenGia": 1.62474E9,
          "IdLoaiTaiSan": null,
          "IdNhomTaiSan": "TS_MMTB",
          "HienTrang": 1,
        },
        {
          "TenTaiSan":
              "Trạm biến áp 400KVA-6/0,4KV MB +30 Tràng khê ( Cung cấp điện nhà điều hành )",
          "NguyenGia": 1.09898E9,
          "IdLoaiTaiSan": null,
          "IdNhomTaiSan": "TS_MMTB",
          "HienTrang": 1,
        },
        {
          "TenTaiSan":
              "Tủ cầu dao phòng nổ 6KV ( máy cắt phòng nổ ) mã hiệu PJG9L-630/6 ( Thiết bị khống chế và bảo vệ mạng điện )",
          "NguyenGia": 1.49437E8,
          "IdLoaiTaiSan": null,
          "IdNhomTaiSan": "TS_MMTB",
          "HienTrang": 1,
        },
        {
          "TenTaiSan": "Tủ nạp ắc quy",
          "NguyenGia": 1.41359E8,
          "IdLoaiTaiSan": null,
          "IdNhomTaiSan": "TS_MMTB",
          "HienTrang": 1,
        },
      ],
      "tongCCDC": 3,
      "taiSanTheoQuy": [
        {"nam": 2025, "quy": 3, "soLuong": 9, "tongGiaTri": 1.7050715103E10},
      ],
      "giaTriTheoNguonVon": [
        {
          "nguonVon": "Vốn Tự Bổ Sung",
          "soLuong": 5,
          "tongGiaTri": 2.724982531E9,
        },
      ],
      "tongNhanVien": 23,
      "taiSanTheoLoaiChinhPhanTram": [],
      "taiSanTheoLoaiChinhChiTietPhanTram": [],
      "tongNguyenGia": 1.7050715103E10,
      "taiSanTheoNamTao": [
        {"nam": 2025, "soLuong": 9, "tongGiaTri": 1.7050715103E10},
      ],
      "tongPhongBan": 94,
      "tongCongTy": 1,
      "taiSanTheoThang": [
        {"nam": 2025, "thang": 9, "soLuong": 9, "tongGiaTri": 1.7050715103E10},
      ],
      "ccdcTheoLoai": [
        {
          "ten": "TEST-02",
          "soLuong": 3,
          "tongSoLuong": 139,
          "tongGiaTri": 5.5175E8,
        },
      ],
      "taiSanSapHetHanBaoHanh": [
        {
          "Id": "Test_002",
          "TenTaiSan": "Test 01",
          "NguyenGia": 55555.0,
          "NgayVaoSo": "2025-09-18 22:53:00",
          "ThoiHanBaoHanh": "Không có thông tin bảo hành",
          "NgayHetHanBaoHanh": "Không có thông tin bảo hành",
          "SoNgayConLai": 0,
        },
      ],
      "taiSanTheoPhongBan": [
        {
          "phongBan": "Phân xưởng Cơ điện lò 2",
          "soLuong": 4,
          "tongGiaTri": 1.625997571E9,
        },
        {"phongBan": "Phòng Giám Đốc", "soLuong": 1, "tongGiaTri": 1.4E10},
      ],
      "ccdcTheoLoaiConChiTietPhanTram": [
        {
          "ten": "TEST-02",
          "idLoaiCCDC": "NCCDC001",
          "tenLoai": "TEST-02",
          "soLuong": 3,
          "tongSoLuong": 139,
          "tongGiaTri": 5.5175E8,
          "phanTramSoLuong": 100.00,
          "phanTramTongSoLuong": 100.00,
          "phanTramGiaTri": 100.0,
        },
      ],
      "tongDuAn": 6,
      "taiSanTheoNhom": [
        {
          "ten": "Máy móc, Trang thiết bị",
          "soLuong": 8,
          "tongGiaTri": 3.050715103E9,
        },
      ],
      "taiSanCanBaoTri": [],
      "giaTriTheoDuAn": [],
      "taiSanTheoLoaiConChiTietPhanTram": [
        {
          "idLoaiTaiSanCon": "lts_01",
          "tenLoaiTaiSanCon": "Máy",
          "idLoaiTaiSan": "TS_MMTB",
          "tenLoaiTaiSan": null,
          "soLuong": 4,
          "tongGiaTri": 1.4001255555E10,
          "phanTramSoLuong": 44.44,
          "phanTramGiaTri": 82.12,
        },
      ],
      "taiSanTheoNguonVonPhanTram": [
        {
          "nguonVon": "Vốn Tự Bổ Sung",
          "soLuong": 5,
          "tongGiaTri": 2.724982531E9,
          "phanTramSoLuong": 55.56,
          "phanTramGiaTri": 15.98,
        },
      ],
      "taiSanTheoPhongBanPhanTram": [
        {
          "phongBan": "Phân xưởng Cơ điện lò 2",
          "soLuong": 4,
          "tongGiaTri": 1.625997571E9,
          "phanTramSoLuong": 44.44,
          "phanTramGiaTri": 9.54,
        },
        {
          "phongBan": "Phòng Giám Đốc",
          "soLuong": 1,
          "tongGiaTri": 1.4E10,
          "phanTramSoLuong": 11.11,
          "phanTramGiaTri": 82.11,
        },
      ],
      "tongGiaTriCCDC": 5.5175E8,
      "ccdcTheoPhongBanPhanTram": [
        {
          "phongBan": "Phân xưởng Cơ giới -Cơ khí 1",
          "soLuong": 3,
          "tongSoLuong": 139,
          "tongGiaTri": 5.5175E8,
          "phanTramSoLuong": 100.00,
          "phanTramTongSoLuong": 100.00,
          "phanTramGiaTri": 100.0,
        },
      ],
      "ccdcTheoLoaiChinhChiTietPhanTram": [
        {
          "idLoaiCCDC": "NCCDC001",
          "tenLoaiCCDC": "Không có bảng LoaiCCDC",
          "soLuong": 3,
          "tongSoLuong": 139,
          "tongGiaTri": 5.5175E8,
          "phanTramSoLuong": 100.00,
          "phanTramTongSoLuong": 100.00,
          "phanTramGiaTri": 100.0,
        },
      ],
      "taiSanChuaDieuDong": [
        {
          "Id": "HL14T",
          "TenTaiSan": "Nhà thờ 120 tỏi của HL",
          "NguyenGia": 1.4E10,
          "HienTrang": 4,
          "TenLoaiTaiSan": null,
          "TenNhom": null,
          "TenPhongBan": "Phòng Giám Đốc",
        },
      ],
      "ccdcTheoLoaiConPhanTram": [
        {
          "ten": "TEST-02",
          "idLoaiCCDC": "NCCDC001",
          "tenLoai": "TEST-02",
          "soLuong": 3,
          "tongSoLuong": 139,
          "tongGiaTri": 5.5175E8,
          "phanTramSoLuong": 100.00,
          "phanTramTongSoLuong": 100.00,
          "phanTramGiaTri": 100.0,
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final data = apiData['data'] as Map<String, dynamic>;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade50,
            Colors.blue.shade50,
            Colors.indigo.shade50,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticsSection(data),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildAssetStatusSection(data)),
                const SizedBox(width: 24),
                Expanded(child: _buildCcdcStatusSection(data)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildAssetGroupDistributionSection(data)),
                const SizedBox(width: 24),
                Expanded(child: _buildCcdcGroupDistributionSection(data)),
              ],
            ),
            const SizedBox(height: 24),
            _buildTopAssetsSection(data),
            const SizedBox(height: 24),
            _buildTrendAnalysisSection(data),
            const SizedBox(height: 24),
            _buildMaintenanceSection(data),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue.shade50, Colors.indigo.shade50],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.indigo.shade700],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.dashboard, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGText(
                    text: "📊 Tổng quan thống kê",
                    style: AppTextStyle.textStyleSemiBold24.copyWith(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    "Thống kê tổng quan về tài sản và thiết bị",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              mainAxisExtent: 160,
            ),
            children: [
              _buildEnhancedStatisticsCard(
                'Tổng tài sản',
                data['tongTaiSan'].toString(),
                Icons.inventory_2,
                [Colors.purple.shade400, Colors.purple.shade600],
              ),
              _buildEnhancedStatisticsCard(
                'Tổng nguyên giá',
                formatter.format(data['tongNguyenGia'] ?? 0),
                Icons.attach_money,
                [Colors.green.shade400, Colors.green.shade600],
              ),
              _buildEnhancedStatisticsCard(
                'Tổng CCDC',
                data['tongCCDC'].toString(),
                Icons.build,
                [Colors.orange.shade400, Colors.orange.shade600],
              ),
              _buildEnhancedStatisticsCard(
                'Tổng giá trị CCDC',
                formatter.format(data['tongGiaTriCCDC'] ?? 0),
                Icons.monetization_on,
                [Colors.teal.shade400, Colors.teal.shade600],
              ),
              _buildEnhancedStatisticsCard(
                'Tổng nhân viên',
                data['tongNhanVien'].toString(),
                Icons.people,
                [Colors.indigo.shade400, Colors.indigo.shade600],
              ),
              _buildEnhancedStatisticsCard(
                'Tổng phòng ban',
                data['tongPhongBan'].toString(),
                Icons.business,
                [Colors.pink.shade400, Colors.pink.shade600],
              ),
              _buildEnhancedStatisticsCard(
                'Tổng dự án',
                data['tongDuAn'].toString(),
                Icons.folder,
                [Colors.cyan.shade400, Colors.cyan.shade600],
              ),
              _buildEnhancedStatisticsCard(
                'Tổng công ty',
                data['tongCongTy'].toString(),
                Icons.corporate_fare,
                [Colors.amber.shade400, Colors.amber.shade600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetStatusSection(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SGText(
                  text: "📊 Tài sản theo hiện trạng",
                  style: AppTextStyle.textStyleSemiBold24.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              if (_assetStatusError != null)
                IconButton(
                  onPressed: _loadAssetStatusData,
                  icon: Icon(Icons.refresh, color: Colors.blue.shade600),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoadingAssetStatus)
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_assetStatusError != null)
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      _assetStatusError!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _loadAssetStatusData,
                      icon: Icon(Icons.refresh, size: 16),
                      label: Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_assetStatusData.isNotEmpty)
            HorizontalProgressChart(
              data:
                  _assetStatusData
                      .map(
                        (item) => <String, dynamic>{
                          'label': item['TenHienTrang'] ?? 'Chưa xác định',
                          'value': item['SoLuong'] ?? 0,
                          'percentage': item['TiLePhanTram'] ?? 0,
                        },
                      )
                      .toList(),
              labelKey: 'label',
              valueKey: 'value',
              percentageKey: 'percentage',
              colors: [
                Colors.blue.shade600,
                Colors.green.shade600,
                Colors.orange.shade600,
                Colors.red.shade600,
                Colors.purple.shade600,
                Colors.teal.shade600,
              ],
              height: 200,
              showValues: true,
              showPercentages: true,
            )
          else
            Container(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có dữ liệu tài sản',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCcdcStatusSection(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.green.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SGText(
                  text: "🔧 CCDC theo hiện trạng",
                  style: AppTextStyle.textStyleSemiBold24.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              if (_ccdcStatusError != null)
                IconButton(
                  onPressed: _loadCcdcStatusData,
                  icon: Icon(Icons.refresh, color: Colors.green.shade600),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoadingCcdcStatus)
            Container(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.green.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_ccdcStatusError != null)
            Container(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      _ccdcStatusError!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _loadCcdcStatusData,
                      icon: Icon(Icons.refresh, size: 16),
                      label: Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_ccdcStatusData.isNotEmpty)
            HorizontalProgressChart(
              data:
                  _ccdcStatusData
                      .map(
                        (item) => <String, dynamic>{
                          'label': item['TenHienTrang'] ?? 'Chưa xác định',
                          'value': item['SoLuong'] ?? 0,
                          'percentage': item['TiLePhanTram'] ?? 0,
                        },
                      )
                      .toList(),
              labelKey: 'label',
              valueKey: 'value',
              percentageKey: 'percentage',
              colors: [
                Colors.green.shade600,
                Colors.blue.shade600,
                Colors.orange.shade600,
                Colors.red.shade600,
                Colors.purple.shade600,
                Colors.teal.shade600,
              ],
              height: 200,
              showValues: true,
              showPercentages: true,
            )
          else
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.build_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có dữ liệu CCDC',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssetGroupDistributionSection(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade600, Colors.purple.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SGText(
                  text: "📊 Phân bố tài sản theo nhóm",
                  style: AppTextStyle.textStyleSemiBold24.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              if (_assetGroupError != null)
                IconButton(
                  onPressed: _loadAssetGroupData,
                  icon: Icon(Icons.refresh, color: Colors.purple.shade600),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoadingAssetGroup)
            Container(
              height: 450,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.purple.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_assetGroupError != null)
            Container(
              height: 450,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      _assetGroupError!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _loadAssetGroupData,
                      icon: Icon(Icons.refresh, size: 16),
                      label: Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_availableGroups.isNotEmpty)
            Column(
              children: [
                // Group selector
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedGroup,
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text('Chọn nhóm tài sản'),
                    items:
                        _availableGroups.map((String group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(
                              group,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGroup = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Chart
                if (_selectedGroup != null)
                  _buildGroupChart(_selectedGroup!)
                else
                  Container(
                    height: 450,
                    child: Center(
                      child: Text(
                        'Vui lòng chọn nhóm tài sản',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          else
            Container(
              height: 450,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có dữ liệu nhóm tài sản',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGroupChart(String groupName) {
    final groupData = _assetGroupData[groupName] as List<dynamic>? ?? [];

    if (groupData.isEmpty) {
      return Container(
        height: 450,
        child: Center(
          child: Text(
            'Nhóm "$groupName" không có dữ liệu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Center(
      child: PieDonutChartWithLegend(
        data:
            groupData
                .map(
                  (item) => <String, Object>{
                    'label': item['TenLoai'] ?? 'Chưa xác định',
                    'value': item['SoLuong'] ?? 0,
                    'percentage': item['TiLePhanTram'] ?? 0,
                  },
                )
                .toList(),
        categoryKey: 'label',
        valueKey: 'value',
        colors: [
          Colors.purple.shade600,
          Colors.blue.shade600,
          Colors.green.shade600,
          Colors.orange.shade600,
          Colors.red.shade600,
          Colors.teal.shade600,
          Colors.indigo.shade600,
          Colors.pink.shade600,
        ],
        chartWidth: 400,
        chartHeight: 400,
      ),
    );
  }

  Widget _buildCcdcGroupDistributionSection(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.orange.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade600, Colors.orange.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SGText(
                  text: "🔧 Phân bố CCDC theo nhóm",
                  style: AppTextStyle.textStyleSemiBold24.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              if (_ccdcGroupError != null)
                IconButton(
                  onPressed: _loadCcdcGroupData,
                  icon: Icon(Icons.refresh, color: Colors.orange.shade600),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoadingCcdcGroup)
            Container(
              height: 450,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.orange.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_ccdcGroupError != null)
            Container(
              height: 450,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      _ccdcGroupError!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _loadCcdcGroupData,
                      icon: Icon(Icons.refresh, size: 16),
                      label: Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_availableCcdcGroups.isNotEmpty)
            Column(
              children: [
                // Group selector
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCcdcGroup,
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text('Chọn nhóm CCDC'),
                    items:
                        _availableCcdcGroups.map((String group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(
                              group,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCcdcGroup = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Chart
                if (_selectedCcdcGroup != null)
                  _buildCcdcGroupChart(_selectedCcdcGroup!)
                else
                  Container(
                    height: 450,
                    child: Center(
                      child: Text(
                        'Vui lòng chọn nhóm CCDC',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          else
            Container(
              height: 450,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.build_circle_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có dữ liệu nhóm CCDC',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCcdcGroupChart(String groupName) {
    final groupData = _ccdcGroupData[groupName] as List<dynamic>? ?? [];

    if (groupData.isEmpty) {
      return Container(
        height: 450,
        child: Center(
          child: Text(
            'Nhóm "$groupName" không có dữ liệu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Center(
      child: PieDonutChartWithLegend(
        data:
            groupData
                .map(
                  (item) => <String, Object>{
                    'label': item['TenLoai'] ?? 'Chưa xác định',
                    'value': item['SoLuong'] ?? 0,
                    'percentage': item['TiLePhanTram'] ?? 0,
                  },
                )
                .toList(),
        categoryKey: 'label',
        valueKey: 'value',
        colors: [
          Colors.orange.shade600,
          Colors.blue.shade600,
          Colors.green.shade600,
          Colors.purple.shade600,
          Colors.red.shade600,
          Colors.teal.shade600,
          Colors.indigo.shade600,
          Colors.pink.shade600,
        ],
        chartWidth: 400,
        chartHeight: 400,
      ),
    );
  }

  Widget _buildTopAssetsSection(Map<String, dynamic> data) {
    final topAssets = data['top5TaiSanGiaTriCao'] as List<dynamic>;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade600, Colors.indigo.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SGText(
                  text: "🏆 Top 5 tài sản giá trị cao",
                  style: AppTextStyle.textStyleSemiBold24.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: Colors.indigo.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Giá trị cao nhất',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 420,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 40,
              left: 100,
              right: 16,
            ),
            child: graphic.Chart(
              data:
                  topAssets
                      .map(
                        (item) => {
                          'tenTaiSan':
                              item['TenTaiSan'].toString().length > 25
                                  ? item['TenTaiSan'].toString().substring(
                                    0,
                                    25,
                                  )
                                  : item['TenTaiSan'].toString(),
                          'nguyenGia': item['NguyenGia'] ?? 0,
                        },
                      )
                      .toList(),
              variables: {
                'genre': graphic.Variable(
                  accessor: (Map map) => map['tenTaiSan'] as String,
                ),
                'sold': graphic.Variable(
                  accessor: (Map map) => map['nguyenGia'] as num,
                ),
              },
              marks: [
                graphic.IntervalMark(
                  label: graphic.LabelEncode(
                    encoder:
                        (tuple) => graphic.Label(
                          formatter.format(tuple['sold']),
                          graphic.LabelStyle(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  ),
                  gradient: graphic.GradientEncode(
                    value: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.indigo.shade300,
                        Colors.indigo.shade500,
                        Colors.indigo.shade700,
                      ],
                      stops: const [0, 0.5, 1],
                    ),
                    updaters: {
                      'tap': {
                        true:
                            (_) => LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.amber.shade300,
                                Colors.amber.shade500,
                                Colors.amber.shade700,
                              ],
                              stops: const [0, 0.5, 1],
                            ),
                      },
                    },
                  ),
                  modifiers: [graphic.StackModifier()],
                  transition: graphic.Transition(
                    duration: const Duration(milliseconds: 500),
                  ),
                  entrance: {graphic.MarkEntrance.y},
                ),
              ],
              coord: graphic.RectCoord(transposed: true),
              axes: [
                graphic.Defaults.verticalAxis
                  ..line = graphic.Defaults.strokeStyle
                  ..grid = null,
                graphic.Defaults.horizontalAxis
                  ..line = null
                  ..grid = graphic.Defaults.strokeStyle,
              ],
              selections: {'tap': graphic.PointSelection(dim: graphic.Dim.x)},
            ),
          ),
          const SizedBox(height: 16),
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Tổng giá trị',
                  formatter.format(
                    topAssets.fold<double>(
                      0,
                      (sum, item) =>
                          sum + ((item['NguyenGia'] as num?)?.toDouble() ?? 0),
                    ),
                  ),
                  Colors.indigo,
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Số lượng',
                  '${topAssets.length}',
                  Colors.green,
                  Icons.inventory,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Giá trị TB',
                  formatter.format(
                    topAssets.fold<double>(
                          0,
                          (sum, item) =>
                              sum +
                              ((item['NguyenGia'] as num?)?.toDouble() ?? 0),
                        ) /
                        topAssets.length,
                  ),
                  Colors.orange,
                  Icons.analytics,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color.withOpacity(0.9),
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysisSection(Map<String, dynamic> data) {
    final yearData = data['taiSanTheoNamTao'] as List<dynamic>;
    final monthData = data['taiSanTheoThang'] as List<dynamic>;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade600, Colors.indigo.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SGText(
                  text: "📈 Phân tích xu hướng",
                  style: AppTextStyle.textStyleSemiBold24.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: Colors.indigo.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Thống kê',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Tài sản theo năm tạo",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ScrollableBarChart(
                        data:
                            yearData
                                .map(
                                  (item) => <String, Object>{
                                    'nam': item['nam'].toString(),
                                    'soLuong': item['soLuong'] ?? 0,
                                  },
                                )
                                .toList(),
                        categoryKey: 'nam',
                        valueKey: 'soLuong',
                        barWidth: 32,
                        spacing: 64,
                        height: 300,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.timeline,
                              color: Colors.green.shade700,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Tài sản theo tháng",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ScrollableBarChart(
                        data:
                            monthData
                                .map(
                                  (item) => <String, Object>{
                                    'thang': item['thang'].toString(),
                                    'soLuong': item['soLuong'] ?? 0,
                                  },
                                )
                                .toList(),
                        categoryKey: 'thang',
                        valueKey: 'soLuong',
                        barWidth: 32,
                        spacing: 64,
                        height: 300,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection(Map<String, dynamic> data) {
    if (_isLoadingDepreciation) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.orange.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_depreciationError != null) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.red.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Lỗi tải dữ liệu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _depreciationError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDepreciationData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_depreciationData.isEmpty) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Không có dữ liệu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Không có tài sản nào sắp hết hạn khấu hao',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.orange.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade600, Colors.orange.shade800],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SGText(
                  text: "⚠️ Tài sản sắp hết hạn khấu hao",
                  style: AppTextStyle.textStyleSemiBold24.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Right side controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display count selector
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hiển thị:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _displayCount,
                          underline: const SizedBox(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade800,
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return [10, 20, 50, 100, -1].map<Widget>((
                              int value,
                            ) {
                              return Text(
                                value == -1 ? 'Tất cả' : '$value',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade800,
                                ),
                              );
                            }).toList();
                          },
                          items: [
                            DropdownMenuItem<int>(value: 10, child: Text('10')),
                            DropdownMenuItem<int>(value: 20, child: Text('20')),
                            DropdownMenuItem<int>(value: 50, child: Text('50')),
                            DropdownMenuItem<int>(
                              value: 100,
                              child: Text('100'),
                            ),
                            DropdownMenuItem<int>(
                              value: -1,
                              child: Text('Tất cả'),
                            ),
                          ],
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _displayCount = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_down,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_depreciationData.length} tài sản',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      MediaQuery.of(context).size.width -
                      48, // Full width minus padding
                ),
                child: DataTable(
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  columns: [
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'ID',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Tên tài sản',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Ngày sử dụng',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Số kỳ khấu hao',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Nguyên giá',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Ngày hết hạn',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Thời hạn còn lại',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Trạng thái',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows:
                      (_displayCount == -1
                              ? _depreciationData
                              : _depreciationData.take(_displayCount))
                          .map((item) {
                            final remainingDays =
                                item['ThoiHanConLai'] as int? ?? 0;
                            final isUrgent = remainingDays <= 30;

                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>((
                                states,
                              ) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.orange.shade50;
                                }
                                return isUrgent ? Colors.red.shade50 : null;
                              }),
                              cells: [
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item['Id']?.toString() ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      item['TenTaiSan']?.toString() ?? '',
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _formatDate(
                                      item['NgaySuDung']?.toString() ?? '',
                                    ),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${item['SoKyKhauHao'] ?? 0} kỳ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    formatter.format(item['NguyenGia'] ?? 0),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _formatDate(
                                      item['NgayHetHan']?.toString() ?? '',
                                    ),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isUrgent
                                              ? Colors.red.shade100
                                              : Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${remainingDays} tháng',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isUrgent
                                                ? Colors.red.shade800
                                                : Colors.green.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isUrgent
                                              ? Colors.red.shade100
                                              : remainingDays <= 60
                                              ? Colors.orange.shade100
                                              : Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isUrgent
                                          ? 'Khẩn cấp'
                                          : remainingDays <= 60
                                          ? 'Cảnh báo'
                                          : 'Bình thường',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color:
                                            isUrgent
                                                ? Colors.red.shade800
                                                : remainingDays <= 60
                                                ? Colors.orange.shade800
                                                : Colors.green.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })
                          .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.orange.shade50, Colors.amber.shade50],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng quan tài sản sắp hết hạn',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _displayCount == -1
                              ? 'Hiển thị tất cả ${_depreciationData.length} tài sản'
                              : 'Hiển thị ${_depreciationData.take(_displayCount).length}/${_depreciationData.length} tài sản',
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red.shade700,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Khẩn cấp: ${_depreciationData.where((item) => (item['ThoiHanConLai'] as int? ?? 0) <= 30).length}',
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.orange.shade700,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cảnh báo: ${_depreciationData.where((item) {
                              final days = item['ThoiHanConLai'] as int? ?? 0;
                              return days > 30 && days <= 60;
                            }).length}',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildEnhancedStatisticsCard(
    String title,
    String value,
    IconData icon,
    List<Color> gradientColors,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyle.textStyleRegular14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyle.textStyleSemiBold24.copyWith(
                color: Colors.white,
                fontSize: 20,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> get listColors => [
    Colors.blue.shade400,
    Colors.purple.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.pink.shade400,
    Colors.teal.shade400,
    Colors.indigo.shade400,
    Colors.amber.shade400,
  ];

  int _getCrossAxisCount(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final TypeSizeScreen size = TypeSizeScreenExtension.getSizeScreen(width);
    switch (size) {
      case TypeSizeScreen.extraSmall:
        return 1;
      case TypeSizeScreen.small:
        return 2;
      case TypeSizeScreen.medium:
        return 2;
      case TypeSizeScreen.large:
        return 4;
      case TypeSizeScreen.extraLarge:
        return 4;
    }
  }
}
