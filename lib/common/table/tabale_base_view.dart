import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/table/table_utils.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_svgs.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_datetime_input_button.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_table_column_ext.dart';

/// Widget hiển thị bảng cơ bản với khả năng lọc theo thời gian
/// Hỗ trợ lọc dữ liệu theo nhiều trường thời gian khác nhau
class TableBaseView<T> extends StatefulWidget {
  const TableBaseView({
    super.key,
    required this.searchTerm,
    required this.columns,
    required this.data,
    this.horizontalController,
    this.onRowTap,
    this.onSelectionChanged,
    this.isShowCheckboxes = true,
    this.isShowFilter = true,
    this.getters,
    this.startDate,
    this.endDate,
    this.filterPopupOffset = const Offset(-10, -70),
    this.showQuantityColumn = 10,
  });

  /// Từ khóa tìm kiếm
  final String searchTerm;

  /// Danh sách cột của bảng
  final List<SgTableColumn<T>> columns;

  /// Dữ liệu hiển thị trong bảng
  final List<T> data;

  /// Danh sách các hàm getter để lấy DateTime từ object T
  /// Dùng để lọc dữ liệu theo nhiều trường thời gian khác nhau
  /// Format: [{'Ngày tạo': (item) => item.createdAt}, {'Ngày cập nhật': (item) => item.updatedAt}]
  final List<Map<String, DateTime Function(T)>>? getters;

  /// Controller cho thanh cuộn ngang
  final ScrollController? horizontalController;

  /// Callback khi người dùng tap vào một dòng
  final Function(T item)? onRowTap;

  /// Callback khi thay đổi selection
  final Function(List<T> items)? onSelectionChanged;

  /// Có hiển thị checkbox để chọn nhiều dòng hay không
  final bool isShowCheckboxes;

  /// Có hiển thị phần filter theo ngày hay không
  final bool isShowFilter;

  final Offset? filterPopupOffset;

  final DateTime? startDate;
  final DateTime? endDate;

  /// Số lượng dòng hiển thị mặc định trong bảng
  final double showQuantityColumn;
  @override
  State<TableBaseView<T>> createState() => _TableBaseViewState<T>();
}

class _TableBaseViewState<T> extends State<TableBaseView<T>> {
  /// Controller cho ô nhập ngày bắt đầu
  final TextEditingController _textTimeStartController =
      TextEditingController();

  /// Controller cho ô nhập ngày kết thúc
  final TextEditingController _textTimeEndController = TextEditingController();

  /// Ngày bắt đầu để lọc dữ liệu
  DateTime? _startDate;

  /// Ngày kết thúc để lọc dữ liệu
  DateTime? _endDate;

  /// Danh sách dữ liệu đã được lọc theo thời gian
  List<T> _filteredData = [];

  /// Danh sách các trường thời gian được chọn để lọc (index tương ứng với getters)
  final List<int> _selectedGetterIndexes = [];

  /// Danh sách các bộ lọc đã áp dụng (để hiển thị chip)
  final List<String> _activeFilters = [];

  @override
  void initState() {
    super.initState();
    _startDate =
        widget.startDate ?? DateTime.now().subtract(const Duration(days: 30));
    _endDate = widget.endDate ?? DateTime.now();
    // Khởi tạo dữ liệu ban đầu chưa lọc
    _filteredData = widget.data;
  }

  @override
  void didUpdateWidget(TableBaseView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Áp dụng lại bộ lọc khi dữ liệu từ widget cha thay đổi
    if (oldWidget.data != widget.data) {
      _applyDateFilter();
    }
  }

  /// Hàm lọc dữ liệu theo nhiều trường thời gian
  ///
  /// [data]: Danh sách dữ liệu cần lọc
  /// [getterMaps]: Danh sách các Map chứa tên và function getter
  /// [start]: Thời gian bắt đầu (có thể null)
  /// [end]: Thời gian kết thúc (có thể null)
  /// [inclusive]: Có bao gồm boundary (start và end) hay không
  ///
  /// Trả về danh sách các item có ít nhất một DateTime nằm trong khoảng [start, end]
  List<T> _filterByMultipleFields({
    required List<T> data,
    required List<Map<String, DateTime Function(T)>> getterMaps,
    DateTime? start,
    DateTime? end,
    bool inclusive = true,
  }) {
    // Nếu không có thời gian nào được chọn thì trả về toàn bộ dữ liệu
    if (start == null && end == null) return data;
    // Nếu không có getter nào thì trả về toàn bộ dữ liệu
    if (getterMaps.isEmpty) return data;

    return data.where((item) {
      // Lấy tất cả thời gian từ item thông qua các getter functions
      final times = getterMaps.expand(
        (getterMap) => getterMap.values.map((getter) => getter(item)),
      );

      // Kiểm tra có ít nhất một thời gian nằm trong khoảng không
      return times.any((dateTime) {
        // Kiểm tra điều kiện thời gian bắt đầu
        bool matchesStart =
            start == null ||
            (inclusive
                ? (dateTime.isAfter(start) || dateTime.isAtSameMomentAs(start))
                : dateTime.isAfter(start));

        // Kiểm tra điều kiện thời gian kết thúc
        bool matchesEnd =
            end == null ||
            (inclusive
                ? (dateTime.isBefore(end) || dateTime.isAtSameMomentAs(end))
                : dateTime.isBefore(end));

        return matchesStart && matchesEnd;
      });
    }).toList();
  }

  /// Áp dụng bộ lọc theo ngày tháng
  /// Cập nhật _filteredData dựa trên _startDate và _endDate
  void _applyDateFilter() {
    setState(() {
      if (widget.getters != null &&
          widget.getters!.isNotEmpty &&
          _selectedGetterIndexes.isNotEmpty) {
        // Chỉ lấy các getter được chọn
        final selectedGetters =
            _selectedGetterIndexes
                .map((index) => widget.getters![index])
                .toList();

        // Áp dụng bộ lọc nếu có getter functions được chọn
        _filteredData = _filterByMultipleFields(
          data: widget.data,
          getterMaps: selectedGetters,
          start: _startDate,
          end: _endDate,
          inclusive: true, // Bao gồm cả boundary dates
        );
      } else {
        // Nếu không có getter được chọn thì giữ nguyên dữ liệu gốc
        _filteredData = widget.data;
      }

      // Cập nhật danh sách active filters để hiển thị chip
      _updateActiveFilters();
    });
  }

  /// Cập nhật danh sách các bộ lọc đang active
  void _updateActiveFilters() {
    _activeFilters.clear();

    if (_selectedGetterIndexes.isNotEmpty && widget.getters != null) {
      for (var index in _selectedGetterIndexes) {
        _activeFilters.add(widget.getters![index].keys.first);
      }
    }
  }

  /// Hiển thị dialog chọn các trường thời gian để lọc
  void _showFilterDialog() {
    if (widget.getters == null || widget.getters!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có thời gian nào để lọc')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Chọn thời gian để lọc'),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              content: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(widget.getters!.length, (index) {
                    final isSelected = _selectedGetterIndexes.contains(index);
                    final getterMap = widget.getters![index];
                    // Lấy tên từ key của Map
                    final displayName = getterMap.keys.first;

                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        displayName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedGetterIndexes.add(index);
                          } else {
                            _selectedGetterIndexes.remove(index);
                          }
                        });
                      },
                    );
                  }),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _applyDateFilter();
                  },
                  child: const Text('Áp dụng'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Xóa một filter cụ thể
  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
      _selectedGetterIndexes.removeWhere(
        (index) => widget.getters![index].keys.first == filter,
      );
      _applyDateFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final newWidths = adjustColumnWidths(
      originalWidths: {
        for (final col in widget.columns) col.title: col.width ?? 0,
      },
      minTableWidth: screenWidth,
    );

    final newColumns =
        widget.columns
            .map((col) => col.copyWith(width: newWidths[col.title]))
            .toList();

    return Column(
      children: [
        if (widget.isShowFilter &&
            widget.getters != null &&
            widget.getters!.isNotEmpty)
          Container(
            color: Colors.white60,
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Khoảng trống bên trái để hiển thị active filters
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        List.generate(_activeFilters.length, (index) {
                          final filter = _activeFilters[index];
                          return Container(
                            height: 32,
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  filter,
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 24,
                                    minHeight: 24,
                                  ),
                                  icon: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeFilter(filter),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),

                // Icon filter - click để mở dialog chọn trường
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: SvgPicture.asset(
                    AppSvgs.iconFilterHorizontal,
                    width: 18,
                    height: 18,
                  ),
                  onPressed: _showFilterDialog, // Mở dialog chọn trường
                ),
                const SizedBox(width: 10),

                // Chỉ hiển thị date inputs khi đã chọn ít nhất một trường
                if (_selectedGetterIndexes.isNotEmpty) ...[
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 8),
                          child: Text(
                            'Ngày bắt đầu:',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        SGDateTimeInputButton(
                          controller: _textTimeStartController,
                          value: _startDate,
                          onChanged: (dt) {
                            setState(() {
                              _startDate = dt;
                            });
                            _applyDateFilter();
                          },
                          width: double.infinity,
                          height: 32,
                          colorBorder: SGAppColors.colorBorderGray,
                          colorBorderFocus: SGAppColors.colorBorderGray,
                          targetAnchor: Alignment.bottomRight,
                          followerAnchor: Alignment.topRight,
                          sizeBorderCircular: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 8),
                          child: Text(
                            'Ngày kết thúc:',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        SGDateTimeInputButton(
                          controller: _textTimeEndController,
                          value: _endDate,
                          onChanged: (dt) {
                            setState(() {
                              _endDate = dt;
                            });
                            _applyDateFilter();
                          },
                          width: double.infinity,
                          height: 32,
                          colorBorder: SGAppColors.colorBorderGray,
                          colorBorderFocus: SGAppColors.colorBorderGray,
                          targetAnchor: Alignment.bottomRight,
                          followerAnchor: Alignment.topRight,
                          sizeBorderCircular: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        Divider(
          height: 1,
          thickness: 1,
          color: SGAppColors.colorBorderGray.withValues(alpha: 0.3),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: TableBaseConfig.tableBase<T>(
              columns: newColumns,
              isShowCheckboxes: widget.isShowCheckboxes,
              data: _filteredData,
              searchTerm: widget.searchTerm,
              onRowTap: (item) {
                widget.onRowTap?.call(item);
              },
              onSelectionChanged: (items) {
                widget.onSelectionChanged?.call(items);
              },
              filterPopupOffset: widget.filterPopupOffset,
              showQuantityColumn: widget.showQuantityColumn,
            ),
          ),
        ),
      ],
    );
  }
}
