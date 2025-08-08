// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';

class CmFormDropdownObject<T> extends StatefulWidget {
  const CmFormDropdownObject({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.items,
    this.inputType,
    this.onChanged,
    this.fieldName,
    this.validationErrors,
    this.value,
    this.defaultValue,
  });
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final TextInputType? inputType;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final T? defaultValue;
  final Function(T)? onChanged;
  final String? fieldName;
  final Map<String, bool>? validationErrors;

  @override
  State<CmFormDropdownObject<T>> createState() => _CommonFormInputState<T>();
}

class _CommonFormInputState<T> extends State<CmFormDropdownObject<T>> {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '${widget.label} :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color:
                    !widget.isEditing
                        ? Colors.black87.withOpacity(0.6)
                        : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGDropdownInputButton<T>(
                  height: 35,
                  controller: widget.controller,
                  textOverflow: TextOverflow.ellipsis,
                  enable: !widget.isEditing,
                  value: widget.value,
                  defaultValue: widget.defaultValue,
                  items: widget.items ?? [],
                  colorBorder:
                      (widget.validationErrors != null &&
                              widget.fieldName != null &&
                              widget.validationErrors![widget.fieldName] ==
                                  true)
                          ? Colors.red
                          : SGAppColors.neutral400,
                  showUnderlineBorderOnly: true,
                  enableSearch: false,
                  isClearController: true,
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
