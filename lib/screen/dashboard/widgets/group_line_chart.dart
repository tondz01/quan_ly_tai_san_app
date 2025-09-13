import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class GroupLineChart extends StatelessWidget {
  final List<Map<String, Object>> data;
  final String xKey;
  final String yKey;
  final String groupKey;
  final double width;
  final double height;

  const GroupLineChart({
    super.key,
    required this.data,
    this.xKey = 'date',
    this.yKey = 'points',
    this.groupKey = 'name',
    this.width = 350,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Chart(
        data: data,
        variables: {
          xKey: Variable(
            accessor: (Map map) => map[xKey] as String,
            scale: OrdinalScale(tickCount: 5, inflate: true),
          ),
          yKey: Variable(accessor: (Map map) => map[yKey] as num),
          groupKey: Variable(accessor: (Map map) => map[groupKey] as String),
        },
        coord: RectCoord(horizontalRange: const [0.01, 0.99]),
        marks: [
          LineMark(
            position: Varset(xKey) * Varset(yKey) / Varset(groupKey),
            shape: ShapeEncode(value: BasicLineShape(smooth: true, stepped: false)),
            size: SizeEncode(value: 0.5),
            color: ColorEncode(
              variable: groupKey,
              values: Defaults.colors10,
              updaters: {
                'groupMouse': {false: (color) => color.withAlpha(100)},
                'groupTouch': {false: (color) => color.withAlpha(100)},
              },
            ),
          ),
          PointMark(
            color: ColorEncode(
              variable: groupKey,
              values: Defaults.colors10,
              updaters: {
                'groupMouse': {false: (color) => color.withAlpha(100)},
                'groupTouch': {false: (color) => color.withAlpha(100)},
              },
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        selections: {
          'tooltipMouse': PointSelection(on: {GestureType.hover}, devices: {PointerDeviceKind.mouse}),
          'groupMouse': PointSelection(
            on: {GestureType.hover},
            variable: groupKey,
            devices: {PointerDeviceKind.mouse},
          ),
          'tooltipTouch': PointSelection(
            on: {GestureType.scaleUpdate, GestureType.tapDown, GestureType.longPressMoveUpdate},
            devices: {PointerDeviceKind.touch},
          ),
          'groupTouch': PointSelection(
            on: {GestureType.scaleUpdate, GestureType.tapDown, GestureType.longPressMoveUpdate},
            variable: groupKey,
            devices: {PointerDeviceKind.touch},
          ),
        },
        tooltip: TooltipGuide(
          selections: {'tooltipTouch', 'tooltipMouse'},
          followPointer: const [true, true],
          align: Alignment.topLeft,
          mark: 0,
          variables: [xKey, groupKey, yKey],
        ),
        crosshair: CrosshairGuide(
          selections: {'tooltipTouch', 'tooltipMouse'},
          styles: [
            PaintStyle(strokeColor: const Color(0xffbfbfbf)),
            PaintStyle(strokeColor: const Color(0x00bfbfbf)),
          ],
          followPointer: const [true, false],
        ),
      ),
    );
  }
} 