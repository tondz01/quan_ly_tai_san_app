import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart' as graphic;
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_text_style.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/scrollable_bar_chart.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/pie_with_legend.dart';
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

  // Asset group percentage data
  List<dynamic> _assetGroupPercentageData = [];
  bool _isLoadingAssetGroupPercentage = false;
  String? _assetGroupPercentageError;

  // CCDC group percentage data
  List<dynamic> _ccdcGroupPercentageData = [];
  bool _isLoadingCcdcGroupPercentage = false;
  String? _ccdcGroupPercentageError;

  // Statistics data
  Map<String, dynamic> _statisticsData = {};
  bool _isLoadingStatistics = false;
  String? _statisticsError;

  late HomeScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener(_onScrollStateChanged);
    _loadAssetStatusData();
    _loadCcdcStatusData();
    _loadAssetGroupData();
    _loadCcdcGroupData();
    _loadDepreciationData();
    _loadAssetGroupPercentageData();
    _loadCcdcGroupPercentageData();
    _loadStatisticsData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_onScrollStateChanged);
  }

  void _onScrollStateChanged() {
    setState(() {});
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

  Future<void> _loadAssetGroupPercentageData() async {
    setState(() {
      _isLoadingAssetGroupPercentage = true;
      _assetGroupPercentageError = null;
    });

    try {
      final result = await _dashboardRepository.getAssetGroupPercentageData();

      if (result['status_code'] == 200) {
        setState(() {
          _assetGroupPercentageData = result['data'] ?? [];
          _isLoadingAssetGroupPercentage = false;
        });
      } else {
        setState(() {
          _assetGroupPercentageError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingAssetGroupPercentage = false;
        });
      }
    } catch (e) {
      setState(() {
        _assetGroupPercentageError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingAssetGroupPercentage = false;
      });
    }
  }

  Future<void> _loadCcdcGroupPercentageData() async {
    setState(() {
      _isLoadingCcdcGroupPercentage = true;
      _ccdcGroupPercentageError = null;
    });

    try {
      final result = await _dashboardRepository.getCcdcGroupPercentageData();

      if (result['status_code'] == 200) {
        setState(() {
          _ccdcGroupPercentageData = result['data'] ?? [];
          _isLoadingCcdcGroupPercentage = false;
        });
      } else {
        setState(() {
          _ccdcGroupPercentageError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingCcdcGroupPercentage = false;
        });
      }
    } catch (e) {
      setState(() {
        _ccdcGroupPercentageError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingCcdcGroupPercentage = false;
      });
    }
  }

  Future<void> _loadStatisticsData() async {
    setState(() {
      _isLoadingStatistics = true;
      _statisticsError = null;
    });

    try {
      final result = await _dashboardRepository.getDashboardData();
      print("Statistics API Result: $result");

      if (result['status_code'] == 200) {
        setState(() {
          // The API returns data directly in the 'data' field
          print("Statistics API Success - result['data']: ${result['data']}");
          _statisticsData = result['data'] as Map<String, dynamic>? ?? {};
          print("Statistics Data Set - _statisticsData: $_statisticsData");
          _isLoadingStatistics = false;
        });
      } else {
        setState(() {
          _statisticsError = result['message'] ?? 'Có lỗi xảy ra';
          _isLoadingStatistics = false;
        });
      }
    } catch (e) {
      setState(() {
        _statisticsError = 'Lỗi khi tải dữ liệu: $e';
        _isLoadingStatistics = false;
      });
    }
  }

  // Dữ liệu mẫu từ API

  @override
  Widget build(BuildContext context) {
    final data = _statisticsData as Map<String, dynamic>? ?? {};
    print("Build - Statistics Data: $data");
    print("Build - Top Assets: ${data['top5TaiSanGiaTriCao']}");

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return true; // Xử lý scroll event bình thường
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          physics:
              _scrollController.isParentScrolling
                  ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                  : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatisticsSection(data),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTopAssetsSection(data)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMaintenanceSection(data)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(Map<String, dynamic> data) {
    if (_isLoadingStatistics) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard, color: Colors.green.shade700, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Tổng quan thống kê",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF21A366),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF21A366),
                    ),
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Đang tải dữ liệu...",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_statisticsError != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white54.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Lỗi tải dữ liệu",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 32,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _statisticsError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loadStatisticsData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white54.withOpacity(0.1),
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
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.dashboard,
                  color: Colors.green.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGText(
                    text: "Tổng quan thống kê",
                    style: AppTextStyle.textStyleSemiBold24.copyWith(
                      color: Colors.green.shade700,
                    ),
                  ),
                  Text(
                    "Thống kê tổng quan về tài sản và thiết bị",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCcdcGroupPercentageSection(data),
                    const SizedBox(height: 16),
                    Column(children: [_buildAssetGroupPercentageSection(data)]),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildCcdcGroupDistributionSection(data),
                    const SizedBox(height: 16),
                    _buildAssetGroupDistributionSection(data),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildYearTrendChart(data),
                    const SizedBox(height: 16),
                    _buildMonthTrendChart(data),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetGroupDistributionSection(Map<String, dynamic> data) {
    return Container(
      height: 300, // Fixed height
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGText(
                text: "Phân bố tài sản theo loại",
                style: AppTextStyle.textStyleSemiBold24.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF21A366),
                ),
              ),
              if (_assetGroupError != null)
                IconButton(
                  onPressed: _loadAssetGroupData,
                  icon: Icon(Icons.refresh, color: const Color(0xFF21A366)),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoadingAssetGroup)
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.purple.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 14,
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
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      _assetGroupError!,
                      style: TextStyle(
                        fontSize: 14,
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
                    height: 200,
                    child: Center(
                      child: Text(
                        'Vui lòng chọn nhóm tài sản',
                        style: TextStyle(
                          fontSize: 14,
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
              height: 200,
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
                        fontSize: 14,
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
        height: 300,
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

    return Container(
      height: 450,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.purple.shade600),
                const SizedBox(width: 8),
                Text(
                  'Phân bố tài sản theo loại trong nhóm "$groupName"',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ScrollableBarChart(
              data:
                  groupData
                      .map(
                        (item) => <String, Object>{
                          'label': item['TenLoai'] ?? 'Chưa xác định',
                          'value': item['SoLuong'] ?? 0,
                        },
                      )
                      .toList(),
              categoryKey: 'label',
              valueKey: 'value',
              barWidth: 40,
              spacing: 80,
              height: 300,
              barColor: Colors.purple.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCcdcGroupDistributionSection(Map<String, dynamic> data) {
    return Container(
      height: 300, // Fixed height
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGText(
                text: "Phân bố CCDC theo loại",
                style: AppTextStyle.textStyleSemiBold24.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF21A366),
                ),
              ),
              if (_ccdcGroupError != null)
                IconButton(
                  onPressed: _loadCcdcGroupData,
                  icon: Icon(Icons.refresh, color: const Color(0xFF21A366)),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoadingCcdcGroup)
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.orange.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu...',
                      style: TextStyle(
                        fontSize: 14,
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
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      _ccdcGroupError!,
                      style: TextStyle(
                        fontSize: 14,
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
                    height: 200,
                    child: Center(
                      child: Text(
                        'Vui lòng chọn nhóm CCDC',
                        style: TextStyle(
                          fontSize: 14,
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
              height: 200,
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
                        fontSize: 14,
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
        height: 300,
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

    return Container(
      height: 450,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                Text(
                  'Phân bố CCDC theo loại trong nhóm "$groupName"',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ScrollableBarChart(
              data:
                  groupData
                      .map(
                        (item) => <String, Object>{
                          'label': item['TenLoai'] ?? 'Chưa xác định',
                          'value': item['SoLuong'] ?? 0,
                        },
                      )
                      .toList(),
              categoryKey: 'label',
              valueKey: 'value',
              barWidth: 40,
              spacing: 80,
              height: 300,
              barColor: Colors.orange.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetGroupPercentageSection(Map<String, dynamic> data) {
    return Container(
      height: 300, // Fixed height
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGText(
                text: "Phân bố tài sản theo nhóm (%)",
                style: AppTextStyle.textStyleSemiBold24.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF21A366),
                ),
              ),
              if (_assetGroupPercentageError != null)
                IconButton(
                  onPressed: _loadAssetGroupPercentageData,
                  icon: Icon(Icons.refresh, color: const Color(0xFF21A366)),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoadingAssetGroupPercentage)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: const Color(0xFF21A366)),
                      const SizedBox(height: 16),
                      Text(
                        'Đang tải dữ liệu...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else if (_assetGroupPercentageError != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _assetGroupPercentageError!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadAssetGroupPercentageData,
                        icon: Icon(Icons.refresh, size: 16),
                        label: Text('Thử lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21A366),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  )
                else if (_assetGroupPercentageData.isNotEmpty)
                  PieDonutChartWithLegend(
                    data:
                        _assetGroupPercentageData
                            .map(
                              (item) => <String, Object>{
                                'label': item['TenNhom'] ?? 'Chưa xác định',
                                'value': item['SoLuong'] ?? 0,
                                'percentage': item['TiLePhanTram'] ?? 0,
                              },
                            )
                            .toList(),
                    categoryKey: 'label',
                    valueKey: 'value',
                    colors: [
                      const Color(0xFF21A366),
                      const Color(0xFF21A366),
                      Colors.orange.shade600,
                      Colors.purple.shade600,
                      Colors.red.shade600,
                      Colors.teal.shade600,
                      Colors.indigo.shade600,
                      Colors.pink.shade600,
                    ],
                    chartWidth: 100,
                    chartHeight: 100,
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pie_chart, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Không có dữ liệu phân bố tài sản',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          _buildStatisticsRow(
            'Tổng tài sản',
            (data['tongTaiSan'] ?? 0).toString(),
            Icons.inventory_2,
          ),
          _buildStatisticsRow(
            'Tổng nguyên giá',
            formatter.format(data['tongNguyenGia'] ?? 0),
            Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildCcdcGroupPercentageSection(Map<String, dynamic> data) {
    return Container(
      height: 300, // Fixed height
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGText(
                text: "Phân bố CCDC theo nhóm (%)",
                style: AppTextStyle.textStyleSemiBold24.copyWith(
                  fontSize: 14,
                  color: const Color(0xFF21A366),
                ),
              ),
              if (_ccdcGroupPercentageError != null)
                IconButton(
                  onPressed: _loadCcdcGroupPercentageData,
                  icon: Icon(Icons.refresh, color: const Color(0xFF21A366)),
                  tooltip: 'Tải lại dữ liệu',
                ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoadingCcdcGroupPercentage)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.amber.shade600),
                      const SizedBox(height: 16),
                      Text(
                        'Đang tải dữ liệu...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else if (_ccdcGroupPercentageError != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _ccdcGroupPercentageError!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadCcdcGroupPercentageData,
                        icon: Icon(Icons.refresh, size: 16),
                        label: Text('Thử lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  )
                else if (_ccdcGroupPercentageData.isNotEmpty)
                  PieDonutChartWithLegend(
                    data:
                        _ccdcGroupPercentageData
                            .map(
                              (item) => <String, Object>{
                                'label': item['TenNhom'] ?? 'Chưa xác định',
                                'value': item['SoLuong'] ?? 0,
                                'percentage': item['TiLePhanTram'] ?? 0,
                              },
                            )
                            .toList(),
                    categoryKey: 'label',
                    valueKey: 'value',
                    colors: [
                      Colors.amber.shade600,
                      const Color(0xFF21A366),
                      const Color(0xFF21A366),
                      Colors.purple.shade600,
                      Colors.red.shade600,
                      Colors.teal.shade600,
                      Colors.indigo.shade600,
                      Colors.pink.shade600,
                    ],
                    chartWidth: 100,
                    chartHeight: 100,
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.build_circle_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Không có dữ liệu phân bố CCDC',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          _buildStatisticsRow(
            'Tổng CCDC',
            (data['tongCCDC'] ?? 0).toString(),
            Icons.build,
          ),
          _buildStatisticsRow(
            'Tổng giá trị CCDC',
            formatter.format(data['tongGiaTriCCDC'] ?? 0),
            Icons.monetization_on,
          ),
        ],
      ),
    );
  }

  Widget _buildTopAssetsSection(Map<String, dynamic> data) {
    final topAssets = (data['top5TaiSanGiaTriCao'] as List<dynamic>?) ?? [];
    print("Top Assets Data: $topAssets");
    print("Top Assets Count: ${topAssets.length}");

    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SGText(
                text: "Top 5 tài sản giá trị cao",
                style: AppTextStyle.textStyleSemiBold12.copyWith(
                  color: const Color(0xFF21A366),
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
            padding: const EdgeInsets.only(left: 100),
            height: 300,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
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
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
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
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.green.shade700),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: const Color(0xFF21A366),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection(Map<String, dynamic> data) {
    if (_isLoadingDepreciation) {
      return Container(
        height: 500,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
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
        height: 500,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
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
        height: 500,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
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
      height: 500,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SGText(
                text: "Tài sản sắp hết hạn khấu hao",
                style: AppTextStyle.textStyleSemiBold24.copyWith(
                  color: const Color(0xFF21A366),
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
                      color: Colors.green.shade50,
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
                        const SizedBox(width: 4),
                        Text(
                          'Hiển thị:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 4),
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
                            color: Colors.green.shade700,
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
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
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
                            color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
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
                                  return Colors.grey.shade100;
                                }
                                return Colors.white;
                              }),
                              cells: [
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item['Id']?.toString() ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
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
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${item['SoKyKhauHao'] ?? 0} kỳ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
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
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${remainingDays} tháng',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
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
                                      color: Colors.green.shade100,
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
                                        color: Colors.red,
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
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.green.shade700,
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
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _displayCount == -1
                              ? 'Hiển thị tất cả ${_depreciationData.length} tài sản'
                              : 'Hiển thị ${_depreciationData.take(_displayCount).length}/${_depreciationData.length} tài sản',
                          style: TextStyle(color: Colors.black, fontSize: 12),
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, color: Colors.black, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Khẩn cấp: ${_depreciationData.where((item) => (item['ThoiHanConLai'] as int? ?? 0) <= 30).length}',
                            style: TextStyle(
                              color: Colors.green.shade50,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule, color: Colors.black, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Cảnh báo: ${_depreciationData.where((item) {
                              final days = item['ThoiHanConLai'] as int? ?? 0;
                              return days > 30 && days <= 60;
                            }).length}',
                            style: TextStyle(
                              color: Colors.green.shade700,
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

  Widget _buildStatisticsRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 16),
        const SizedBox(width: 8),
        Text(
          "$title : ",
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildYearTrendChart(Map<String, dynamic> data) {
    final yearData = (data['taiSanTheoNamTao'] as List<dynamic>?) ?? const [];

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
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
                  Icons.calendar_today,
                  color: Colors.green.shade700,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Tài sản theo năm tạo",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ScrollableBarChart(
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
              barWidth: 12,
              spacing: 24,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthTrendChart(Map<String, dynamic> data) {
    final monthData = (data['taiSanTheoThang'] as List<dynamic>?) ?? const [];

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
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
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Tài sản theo tháng",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ScrollableBarChart(
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
              barWidth: 12,
              spacing: 24,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> get listColors => [
    Colors.green.shade400,
    Colors.purple.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.pink.shade400,
    Colors.teal.shade400,
    Colors.indigo.shade400,
    Colors.amber.shade400,
  ];
}
