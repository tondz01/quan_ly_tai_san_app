// ignore_for_file: deprecated_member_use

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/report_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_kiem_ke_tai_san_co_dinh_page.dart';
import 'package:quan_ly_tai_san_app/screen/report/utils/data_converter.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:quan_ly_tai_san_app/screen/report/component/report_provider.dart';

class BienBanKiemKeTaiSanCoDinhScreen extends StatefulWidget {
  const BienBanKiemKeTaiSanCoDinhScreen({super.key});

  @override
  State<BienBanKiemKeTaiSanCoDinhScreen> createState() =>
      _BienBanKiemKeTaiSanCoDinhScreenState();
}

class _BienBanKiemKeTaiSanCoDinhScreenState
    extends State<BienBanKiemKeTaiSanCoDinhScreen> {
  List<InventoryMinutes> _list = [];
  List<List<InventoryMinutes>> _listPages = [];
  final ReportRepository _repo = ReportRepository();
  final List<GlobalKey> _pageKeys = [];

  TextEditingController controllerImportDate = TextEditingController();
  TextEditingController controllerDonVi = TextEditingController();

  List<PhongBan> listPhongBan = [];
  PhongBan? donVi;
  bool _isLoading = false;
  bool _isExporting = false;
  int numberPageStart = 5;
  int numberPage = 17;
  late HomeScrollController _scrollController;

  // Giới hạn số lượng items để tránh lag khi có quá nhiều dữ liệu
  static const int _maxItemsToDisplay = 500; // Giới hạn 500 items đầu tiên
  bool _hasMoreData = false; // Có dữ liệu bị cắt bớt không
  int _totalAssetCount = 0; // Tổng số tài sản thực tế

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void initState() {
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);

    controllerImportDate.dispose();
    controllerDonVi.dispose();
    super.dispose();
  }

  Future<void> _exportToPdf() async {
    setState(() {
      _isExporting = true;
    });
    try {
      final pdf = pw.Document();
      // Đợi frame hiện tại kết thúc để đảm bảo UI render hoàn toàn
      await WidgetsBinding.instance.endOfFrame;
      if (_pageKeys.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không có trang để xuất.')),
          );
        }
        return;
      }

      // Đợi thêm một khoảng nhỏ để ổn định layout (phòng trường hợp scroll/layout vừa thay đổi)
      await Future.delayed(const Duration(milliseconds: 50));

      for (final key in _pageKeys) {
        final boundary =
            key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) continue;

        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        final imageWidth = image.width.toDouble();
        final imageHeight = image.height.toDouble();
        if (imageWidth.isNaN ||
            imageHeight.isNaN ||
            imageWidth <= 0 ||
            imageHeight <= 0) {
          continue;
        }

        final imageProvider = pw.MemoryImage(pngBytes);
        final aspectRatio = imageWidth / imageHeight;
        final a4AspectRatio = PdfPageFormat.a4.width / PdfPageFormat.a4.height;

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4.portrait,
            margin: const pw.EdgeInsets.all(20),
            build: (context) {
              if (aspectRatio > a4AspectRatio) {
                return pw.Center(
                  child: pw.Image(imageProvider, fit: pw.BoxFit.fitWidth),
                );
              } else {
                return pw.Center(
                  child: pw.Image(imageProvider, fit: pw.BoxFit.fitHeight),
                );
              }
            },
          ),
        );
      }

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            'bien_ban_kiem_ke_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      SGLog.error('Lỗi xuất PDF', 'Lỗi xuất PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi xuất PDF: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _loadData() async {
    listPhongBan =
        AccountHelper.instance.getDepartmentWithOptionAllCompany() ?? [];
    setState(() {});
  }

  /// Load và map dữ liệu assets theo batch với tối ưu cho Web
  Future<void> _loadAllAssetsInBatches() async {
    final allAssets = AccountHelper.instance.getAllAssets();
    _totalAssetCount = allAssets.length;

    if (allAssets.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasMoreData = false;
      });
      if (mounted) {
        AppUtility.showSnackBar(context, 'Không có dữ liệu!');
      }
      return;
    }

    // Giới hạn số lượng items để tránh treo web
    final assetsToProcess =
        allAssets.length > _maxItemsToDisplay
            ? allAssets.sublist(0, _maxItemsToDisplay)
            : allAssets;

    _hasMoreData = allAssets.length > _maxItemsToDisplay;

    if (_hasMoreData) {
      SGLog.info(
        'Loading',
        'Giới hạn hiển thị $_maxItemsToDisplay/$_totalAssetCount tài sản để tránh lag',
      );
    }

    SGLog.info('Loading', 'Bắt đầu xử lý ${assetsToProcess.length} tài sản...');

    // Giảm batch size xuống để tránh block UI
    const int batchSize = 50;
    final List<InventoryMinutes> result = [];
    int processedCount = 0;

    try {
      // Xử lý từng batch
      for (int i = 0; i < assetsToProcess.length; i += batchSize) {
        if (!mounted) return; // Dừng nếu widget bị dispose

        final int end =
            (i + batchSize < assetsToProcess.length)
                ? i + batchSize
                : assetsToProcess.length;

        final batch = assetsToProcess.sublist(i, end);

        // Map batch hiện tại - inline để nhanh hơn
        for (final asset in batch) {
          result.add(
            InventoryMinutes(
              tenTaiSan: asset.tenTaiSan,
              donViTinh: asset.donViTinh ?? '',
              nuocSanXuat: asset.nuocSanXuat,
              hienTrang: asset.hienTrang?.toString() ?? '',
              ghiChu: asset.ghiChu,
            ),
          );
        }

        processedCount += batch.length;

        // Yield control về event loop sau mỗi batch
        await Future.value();

        // Log progress mỗi 200 items
        if (processedCount % 200 == 0 ||
            processedCount == assetsToProcess.length) {
          SGLog.info(
            'Loading',
            'Đã xử lý $processedCount / ${assetsToProcess.length} items (${(processedCount / assetsToProcess.length * 100).toStringAsFixed(1)}%)',
          );
        }
      }

      if (!mounted) return;

      SGLog.info('Loading', 'Bắt đầu chia trang...');

      // Chia trang
      final listPages = _chunkInventoryMinutes(result);

      if (!mounted) return;

      setState(() {
        _list = result;
        _listPages = listPages;
        final int totalPages = _listPages.isEmpty ? 1 : _listPages.length + 1;
        _pageKeys
          ..clear()
          ..addAll(List.generate(totalPages, (_) => GlobalKey()));
        _isLoading = false;
      });

      if (mounted) {
        String message =
            'Lấy dữ liệu thành công! (${result.length} tài sản, ${listPages.length} trang)';
        if (_hasMoreData) {
          message =
              'Hiển thị ${result.length}/$_totalAssetCount tài sản (giới hạn để tránh lag)';
        }
        AppUtility.showSnackBar(context, message);
      }
    } catch (e) {
      SGLog.error('Loading', 'Lỗi khi xử lý dữ liệu: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        AppUtility.showSnackBar(
          context,
          'Lỗi khi xử lý dữ liệu: $e',
          isError: true,
        );
      }
    }
  }

  Future<void> onloadViewPage() async {
    if (donVi == null) {
      AppUtility.showSnackBar(context, 'Vui lòng chọn đơn vị!', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Format date to YYYY-MM-DD format
    String formattedDate = formatToYyyyMmDd(controllerImportDate.text.trim());

    // với loại tất cả công ty sẽ query theo all Assets
    if (donVi!.id! == 'all') {
      await _loadAllAssetsInBatches();
      return;
    }

    final result = await _repo.getInventoryMinutes(donVi!.id!, formattedDate);
    if (!mounted) return;
    if (checkStatusCodeDone(result)) {
      setState(() {
        _list = [];
        _list = (result['data'] as List).cast<InventoryMinutes>();
        _listPages = _chunkInventoryMinutes(_list);
        final int totalPages =
            _listPages.isEmpty ? 1 : _listPages.length + 1; // +1 trang footer
        _pageKeys
          ..clear()
          ..addAll(List.generate(totalPages, (_) => GlobalKey()));
        _isLoading = false;
        if (_list.isEmpty) {
          AppUtility.showSnackBar(context, 'Không có dữ liệu!');
        } else {
          AppUtility.showSnackBar(context, 'Lấy dữ liệu thành công!');
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

  List<List<InventoryMinutes>> _chunkInventoryMinutes(
    List<InventoryMinutes> source,
  ) {
    if (source.isEmpty) return [];

    final List<List<InventoryMinutes>> pages = [];

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

  int _pageStartIndex(int pageIndex) {
    int start = 0;
    for (int i = 0; i < pageIndex && i < _listPages.length; i++) {
      start += _listPages[i].length;
    }
    return start;
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width; // A4 width in pixels at 96 DPI
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 1400,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SGText(
                            text: 'Biên bản kiểm kê tài sản cố định',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          CmFormDate(
                            label: 'Ngày kiểm kê',
                            controller: controllerImportDate,
                            isEditing: true,
                            fieldName: 'importDate',
                            onChanged: (date) {
                              setState(() {});
                            },
                          ),
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
                          Divider(),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  onloadViewPage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
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
                              Expanded(child: SizedBox.shrink()),
                              GestureDetector(
                                onTap: () {
                                  _exportToPdf();
                                },
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
                              GestureDetector(
                                onTap: () {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) async {
                                    await ReportProvider().exportToPdfAndPrint(
                                      _pageKeys,
                                      context,
                                      () {},
                                    );
                                  });
                                },
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Stack(
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            return true; // Xử lý scroll event bình thường
                          },
                          child: SingleChildScrollView(
                            physics:
                                _scrollController.isParentScrolling
                                    ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                                    : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
                            scrollDirection: Axis.vertical,
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
                                          scale: 1.2,
                                          maxWidth: sizeWidth,
                                          maxHeight: sizeWidth * (297 / 210),
                                          child: BienBanKiemKeTaiSanCoDinhPage(
                                            taiSanCoDinhList:
                                                DataConverter.convertInventoryMinutesToTaiSanCoDinh(
                                                  _list,
                                                ),
                                            denNgay: formatToYyyyMmDd(
                                              controllerImportDate.text,
                                            ),
                                            tenDonVi: donVi?.tenPhongBan ?? '',
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
                                          scale: 1.2,
                                          maxWidth: sizeWidth,
                                          maxHeight: sizeWidth * (297 / 210),
                                          child: BienBanKiemKeTaiSanCoDinhPage(
                                            taiSanCoDinhList:
                                                DataConverter.convertInventoryMinutesToTaiSanCoDinh(
                                                  _list,
                                                ),
                                            denNgay: formatToYyyyMmDd(
                                              controllerImportDate.text,
                                            ),
                                            tenDonVi: donVi?.tenPhongBan ?? '',
                                          ),
                                        ),
                                        NumberPageView(index: 0),
                                      ],
                                    ),
                                  )
                                else
                                  ...List.generate(_listPages.length, (index) {
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
                                                scale: 1.2,
                                                maxWidth: sizeWidth,
                                                maxHeight: sizeWidth * (297 / 210),
                                                child: Column(
                                                  children: [
                                                    HeaderBienBanKiemKe(
                                                      tenDonVi:
                                                          donVi?.tenPhongBan ??
                                                          '',
                                                      denNgay: formatToYyyyMmDd(
                                                        controllerImportDate
                                                            .text,
                                                      ),
                                                    ),
                                                    BodyBienBanKiemKe(
                                                      taiSanCoDinhList:
                                                          DataConverter.convertInventoryMinutesToTaiSanCoDinh(
                                                            _listPages[index],
                                                          ),
                                                      startIndex:
                                                          _pageStartIndex(
                                                            index,
                                                          ),
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
                                                    scale: 1.2,
                                                    maxWidth: sizeWidth,
                                                    maxHeight:
                                                        sizeWidth * (297 / 210),
                                                    child: BodyBienBanKiemKe(
                                                      taiSanCoDinhList:
                                                          DataConverter.convertInventoryMinutesToTaiSanCoDinh(
                                                            _listPages[index],
                                                          ),
                                                      startIndex:
                                                          _pageStartIndex(
                                                            index,
                                                          ),
                                                    ),
                                                  ),
                                                  NumberPageView(index: index),
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
                                                    scale: 1.2,
                                                    maxWidth: sizeWidth,
                                                    maxHeight:
                                                        sizeWidth * (297 / 210),
                                                    child:
                                                        FooterBienBanKiemKe(),
                                                  ),
                                                  NumberPageView(index: index),
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
                                              scale: 1.2,
                                              maxWidth: sizeWidth,
                                              maxHeight: sizeWidth * (297 / 210),
                                              child: BodyBienBanKiemKe(
                                                taiSanCoDinhList:
                                                    DataConverter.convertInventoryMinutesToTaiSanCoDinh(
                                                      _listPages[index],
                                                    ),
                                                startIndex: _pageStartIndex(
                                                  index,
                                                ),
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
                        ),

                        if (_isLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black54,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
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
          ),
        ),
        if (_isExporting)
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
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

String formatteDate(String formattedDate) {
  if (formattedDate.isNotEmpty) {
    // Strip time part if exists (e.g., '01/10/2025 21:56:05' -> '01/10/2025')
    final String dateOnly = formattedDate.split(' ').first;
    try {
      // Try ISO first (e.g., 2025-10-01 or 2025-10-01T12:00:00)
      final DateTime parsedDate = DateTime.parse(dateOnly);
      formattedDate =
          "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
    } catch (e) {
      try {
        // Try DD/MM/YYYY
        final parts = dateOnly.split('/');
        if (parts.length == 3) {
          final int day = int.parse(parts[0]);
          final int month = int.parse(parts[1]);
          final int year = int.parse(parts[2]);
          formattedDate =
              "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
        }
      } catch (e) {
        SGLog.info('formattedDate', 'DD/MM/YYYY parse error: $e');
      }
    }
  }
  return formattedDate;
}
