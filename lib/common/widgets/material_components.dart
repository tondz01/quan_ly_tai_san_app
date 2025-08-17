import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

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
        color: foregroundColor ?? Colors.amberAccent,
        size: size ?? 20,
      ),
      tooltip: tooltip,
      style: IconButton.styleFrom(
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
      icon: icon != null ? Icon(icon, size: 16, color: Colors.white) : null,
      label: Text(
        text,
        style: textStyle ?? const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorValue.primaryBlue,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 2,
        shadowColor: ColorValue.primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        style: textStyle ?? const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
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
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            child: Icon(
              Icons.search,
              color: ColorValue.neutral500,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              style: TextStyle(
                color: ColorValue.neutral900,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: hintText ?? 'Tìm kiếm ...',
                hintStyle: TextStyle(
                  color: ColorValue.neutral500,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
          color: foregroundColor ?? (selected ? ColorValue.primaryBlue : ColorValue.neutral700),
          fontSize: 12,
        ),
      ),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 16) : null,
      onDeleted: onDeleted,
      backgroundColor: backgroundColor ?? (selected ? ColorValue.primaryLightBlue : ColorValue.neutral100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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

class MaterialStatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  const MaterialStatusBadge({
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
        style: textStyle ??
            TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  /// Factory constructor cho trạng thái thành công
  factory MaterialStatusBadge.success({required String text}) {
    return MaterialStatusBadge(
      text: text,
      color: ColorValue.success,
    );
  }

  /// Factory constructor cho trạng thái đang xử lý
  factory MaterialStatusBadge.processing({required String text}) {
    return MaterialStatusBadge(
      text: text,
      color: ColorValue.primaryBlue,
    );
  }

  /// Factory constructor cho trạng thái cảnh báo
  factory MaterialStatusBadge.warning({required String text}) {
    return MaterialStatusBadge(
      text: text,
      color: ColorValue.warning,
    );
  }

  /// Factory constructor cho trạng thái lỗi
  factory MaterialStatusBadge.error({required String text}) {
    return MaterialStatusBadge(
      text: text,
      color: ColorValue.error,
    );
  }

  /// Factory constructor cho trạng thái chờ xử lý
  factory MaterialStatusBadge.pending({required String text}) {
    return MaterialStatusBadge(
      text: text,
      color: ColorValue.neutral500,
    );
  }
}

class MaterialUserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  const MaterialUserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.backgroundColor = ColorValue.primaryBlue,
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