import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/bloc/asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/bloc/asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/bloc/asset_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/models/asset_model.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/themes/sg_app_font.dart';
import 'dart:async';

class AssetView extends StatelessWidget {
  const AssetView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: _AssetViewBody(),
    );
  }
}

class _AssetViewBody extends StatelessWidget {
  const _AssetViewBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetBloc, AssetState>(
      listener: (context, state) {
        if (state is AssetError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        // Load dữ liệu khi widget được tạo
        if (state is AssetInitial) {
          context.read<AssetBloc>().add(
            LoadAssetsWithPagination(
              page: 1, 
              pageSize: context.read<AssetBloc>().defaultPageSize,
            ),
          );
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 12.0, 
              color: ColorValue.colorFE9F43,
            ),
          );
        }

        if (state is AssetLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 12.0, 
              color: ColorValue.colorFE9F43,
            ),
          );
        }

        if (state is AssetPaginatedLoaded) {
          return AssetPaginatedContent(state: state);
        }

        return const Center(child: Text('Không có dữ liệu'));
      },
    );
  }
}

class AssetPaginatedContent extends StatefulWidget {
  final AssetPaginatedLoaded state;

  const AssetPaginatedContent({super.key, required this.state});

  @override
  State<AssetPaginatedContent> createState() => _AssetPaginatedContentState();
}

class _AssetPaginatedContentState extends State<AssetPaginatedContent> {
  final ScrollController horizontalController = ScrollController();
  String searchQuery = '';
  final TextEditingController controllerDropdownPage = TextEditingController();

  // Thêm biến để điều chỉnh tốc độ cuộn
  double scrollVelocity = 2.0;
  bool isProgrammaticScroll = false;
  Timer? _scrollTimer;

  // Cache cho columns để tránh tính toán lại
  List<SgTableColumn<AssetModel>>? _cachedColumns;
  double? _cachedScreenWidth;

  @override
  void initState() {
    super.initState();
    searchQuery = widget.state.searchQuery ?? '';
    controllerDropdownPage.text = widget.state.pageSize.toString();
  }

  @override
  void didUpdateWidget(AssetPaginatedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Invalidate cache nếu state thay đổi
    if (oldWidget.state != widget.state) {
      _cachedColumns = null;
      _cachedScreenWidth = null;
    }
    
    searchQuery = widget.state.searchQuery ?? '';
    if (controllerDropdownPage.text != widget.state.pageSize.toString()) {
      controllerDropdownPage.text = widget.state.pageSize.toString();
    }
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    controllerDropdownPage.dispose();
    horizontalController.dispose();
    _cachedColumns = null; // Clear cache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tài sản', style: SGAppFont.headline6(fontWeight: FontWeight.w400)),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ScrollbarTheme(
                data: const ScrollbarThemeData(
                  thumbColor: WidgetStatePropertyAll(Color(0xFF78909C)),
                  thickness: WidgetStatePropertyAll(8.0),
                  radius: Radius.circular(4),
                ),
                child: Scrollbar(
                  controller: horizontalController,
                  thumbVisibility: true,
                  notificationPredicate: (notification) => 
                      notification.metrics.axis == Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: horizontalController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    clipBehavior: Clip.hardEdge,
                    key: PageStorageKey<String>(
                      'asset_table_horizontal_${widget.state.hashCode}'
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTable(
                        widget.state.assets,
                        onViewAction: (item) {},
                        onEditAction: (item) {},
                        onDeleteAction: (item) {},
                        onRowTap: (item) {},
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _buildPagination(widget.state),
      ],
    );
  }

  Widget _buildPagination(AssetPaginatedLoaded state) {
    final int firstItem = (state.currentPage - 1) * state.pageSize + 1;
    final int lastItem =
        (state.currentPage * state.pageSize > state.totalItems) ? state.totalItems : state.currentPage * state.pageSize;

    return SGPaginationControls(
      labelRowsPerPage: '$firstItem-$lastItem / ${state.totalItems}',
      totalPages: state.totalPages,
      currentPage: state.currentPage,
      rowsPerPage: state.pageSize,
      controllerDropdownPage: controllerDropdownPage,
      items: context.read<AssetBloc>().rowPerPageItems,
      onPageChanged: (page) {
        context.read<AssetBloc>().add(ChangePage(page));
      },
      onRowsPerPageChanged: (pageSize) {
        if (pageSize != null) {
          context.read<AssetBloc>().add(
            LoadAssetsWithPagination(
              page: 1,
              pageSize: pageSize,
              searchQuery: state.searchQuery,
              department: state.department,
              assetType: state.assetType,
            ),
          );
        }
      },
    );
  }

  List<SgTableColumn<AssetModel>> _buildColumns() {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    // Cache columns nếu kích thước màn hình không thay đổi
    if (_cachedColumns != null && _cachedScreenWidth == screenWidth) {
      return _cachedColumns!;
    }

    // Tối ưu tính toán kích thước cột
    const int columnsCount = 19; // 1 cột checkbox + 18 cột dữ liệu
    const double defaultColumnWidth = 120.0; // Tăng một chút để dễ đọc
    const double minColumnWidth = 80.0; // Kích thước tối thiểu

    // Tính toán column width một cách thông minh
    double columnWidth = defaultColumnWidth;
    final double totalDefaultWidth = defaultColumnWidth * columnsCount;
    
    if (totalDefaultWidth > screenWidth) {
      // Nếu quá rộng, điều chỉnh nhưng không nhỏ hơn min
      final double calculatedWidth = (screenWidth * 0.95) / columnsCount;
      columnWidth = calculatedWidth > minColumnWidth ? calculatedWidth : minColumnWidth;
    }

    _cachedColumns = [
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Mã tài sản',
        width: columnWidth,
        getValue: (item) => item.id,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Tên tài sản',
        width: columnWidth,
        getValue: (item) => item.name,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Ngày vào sổ',
        width: columnWidth,
        getValue: (item) => item.registrationDate,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Ngày sử dụng',
        width: columnWidth,
        getValue: (item) => item.usageDate,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Đơn vị sử dụng',
        width: columnWidth,
        getValue: (item) => item.department,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Số lượng TS con',
        width: columnWidth,
        getValue: (item) => item.childAssetCount,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Số lượng Phụ lục ts',
        width: columnWidth,
        getValue: (item) => item.attachmentCount,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Ghi chú',
        width: columnWidth,
        getValue: (item) => item.note,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Tài khoản tài sản',
        width: columnWidth,
        getValue: (item) => item.assetAccount,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Dự án',
        width: columnWidth,
        getValue: (item) => item.project,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Mô hình tài sản',
        width: columnWidth,
        getValue: (item) => item.assetType,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Nguyên giá tài sản',
        width: columnWidth,
        getValue: (item) => item.originalCost,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Giá trị Khấu hao ban đầu',
        width: columnWidth,
        getValue: (item) => item.initialDepreciationValue,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Kỳ khấu hao ban đầu',
        width: columnWidth,
        getValue: (item) => item.initialDepreciationPeriod,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'GTCL ban đầu',
        width: columnWidth,
        getValue: (item) => item.initialResidualValue,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Giá trị Khấu hao phát sinh',
        width: columnWidth,
        getValue: (item) => item.accruedDepreciationValue,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Kỳ khấu hao phát sinh',
        width: columnWidth,
        getValue: (item) => item.accruedDepreciationPeriod,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Giá trị khấu hao còn lại',
        width: columnWidth,
        getValue: (item) => item.remainingDepreciationValue,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
      TableColumnBuilder.createTextColumn<AssetModel>(
        title: 'Kỳ khấu hao còn lại',
        width: columnWidth,
        getValue: (item) => item.remainingDepreciationPeriod,
        align: TextAlign.left,
        styleTextValue: SGAppFont.bodyMedium(fontWeight: FontWeight.w400, color: Colors.black),
        titleStyle: SGAppFont.bodyMedium(fontWeight: FontWeight.w600, color: Colors.black),
        maxLines: 1,
      ),
    ];
    
    _cachedScreenWidth = screenWidth;
    return _cachedColumns!;
  }

  Widget _buildTable(
    List<AssetModel> data, {
    Function(AssetModel)? onViewAction,
    Function(AssetModel)? onEditAction,
    Function(AssetModel)? onDeleteAction,
    Function(AssetModel)? onRowTap,
  }) {
    // Sử dụng const cho các giá trị không thay đổi
    const Color headerBgColor = ColorValue.colorE6EAED;
    const Color evenRowBgColor = Color(0xFFF8F9FA);
    const Color oddRowBgColor = Colors.white;
    const Color selectedRowColor = Color(0xFFE3F2FD);
    const Color checkedRowColor = Color(0xFFE8F5E9);
    const Color gridLineColor = Color(0xFFE0E0E0);
    const Color activeColor = Color(0xFF4CAF50);
    const Color checkColor = Colors.white;
    const BorderSide borderSide = BorderSide(color: Color(0xFFBDBDBD), width: 0.5);
    
    return RepaintBoundary(
      child: SgTable<AssetModel>(
        headerBackgroundColor: headerBgColor,
        evenRowBackgroundColor: evenRowBgColor,
        oddRowBackgroundColor: oddRowBgColor,
        selectedRowColor: selectedRowColor,
        checkedRowColor: checkedRowColor,
        gridLineColor: gridLineColor,
        gridLineWidth: 1,
        showVerticalLines: true,
        showHorizontalLines: true,
        showLastLineLeftRight: true,
        showLastLineTopBottom: true,
        allowRowSelection: true,
        searchTerm: '',
        showCheckboxes: true,
        onSelectionChanged: (selectedItems) {},
        customFilter: (item) => true,
        checkboxColumnWidth: 42,
        rowHeight: 42,
        columns: _buildColumns(),
        data: data,
        onRowTap: onRowTap,
        scaleCheckbox: 0.8,
        activeColor: activeColor,
        checkColor: checkColor,
        side: borderSide,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
      ),
    );
  }
}
