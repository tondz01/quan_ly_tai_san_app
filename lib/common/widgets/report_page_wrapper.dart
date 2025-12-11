import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

/// ReportPageWrapper - Component tái sử dụng cho tất cả các trang báo cáo
///
/// Cung cấp layout đồng nhất với:
/// - Control Panel (header với title, filters, action buttons)
/// - Content Area (scrollable với decoration)
/// - Loading overlay
/// - Export overlay
class ReportPageWrapper extends StatelessWidget {
  /// Tiêu đề báo cáo
  final String title;

  /// Các form control (date picker, dropdown, etc.)
  final List<Widget> filterWidgets;

  /// Callback khi nhấn nút "Lấy dữ liệu"
  final VoidCallback? onLoadData;

  /// Callback khi nhấn nút "Export PDF"
  final VoidCallback? onExportPdf;

  /// Callback khi nhấn nút "Export Excel"
  final VoidCallback? onExportExcel;

  /// Callback khi nhấn nút "Print"
  final VoidCallback? onPrint;

  /// Nội dung báo cáo (scrollable)
  final Widget content;

  /// Có đang loading không
  final bool isLoading;

  /// Có đang export không
  final bool isExporting;

  /// Scroll controller (optional)
  final ScrollPhysics? scrollPhysics;

  /// Custom padding cho control panel (default: 16.0)
  final EdgeInsets? controlPanelPadding;

  /// Custom padding cho content area (default: 16.0)
  final EdgeInsets? contentPadding;

  /// Width của page wrapper (default: 1400)
  final double pageWidth;

  /// Ẩn các action buttons (default: false)
  final bool hideActionButtons;

  const ReportPageWrapper({
    super.key,
    required this.title,
    required this.filterWidgets,
    required this.content,
    this.onLoadData,
    this.onExportPdf,
    this.onExportExcel,
    this.onPrint,
    this.isLoading = false,
    this.isExporting = false,
    this.scrollPhysics,
    this.controlPanelPadding,
    this.contentPadding,
    this.pageWidth = 1400,
    this.hideActionButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: pageWidth,
              child: Column(
                children: [
                  // ===== CONTROL PANEL =====
                  _buildControlPanel(),

                  const SizedBox(height: 24),

                  // ===== CONTENT AREA =====
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: scrollPhysics ?? const BouncingScrollPhysics(),
                            child: Padding(
                              padding: contentPadding ?? const EdgeInsets.all(16.0),
                              child: content,
                            ),
                          ),
                          // Content loading overlay
                          if (isLoading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black54,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ===== EXPORT OVERLAY =====
        if (isExporting)
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  /// Build Control Panel với title, filters, và action buttons
  Widget _buildControlPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: controlPanelPadding ?? const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title
            SGText(
              text: title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 32),

            // Filter Widgets
            ...filterWidgets.map((widget) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: widget,
              );
            }),

            // Action Buttons
            if (!hideActionButtons) ...[
              const Divider(),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  /// Build Action Buttons Row (Lấy dữ liệu, PDF, Print)
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Nút "Lấy dữ liệu"
        if (onLoadData != null)
          GestureDetector(
            onTap: onLoadData,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Lấy dữ liệu',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

        const Expanded(child: SizedBox.shrink()),

        // Nút "Export PDF"
        if (onExportPdf != null) ...[
          GestureDetector(
            onTap: onExportPdf,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],

        // Nút "Export Excel"
        if (onExportExcel != null) ...[
          GestureDetector(
            onTap: onExportExcel,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF217346), // Excel green color
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.grid_on,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],

        // Nút "Print"
        if (onPrint != null)
          GestureDetector(
            onTap: onPrint,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.print,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
