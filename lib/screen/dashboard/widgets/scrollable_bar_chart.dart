import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class ScrollableBarChart extends StatelessWidget {
  final List<Map<String, Object>> data;
  final String categoryKey;
  final String valueKey;
  final double barWidth;
  final double spacing;
  final double height;
  final Color? barColor;

  const ScrollableBarChart({
    super.key,
    required this.data,
    this.categoryKey = 'genre',
    this.valueKey = 'sold',
    this.barWidth = 18,
    this.spacing = 64,
    this.height = 200,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int count = data.length;
          final double minWidth = constraints.maxWidth;
          final double contentWidth = count * (barWidth + spacing) + 40;
          final double chartWidth =
              contentWidth < minWidth ? minWidth : contentWidth;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: chartWidth,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chart(
                data: data,
                variables: {
                  categoryKey: Variable(
                    accessor: (Map map) => map[categoryKey] as String,
                  ),
                  valueKey: Variable(
                    accessor: (Map map) => map[valueKey] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    size: SizeEncode(value: barWidth),
                    label: LabelEncode(
                      encoder: (tuple) => Label((tuple[valueKey]).toString()),
                    ),
                    elevation: ElevationEncode(value: 0),
                    color:
                        barColor != null
                            ? ColorEncode(value: barColor!)
                            : ColorEncode(value: Defaults.primaryColor),
                  ),
                ],
                axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
              ),
            ),
          );
        },
      ),
    );
  }
}
