import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columnSpacing: 24,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  columns: const [
                    DataColumn(label: Text("Phiếu bàn giao")),
                    DataColumn(label: Text("Đơn vị giao")),
                    DataColumn(label: Text("Đơn vị nhận")),
                    DataColumn(label: Text("Ngày hiệu lực")),
                    DataColumn(label: Text("Trạng thái")),
                  ],
                  rows:
                      _list.map((item) {
                        return DataRow(
                          onSelectChanged: (value) async {
                            DieuDongTaiSanDto dieuDongTaiSanDto =
                                await DieuDongTaiSanRepository().getById(
                                  item.quyetDinhDieuDongSo.toString(),
                                );
                            List<ChiTietDieuDongTaiSan>?
                            chiTietDieuDongTaiSans =
                                dieuDongTaiSanDto.chiTietDieuDongTaiSans;
                            print(chiTietDieuDongTaiSans);
                            if (chiTietDieuDongTaiSans != null) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder:
                                    (context) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 24.0,
                                        right: 24.0,
                                        top: 16.0,
                                        bottom: 16.0,
                                      ),
                                      child: AssetMoveReport(
                                        contractType: BienBanDoiChieuKiemKePage(

                                        ),
                                        signatureList: <String>[
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe8wBK0d0QukghPwb_8QvKjEzjtEjIszRwbA&s',
                                        ],
                                        idTaiLieu: item.id.toString(),
                                        idNguoiKy: "thanhtonvk",
                                        tenNguoiKy: "Do Thanh Ton",
                                      ),
                                    ),
                              );
                            }
                          },
                          color: MaterialStateProperty.resolveWith<Color?>((
                            Set<MaterialState> states,
                          ) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blue.withOpacity(0.08); // màu hover
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Colors.blue.withOpacity(0.15);
                            }
                            return null;
                          }),
                          cells: [
                            DataCell(Text(item.quyetDinhDieuDongSo ?? '')),
                            DataCell(Text(item.tenDonViGiao ?? '')),
                            DataCell(Text(item.tenDonViNhan ?? '')),
                            DataCell(Text(_formatDate(item.ngayBanGiao))),
                            DataCell(
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: ConfigViewAT.getColorStatus(
                                      item.trangThai!,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(ConfigViewAT.getStatus(item.trangThai!)),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
    );
  }
}
