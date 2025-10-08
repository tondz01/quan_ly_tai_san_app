// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_icons.dart';

enum ConfirmType { add, edit, delete }

class _Styles {
  final Widget icon;
  final Color badgeBg;
  final Color cancelBg;
  final Color cancelFg;
  final Color confirmBg;
  final Color confirmFg;
  const _Styles({
    required this.icon,
    required this.badgeBg,
    required this.cancelBg,
    required this.cancelFg,
    required this.confirmBg,
    required this.confirmFg,
  });
}

class PopupConfirm extends StatelessWidget {
  final ConfirmType type;
  final String title;
  final String message;
  final String highlight;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const PopupConfirm({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.highlight = '',
    this.cancelText = 'No, Cancel',
    this.confirmText = 'Yes, Confirm',
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final _Styles s = _stylesFor(type);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(20),
              //     onTap: () => Navigator.of(context).pop(false),
              //     child: const Padding(
              //       padding: EdgeInsets.all(4),
              //       child: Icon(Icons.close_rounded, color: Colors.black54),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: s.badgeBg,
                  shape: BoxShape.circle,
                ),
                child: s.icon,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildMessage(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionButton(
                      text: cancelText,
                      background: s.cancelBg,
                      foreground: s.cancelFg,
                      onTap: () {
                        onCancel?.call();
                        Navigator.of(context).pop(false);
                      },
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      text: confirmText,
                      background: s.confirmBg,
                      foreground: s.confirmFg,
                      onTap: () {
                        onConfirm?.call();
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    final String composed =
        highlight.isEmpty
            ? message
            : message.replaceFirst(highlight, '§§HIGHLIGHT§§');

    final parts = composed.split('§§HIGHLIGHT§§');

    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 4,
      children: [
        if (parts.isNotEmpty)
          Text(
            parts[0],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        if (highlight.isNotEmpty)
          Text(
            '"$highlight"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        if (parts.length > 1)
          Text(
            parts[1],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
      ],
    );
  }

  _Styles _stylesFor(ConfirmType t) {
    switch (t) {
      case ConfirmType.add:
        return _Styles(
          icon: AppIcons.add(color: ColorValue.oceanBlue),
          badgeBg: ColorValue.lightOceanBlue.withOpacity(0.25),
          cancelBg: ColorValue.neutral100,
          cancelFg: Colors.black87,
          confirmBg: ColorValue.oceanBlue.withOpacity(0.15),
          confirmFg: ColorValue.oceanBlue,
        );
      case ConfirmType.edit:
        return _Styles(
          icon: AppIcons.edit(color: ColorValue.accentCyan),
          badgeBg: ColorValue.accentLightCyan.withOpacity(0.25),
          cancelBg: ColorValue.neutral100,
          cancelFg: Colors.black87,
          confirmBg: ColorValue.accentLightCyan.withOpacity(0.35),
          confirmFg: ColorValue.accentCyan,
        );
      case ConfirmType.delete:
        return _Styles(
          icon: AppIcons.delete(color: ColorValue.brightRed),
          badgeBg: ColorValue.coral.withOpacity(0.2),
          cancelBg: ColorValue.neutral100,
          cancelFg: Colors.black87,
          confirmBg: ColorValue.brightRed.withOpacity(0.15),
          confirmFg: ColorValue.brightRed,
        );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required ConfirmType type,
  required String title,
  required String message,
  String highlight = '',
  String cancelText = 'No, Cancel',
  String confirmText = 'Yes, Confirm',
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder:
        (_) => PopupConfirm(
          type: type,
          title: title,
          message: message,
          highlight: highlight,
          cancelText: cancelText,
          confirmText: confirmText,
          onCancel: onCancel,
          onConfirm: onConfirm,
        ),
  );
}
