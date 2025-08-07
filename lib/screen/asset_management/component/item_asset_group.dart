// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';

class ItemAssetGroup extends StatefulWidget {
  const ItemAssetGroup({
    super.key,
    required this.titleName,
    this.numberAsset,
    this.image,
    this.valueCheckBox = false,
    this.color,
    this.icon,
    this.onTap,
    this.onChange,
  });
  final String titleName;
  final String? numberAsset;
  final String? image;
  final bool valueCheckBox;
  final Color? color;
  final IconData? icon;

  final VoidCallback? onTap;
  final Function(bool)? onChange;

  @override
  State<ItemAssetGroup> createState() => _ItemAssetGroupState();
}

class _ItemAssetGroupState extends State<ItemAssetGroup> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      width: (size.width * 0.2) <= 170 ? 170 : size.width * 0.2,
      height: (size.width * 0.2) <= 100 ? 100 : (size.width * 0.2) * 0.5,
      decoration: BoxDecoration(
        color: widget.valueCheckBox ? ColorValue.neutral50 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color:
                !widget.valueCheckBox
                    ? ColorValue.neutral200.withOpacity(0.3)
                    : Colors.black,
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      widget.color?.withOpacity(0.1) ??
                      ColorValue.accentLightCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    widget.icon != null
                        ? Icon(
                          widget.icon,
                          color: widget.color ?? ColorValue.accentLightCyan,
                          size: 24,
                        )
                        : SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            widget.image ?? 'assets/images/asset_group.png',
                            fit: BoxFit.cover,
                            color: widget.color ?? ColorValue.accentLightCyan,
                          ),
                        ),
              ),
              // Image.asset('assets/images/asset_group.png'),
              SizedBox(width: 10),
              Expanded(
                child: SGText(
                  text: widget.titleName,
                  size: 14,
                  fontWeight: FontWeight.bold,
                  lineHeight: 1.5,
                ),
              ),
            ],
          ),
          // Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SGText(
                text: 'Số lượng tài sản: ',
                size: 14,
                color: ColorValue.cyan,
                fontWeight: FontWeight.bold,
              ),
              SGText(
                text: widget.numberAsset ?? '0',
                size: 14,
                color: ColorValue.neutral500,
                fontWeight: FontWeight.bold,
              ),
              Spacer(),
              SgCheckbox(
                value: widget.valueCheckBox,
                onChanged: (value) => widget.onChange?.call(value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
