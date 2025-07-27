import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/bloc/asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/bloc/asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/bloc/asset_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/models/asset_model.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/themes/sg_app_font.dart';
import 'dart:async'; // Import timer

class AssetView extends StatelessWidget {
  const AssetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AssetBloc, AssetState>(
        listener: (context, state) {
          if (state is AssetError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}')));
          }
        },
        builder: (context, state) {
          // Load dữ liệu khi widget được tạo
          if (state is AssetInitial) {
            context.read<AssetBloc>().add(LoadAssetsWithPagination(page: 1, pageSize: context.read<AssetBloc>().defaultPageSize));
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssetPaginatedLoaded) {
            return AssetPaginatedContent(state: state);
          }

          return const Center(child: Text('Không có dữ liệu'));
        },
      ),
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
  final ScrollController verticalController = ScrollController();
  String searchQuery = '';
  final TextEditingController controllerDropdownPage = TextEditingController();

  // Thêm biến để điều chỉnh tốc độ cuộn
  double scrollVelocity = 2.0;
  bool isProgrammaticScroll = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    searchQuery = widget.state.searchQuery ?? '';
    controllerDropdownPage.text = widget.state.pageSize.toString();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    controllerDropdownPage.dispose();
    horizontalController.dispose();
    verticalController.dispose();
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
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.all(const Color(0xFF78909C)),
              thickness: WidgetStateProperty.all(8),
              radius: const Radius.circular(4),
            ),
            child: Scrollbar(
              controller: horizontalController,
              thumbVisibility: true,
              notificationPredicate: (notification) => notification.metrics.axis == Axis.horizontal,
              child: Scrollbar(
                controller: verticalController,
                thumbVisibility: true,
                notificationPredicate: (notification) => notification.metrics.axis == Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  clipBehavior: Clip.hardEdge,
                  key: PageStorageKey<String>('asset_table_horizontal_${widget.state.hashCode}'),
                  child: _buildTable(
                    widget.state.assets,
                    onViewAction: (item) {},
                    onEditAction: (item) {},
                    onDeleteAction: (item) {},
                    onRowTap: (item) {},
                    verticalController: verticalController,
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildPagination(widget.state),
      ],
    );
  }

  Widget _buildPagination(AssetPaginatedLoaded state) {
    final int firstItem = (state.currentPage - 1) * state.pageSize + 1;
    final int lastItem = (state.currentPage * state.pageSize > state.totalItems) ? state.totalItems : state.currentPage * state.pageSize;

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
            LoadAssetsWithPagination(page: 1, pageSize: pageSize, searchQuery: state.searchQuery, department: state.department, assetType: state.assetType),
          );
        }
      },
    );
  }

  List<SgTableColumn<AssetModel>> _buildColumns() {
    // Tính toán kích thước cột dựa trên kích thước màn hình
    final double screenWidth = MediaQuery.of(context).size.width;
    final int columnsCount = 19; // 1 cột checkbox + 18 cột dữ liệu
    final double defaultColumnWidth = 92.0;

    // Tính tổng kích thước các cột nếu dùng giá trị mặc định
    final double totalDefaultWidth = defaultColumnWidth * columnsCount;

    // Nếu tổng kích thước không vượt quá màn hình, chia đều
    double columnWidth = defaultColumnWidth;
    if (totalDefaultWidth < screenWidth) {
      // Trừ đi padding và margin để có không gian thực tế
      double availableWidth = screenWidth; // Giả sử padding 20px mỗi bên
      columnWidth = availableWidth / columnsCount;
    }
    // Nếu vượt quá, giữ nguyên giá trị mặc định

    return [
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
  }

  Widget _buildTable(
    List<AssetModel> data, {
    Function(AssetModel)? onViewAction,
    Function(AssetModel)? onEditAction,
    Function(AssetModel)? onDeleteAction,
    Function(AssetModel)? onRowTap,
    ScrollController? verticalController,
  }) {
    return SgTable<AssetModel>(
      headerBackgroundColor: ColorValue.colorE6EAED, // Giữ nguyên
      evenRowBackgroundColor: const Color(0xFFF8F9FA), // Màu xám nhạt cho hàng chẵn
      oddRowBackgroundColor: Colors.white, // Giữ nguyên
      selectedRowColor: const Color(0xFFE3F2FD), // Xanh dương nhạt cho hàng được chọn
      checkedRowColor: const Color(0xFFE8F5E9), // Xanh lá nhạt cho hàng được check
      gridLineColor: const Color(0xFFE0E0E0), // Xám nhạt cho đường kẻ
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
      onRowTap: (item) {
        onRowTap?.call(item);
      },
      scaleCheckbox: 0.8,
      activeColor: const Color(0xFF4CAF50), // Màu xanh lá cho checkbox đã chọn
      checkColor: Colors.white, // Giữ nguyên
      side: const BorderSide(color: Color(0xFFBDBDBD), width: 0.5), // Viền xám nhạt thay vì đen
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      verticalController: verticalController,
    );
  }
}
