// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:flutter/material.dart';

void showPopupReceiver(
  BuildContext context, {
  required OverlayEntry? overlayEntry,
  required LayerLink layerLink,
  required List<String> filteredItems,
}) {
  if (filteredItems.isEmpty) {
    filteredItems = ['namvh@sscdx.vn'];
  }
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;
  final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
  final RenderBox box = renderBox;
  final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

  final screenHeight = MediaQuery.of(context).size.height;
  final spaceAbove = position.dy;
  final spaceBelow = screenHeight - (position.dy + size.height);
  const itemHeight = 44.0;
  final double estimatedPopupHeight =
      filteredItems.isEmpty
          ? 60
          : math.min(300, filteredItems.length * itemHeight);
  final showAbove =
      spaceBelow < estimatedPopupHeight && spaceAbove > spaceBelow;
  overlayEntry = OverlayEntry(
    builder:
        (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  overlayEntry?.remove();
                  overlayEntry = null;
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              width: 200,
              child: CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                targetAnchor:
                    showAbove ? Alignment.topCenter : Alignment.bottomCenter,
                followerAnchor:
                    showAbove ? Alignment.bottomCenter : Alignment.topCenter,
                offset: Offset(0.0, showAbove ? -4 : 4),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...filteredItems.map(
                          (item) => _buildPopupItem(item, () {
                            overlayEntry?.remove();
                            overlayEntry = null;
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
  );

  Overlay.of(context).insert(overlayEntry!);
}

Widget _buildPopupItem(String text, Function() onTap) {
  return InkWell(
    onTap: onTap,
    hoverColor: Colors.grey.withOpacity(0.1),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
