// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_input_text.dart';

class CommonFormInput extends StatefulWidget {
  const CommonFormInput({
    super.key,
    required this.label,
    required this.textContent,
    required this.controller,
    required this.isEditing,
    this.isDropdown = false,
    this.inputType,
    this.items,
    this.onChanged,
    this.fieldName,
    this.validationErrors,
  });
  final String label;
  final String textContent;
  final TextEditingController controller;
  final bool isEditing;
  final bool isDropdown;
  final bool isEnable = true;
  final TextInputType? inputType;
  final List<DropdownMenuItem<String>>? items;
  final Function(String)? onChanged;
  final String? fieldName;
  final Map<String, bool>? validationErrors;

  @override
  State<CommonFormInput> createState() => _CommonFormInputState();
}

class _CommonFormInputState extends State<CommonFormInput> {
  @override
  Widget build(BuildContext context) {
    bool hasError = false;
    if (widget.validationErrors != null) {
      hasError = widget.fieldName != null && widget.validationErrors![widget.fieldName] == true;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '${widget.label} :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: !widget.isEditing ? Colors.black87.withOpacity(0.6) : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isDropdown && widget.isEditing
                    ? SGDropdownInputButton<String>(
                      height: 35,
                      controller: widget.controller,
                      textOverflow: TextOverflow.ellipsis,
                      // Use value directly rather than setting controller.text
                      value: widget.textContent,
                      defaultValue: widget.textContent,
                      items: widget.items ?? [],
                      colorBorder:
                          (widget.validationErrors != null &&
                                  widget.fieldName != null &&
                                  widget.validationErrors![widget.fieldName] == true)
                              ? Colors.red
                              : SGAppColors.neutral400,
                      showUnderlineBorderOnly: true,
                      enableSearch: true,
                      isClearController: false, // Ensure this is false to prevent clearing controller
                      fontSize: 16,
                      inputType: widget.inputType,
                      isShowSuffixIcon: true,
                      hintText: 'Chọn ${widget.label.toLowerCase()}',
                      textAlign: TextAlign.left,
                      textAlignItem: TextAlign.left,
                      sizeBorderCircular: 10,
                      contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
                      onChanged: (value) {
                        if (value != null) {
                          widget.onChanged?.call(value);
                          if (hasError) {
                            setState(() {
                              widget.validationErrors?.remove(widget.fieldName);
                            });
                          }
                        }
                      },
                    )
                    : SGInputText(
                      height: 40,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      width: MediaQuery.of(context).size.width,
                      // expandable: true,
                      maxLines: 2,
                      controller: widget.controller,
                      borderRadius: 10,
                      enabled: widget.isEnable ? widget.isEditing : false,
                      textAlign: TextAlign.left,
                      readOnly: !widget.isEditing,
                      inputFormatters:
                          widget.inputType == TextInputType.number
                              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))]
                              : null,
                      onlyLine: true,
                      color: Colors.black,
                      showBorder: widget.isEditing,
                      borderColor: hasError ? Colors.red : null,
                      hintText: !widget.isEditing ? '' : '${'common.hint'.tr} ${widget.label}',
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      fontSize: 14,
                      onChanged: (value) {
                        widget.onChanged?.call(value);
                        // Clear validation error when text changes
                        if (hasError) {
                          setState(() {
                            widget.validationErrors?.remove(widget.fieldName);
                          });
                        }
                      },
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
          ),
        ],
      ),
    );
  }
}
