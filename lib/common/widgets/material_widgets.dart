import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/style_helper.dart';

/// Widget cho header trong các phần khác nhau của ứng dụng
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final bool withDivider;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.withDivider = true,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    titleStyle ??
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorValue.neutral900,
                    ),
              ),
              if (action != null) action!,
            ],
          ),
        ),
        if (withDivider)
          const Divider(thickness: 1, height: 1, color: ColorValue.neutral200),
      ],
    );
  }
}

/// Widget cho Status Badge
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style:
            textStyle ??
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Factory constructor cho trạng thái thành công
  factory StatusBadge.success({required String text}) {
    return StatusBadge(text: text, color: ColorValue.mediumGreen);
  }

  /// Factory constructor cho trạng thái đang xử lý
  factory StatusBadge.processing({required String text}) {
    return StatusBadge(text: text, color: ColorValue.lightOceanBlue);
  }

  /// Factory constructor cho trạng thái cảnh báo
  factory StatusBadge.warning({required String text}) {
    return StatusBadge(text: text, color: Colors.orange);
  }

  /// Factory constructor cho trạng thái lỗi
  factory StatusBadge.error({required String text}) {
    return StatusBadge(text: text, color: ColorValue.brightRed);
  }

  /// Factory constructor cho trạng thái chờ xử lý
  factory StatusBadge.pending({required String text}) {
    return StatusBadge(text: text, color: Colors.grey);
  }
}

/// Widget cho Search Bar với material design
class MaterialSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final bool showFilterButton;
  final VoidCallback? onFilterPressed;
  final EdgeInsetsGeometry margin;
  final double height;

  const MaterialSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Tìm kiếm...',
    this.onChanged,
    this.onClear,
    this.showFilterButton = true,
    this.onFilterPressed,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      decoration: StyleHelper.materialContainerDecoration(
        color: Colors.white,
        borderRadius: 24,
        withShadow: true,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: ColorValue.secondaryText,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: ColorValue.secondaryText,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clear();
                    if (onClear != null) {
                      onClear!();
                    }
                  },
                ),
              if (showFilterButton)
                IconButton(
                  icon: const Icon(
                    Icons.filter_list_rounded,
                    color: ColorValue.oceanBlue,
                  ),
                  onPressed: onFilterPressed,
                ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
        ),
      ),
    );
  }
}

/// Widget cho Empty State
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off_rounded,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorValue.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              StyleHelper.materialButton(
                onPressed: onActionPressed!,
                text: actionLabel!,
                icon: const Icon(Icons.add_rounded, size: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget cho avatar người dùng
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.backgroundColor = ColorValue.oceanBlue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl != null && imageUrl!.isNotEmpty
        ? CircleAvatar(
          radius: size / 2,
          backgroundImage: NetworkImage(imageUrl!),
        )
        : CircleAvatar(
          radius: size / 2,
          backgroundColor: backgroundColor,
          child: Text(
            _getInitials(name),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.4,
            ),
          ),
        );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    final names = name.split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    }

    return names.first[0].toUpperCase() + names.last[0].toUpperCase();
  }
}

/// Widget cho card thông tin cơ bản
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = ColorValue.oceanBlue,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorValue.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorValue.primaryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị nhãn và giá trị theo chiều dọc
class LabelValuePair extends StatelessWidget {
  final String label;
  final String value;
  final EdgeInsetsGeometry padding;
  final bool hasDivider;

  const LabelValuePair({
    super.key,
    required this.label,
    required this.value,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ColorValue.primaryText,
                ),
              ),
            ],
          ),
        ),
        if (hasDivider)
          const Divider(height: 1, thickness: 1, color: ColorValue.divider),
      ],
    );
  }
}

/// Widget hiển thị nhãn và giá trị theo chiều ngang
class HorizontalLabelValuePair extends StatelessWidget {
  final String label;
  final String value;
  final EdgeInsetsGeometry padding;
  final bool hasDivider;

  const HorizontalLabelValuePair({
    super.key,
    required this.label,
    required this.value,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorValue.primaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasDivider)
          const Divider(height: 1, thickness: 1, color: ColorValue.divider),
      ],
    );
  }
}

class MaterialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const MaterialIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: foregroundColor ?? const Color(0xFF21A366),
        size: size ?? 20,
      ),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorValue.neutral100,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        padding: padding ?? const EdgeInsets.all(8),
      ),
    );
  }
}

class MaterialTextButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;

  const MaterialTextButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
      label: Text(
        text,
        style:
            textStyle ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorValue.primaryBlue,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 2,
        shadowColor: ColorValue.primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class MaterialOutlinedButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? foregroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;

  const MaterialOutlinedButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.foregroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
      label: Text(
        text,
        style:
            textStyle ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? ColorValue.primaryBlue,
        side: BorderSide(
          color: borderColor ?? ColorValue.primaryBlue,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class MaterialSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final double? width;
  final double? height;

  const MaterialSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 280,
      height: height ?? 40,
      decoration: BoxDecoration(
        color: ColorValue.neutral50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorValue.neutral300),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search, color: ColorValue.neutral500, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              style: TextStyle(color: ColorValue.neutral900, fontSize: 14),
              decoration: InputDecoration(
                hintText: hintText ?? 'Tìm kiếm ...',
                hintStyle: TextStyle(
                  color: ColorValue.neutral500,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const MaterialCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      color: backgroundColor ?? Colors.white,
      elevation: elevation ?? 2,
      shadowColor: ColorValue.neutral300,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      margin: margin ?? const EdgeInsets.all(8),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }
}

class MaterialChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onDeleted;
  final bool selected;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const MaterialChip({
    super.key,
    required this.label,
    this.icon,
    this.onDeleted,
    this.selected = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color:
              foregroundColor ??
              (selected ? ColorValue.primaryBlue : ColorValue.neutral700),
          fontSize: 12,
        ),
      ),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 16) : null,
      onDeleted: onDeleted,
      backgroundColor:
          backgroundColor ??
          (selected ? ColorValue.primaryLightBlue : ColorValue.neutral100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class MaterialDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final double? height;
  final EdgeInsetsGeometry? margin;

  const MaterialDivider({
    super.key,
    this.color,
    this.thickness,
    this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? ColorValue.neutral200,
      thickness: thickness ?? 1,
      height: height ?? 1,
      indent: margin?.resolve(TextDirection.ltr).left ?? 0,
      endIndent: margin?.resolve(TextDirection.ltr).right ?? 0,
    );
  }
}
