import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart' as graphic;
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_text_style.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:quan_ly_tai_san_app/core/enum/type_size_screen.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/pie_with_legend.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/scrollable_bar_chart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey.shade100, Colors.blue.shade50],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticsSection(data),
            const SizedBox(height: 24),
            _buildAssetStatusSection(data),
            const SizedBox(height: 24),
            _buildAssetDistributionSection(data),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade800],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SGText(
              text: "📊 Tổng quan thống kê",
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
          const SizedBox(height: 24),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 140,
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
    final statusData = data['taiSanTheoTrangThaiPhanTram'] as List<dynamic>;

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade800],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SGText(
              text: "📈 Tài sản theo trạng thái",
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
          const SizedBox(height: 24),
          if (statusData.isNotEmpty)
            Center(
              child: PieDonutChartWithLegend(
                data:
                    statusData
                        .map(
                          (item) => <String, Object>{
                            'trangThai': item['trangThai'] ?? 'Chưa xác định',
                            'phanTramSoLuong': item['phanTramSoLuong'] ?? 0,
                          },
                        )
                        .toList(),
                categoryKey: 'trangThai',
                valueKey: 'phanTramSoLuong',
                colors: listColors,
                chartWidth: 450,
                chartHeight: 450,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssetDistributionSection(Map<String, dynamic> data) {
    final groupData = data['taiSanTheoNhomPhanTram'] as List<dynamic>;
    final departmentData = data['taiSanTheoPhongBanPhanTram'] as List<dynamic>;

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.purple.shade800],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SGText(
              text: "🎯 Phân bố tài sản",
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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SGText(
                        text: "📊 Tài sản theo nhóm",
                        style: AppTextStyle.textStyleRegular14.copyWith(
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PieDonutChartWithLegend(
                      data:
                          groupData
                              .map(
                                (item) => <String, Object>{
                                  'ten': item['ten'] ?? 'Chưa xác định',
                                  'phanTramSoLuong':
                                      item['phanTramSoLuong'] ?? 0,
                                },
                              )
                              .toList(),
                      categoryKey: 'ten',
                      valueKey: 'phanTramSoLuong',
                      colors: listColors,
                      chartWidth: 350,
                      chartHeight: 350,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SGText(
                        text: "🏢 Tài sản theo phòng ban",
                        style: AppTextStyle.textStyleRegular14.copyWith(
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PieDonutChartWithLegend(
                      data:
                          departmentData
                              .map(
                                (item) => <String, Object>{
                                  'phongBan':
                                      item['phongBan'] ?? 'Chưa xác định',
                                  'phanTramSoLuong':
                                      item['phanTramSoLuong'] ?? 0,
                                },
                              )
                              .toList(),
                      categoryKey: 'phongBan',
                      valueKey: 'phanTramSoLuong',
                      colors: listColors,
                      chartWidth: 350,
                      chartHeight: 350,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SGText(
                        text: "🔧 CCDC theo loại",
                        style: AppTextStyle.textStyleRegular14.copyWith(
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (data['ccdcTheoLoaiConPhanTram'] != null &&
                        (data['ccdcTheoLoaiConPhanTram'] as List).isNotEmpty)
                      PieDonutChartWithLegend(
                        data:
                            (data['ccdcTheoLoaiConPhanTram'] as List)
                                .map(
                                  (item) => <String, Object>{
                                    'ten': item['ten'] ?? 'Chưa xác định',
                                    'phanTramSoLuong':
                                        item['phanTramSoLuong'] ?? 0,
                                  },
                                )
                                .toList(),
                        categoryKey: 'ten',
                        valueKey: 'phanTramSoLuong',
                        colors: listColors,
                        chartWidth: 350,
                        chartHeight: 350,
                      )
                    else
                      Container(
                        height: 350,
                        child: Center(
                          child: Text(
                            'Không có dữ liệu CCDC',
                            style: AppTextStyle.textStyleRegular14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SGText(
                        text: "⚙️ Tài sản theo loại",
                        style: AppTextStyle.textStyleRegular14.copyWith(
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (data['taiSanTheoLoaiConChiTietPhanTram'] != null &&
                        (data['taiSanTheoLoaiConChiTietPhanTram'] as List)
                            .isNotEmpty)
                      PieDonutChartWithLegend(
                        data:
                            (data['taiSanTheoLoaiConChiTietPhanTram'] as List)
                                .map(
                                  (item) => <String, Object>{
                                    'tenLoaiTaiSanCon':
                                        item['tenLoaiTaiSanCon'] ??
                                        'Chưa xác định',
                                    'phanTramSoLuong':
                                        item['phanTramSoLuong'] ?? 0,
                                  },
                                )
                                .toList(),
                        categoryKey: 'tenLoaiTaiSanCon',
                        valueKey: 'phanTramSoLuong',
                        colors: listColors,
                        chartWidth: 350,
                        chartHeight: 350,
                      )
                    else
                      Container(
                        height: 350,
                        child: Center(
                          child: Text(
                            'Không có dữ liệu tài sản loại con',
                            style: AppTextStyle.textStyleRegular14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade600, Colors.orange.shade800],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 200),
              child: SGText(
                text: "Top 5 tài sản giá trị cao",
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
          ),
          const SizedBox(height: 24),

          Container(
            padding: EdgeInsets.only(left: 100),
            height: 420,
            child: graphic.Chart(
              data:
                  topAssets
                      .map(
                        (item) => {
                          'tenTaiSan': _truncateText(
                            item['TenTaiSan'] ?? 'Chưa xác định',
                            20,
                          ),
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
                        (tuple) =>
                            graphic.Label(formatter.format(tuple['sold'])),
                  ),
                  gradient: graphic.GradientEncode(
                    value: LinearGradient(
                      colors: [
                        Colors.orange.shade300.withOpacity(0.8),
                        Colors.orange.shade500.withOpacity(0.8),
                        Colors.orange.shade700.withOpacity(0.9),
                      ],
                      stops: const [0, 0.5, 1],
                    ),
                    updaters: {
                      'tap': {
                        true:
                            (_) => LinearGradient(
                              colors: [
                                Colors.orange.shade400.withOpacity(0.9),
                                Colors.orange.shade600.withOpacity(0.9),
                                Colors.orange.shade800,
                              ],
                              stops: const [0, 0.7, 1],
                            ),
                      },
                    },
                  ),
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
        ],
      ),
    );
  }

  Widget _buildTrendAnalysisSection(Map<String, dynamic> data) {
    final yearData = data['taiSanTheoNamTao'] as List<dynamic>;
    final monthData = data['taiSanTheoThang'] as List<dynamic>;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SGText(
            text: "Phân tích xu hướng",
            style: AppTextStyle.textStyleSemiBold24,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SGText(
                      text: "Tài sản theo năm tạo",
                      style: AppTextStyle.textStyleRegular14,
                    ),
                    const SizedBox(height: 16),
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
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    SGText(
                      text: "Tài sản theo tháng",
                      style: AppTextStyle.textStyleRegular14,
                    ),
                    const SizedBox(height: 16),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection(Map<String, dynamic> data) {
    final maintenanceData = data['taiSanSapHetHanBaoHanh'] as List<dynamic>;

    if (maintenanceData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SGText(
            text: "Tài sản sắp hết hạn bảo hành",
            style: AppTextStyle.textStyleSemiBold24,
          ),
          const SizedBox(height: 24),
          DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Tên tài sản')),
              DataColumn(label: Text('Nguyên giá')),
              DataColumn(label: Text('Ngày vào sổ')),
              DataColumn(label: Text('Thời hạn bảo hành')),
              DataColumn(label: Text('Số ngày còn lại')),
            ],
            rows:
                maintenanceData
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(item['Id']?.toString() ?? '')),
                          DataCell(Text(item['TenTaiSan']?.toString() ?? '')),
                          DataCell(
                            Text(formatter.format(item['NguyenGia'] ?? 0)),
                          ),
                          DataCell(Text(item['NgayVaoSo']?.toString() ?? '')),
                          DataCell(
                            Text(item['ThoiHanBaoHanh']?.toString() ?? ''),
                          ),
                          DataCell(
                            Text(item['SoNgayConLai']?.toString() ?? ''),
                          ),
                        ],
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
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

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
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
