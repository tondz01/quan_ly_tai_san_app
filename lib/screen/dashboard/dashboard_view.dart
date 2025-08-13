import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_text_style.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/statistics_card.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:quan_ly_tai_san_app/core/enum/type_size_screen.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/pie_with_legend.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/scrollable_bar_chart.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/group_line_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGText(text: 'Tổng quan', style: AppTextStyle.textStyleSemiBold14),
              Row(
                children: [
                  SGText(text: 'Hôm nay (${_getCurrentDate()})', style: AppTextStyle.textStyleRegular12),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 4),
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: ColorValue.neutral700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Statistics cards
          _buildStatisticsSection(),

          Container(
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  alignment: Alignment.centerLeft,
                  child: SGText(text: "Biểu đồ tình trạng tài sản", style: AppTextStyle.textStyleSemiBold24),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(text: 'Tài sản theo hiện trạng', style: AppTextStyle.textStyleRegular14),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: PieDonutChartWithLegend(
                              data: basicData,
                              categoryKey: 'genre',
                              valueKey: 'sold',
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
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(text: "Tài sản theo loại", style: AppTextStyle.textStyleRegular14),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ScrollableBarChart(
                              data: basicData2,
                              categoryKey: 'genre',
                              valueKey: 'sold',
                              barWidth: 18,
                              spacing: 64,
                              height: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(text: "Tài sản theo nhóm / mô hình", style: AppTextStyle.textStyleRegular14),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ScrollableBarChart(
                              data: basicData2,
                              categoryKey: 'genre',
                              valueKey: 'sold',
                              barWidth: 18,
                              spacing: 64,
                              height: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(text: "Tài sản theo năm sản xuất", style: AppTextStyle.textStyleRegular14),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ScrollableBarChart(
                              data: basicData2,
                              categoryKey: 'genre',
                              valueKey: 'sold',
                              barWidth: 18,
                              spacing: 64,
                              height: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  alignment: Alignment.centerLeft,
                  child: SGText(text: "Tài sản theo nguồn vốn", style: AppTextStyle.textStyleRegular14),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ScrollableBarChart(
                    data: basicData2,
                    categoryKey: 'genre',
                    valueKey: 'sold',
                    barWidth: 18,
                    spacing: 64,
                    height: 300,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  alignment: Alignment.centerLeft,
                  child: SGText(text: "Hoạt động điều động & bàn giao", style: AppTextStyle.textStyleSemiBold24),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(
                              text: 'Phiếu điều động tài sản (tháng/quý)',
                              style: AppTextStyle.textStyleRegular14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 350,
                            height: 300,
                            child: GroupLineChart(
                              data: complexGroupData,
                              xKey: 'date',
                              yKey: 'points',
                              groupKey: 'name',
                              width: 350,
                              height: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(
                              text: "Phiếu điều động CCDC / vật tư",
                              style: AppTextStyle.textStyleRegular14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 350,
                            height: 300,
                            child: GroupLineChart(
                              data: complexGroupData,
                              xKey: 'date',
                              yKey: 'points',
                              groupKey: 'name',
                              width: 350,
                              height: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(
                              text: "Bàn giao tài sản theo trạng thái",
                              style: AppTextStyle.textStyleRegular14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: PieDonutChartWithLegend(
                              data: basicData,
                              categoryKey: 'genre',
                              valueKey: 'sold',
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
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(
                              text: "Tiến độ điều động (từ tggnTuNgay đến tggnDenNgay)",
                              style: AppTextStyle.textStyleRegular14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 350,
                            height: 300,
                            child: GroupLineChart(
                              data: complexGroupData,
                              xKey: 'date',
                              yKey: 'points',
                              groupKey: 'name',
                              width: 350,
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

          Container(
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  alignment: Alignment.centerLeft,
                  child: SGText(text: "Phòng ban & nhân sự", style: AppTextStyle.textStyleSemiBold24),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(text: 'Nhân viên theo phòng ban', style: AppTextStyle.textStyleRegular14),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ScrollableBarChart(
                              data: basicData2,
                              categoryKey: 'genre',
                              valueKey: 'sold',
                              barWidth: 18,
                              spacing: 64,
                              height: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            alignment: Alignment.centerLeft,
                            child: SGText(
                              text: "Tỷ lệ nhân viên Active / Inactive",
                              style: AppTextStyle.textStyleRegular14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: PieDonutChartWithLegend(
                              data: basicData,
                              categoryKey: 'genre',
                              valueKey: 'sold',
                              colors: listColors,
                              chartWidth: 420,
                              chartHeight: 420,
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
        ],
      ),
    );
  }

  List<Color> get listColors => [ColorValue.oceanBlue, ColorValue.pink, ColorValue.coral, ColorValue.amber];

  Widget _buildStatisticsSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
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
          StatisticsCard(
            title: 'Tổng tài sản',
            value: '1,234',
            icon: Icons.inventory,
            trend: '+12%',
            trendUp: true,
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'Nguyên giá',
            value: '1,234',
            icon: Icons.inventory,
            trend: '+12%',
            trendUp: true,
            backgroundColor: ColorValue.backgroundBG3,
          ),
          StatisticsCard(
            title: 'Giá trị còn lại',
            value: '987',
            icon: Icons.check_circle,
            trend: '+8%',
            trendUp: true,
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'Đang dùng / Thanh lý',
            value: '45',
            icon: Icons.build,
            trend: '-3%',
            trendUp: false,
            backgroundColor: ColorValue.backgroundBG3,
          ),
          StatisticsCard(
            title: 'Nhân viên & phòng ban',
            value: '23',
            icon: Icons.cancel,
            trend: '-5%',
            trendUp: false,
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'Dự án',
            value: '23',
            icon: Icons.cancel,
            trend: '-5%',
            trendUp: false,
            backgroundColor: ColorValue.backgroundBG3,
          ),
          StatisticsCard(
            title: 'Nguồn vốn',
            value: '23',
            icon: Icons.cancel,
            trend: '-5%',
            trendUp: false,
            backgroundColor: ColorValue.backgroundBG4,
          ),
          StatisticsCard(
            title: 'CCDC/Vật tư',
            value: '23',
            icon: Icons.cancel,
            trend: '-5%',
            trendUp: false,
            backgroundColor: ColorValue.backgroundBG3,
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  Widget _buildPieLegend(List<Map<String, Object>> data) {
    final List<String> categories = data.map((e) => e['genre'] as String).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < categories.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: listColors[i % listColors.length],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  categories[i],
                  style: TextStyle(fontSize: 12, color: ColorValue.neutral700, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
      ],
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
