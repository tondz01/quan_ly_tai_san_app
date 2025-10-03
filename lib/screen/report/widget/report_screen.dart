import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/dieu_dong_tai_san_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/report_repository.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import '../../../common/page/contract_page.dart';
import '../../asset_transfer/component/config_view_asset_transfer.dart';
import '../../asset_transfer/model/dieu_dong_tai_san_dto.dart';

class ReportScreen extends StatefulWidget {
  final String idCongty;
  final int loai;

  const ReportScreen({super.key, required this.idCongty, required this.loai});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportRepository _repo = ReportRepository();
  List<DieuDongTaiSanDto> _list = [];
  bool _isLoading = true;
  PdfDocument? _document;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadPdfNetwork(String nameFile) async {
    try {
      final document = await PdfDocument.openUri(
        Uri.parse("${Config.baseUrl}/api/upload/preview/$nameFile"),
      );
      setState(() {
        _document = document;
      });
    } catch (e) {
      setState(() {
        _document = null;
      });
      SGLog.error("Error loading PDF", e.toString());
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await _repo.getReportAsset(widget.idCongty, widget.loai);
    setState(() {
      _list = (result['data'] as List).cast<DieuDongTaiSanDto>();
      _isLoading = false;
    });
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      TableBaseConfig.columnTable<DieuDongTaiSanDto>(
        title: 'Phiếu điều động',
        getValue: (item) => item.soQuyetDinh ?? '',
        width: 0,
      ),
      TableBaseConfig.columnTable<DieuDongTaiSanDto>(
        title: 'Đơn vị giao',
        getValue: (item) => item.tenDonViGiao ?? '',
        width: 0,
      ),
      TableBaseConfig.columnTable<DieuDongTaiSanDto>(
        title: 'Đơn vị nhận',
        getValue: (item) => item.tenDonViNhan ?? '',
        width: 0,
      ),
      TableBaseConfig.columnTable<DieuDongTaiSanDto>(
        title: 'Ngày hiệu lực',
        getValue: (item) => _formatDate(item.tggnTuNgay),
        width: 0,
      ),
      TableBaseConfig.columnWidgetBase<DieuDongTaiSanDto>(
        title: 'Trạng thái',
        cellBuilder: (item) => ConfigViewAT.showStatus(item.trangThai ?? 0),
        width: 120,
        searchable: true,
      ),
    ];

    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.table_chart,
                                    color: Colors.grey.shade600,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Báo cáo cấp phát tài sản trong kỳ (${_list.length})',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              // FindByStateAssetHandover(provider: widget.provider),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: SGAppColors.colorBorderGray.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        Expanded(
                          child: TableBaseView<DieuDongTaiSanDto>(
                            searchTerm: '',
                            columns: columns,
                            data: _list,
                            horizontalController: ScrollController(),
                            isShowCheckboxes: false,
                            onRowTap: (item) async {
                              UserInfoDTO userInfo =
                                  AccountHelper.instance.getUserInfo()!;

                              item = await DieuDongTaiSanRepository().getById(
                                item.id.toString(),
                              );

                              await _loadPdfNetwork(item.tenFile ?? "");
                              if (mounted) {
                                showDialog(
                                  context: this.context,
                                  barrierDismissible: true,
                                  builder:
                                      (context) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 24.0,
                                          right: 24.0,
                                          top: 16.0,
                                          bottom: 16.0,
                                        ),
                                        child: CommonContract(
                                          contractPages: [
                                            if (_document != null)
                                              for (
                                                var index = 0;
                                                index < _document!.pages.length;
                                                index++
                                              )
                                                PdfPageView(
                                                  document: _document!,
                                                  pageNumber: index + 1,
                                                  alignment: Alignment.center,
                                                ),
                                            A4Canvas(
                                              marginsMm: const EdgeInsets.all(
                                                20,
                                              ),
                                              scale: 1.2,
                                              maxWidth: 800,
                                              maxHeight: 800 * (297 / 210),
                                              child: ContractPage.assetMovePage(
                                                item,
                                              ),
                                            ),
                                          ],
                                          signatureList: [],
                                          idTaiLieu: item.id.toString(),
                                          idNguoiKy: userInfo.tenDangNhap,
                                          tenNguoiKy: userInfo.hoTen,
                                          isShowKy: false,
                                        ),
                                      ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
