import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import '../../../common/reponsitory/save_export_file_stub.dart'
    if (dart.library.html) '../../../common/reponsitory/save_export_file_web.dart'
    if (dart.library.io) '../../../common/reponsitory/save_export_file_io.dart';

class ChatDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String? sqlQuery;
  final VoidCallback? onExportExcel;
  final bool isFullScreen;

  const ChatDataTable({
    super.key,
    required this.data,
    this.sqlQuery,
    this.onExportExcel,
    this.isFullScreen = false,
  });

  @override
  State<ChatDataTable> createState() => _ChatDataTableState();
}

class _ChatDataTableState extends State<ChatDataTable> {
  bool _showSqlQuery = false;
  bool _isExporting = false;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<String> get _columns {
    if (widget.data.isEmpty) return [];
    return widget.data.first.keys.toList();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Không có dữ liệu',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActionBar(),
        if (_showSqlQuery && widget.sqlQuery != null) _buildSqlQuerySection(),
        const SizedBox(height: 8),
        _buildScrollHint(),
        const SizedBox(height: 4),
        _buildDataTable(),
        const SizedBox(height: 4),
        Text(
          'Tổng: ${widget.data.length} bản ghi',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollHint() {
    return Row(
      children: [
        Icon(
          Icons.swipe,
          size: 14,
          color: Colors.grey.shade500,
        ),
        const SizedBox(width: 4),
        Text(
          'Kéo ngang để xem thêm cột',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        if (widget.sqlQuery != null)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showSqlQuery = !_showSqlQuery;
              });
            },
            icon: Icon(
              _showSqlQuery ? Icons.code_off : Icons.code,
              size: 16,
            ),
            label: Text(
              _showSqlQuery ? 'Ẩn SQL' : 'Xem SQL',
              style: const TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        const Spacer(),
        _isExporting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton.icon(
                onPressed: _exportToExcel,
                icon: const Icon(Icons.download, size: 16),
                label: const Text(
                  'Export Excel',
                  style: TextStyle(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: ColorValue.success,
                ),
              ),
      ],
    );
  }

  Widget _buildSqlQuerySection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              const Text(
                'SQL Query:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (widget.sqlQuery != null) {
                    Clipboard.setData(ClipboardData(text: widget.sqlQuery!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã copy SQL query'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: const Tooltip(
                  message: 'Copy SQL',
                  child: Icon(Icons.copy, size: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            widget.sqlQuery ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    final maxHeight = widget.isFullScreen ? 500.0 : 300.0;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          child: Scrollbar(
            controller: _verticalScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notification) => notification.depth == 1,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(ColorValue.neutral100),
                  dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return null;
                    },
                  ),
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  headingRowHeight: 44,
                  dataRowMinHeight: 36,
                  dataRowMaxHeight: 52,
                  columns: _buildColumns(),
                  rows: _buildRows(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return _columns.map((column) {
      return DataColumn(
        label: Container(
          constraints: const BoxConstraints(minWidth: 80, maxWidth: 200),
          child: Text(
            column,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();
  }

  List<DataRow> _buildRows() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;
      return DataRow(
        color: WidgetStateProperty.all(
          index.isEven ? Colors.white : Colors.grey.shade50,
        ),
        cells: _columns.map((column) {
          final value = row[column];
          return DataCell(
            Container(
              constraints: const BoxConstraints(minWidth: 80, maxWidth: 200),
              child: Tooltip(
                message: _formatValue(value),
                child: Text(
                  _formatValue(value),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  String _formatValue(dynamic value) {
    if (value == null) return '';
    if (value is double) {
      if (value == value.roundToDouble()) {
        return value.toInt().toString();
      }
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }

  Future<void> _exportToExcel() async {
    if (widget.data.isEmpty) return;

    setState(() {
      _isExporting = true;
    });

    try {
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];
      sheet.name = 'Query Result';

      // Write headers
      for (int i = 0; i < _columns.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(_columns[i]);
        cell.cellStyle.bold = true;
        cell.cellStyle.backColor = '#E0E0E0';
        cell.cellStyle.hAlign = xlsio.HAlignType.center;
      }

      // Write data rows
      for (int rowIndex = 0; rowIndex < widget.data.length; rowIndex++) {
        final row = widget.data[rowIndex];
        for (int colIndex = 0; colIndex < _columns.length; colIndex++) {
          final value = row[_columns[colIndex]];
          final cell = sheet.getRangeByIndex(rowIndex + 2, colIndex + 1);

          if (value == null) {
            cell.setText('');
          } else if (value is num) {
            cell.setNumber(value.toDouble());
          } else {
            cell.setText(value.toString());
          }
        }
      }

      // Auto-fit columns
      for (int i = 1; i <= _columns.length; i++) {
        sheet.autoFitColumn(i);
      }

      // Save file
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final fileName =
          'chatbot_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      await saveExportFile(
        Uint8List.fromList(bytes),
        fileName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xuất file Excel thành công'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xuất file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }
}
