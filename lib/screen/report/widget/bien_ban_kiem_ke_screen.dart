import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/dieu_dong_tai_san_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/report_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_kiem_ke_page.dart';
import '../../../common/page/contract_page.dart';
import '../../asset_transfer/component/config_view_asset_transfer.dart';
import '../../asset_transfer/model/dieu_dong_tai_san_dto.dart';
import '../views/asset_move_report.dart';
import '../views/bien_ban_doi_chieu_page.dart';

class BienBanKiemKeScreen extends StatefulWidget {
  final String idCongty;

  const BienBanKiemKeScreen({super.key, required this.idCongty});

  @override
  State<BienBanKiemKeScreen> createState() => _BienBanKiemKeScreenState();
}

class _BienBanKiemKeScreenState extends State<BienBanKiemKeScreen> {
  final AssetHandoverRepository _repo = AssetHandoverRepository();
  List<AssetHandoverDto> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await _repo.getListAssetHandover();
    setState(() {
      _list = (result['data'] as List).cast<AssetHandoverDto>();
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
      TableBaseConfig.columnTable<AssetHandoverDto>(title: 'Phiếu bàn giao', getValue: (item) => item.quyetDinhDieuDongSo ?? '', width: 0),
      TableBaseConfig.columnTable<AssetHandoverDto>(title: 'Đơn vị giao', getValue: (item) => item.tenDonViGiao ?? '', width: 0),
      TableBaseConfig.columnTable<AssetHandoverDto>(title: 'Đơn vị nhận', getValue: (item) => item.tenDonViNhan ?? '', width: 0),
      TableBaseConfig.columnTable<AssetHandoverDto>(title: 'Ngày hiệu lực', getValue: (item) => _formatDate(item.ngayBanGiao), width: 0),
      TableBaseConfig.columnWidgetBase<AssetHandoverDto>(title: 'Trạng thái', cellBuilder: (item) => ConfigViewAT.showStatus(item.trangThai ?? 0), width: 120, searchable: true),
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
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Biên bản kiểm kê (${_list.length})',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                              // FindByStateAssetHandover(provider: widget.provider),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TableBaseView<AssetHandoverDto>(
                            searchTerm: '',
                            columns: columns,
                            data: _list,
                            horizontalController: ScrollController(),
                            onRowTap: (item) async {
                              DieuDongTaiSanDto dieuDongTaiSanDto = await DieuDongTaiSanRepository().getById(item.quyetDinhDieuDongSo.toString());
                              List<ChiTietDieuDongTaiSan>? chiTietDieuDongTaiSans = dieuDongTaiSanDto.chiTietDieuDongTaiSans;
                              if (chiTietDieuDongTaiSans != null) {
                                if (mounted) {
                                  showDialog(
                                    context: this.context,
                                    barrierDismissible: true,
                                    builder:
                                        (context) => Padding(
                                          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                                          child: AssetMoveReport(
                                            contractType: BienBanDoiChieuKiemKePage(),
                                            signatureList: <String>['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe8wBK0d0QukghPwb_8QvKjEzjtEjIszRwbA&s'],
                                            idTaiLieu: item.id.toString(),
                                            idNguoiKy: "thanhtonvk",
                                            tenNguoiKy: "Do Thanh Ton",
                                          ),
                                        ),
                                  );
                                }
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
