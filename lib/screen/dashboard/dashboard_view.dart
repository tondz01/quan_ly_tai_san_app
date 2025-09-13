import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_text_style.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/model/dashboard_report.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/statistics_card.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:quan_ly_tai_san_app/core/enum/type_size_screen.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/pie_with_legend.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/scrollable_bar_chart.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/group_line_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/bloc/dashboard_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/bloc/dashboard_state.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/bloc/dashboard_event.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

const basicData = [
  {'genre': 'Đang sử dụng', 'sold': 275},
  {'genre': 'Bảo trì', 'sold': 115},
  {'genre': 'Hỏng', 'sold': 120},
  {'genre': 'Thanh lý', 'sold': 150},
];

const basicData2 = [
  {'genre': 'Đang sử dụng', 'sold': 275},
  {'genre': 'Bảo trì', 'sold': 115},
  {'genre': 'Hỏng', 'sold': 120},
  {'genre': 'Thanh lý', 'sold': 150},
  {'genre': 'Thanh lý 2', 'sold': 150},
  {'genre': 'Thanh lý 3', 'sold': 150},
  {'genre': 'Thanh lý 4', 'sold': 150},
  {'genre': 'Thanh lý 5', 'sold': 150},
  {'genre': 'Thanh lý 6', 'sold': 150},
  {'genre': 'Thanh lý 7', 'sold': 150},
  {'genre': 'Thanh lý 8', 'sold': 150},
  {'genre': 'Thanh lý 9', 'sold': 150},
  {'genre': 'Thanh lý 10', 'sold': 150},
  {'genre': 'Thanh lý 11', 'sold': 150},
  {'genre': 'Thanh lý 12', 'sold': 150},
  {'genre': 'Thanh lý 13', 'sold': 150},
  {'genre': 'Thanh lý 14', 'sold': 150},
  {'genre': 'Thanh lý 15', 'sold': 150},
  {'genre': 'Thanh lý 16', 'sold': 150},
  {'genre': 'Thanh lý 17', 'sold': 150},
  {'genre': 'Thanh lý 18', 'sold': 150},
  {'genre': 'Thanh lý 19', 'sold': 150},
  {'genre': 'Thanh lý 20', 'sold': 150},
  {'genre': 'Thanh lý 21', 'sold': 150},
  {'genre': 'Thanh lý 22', 'sold': 150},
  {'genre': 'Thanh lý 23', 'sold': 150},
  {'genre': 'Thanh lý 24', 'sold': 150},
  {'genre': 'Thanh lý 25', 'sold': 150},
];

const complexGroupData = [
  {'date': '2021-10-02', 'name': 'Noah', 'points': 1492},
  {'date': '2021-10-03', 'name': 'Noah', 'points': 1465},
  {'date': '2021-10-04', 'name': 'Noah', 'points': 1504},
  {'date': '2021-10-06', 'name': 'Noah', 'points': 1463},
  {'date': '2021-10-07', 'name': 'Noah', 'points': 1539},
  {'date': '2021-10-08', 'name': 'Noah', 'points': 1483},
  {'date': '2021-10-09', 'name': 'Noah', 'points': 1519},
  {'date': '2021-10-10', 'name': 'Noah', 'points': 1518},
  {'date': '2021-10-11', 'name': 'Noah', 'points': 1478},
  {'date': '2021-10-12', 'name': 'Noah', 'points': 1537},
  {'date': '2021-10-15', 'name': 'Noah', 'points': 1509},
  {'date': '2021-10-17', 'name': 'Noah', 'points': 1515},
  {'date': '2021-10-20', 'name': 'Noah', 'points': 1533},
  {'date': '2021-10-21', 'name': 'Noah', 'points': 1477},
  {'date': '2021-10-22', 'name': 'Noah', 'points': 1476},
  {'date': '2021-10-24', 'name': 'Noah', 'points': 1532},
  {'date': '2021-10-25', 'name': 'Noah', 'points': 1504},
  {'date': '2021-10-26', 'name': 'Noah', 'points': 1503},
  {'date': '2021-10-27', 'name': 'Noah', 'points': 1530},
  {'date': '2021-10-29', 'name': 'Noah', 'points': 1499},
  {'date': '2021-10-30', 'name': 'Noah', 'points': 1460},
];

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool rebuild = false;
  List<Map<String, Object>> tangTruongTaiSanTheoNamSX = [];
  List<Map<String, Object>> taiSanTheoLoai = [];
  List<Map<String, Object>> taiSanTheoPhongBan = [];
  List<Map<String, Object>> ccdcTheoPhongBan = [];
  List<Map<String, Object>> top5TaiSanGiaTriCao = [];
  List<Map<String, Object>> taiSanTheoNhom = [];
  List<Map<String, Object>> nhapKhoCCDCTheoNam = [];
  List<Map<String, Object>> giaTriTheoDuAn = [];
  List<Map<String, Object>> giaTriTheoNguonVon = [];
  List<Map<String, Object>> giaTriTaiSanTheoCongTy = [];
  List<Map<String, Object>> taiSanChuaDieuDong = [];
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    tangTruongTaiSanTheoNamSX.clear();
    taiSanTheoLoai.clear();
    taiSanTheoPhongBan.clear();
    ccdcTheoPhongBan.clear();
    top5TaiSanGiaTriCao.clear();
    taiSanTheoNhom.clear();
    nhapKhoCCDCTheoNam.clear();
    giaTriTheoDuAn.clear();
    giaTriTheoNguonVon.clear();
    giaTriTaiSanTheoCongTy.clear();
    taiSanChuaDieuDong.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(const LoadDashboard());
    });
  }

  @override
  void dispose() {
    tangTruongTaiSanTheoNamSX.clear();
    taiSanTheoLoai.clear();
    taiSanTheoPhongBan.clear();
    ccdcTheoPhongBan.clear();
    top5TaiSanGiaTriCao.clear();
    taiSanTheoNhom.clear();
    nhapKhoCCDCTheoNam.clear();
    giaTriTheoDuAn.clear();
    giaTriTheoNguonVon.clear();
    giaTriTaiSanTheoCongTy.clear();
    taiSanChuaDieuDong.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final bool isLoading = state is! DashboardLoaded;
        final data = state is DashboardLoaded ? state.data : null;

        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (data != null) {
          tangTruongTaiSanTheoNamSX.clear();
          for (GrowthByYear item in data.tangTruongTaiSanTheoNamSX) {
            tangTruongTaiSanTheoNamSX.add({
              'nam': item.nam.toString(),
              'soLuong': item.soLuong ?? 0,
            });
          }
        }
        if (data != null) {
          taiSanTheoLoai.clear();
          for (AssetByType item in data.taiSanTheoLoai) {
            taiSanTheoLoai.add({
              'ten': item.ten ?? 'Chưa xác định',
              'soLuong': item.soLuong ?? 0,
            });
          }
        }
        if (data != null) {
          taiSanTheoPhongBan.clear();
          for (AssetByDepartment item in data.taiSanTheoPhongBan) {
            taiSanTheoPhongBan.add({
              'phongBan': item.phongBan ?? 'Chưa xác định',
              'soLuong': item.soLuong ?? 0,
            });
          }
        }
        if (data != null) {
          top5TaiSanGiaTriCao.clear();
          for (TopAsset item in data.top5TaiSanGiaTriCao) {
            top5TaiSanGiaTriCao.add({
              'tenTaiSan': item.tenTaiSan ?? 'Chưa xác định',
              'nguyenGia': item.nguyenGia ?? 0,
            });
          }
        }
        if (data != null) {
          taiSanTheoNhom.clear();
          for (AssetByGroup item in data.taiSanTheoNhom) {
            taiSanTheoNhom.add({
              'ten': item.ten ?? 'Chưa xác định',
              'soLuong': item.soLuong ?? 0,
            });
          }
        }
        if (data != null) {
          giaTriTheoDuAn.clear();
          for (ProjectValue item in data.giaTriTheoDuAn) {
            giaTriTheoDuAn.add({
              'duAn': item.duAn ?? 'Chưa xác định',
              'tongGiaTri': item.tongGiaTri ?? 0,
            });
          }
        }
        if (data != null) {
          giaTriTheoNguonVon.clear();
          for (CapitalValue item in data.giaTriTheoNguonVon) {
            giaTriTheoNguonVon.add({
              'nguonVon': item.nguonVon ?? 'Chưa xác định',
              'tongGiaTri': item.tongGiaTri ?? 0,
            });
          }
        }
        if (data != null) {
          giaTriTaiSanTheoCongTy.clear();
          for (CompanyValue item in data.giaTriTaiSanTheoCongTy) {
            giaTriTaiSanTheoCongTy.add({
              'congTy': item.congTy ?? 'Chưa xác định',
              'tongGiaTri': item.tongGiaTri ?? 0,
            });
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatisticsSection(data),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      alignment: Alignment.centerLeft,
                      child: SGText(
                        text: "Thông tin tài sản",
                        style: AppTextStyle.textStyleSemiBold24,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Tài sản theo loại",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: PieDonutChartWithLegend(
                                  data: taiSanTheoLoai,
                                  categoryKey: 'ten',
                                  valueKey: 'soLuong',
                                  colors: listColors,
                                  chartWidth: 420,
                                  chartHeight: 420,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Tăng trưởng tài sản theo năm sản xuất",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: ScrollableBarChart(
                                  data: tangTruongTaiSanTheoNamSX,
                                  categoryKey: 'nam',
                                  valueKey: 'soLuong',
                                  barWidth: 32,
                                  spacing: 64,
                                  height: 300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Tài sản theo phòng ban",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: PieDonutChartWithLegend(
                                  data: taiSanTheoPhongBan,
                                  categoryKey: 'phongBan',
                                  valueKey: 'soLuong',
                                  colors: listColors,
                                  chartWidth: 420,
                                  chartHeight: 420,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Top 5 tài sản giá trị cao",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 420,
                                child: Chart(
                                  data: top5TaiSanGiaTriCao,
                                  variables: {
                                    'genre': Variable(
                                      accessor:
                                          (Map map) =>
                                              map['tenTaiSan'] as String,
                                    ),
                                    'sold': Variable(
                                      accessor:
                                          (Map map) => map['nguyenGia'] as num,
                                    ),
                                  },
                                  marks: [
                                    IntervalMark(
                                      label: LabelEncode(
                                        encoder:
                                            (tuple) =>
                                                Label(tuple['sold'].toString()),
                                      ),
                                      gradient: GradientEncode(
                                        value: const LinearGradient(
                                          colors: [
                                            Color(0x8883bff6),
                                            Color(0x88188df0),
                                            Color(0xcc188df0),
                                          ],
                                          stops: [0, 0.5, 1],
                                        ),
                                        updaters: {
                                          'tap': {
                                            true:
                                                (_) => const LinearGradient(
                                                  colors: [
                                                    Color(0xee83bff6),
                                                    Color(0xee3f78f7),
                                                    Color(0xff3f78f7),
                                                  ],
                                                  stops: [0, 0.7, 1],
                                                ),
                                          },
                                        },
                                      ),
                                    ),
                                  ],
                                  coord: RectCoord(transposed: true),
                                  axes: [
                                    Defaults.verticalAxis
                                      ..line = Defaults.strokeStyle
                                      ..grid = null,
                                    Defaults.horizontalAxis
                                      ..line = null
                                      ..grid = Defaults.strokeStyle,
                                  ],
                                  selections: {
                                    'tap': PointSelection(dim: Dim.x),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Tài sản theo nhóm",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: PieDonutChartWithLegend(
                                  data: taiSanTheoNhom,
                                  categoryKey: 'ten',
                                  valueKey: 'soLuong',
                                  colors: listColors,
                                  chartWidth: 420,
                                  chartHeight: 420,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Giá trị theo dự án",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: ScrollableBarChart(
                                  data: giaTriTheoDuAn,
                                  categoryKey: 'duAn',
                                  valueKey: 'tongGiaTri',
                                  barWidth: 32,
                                  spacing: 64,
                                  height: 300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Giá trị theo nguồn vốn",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: PieDonutChartWithLegend(
                                  data: giaTriTheoNguonVon,
                                  categoryKey: 'nguonVon',
                                  valueKey: 'tongGiaTri',
                                  colors: listColors,
                                  chartWidth: 420,
                                  chartHeight: 420,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  5,
                                  10,
                                  0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: SGText(
                                  text: "Giá trị tài sản theo công ty",
                                  style: AppTextStyle.textStyleRegular14,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: ScrollableBarChart(
                                  data: giaTriTaiSanTheoCongTy,
                                  categoryKey: 'congTy',
                                  valueKey: 'tongGiaTri',
                                  barWidth: 32,
                                  spacing: 64,
                                  height: 300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   padding: EdgeInsets.all(12),
              //   child: Column(
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              //         alignment: Alignment.centerLeft,
              //         child: SGText(
              //           text: "Hoạt động điều động & bàn giao",
              //           style: AppTextStyle.textStyleSemiBold24,
              //         ),
              //       ),
              //       SizedBox(
              //         width: double.infinity,
              //         height: 400,
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Container(
              //                     padding: const EdgeInsets.fromLTRB(
              //                       10,
              //                       5,
              //                       10,
              //                       0,
              //                     ),
              //                     alignment: Alignment.centerLeft,
              //                     child: SGText(
              //                       text: 'Phiếu điều động tài sản (tháng/quý)',
              //                       style: AppTextStyle.textStyleRegular14,
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Container(
              //                       margin: const EdgeInsets.only(top: 10),
              //                       width: double.infinity,
              //                       height: double.infinity,
              //                       child: GroupLineChart(
              //                         data: complexGroupData,
              //                         xKey: 'date',
              //                         yKey: 'points',
              //                         groupKey: 'name',
              //                         width: 350,
              //                         height: 300,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Container(
              //                     padding: const EdgeInsets.fromLTRB(
              //                       10,
              //                       5,
              //                       10,
              //                       0,
              //                     ),
              //                     alignment: Alignment.centerLeft,
              //                     child: SGText(
              //                       text: "Phiếu điều động CCDC / vật tư",
              //                       style: AppTextStyle.textStyleRegular14,
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Container(
              //                       margin: const EdgeInsets.only(top: 10),
              //                       width: double.infinity,
              //                       height: double.infinity,
              //                       child: GroupLineChart(
              //                         data: complexGroupData,
              //                         xKey: 'date',
              //                         yKey: 'points',
              //                         groupKey: 'name',
              //                         width: 350,
              //                         height: 300,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),

              //       SizedBox(
              //         width: double.infinity,
              //         height: 400,
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Container(
              //                     padding: const EdgeInsets.fromLTRB(
              //                       10,
              //                       5,
              //                       10,
              //                       0,
              //                     ),
              //                     alignment: Alignment.centerLeft,
              //                     child: SGText(
              //                       text: "Bàn giao tài sản theo trạng thái",
              //                       style: AppTextStyle.textStyleRegular14,
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Container(
              //                       width: double.infinity,
              //                       height: double.infinity,
              //                       margin: const EdgeInsets.only(top: 10),
              //                       child: PieDonutChartWithLegend(
              //                         data: basicData,
              //                         categoryKey: 'genre',
              //                         valueKey: 'sold',
              //                         colors: listColors,
              //                         chartWidth: 420,
              //                         chartHeight: 420,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Container(
              //                     padding: const EdgeInsets.fromLTRB(
              //                       10,
              //                       5,
              //                       10,
              //                       0,
              //                     ),
              //                     alignment: Alignment.centerLeft,
              //                     child: SGText(
              //                       text:
              //                           "Tiến độ điều động (từ tggnTuNgay đến tggnDenNgay)",
              //                       style: AppTextStyle.textStyleRegular14,
              //                     ),
              //                   ),
              //                   Expanded(
              //                     child: Container(
              //                       margin: const EdgeInsets.only(top: 10),
              //                       width: double.infinity,
              //                       height: double.infinity,
              //                       child: GroupLineChart(
              //                         data: complexGroupData,
              //                         xKey: 'date',
              //                         yKey: 'points',
              //                         groupKey: 'name',
              //                         width: 350,
              //                         height: 300,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 16),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   padding: EdgeInsets.all(12),
              //   child: Column(
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              //         alignment: Alignment.centerLeft,
              //         child: SGText(
              //           text: "Phòng ban & nhân sự",
              //           style: AppTextStyle.textStyleSemiBold24,
              //         ),
              //       ),
              //       Row(
              //         children: [
              //           Expanded(
              //             child: Column(
              //               children: [
              //                 Container(
              //                   padding: const EdgeInsets.fromLTRB(
              //                     10,
              //                     5,
              //                     10,
              //                     0,
              //                   ),
              //                   alignment: Alignment.centerLeft,
              //                   child: SGText(
              //                     text: 'Nhân viên theo phòng ban',
              //                     style: AppTextStyle.textStyleRegular14,
              //                   ),
              //                 ),
              //                 Container(
              //                   margin: const EdgeInsets.only(top: 10),
              //                   child: ScrollableBarChart(
              //                     data: basicData2,
              //                     categoryKey: 'genre',
              //                     valueKey: 'sold',
              //                     barWidth: 18,
              //                     spacing: 64,
              //                     height: 300,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Expanded(
              //             child: Column(
              //               children: [
              //                 Container(
              //                   padding: const EdgeInsets.fromLTRB(
              //                     10,
              //                     5,
              //                     10,
              //                     0,
              //                   ),
              //                   alignment: Alignment.centerLeft,
              //                   child: SGText(
              //                     text: "Tỷ lệ nhân viên Active / Inactive",
              //                     style: AppTextStyle.textStyleRegular14,
              //                   ),
              //                 ),
              //                 Container(
              //                   margin: const EdgeInsets.only(top: 10),
              //                   child: PieDonutChartWithLegend(
              //                     data: basicData,
              //                     categoryKey: 'genre',
              //                     valueKey: 'sold',
              //                     colors: listColors,
              //                     chartWidth: 420,
              //                     chartHeight: 420,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  List<Color> get listColors => [
    ColorValue.oceanBlue,
    ColorValue.pink,
    ColorValue.coral,
    ColorValue.amber,
  ];

  Widget _buildStatisticsSection(DashboardReport? data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(12),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          crossAxisSpacing: 32,
          mainAxisSpacing: 32,
          mainAxisExtent: 112,
        ),
        children: [
          // Nhóm Tài sản
          StatisticsCard(
            title: 'Tổng tài sản',
            value: data?.tongTaiSan.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'Tổng nguyên giá',
            value: formatter.format(data?.tongNguyenGia ?? 0),
            backgroundColor: ColorValue.backgroundBG3,
          ),

          // Nhóm CCDC (Công cụ dụng cụ)
          StatisticsCard(
            title: 'Tổng công cụ dụng cụ',
            value: data?.tongCCDC.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'Tổng số lượng CCDC điều động',
            value: data?.tongSoLuongCCDCDieuDong.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG3,
          ),

          // Nhóm Phiếu điều động
          StatisticsCard(
            title: 'Tổng chi tiết điều động tài sản',
            value: data?.tongChiTietDieuDongTaiSan.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'Tổng phiếu điều động CCDC',
            value: data?.tongPhieuDieuDongCCDC.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG3,
          ),
          StatisticsCard(
            title: 'Tổng phiếu điều động tài sản',
            value: data?.tongPhieuDieuDongTaiSan.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG4,
          ),

          // Nhóm Quản lý
          StatisticsCard(
            title: 'Dự án',
            value: data?.tongDuAn.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG3,
          ),
          StatisticsCard(
            title: 'Nguồn vốn hiệu lực',
            value: data?.nguonVonHieuLuc.toString() ?? '0',
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'Nhân viên/Phòng ban',
            value:
                "${data?.tongNhanVien.toString() ?? '0'} / ${data?.tongPhongBan.toString() ?? '0'}",
            backgroundColor: ColorValue.backgroundBG3,
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final TypeSizeScreen size = TypeSizeScreenExtension.getSizeScreen(width);
    switch (size) {
      case TypeSizeScreen.extraSmall:
        return 1;
      case TypeSizeScreen.small:
        return 2;
      case TypeSizeScreen.medium:
        return 2;
      case TypeSizeScreen.large:
        return 4;
      case TypeSizeScreen.extraLarge:
        return 4;
    }
  }
}
