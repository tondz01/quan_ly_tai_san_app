// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_datetime_input_button.dart';

class CmFormDate extends StatefulWidget {
  const CmFormDate({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditing,
    this.fieldName,
    this.validationErrors,
    this.onChanged,
    this.value,
    this.initWithNow = true,
    this.enable = false,
    this.allowTyping = true,
    this.showTimeSection = true,
    this.timeOptional = true,
    this.includeSeconds = true,
    this.initialIncludeTime = false,
    this.isRequired = false,
  });
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final bool initWithNow;
  final bool enable;
  final bool allowTyping;
  final bool showTimeSection;
  final bool timeOptional;
  final bool includeSeconds;
  final bool initialIncludeTime;
  final DateTime? value;
  final Function(DateTime?)? onChanged;
  final String? fieldName;
  final Map<String, bool>? validationErrors;
  final bool isRequired;
  @override
  State<CmFormDate> createState() => _CmFormDateState();
}

class _CmFormDateState extends State<CmFormDate> {
  @override
  Widget build(BuildContext context) {
    bool hasError = false;
    if (widget.validationErrors != null) {
      hasError =
          widget.fieldName != null &&
          widget.validationErrors![widget.fieldName] == true;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SGDateTimeInputButton(
            label: widget.label,
            controller: widget.controller,
            value: widget.value,
            onChanged: (dt) {
              widget.onChanged?.call(dt);
            },
            width: double.infinity,
            height: 40,
            initWithNow: widget.initWithNow,
            enable: widget.enable,
            textAlign: TextAlign.left,
            sizeBorderCircular: 7,
            allowTyping: widget.allowTyping,
            showTimeSection: widget.showTimeSection,
            timeOptional: widget.timeOptional,
            includeSeconds: widget.includeSeconds,
            initialIncludeTime: widget.initialIncludeTime,
            colorBorder: SGAppColors.colorBorderGray,
            colorBorderFocus: SGAppColors.info500,
            // showUnderlineBorderOnly: true,
          ),
            
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Trường \'${widget.label}\' không được để trống',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
