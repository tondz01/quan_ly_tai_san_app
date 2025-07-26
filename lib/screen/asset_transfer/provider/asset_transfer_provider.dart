// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/asset_transfer_list.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_state.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/detail_and_edit.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetTransferProvider with ChangeNotifier {
  bool get isLoading => _isLoading;
  List<AssetTransferDto>? get dataPage => _dataPage;
  get data => _data;
  get columns => _columns;
  String? get error => _error;
  String? get subScreen => _subScreen;

  Widget? get body => _body;

  set subScreen(String? value) {
    _subScreen = value;
    notifyListeners();
  }

  set body(Widget? value) {
    _body = value;
    notifyListeners();
  }

  set dataPage(List<AssetTransferDto>? value) {
    _dataPage = value;
    notifyListeners();
  }

  int typeAssetTransfer = 1;

  late int totalEntries;
  late int totalPages;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  String? _error;
  String? _subScreen;
  String mainScreen = '';

  Widget? _body;

  bool _isLoading = false;

  List<AssetTransferDto>? _data;
  List<AssetTransferDto>? _dataPage;
  List<SgTableColumn<AssetTransferDto>> _columns = [];

  void onInit(BuildContext context, int typeAssetTransfer) {
    this.typeAssetTransfer = typeAssetTransfer;
    _isLoading = true;
    controllerDropdownPage = TextEditingController(text: '10');
    // Initialize body without triggering notification
    _body = AssetTransferList(provider: this, mainScreen: onSetMainScreen());
    onChangeScreen(item: null, isMainScreen: true, isEdit: false);
    log('message onInit');
    getListToolsAndSupplies(context);
  }

  void onDispose() {
    _isLoading = false;
    _data = null;
    _error = null;

    if (controllerDropdownPage != null) {
      controllerDropdownPage!.dispose();
      controllerDropdownPage = null;
    }
  }

  void onTapBackHeader() {
    onChangeScreen(item: null, isMainScreen: true, isEdit: false);
    notifyListeners();
  }

  void onTapNewHeader() {
    onChangeScreen(item: null, isMainScreen: false, isEdit: true);
    notifyListeners();
  }

  void getListToolsAndSupplies(BuildContext context) {
    _isLoading = true;
    Future.microtask(() {
      context.read<AssetTransferBloc>().add(
        GetListAssetTransferEvent(context, typeAssetTransfer),
      );
    });
  }

  void _updatePagination() {
    totalEntries = data?.length ?? 0;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    dataPage =
        data.isNotEmpty
            ? data.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
    log('message pageProducts: ${dataPage!.length}');
  }

  void onChangeScreen({
    required AssetTransferDto? item,
    required bool isMainScreen,
    required bool isEdit,
  }) {
    // Use Future.microtask to avoid build phase conflicts
    log('message onChangeScreen');
    Future.microtask(() {
      mainScreen =
          typeAssetTransfer == 1
              ? 'Cấp phát tài sản'
              : typeAssetTransfer == 2
              ? 'Thu hồi tài sản'
              : 'Điều động tài sản';
      if (!isMainScreen) {
        _subScreen = item == null ? 'Mới' : item.documentName ?? '';
        _body = Container();
      } else {
        _subScreen = '';
        _subScreen = null;
        _body = AssetTransferList(provider: this, mainScreen: mainScreen);
      }
      notifyListeners();
    });
  }

  void onPageChanged(int page) {
    currentPage = page;
    _updatePagination();
    notifyListeners();
  }

  void onRowsPerPageChanged(int? value) {
    log('message onRowsPerPageChanged: $value');
    if (value == null) return;
    rowsPerPage = value;
    currentPage = 1;
    _updatePagination();
    notifyListeners();
  }

  void updateItem(AssetTransferDto updatedItem) {
    if (_data == null) return;

    int index = _data!.indexWhere((item) => item.id == updatedItem.id);

    if (index != -1) {
      _data![index] = updatedItem;

      _updatePagination();

      notifyListeners();

      log('Đã cập nhật item có ID: ${updatedItem.id}');
    } else {
      log('Không tìm thấy item có ID: ${updatedItem.id}');
    }
  }

  void deleteItem(String id) {
    if (_data == null) return;

    // Tìm vị trí của item cần xóa
    int index = _data!.indexWhere((item) => item.id == id);

    if (index != -1) {
      // Xóa item khỏi danh sách
      _data!.removeAt(index);

      // Cập nhật lại trang hiện tại
      _updatePagination();

      // Thông báo UI cập nhật
      notifyListeners();

      log('Đã xóa item có ID: $id');
    } else {
      log('Không tìm thấy item có ID: $id');
    }
  }

  getListAssetTransferSuccess(
    BuildContext context,
    GetListAssetTransferSuccessState state,
  ) {
    _error = null;
    if (state.data.isEmpty) {
      _data = [];
    } else {
      _data = state.data;
      _isLoading = false;
      onSetColumns();
      _updatePagination();
    }
    notifyListeners();
  }

  String onSetMainScreen() {
    return mainScreen =
        typeAssetTransfer == 1
            ? 'Cấp phát tài sản'
            : typeAssetTransfer == 2
            ? 'Thu hồi tài sản'
            : 'Điều động tài sản';
  }

  void onSetColumns() {
    _columns = [
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Tên phiếu',
        getValue: (item) => item.documentName ?? '',
        width: 170,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Số quyết định',
        getValue: (item) => item.decisionNumber ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Ngày quyết định',
        getValue: (item) => item.decisionDate ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Người đề nghị',
        getValue: (item) => item.requester ?? '',
        width: 150,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Người lập phiếu',
        getValue: (item) => item.creator ?? '',
        width: 150,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Chi tiết điều động',
        getValue: (item) => item.movementDetails?.join(', ') ?? '',
        width: 170,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Đơn vị giao',
        getValue: (item) => item.sendingUnit ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Đơn vị nhận',
        getValue: (item) => item.receivingUnit ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'TGGN từ Ngày',
        getValue: (item) => item.effectiveDate ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Trình duyệt Ban giám đốc',
        getValue: (item) => item.approver ?? '',
        width: 120,
      ),
      TableColumnBuilder.createTextColumn<AssetTransferDto>(
        title: 'Trạng thái',
        getValue: (item) => item.status ?? '',
        width: 120,
      ),
      SgTableColumn<AssetTransferDto>(
        title: 'Có hiệu lực',
        cellBuilder: (item) => showEffective(item.isEffective ?? false),
        sortValueGetter: (item) => item.isEffective,
        searchValueGetter:
            (item) => (item.isEffective ?? false) ? 'Có' : 'Không',
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: 120,
        searchable: true,
      ),
    ];
  }

  Widget showEffective(bool isEffective) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: isEffective,
        onChanged: null, // Checkbox is read-only, no setState in provider
        activeColor: const Color(0xFF80C9CB), // màu xanh nhạt
        checkColor: Colors.white, // dấu tick màu trắng
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2), // vuông góc
        ),
        materialTapTargetSize:
            MaterialTapTargetSize.shrinkWrap, // thu nhỏ vùng tap
        visualDensity: VisualDensity.compact, // giảm padding
      ),
    );
  }
}
