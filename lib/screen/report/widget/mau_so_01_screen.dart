// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/common/widgets/report_page_wrapper_multipage.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tang_giam_trong_ky_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/mau_so_01.page.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:quan_ly_tai_san_app/screen/report/component/report_provider.dart';
import 'package:quan_ly_tai_san_app/screen/report/service/excel_export_service.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/report_repository.dart';
import 'package:se_gay_components/core/enum/sg_date_time_mode.dart';

class MauSo01Screen extends StatefulWidget {
  const MauSo01Screen({super.key});

  @override
  State<MauSo01Screen> createState() => _MauSo01ScreenState();
}

class _MauSo01ScreenState extends State<MauSo01Screen> {
  List<TangGiamTrongKyDto> _listData = [];
  List<TangGiamTrongKyDto> _fullListData = []; // Dữ liệu đầy đủ để xuất Excel/In

  List<AssetRowData> _allAssetRows = [];
  List<List<AssetRowData>> _listPages = [];
  final ReportRepository _repo = ReportRepository();
  final List<GlobalKey> _pageKeys = [];

  // Giới hạn hiển thị tối đa 50 items
  static const int _maxDisplayItems = 50;

  TextEditingController controllerImportDate = TextEditingController();
  TextEditingController controllerDonVi = TextEditingController();

  List<PhongBan> listPhongBan = [];
  PhongBan? donVi;
  bool _isLoading = false;
  bool _isExporting = false;
  int numberPageStart = 6;
  int numberPage = 18;
  late HomeScrollController _scrollController;

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    controllerImportDate.dispose();
    controllerDonVi.dispose();
    super.dispose();
  }

  Future<void> _exportToExcel() async {
    if (_fullListData.isEmpty) {
      AppUtility.showSnackBar(context, 'Không có dữ liệu để xuất!', isError: true);
      return;
    }

    setState(() => _isExporting = true);

    try {
      await ExcelExportService.exportMauSo01ToExcel(
        data: _fullListData,
        departmentName: donVi?.tenPhongBan ?? '',
        thangNam: controllerImportDate.text.trim(),
      );

      if (mounted) {
        AppUtility.showSnackBar(context, 'Xuất Excel thành công!');
      }
    } catch (e) {
      SGLog.error('MauSo01Screen', 'Lỗi xuất Excel: $e');
      if (mounted) {
        AppUtility.showSnackBar(context, 'Lỗi xuất Excel: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _loadData() async {
    listPhongBan = AccountHelper.instance.getDepartment() ?? [];
    setState(() {});
  }

  Future<void> onloadViewPage() async {
    if (donVi == null) return;

    setState(() {
      _isLoading = true;
    });

    // Format date to YYYY-MM-DD format
    String formattedDate = formatToYyyyMmDd(controllerImportDate.text.trim());

    // Gọi API mới: GET /api/baocao/tang-giam-trong-ky
    final result = await _repo.getTangGiamTrongKy(
      donVi!.id!,
      formattedDate,
    );

    if (!mounted) return;
    if (checkStatusCodeDone(result)) {
      final fullData = (result['data'] as List).cast<TangGiamTrongKyDto>();
      _fullListData = fullData;

      // Giới hạn hiển thị tối đa 50 items
      final displayData = fullData.length > _maxDisplayItems
          ? fullData.sublist(0, _maxDisplayItems)
          : fullData;

      setState(() {
        _listData = displayData;

        _parseDataToAssetRows();

        _listPages = _chunkAssetRowData(_allAssetRows);
        final int totalPages =
            _listPages.isEmpty ? 1 : _listPages.length + 1; // +1 trang footer
        _pageKeys
          ..clear()
          ..addAll(List.generate(totalPages, (_) => GlobalKey()));
        _isLoading = false;
        if (fullData.isEmpty) {
          AppUtility.showSnackBar(context, 'Không có dữ liệu!');
        } else {
          String message = 'Lấy dữ liệu thành công!';
          if (fullData.length > _maxDisplayItems) {
            message = 'Hiển thị $_maxDisplayItems/${fullData.length} items. Xuất Excel/In để xem toàn bộ.';
          }
          AppUtility.showSnackBar(context, message);
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      AppUtility.showSnackBar(context, 'Lấy dữ liệu thất bại!', isError: true);
    }
  }

  String formatToYyyyMmDd(String input) {
    final String trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      // Thử parse ISO trực tiếp (e.g., 2025-10-01 hoặc có time)
      final DateTime parsedIso = DateTime.parse(trimmed.split(' ').first);
      return "${parsedIso.year}-${parsedIso.month.toString().padLeft(2, '0')}-${parsedIso.day.toString().padLeft(2, '0')}";
    } catch (_) {
      try {
        // Thử định dạng DD/MM/YYYY (có thể kèm time)
        final String dateOnly = trimmed.split(' ').first;
        final List<String> parts = dateOnly.split('/');
        if (parts.length == 3) {
          final int day = int.parse(parts[0]);
          final int month = int.parse(parts[1]);
          final int year = int.parse(parts[2]);
          return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
        }
      } catch (e) {
        SGLog.info('formattedDate', 'DD/MM/YYYY parse error: $e');
      }
    }
    return trimmed;
  }

  List<List<AssetRowData>> _chunkAssetRowData(List<AssetRowData> source) {
    if (source.isEmpty) return [];

    final List<List<AssetRowData>> pages = [];

    // First page: up to 20 items
    final int firstPageCount =
        source.length >= numberPageStart ? numberPageStart : source.length;
    pages.add(source.sublist(0, firstPageCount));

    // Remaining pages: 50 items each
    int startIndex = firstPageCount;
    int subsequentPageSize = numberPage;
    while (startIndex < source.length) {
      final int endIndex =
          (startIndex + subsequentPageSize <= source.length)
              ? startIndex + subsequentPageSize
              : source.length;
      pages.add(source.sublist(startIndex, endIndex));
      startIndex = endIndex;
    }

    return pages;
  }

  // int _pageStartIndex(int pageIndex) {
  //   int start = 0;
  //   for (int i = 0; i < pageIndex && i < _listPages.length; i++) {
  //     start += _listPages[i].length;
  //   }
  //   return start;
  // }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    return ReportPageWrapperMultipage(
      title: 'Mẫu số-01',
      isLoading: _isLoading,
      isExporting: _isExporting,
      scrollPhysics: _scrollController.isParentScrolling
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      filterWidgets: [
        CmFormDropdownObject<PhongBan>(
          label: 'Đơn vị',
          controller: controllerDonVi,
          isEditing: true,
          items: [
            ...listPhongBan.map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.tenPhongBan ?? ''),
              ),
            ),
          ],
          fieldName: 'tPDonVi',
          value: donVi,
          onChanged: (value) {
            setState(() {
              donVi = value;
            });
          },
        ),
        CmFormDate(
          label: 'Kỳ báo cáo',
          controller: controllerImportDate,
          isEditing: true,
          fieldName: 'importDate',
          dateTimeMode: SGDateTimeMode.monthYear,
          showTimeSection: false,
          onChanged: (date) {
            setState(() {});
          },
        ),
      ],
      onLoadData: onloadViewPage,
      onExportExcel: _exportToExcel,
      onPrint: () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await ReportProvider().exportToPdfAndPrint(
            _pageKeys,
            context,
            () {},
          );
        });
      },
      content: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return true;
        },
        child: Column(
                                children: [
                                  if (_listPages.isEmpty)
                                    RepaintBoundary(
                                      key:
                                          _pageKeys.isNotEmpty
                                              ? _pageKeys[0]
                                              : GlobalKey(),
                                      child: Stack(
                                        children: [
                                          A4Canvas(
                                            marginsMm: EdgeInsets.all(4),
                                            scale: 1.0,
                                            maxWidth: sizeWidth,
                                            maxHeight: sizeWidth * (297 / 210),
                                            child: Column(
                                              children: [
                                                HeaderMauSo01(),
                                                BodyMauSo01(assetRows: _allAssetRows),
                                                FoooterMauSo01(),
                                              ],
                                            ),
                                          ),
                                          NumberPageView(index: 0),
                                        ],
                                      ),
                                    )
                                  else if (_listPages.length < numberPageStart)
                                    RepaintBoundary(
                                      key:
                                          _pageKeys.isNotEmpty
                                              ? _pageKeys[0]
                                              : GlobalKey(),
                                      child: Stack(
                                        children: [
                                          A4Canvas(
                                            marginsMm: EdgeInsets.all(4),
                                            scale: 1.0,
                                            maxWidth: sizeWidth,
                                            maxHeight: sizeWidth * (297 / 210),
                                            child: Column(
                                              children: [
                                                HeaderMauSo01(),
                                                BodyMauSo01(assetRows: _allAssetRows),
                                                FoooterMauSo01(),
                                              ],
                                            ),
                                          ),
                                          NumberPageView(index: 0),
                                        ],
                                      ),
                                    )
                                  else
                                    ...List.generate(_listPages.length, (
                                      index,
                                    ) {
                                      if (index == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                          ),
                                          child: RepaintBoundary(
                                            key: _pageKeys[index],
                                            child: Stack(
                                              children: [
                                                A4Canvas(
                                                  marginsMm: EdgeInsets.all(4),
                                                  scale: 1.0,
                                                  maxWidth: sizeWidth,
                                                  maxHeight: sizeWidth * (297 / 210),
                                                  child: Column(
                                                    children: [
                                                      HeaderMauSo01(),
                                                      BodyMauSo01(
                                                        assetRows:
                                                            _listPages[index],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                NumberPageView(index: index),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      if (index == _listPages.length - 1) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 12.0,
                                              ),
                                              child: RepaintBoundary(
                                                key: _pageKeys[index],
                                                child: Stack(
                                                  children: [
                                                    A4Canvas(
                                                      marginsMm: EdgeInsets.all(
                                                        4,
                                                      ),
                                                      scale: 1.0,
                                                      maxWidth: sizeWidth,
                                                      maxHeight:
                                                          sizeWidth * (297 / 210),
                                                      // child: BodyBankiemKeCCDC(
                                                      //   ccdcInventory:
                                                      //       _listPages[index],
                                                      //   startIndex:
                                                      //       _pageStartIndex(
                                                      //         index,
                                                      //       ),
                                                      // ),
                                                      child: BodyMauSo01(
                                                        assetRows:
                                                            _listPages[index],
                                                      ),
                                                    ),
                                                    NumberPageView(
                                                      index: index,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 12.0,
                                              ),
                                              child: RepaintBoundary(
                                                key: _pageKeys[index + 1],
                                                child: Stack(
                                                  children: [
                                                    A4Canvas(
                                                      marginsMm: EdgeInsets.all(
                                                        4,
                                                      ),
                                                      scale: 1.0,
                                                      maxWidth: sizeWidth,
                                                      maxHeight:
                                                          sizeWidth * (297 / 210),
                                                      child: FoooterMauSo01(),
                                                    ),
                                                    NumberPageView(
                                                      index: index,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12.0,
                                        ),
                                        child: RepaintBoundary(
                                          key: _pageKeys[index],
                                          child: Stack(
                                            children: [
                                              A4Canvas(
                                                marginsMm: EdgeInsets.all(4),
                                                scale: 1.0,
                                                maxWidth: sizeWidth,
                                                maxHeight: sizeWidth * (297 / 210),
                                                child: BodyMauSo01(
                                                  assetRows: _listPages[index],
                                                ),
                                              ),
                                              NumberPageView(index: index),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
      ),
    );
  }

  /// Parse TangGiamTrongKyDto sang AssetRowData
  /// Dữ liệu từ API đã bao gồm cả TaiSan và CCDCVatTu với field loai để phân biệt
  void _parseDataToAssetRows() {
    final List<AssetRowData> result = [];

    // Tách dữ liệu thành 2 nhóm: TaiSan và CCDCVatTu
    final listTaiSan = _listData.where((item) => item.loai == 'TaiSan').toList();
    final listCCDC = _listData.where((item) => item.loai == 'CCDCVatTu').toList();

    // 1. Thêm header "A - Tài sản cố định"
    result.add(AssetRowData(stt: 'A', tenNhanHieu: 'Tài sản cố định'));

    // 2. Convert TaiSan từ API sang AssetRowData
    int assetIndex = 1;
    for (final asset in listTaiSan) {
      result.add(
        AssetRowData(
          stt: assetIndex.toString(),
          tenNhanHieu: asset.tenTaiSan,
          dvt: asset.donViTinh,
          nuocSx: asset.nuocSanXuat,
          soDuDauKy: asset.soDuDauKy.toString(),
          tangSoLuong: asset.soLuongTangTrongKy.toString(),
          tangLyDo: asset.lyDoTangTrongKy ?? '',
          giamSoLuong: asset.soLuongGiamTrongKy.toString(),
          giamLyDo: asset.lyDoGiamTrongKy ?? '',
          soDuCuoiKy: asset.soDuCuoiKy.toString(),
          tinhTrang: asset.tinhTrangKyThuat,
          ghiChu: asset.ghiChu ?? '',
        ),
      );
      assetIndex++;
    }

    // 3. Thêm header "B - Công cụ dụng cụ"
    result.add(AssetRowData(stt: 'B', tenNhanHieu: 'Công cụ dụng cụ'));

    // 4. Convert CCDCVatTu từ API sang AssetRowData
    int ccdcIndex = 1;
    for (final ccdc in listCCDC) {
      result.add(
        AssetRowData(
          stt: ccdcIndex.toString(),
          tenNhanHieu: ccdc.tenTaiSan,
          dvt: ccdc.donViTinh,
          nuocSx: ccdc.nuocSanXuat,
          soDuDauKy: ccdc.soDuDauKy.toString(),
          tangSoLuong: ccdc.soLuongTangTrongKy.toString(),
          tangLyDo: ccdc.lyDoTangTrongKy ?? '',
          giamSoLuong: ccdc.soLuongGiamTrongKy.toString(),
          giamLyDo: ccdc.lyDoGiamTrongKy ?? '',
          soDuCuoiKy: ccdc.soDuCuoiKy.toString(),
          tinhTrang: ccdc.tinhTrangKyThuat,
          ghiChu: ccdc.ghiChu ?? '',
        ),
      );
      ccdcIndex++;
    }

    setState(() {
      _allAssetRows = result;
    });
  }
}

class NumberPageView extends StatelessWidget {
  const NumberPageView({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: SGText(
        text: "Page $index",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
