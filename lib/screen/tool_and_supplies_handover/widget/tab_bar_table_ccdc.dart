import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/services/count_service.dart';
import 'package:quan_ly_tai_san_app/message/message_providers.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/tool_and_supplies_handover_list.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/tool_and_supplies_handover_transfer_list.dart';

class TabBarTableCcdc extends riverpod.ConsumerStatefulWidget {
  final ToolAndSuppliesHandoverProvider provider;
  const TabBarTableCcdc({super.key, required this.provider});

  @override
  riverpod.ConsumerState<TabBarTableCcdc> createState() => _TabBarTableCcdcState();
}

class _TabBarTableCcdcState extends riverpod.ConsumerState<TabBarTableCcdc> {
  List<ToolAndMaterialTransferDto> dataAssetTransfer = [];
  int quyetDinhCount = 0;
  riverpod.ProviderSubscription<Map<String, dynamic>?>? _messageSub;
  
  final CountService _countService = CountService();
  
  // Cache constants để tránh lookup nhiều lần
  static const int _toolAndMaterialTransferType = FunctionType.TOOL_AND_MATERIAL_TRANSFER;
  static const int _allFunctionType = FunctionType.ALL_FUNCTION;
  
  // Cache message timestamp để tránh xử lý duplicate
  int? _lastProcessedMessageTime;

  void _loadCount({bool force = false, bool immediate = false}) {
    // Sử dụng CountService để load count (đã được tối ưu)
    _countService.loadAllCounts(force: force).then((counts) {
      if (!mounted) return;
      
      final newCount = counts['toolMaterialTransfer'] ?? 0;
      // Chỉ setState khi giá trị thực sự thay đổi
      if (newCount != quyetDinhCount) {
        setState(() {
          quyetDinhCount = newCount;
        });
      }
    }).catchError((error) {
      // Log error nếu cần
    });
  }

  void _debouncedLoadCount() {
    // Sử dụng CountService debounce method
    _countService.debouncedLoadAllCounts();
    
    // Cập nhật UI sau khi debounce
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _loadCount();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    
    // Đăng ký callback để nhận count updates từ CountService
    _countService.registerCallback(
      'toolMaterialTransfer-${widget.provider.userInfo?.id}',
      (count) {
        if (mounted && count != quyetDinhCount) {
          setState(() {
            quyetDinhCount = count;
          });
        }
      },
    );
    
    // Load count ngay lập tức khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCount(force: true, immediate: true);
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
      if (typeFunc != _toolAndMaterialTransferType && 
          typeFunc != _allFunctionType) {
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
    // Hủy đăng ký callback
    _countService.unregisterCallback('toolMaterialTransfer-${widget.provider.userInfo?.id}');
    _messageSub?.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(TabBarTableCcdc oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _getDataAssetTransfer();
  }

  // void _getDataAssetTransfer() {
  //   dataAssetTransfer =
  //       widget.provider.dataAssetTransfer
  //           ?.where((element) => element.trangThai == 3)
  //           // .where((element) => element.daBanGiao == false)
  //           .toList() ??
  //       [];
  //   quyetDinhCount = dataAssetTransfer.length;
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
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
                  ToolAndSuppliesHandoverList(
                    provider: widget.provider,
                    listAssetTransfer: dataAssetTransfer,
                  ),
                  ToolAndSuppliesHandoverTransferList(
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
