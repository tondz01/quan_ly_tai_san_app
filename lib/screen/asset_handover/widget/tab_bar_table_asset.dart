import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/message/message_providers.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_list.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_transfer_list_by_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class TabBarTableAsset extends riverpod.ConsumerStatefulWidget {
  final AssetHandoverProvider provider;
  const TabBarTableAsset({super.key, required this.provider});

  @override
  riverpod.ConsumerState<TabBarTableAsset> createState() =>
      _TabBarTableAssetState();
}

class _TabBarTableAssetState extends riverpod.ConsumerState<TabBarTableAsset> {
  List<DieuDongTaiSanDto> dataAssetTransfer = [];
  int quyetDinhCount = 0;
  UserInfoDTO? userInfoDTO;
  riverpod.ProviderSubscription<Map<String, dynamic>?>? _messageSub;

  final AssetTransferRepository _repository = AssetTransferRepository();
  Timer? _debounceTimer;

  // Cache constants để tránh lookup nhiều lần
  static const int _assetTransferType = FunctionType.ASSET_TRANSFER;
  static const int _allFunctionType = FunctionType.ALL_FUNCTION;

  // Cache message timestamp để tránh xử lý duplicate
  int? _lastProcessedMessageTime;
  bool _isLoadingCount = false;

  Future<void> _loadCount() async {
    // Đảm bảo userInfoDTO đã được khởi tạo
    userInfoDTO ??=
        widget.provider.userInfo ?? AccountHelper.instance.getUserInfo();

    // Lấy idDonViGiao từ NhanVien (phòng ban của user)
    NhanVien? nhanVien = AccountHelper.instance.getNhanVienById(
      userInfoDTO?.tenDangNhap ?? '',
    );
    final idDonViGiao = nhanVien?.phongBanId ?? '';

    if (idDonViGiao.isEmpty || _isLoadingCount) return;

    _isLoadingCount = true;
    try {
      // Gọi API getCountByDvGiao để lấy count
      final newCount = await _repository.getDataPageByBanGiao(
        0,
        20,
        -1,
        '',
        idDonViGiao,
      );
      if (!mounted) return;

      // Chỉ setState khi giá trị thực sự thay đổi
      setState(() {
        setState(() {
          quyetDinhCount = newCount['totalItems'] ?? 0;
        });
      });
    } catch (e) {
      // Log error nếu cần
    } finally {
      _isLoadingCount = false;
    }
  }

  void _debouncedLoadCount() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadCount();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userInfoDTO = widget.provider.userInfo;
    userInfoDTO ??= AccountHelper.instance.getUserInfo() ?? UserInfoDTO.empty();
    // Load count ngay lập tức khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCount();
      }
    });

    // Listen Firebase realtime messages với early return tối ưu
    _messageSub = ref.listenManual(messageLatestJsonProvider, (previous, next) {
      // Early return: kiểm tra null/empty trước
      if (next == null || next.isEmpty || !mounted) return;

      // Early return: lấy typeFunc và check ngay, tránh parse không cần thiết
      final typeFunc = next['type_func'];
      if (typeFunc is! int) return;

      // Fast comparison với cached constants
      if (typeFunc != _assetTransferType && typeFunc != _allFunctionType) {
        return; // Không phải message cần xử lý
      }

      // Tránh xử lý duplicate message: check timestamp
      final messageTime = next['time'];
      if (messageTime is int && _lastProcessedMessageTime != null) {
        if (messageTime <= _lastProcessedMessageTime!) {
          return; // Message cũ hơn hoặc bằng message đã xử lý
        }
        _lastProcessedMessageTime = messageTime;
      } else if (messageTime is int) {
        _lastProcessedMessageTime = messageTime;
      }

      // Chỉ debounce khi thực sự cần refresh
      _debouncedLoadCount();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _messageSub?.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(TabBarTableAsset oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        // Sửa: Loại bỏ +250 để tránh layout overflow, để Expanded tự điều chỉnh
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 400,
                    child: TabBar(
                      indicatorColor: ColorValue.link,
                      labelColor: ColorValue.link,
                      unselectedLabelColor: Colors.grey.shade600,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.book_outlined, size: 18),
                          text: 'Biên bản bàn giao',
                        ),
                        Tab(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.table_chart, size: 18),
                                  SizedBox(width: 6),
                                  Text('Quyết định điều động'),
                                ],
                              ),

                              Positioned(
                                right: -10,
                                top: -6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$quyetDinhCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tab(
                        //   icon: Icon(Icons.table_chart, size: 18),
                        //   text: 'Quyết định điều động',
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Tab 1: Bàn giao tài sản
                  AssetHandoverList(
                    provider: widget.provider,
                    listAssetTransfer: dataAssetTransfer,
                  ),
                  AssetTransferListByHandover(
                    data: dataAssetTransfer,
                    provider: widget.provider,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
