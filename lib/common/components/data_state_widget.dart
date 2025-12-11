import 'package:flutter/material.dart';

/// Widget hiển thị trạng thái loading hoặc empty data
/// Sử dụng để wrap table/list widgets
class DataStateWidget extends StatelessWidget {
  /// Trạng thái đang tải dữ liệu
  final bool isLoading;

  /// Dữ liệu đã được load xong hay chưa (để phân biệt giữa chưa load và đã load xong empty)
  final bool hasLoadedOnce;

  /// Kiểm tra data có empty không
  final bool isEmpty;

  /// Widget con sẽ hiển thị khi có data
  final Widget child;

  /// Thông báo loading (mặc định: "Đang tải dữ liệu...")
  final String loadingMessage;

  /// Thông báo khi không có dữ liệu (mặc định: "Không có dữ liệu")
  final String emptyMessage;

  /// Chiều cao tối thiểu của container
  final double? minHeight;

  const DataStateWidget({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.child,
    this.hasLoadedOnce = false,
    this.loadingMessage = 'Đang tải dữ liệu...',
    this.emptyMessage = 'Không có dữ liệu',
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu đang loading, hiển thị loading indicator
    if (isLoading) {
      return _buildLoadingWidget();
    }

    // Nếu đã load xong và data rỗng, hiển thị empty state
    if (hasLoadedOnce && isEmpty) {
      return _buildEmptyWidget();
    }

    // Nếu chưa load lần nào và đang empty, cũng hiển thị loading
    // (trường hợp khởi tạo ban đầu)
    if (!hasLoadedOnce && isEmpty) {
      return _buildLoadingWidget();
    }

    // Có data, hiển thị child
    return child;
  }

  Widget _buildLoadingWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight ?? 200),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 16),
            Text(
              loadingMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight ?? 200),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension để dễ sử dụng hơn với List
extension DataStateExtension<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get hasData => this != null && this!.isNotEmpty;
}
