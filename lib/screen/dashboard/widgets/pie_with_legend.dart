import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class PieDonutChartWithLegend extends StatelessWidget {
  final List<Map<String, Object>> data;
  final String categoryKey;
  final String valueKey;
  final List<Color>? colors;
  final double chartWidth;
  final double chartHeight;
  final TextStyle? labelTextStyle;
  final bool showLegend;

  const PieDonutChartWithLegend({
    super.key,
    required this.data,
    this.categoryKey = 'genre',
    this.valueKey = 'sold',
    this.colors,
    this.chartWidth = 420,
    this.chartHeight = 420,
    this.labelTextStyle,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> resolvedColors = colors ?? Defaults.colors10;
    final List<String> categories =
        data.map((e) => e[categoryKey] as String).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: chartWidth,
          height: chartHeight,
          child: Chart(
            data: data,
            variables: {
              categoryKey: Variable(
                accessor: (Map map) => map[categoryKey] as String,
              ),
              valueKey: Variable(accessor: (Map map) => map[valueKey] as num),
            },
            transforms: [Proportion(variable: valueKey, as: 'percent')],
            marks: [
              IntervalMark(
                position: Varset('percent') / Varset(categoryKey),
                label: LabelEncode(
                  encoder: (tuple) {
                    final value = tuple[valueKey] as num;
                    final percent = tuple['percent'] as num;
                    return Label(
                      '${value.toInt()}',
                      LabelStyle(
                        textStyle: (labelTextStyle ??
                                const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ))
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                color: ColorEncode(
                  variable: categoryKey,
                  values: resolvedColors,
                ),
                modifiers: [StackModifier()],
                transition: Transition(
                  duration: const Duration(milliseconds: 300),
                ),
                entrance: {MarkEntrance.y},
              ),
            ],
            coord: PolarCoord(transposed: true, dimCount: 1),
            axes: [],
          ),
        ),
        if (showLegend) const SizedBox(width: 24),
        if (showLegend)
          Expanded(
            child: Column(
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
                            color: resolvedColors[i % resolvedColors.length],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categories[i],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF667085),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (i < data.length)
                                Text(
                                  '${(data[i][valueKey] as num).toInt()} (${((data[i][valueKey] as num) / data.fold(0.0, (sum, item) => sum + (item[valueKey] as num)) * 100).toStringAsFixed(1)}%)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF667085),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
