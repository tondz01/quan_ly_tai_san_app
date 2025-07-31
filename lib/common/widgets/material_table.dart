import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/common/table/table_styles.dart';

class MaterialTable<T> extends StatelessWidget {
  final List<MaterialTableColumn<T>> columns;
  final List<T> data;
  final String? searchTerm;
  final Function(T)? onRowTap;
  final Function(T)? onViewAction;
  final Function(T)? onEditAction;
  final Function(T)? onDeleteAction;
  final Function(List<T>)? onSelectionChanged;
  final bool showCheckboxes;
  final bool showActions;
  final bool allowRowSelection;
  final double rowHeight;
  final EdgeInsetsGeometry? padding;
  final bool showHeader;
  final String? emptyMessage;
  final Widget? emptyWidget;

  const MaterialTable({
    super.key,
    required this.columns,
    required this.data,
    this.searchTerm,
    this.onRowTap,
    this.onViewAction,
    this.onEditAction,
    this.onDeleteAction,
    this.onSelectionChanged,
    this.showCheckboxes = false,
    this.showActions = true,
    this.allowRowSelection = true,
    this.rowHeight = 56.0,
    this.padding,
    this.showHeader = true,
    this.emptyMessage,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: TableStyles.tableContainerDecoration(),
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: [
          if (showHeader) _buildHeader(),
          _buildTableContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: ColorValue.primaryBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          if (showCheckboxes)
            Container(
              width: 48,
              padding: const EdgeInsets.all(16),
              child: Checkbox(
                value: false,
                onChanged: (value) {},
                activeColor: Colors.white,
                checkColor: ColorValue.primaryBlue,
              ),
            ),
          ...columns.map((column) => Expanded(
            flex: column.flex ?? 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                column.title,
                style: TableStyles.headerTextStyle(),
                textAlign: column.textAlign ?? TextAlign.start,
              ),
            ),
          )),
          if (showActions)
            Container(
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Thao tác',
                style: TableStyles.headerTextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (context, index) => Divider(
          color: ColorValue.neutral200,
          height: 1,
          thickness: 1,
        ),
        itemBuilder: (context, index) {
          final item = data[index];
          return _buildTableRow(item, index);
        },
      ),
    );
  }

  Widget _buildTableRow(T item, int index) {
    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : ColorValue.neutral50,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onRowTap?.call(item),
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              if (showCheckboxes)
                Container(
                  width: 48,
                  padding: const EdgeInsets.all(16),
                  child: Checkbox(
                    value: false,
                    onChanged: (value) {},
                    activeColor: ColorValue.primaryBlue,
                    checkColor: Colors.white,
                  ),
                ),
              ...columns.map((column) => Expanded(
                flex: column.flex ?? 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: column.builder(item),
                ),
              )),
              if (showActions)
                Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (onViewAction != null)
                        _buildActionButton(
                          icon: Icons.visibility,
                          color: ColorValue.success,
                          onPressed: () => onViewAction!(item),
                          tooltip: 'Xem',
                        ),
                      if (onEditAction != null) ...[
                        const SizedBox(width: 4),
                        _buildActionButton(
                          icon: Icons.edit,
                          color: ColorValue.primaryBlue,
                          onPressed: () => onEditAction!(item),
                          tooltip: 'Sửa',
                        ),
                      ],
                      if (onDeleteAction != null) ...[
                        const SizedBox(width: 4),
                        _buildActionButton(
                          icon: Icons.delete,
                          color: ColorValue.error,
                          onPressed: () => onDeleteAction!(item),
                          tooltip: 'Xóa',
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(icon, size: 16),
          color: color,
          onPressed: onPressed,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (emptyWidget != null) {
      return emptyWidget!;
    }

    return Container(
      decoration: TableStyles.tableContainerDecoration(),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.table_rows,
            size: 64,
            color: ColorValue.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage ?? 'Không có dữ liệu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorValue.neutral600,
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialTableColumn<T> {
  final String title;
  final Widget Function(T item) builder;
  final int? flex;
  final TextAlign? textAlign;

  const MaterialTableColumn({
    required this.title,
    required this.builder,
    this.flex,
    this.textAlign,
  });
}

class MaterialTableWithPagination<T> extends StatefulWidget {
  final List<MaterialTableColumn<T>> columns;
  final List<T> data;
  final int itemsPerPage;
  final String? searchTerm;
  final Function(T)? onRowTap;
  final Function(T)? onViewAction;
  final Function(T)? onEditAction;
  final Function(T)? onDeleteAction;
  final Function(List<T>)? onSelectionChanged;
  final bool showCheckboxes;
  final bool showActions;
  final bool allowRowSelection;
  final double rowHeight;
  final EdgeInsetsGeometry? padding;
  final bool showHeader;
  final String? emptyMessage;
  final Widget? emptyWidget;

  const MaterialTableWithPagination({
    super.key,
    required this.columns,
    required this.data,
    this.itemsPerPage = 10,
    this.searchTerm,
    this.onRowTap,
    this.onViewAction,
    this.onEditAction,
    this.onDeleteAction,
    this.onSelectionChanged,
    this.showCheckboxes = false,
    this.showActions = true,
    this.allowRowSelection = true,
    this.rowHeight = 56.0,
    this.padding,
    this.showHeader = true,
    this.emptyMessage,
    this.emptyWidget,
  });

  @override
  State<MaterialTableWithPagination<T>> createState() => _MaterialTableWithPaginationState<T>();
}

class _MaterialTableWithPaginationState<T> extends State<MaterialTableWithPagination<T>> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.data.length / widget.itemsPerPage).ceil();
    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(0, widget.data.length);
    final currentData = widget.data.sublist(startIndex, endIndex);

    return Column(
      children: [
        MaterialTable<T>(
          columns: widget.columns,
          data: currentData,
          searchTerm: widget.searchTerm,
          onRowTap: widget.onRowTap,
          onViewAction: widget.onViewAction,
          onEditAction: widget.onEditAction,
          onDeleteAction: widget.onDeleteAction,
          onSelectionChanged: widget.onSelectionChanged,
          showCheckboxes: widget.showCheckboxes,
          showActions: widget.showActions,
          allowRowSelection: widget.allowRowSelection,
          rowHeight: widget.rowHeight,
          padding: widget.padding,
          showHeader: widget.showHeader,
          emptyMessage: widget.emptyMessage,
          emptyWidget: widget.emptyWidget,
        ),
        if (totalPages > 1) ...[
          const SizedBox(height: 16),
          _buildPagination(totalPages),
        ],
      ],
    );
  }

  Widget _buildPagination(int totalPages) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorValue.neutral200.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hiển thị ${_currentPage * widget.itemsPerPage + 1}-${(_currentPage + 1) * widget.itemsPerPage} của ${widget.data.length} kết quả',
            style: TextStyle(
              fontSize: 13,
              color: ColorValue.neutral600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _buildPaginationButton(
                icon: Icons.chevron_left,
                onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
              ),
              const SizedBox(width: 8),
              ...List.generate(totalPages, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _buildPageButton(index),
                );
              }),
              const SizedBox(width: 8),
              _buildPaginationButton(
                icon: Icons.chevron_right,
                onPressed: _currentPage < totalPages - 1 ? () => _goToPage(_currentPage + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null ? ColorValue.primaryBlue : ColorValue.neutral200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: onPressed != null ? Colors.white : ColorValue.neutral400,
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
      ),
    );
  }

  Widget _buildPageButton(int pageIndex) {
    final isActive = pageIndex == _currentPage;
    return Container(
      decoration: BoxDecoration(
        color: isActive ? ColorValue.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? ColorValue.primaryBlue : ColorValue.neutral300,
          width: 1,
        ),
      ),
      child: TextButton(
        onPressed: () => _goToPage(pageIndex),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(32, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          '${pageIndex + 1}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : ColorValue.neutral700,
          ),
        ),
      ),
    );
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }
} 