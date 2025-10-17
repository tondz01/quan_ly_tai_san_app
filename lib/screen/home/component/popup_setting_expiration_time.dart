// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class PopupSettingExpirationTime extends StatefulWidget {
  final String title;
  final String description;
  final int initialValue;
  final int initialValueNotifiDealing;
  final int minValue;
  final int maxValue;
  final int step;
  final double? width;
  final double? height;
  final Function(int, int) onConfirm;
  final VoidCallback? onCancel;

  const PopupSettingExpirationTime({
    super.key,
    required this.title,
    required this.description,
    this.initialValue = 0,
    this.initialValueNotifiDealing = 0,
    this.minValue = 0,
    this.maxValue = 999,
    this.step = 1,
    this.width,
    this.height,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  State<PopupSettingExpirationTime> createState() =>
      _PopupSettingExpirationTimeState();
}

class _PopupSettingExpirationTimeState
    extends State<PopupSettingExpirationTime> {
  late TextEditingController _controller;
  late TextEditingController _controllerNotifiDealing;
  late int _currentValue;
  late int _currentValueNotifiDealing;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
    _controllerNotifiDealing = TextEditingController();
    _currentValueNotifiDealing = widget.initialValueNotifiDealing;
    _controllerNotifiDealing.text = _currentValueNotifiDealing.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerNotifiDealing.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      if (_currentValue + widget.step <= widget.maxValue) {
        _currentValue += widget.step;
        _controller.text = _currentValue.toString();
      }
    });
  }

  void _decrement() {
    setState(() {
      if (_currentValue - widget.step >= widget.minValue) {
        _currentValue -= widget.step;
        _controller.text = _currentValue.toString();
      }
    });
  }

  void _incrementDealing() {
    setState(() {
      if (_currentValueNotifiDealing + widget.step <= widget.maxValue) {
        _currentValueNotifiDealing += widget.step;
        _controllerNotifiDealing.text = _currentValueNotifiDealing.toString();
      }
    });
  }

  void _decrementDealing() {
    setState(() {
      if (_currentValueNotifiDealing - widget.step >= widget.minValue) {
        _currentValueNotifiDealing -= widget.step;
        _controllerNotifiDealing.text = _currentValueNotifiDealing.toString();
      }
    });
  }

  void _onTextChanged(String value) {
    if (value.isEmpty) {
      _currentValue = widget.minValue;
      return;
    }

    int? parsedValue = int.tryParse(value);
    if (parsedValue != null) {
      if (parsedValue >= widget.minValue && parsedValue <= widget.maxValue) {
        _currentValue = parsedValue;
      } else if (parsedValue < widget.minValue) {
        _currentValue = widget.minValue;
        _controller.text = widget.minValue.toString();
      } else if (parsedValue > widget.maxValue) {
        _currentValue = widget.maxValue;
        _controller.text = widget.maxValue.toString();
      }
    }
  }

  void _onTextChangedDealing(String value) {
    if (value.isEmpty) {
      _currentValueNotifiDealing = widget.minValue;
      return;
    }

    int? parsedValue = int.tryParse(value);
    if (parsedValue != null) {
      if (parsedValue >= widget.minValue && parsedValue <= widget.maxValue) {
        _currentValueNotifiDealing = parsedValue;
      } else if (parsedValue < widget.minValue) {
        _currentValueNotifiDealing = widget.minValue;
        _controllerNotifiDealing.text = widget.minValue.toString();
      } else if (parsedValue > widget.maxValue) {
        _currentValueNotifiDealing = widget.maxValue;
        _controllerNotifiDealing.text = widget.maxValue.toString();
      }
    }
  }

  void _confirm() {
    widget.onConfirm(_currentValue, _currentValueNotifiDealing);
    Navigator.of(context).pop();
  }

  void _cancel() {
    widget.onCancel?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = widget.width ?? screenWidth * 0.5;

    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: popupWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _cancel,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: ColorValue.colorGreenDefault,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Title
              Text(
                widget.title,
                style: AppTextStyle.textStyleSemiBold24.copyWith(
                  color: ColorValue.colorGreenDefault,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                widget.description,
                style: AppTextStyle.textStyleRegular14.copyWith(
                  color: ColorValue.neutral600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Input field with increment/decrement buttons
              Container(
                decoration: BoxDecoration(
                  color: ColorValue.neutral100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Decrement button
                    GestureDetector(
                      onTap: _decrement,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorValue.colorGreenDefault,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    // Input field
                    Expanded(
                      child: SGInputText(
                        height: 50,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        maxLines: 1,
                        controller: _controller,
                        borderRadius: 20,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        enabledBorderColor: ColorValue.primaryDarkBlue,
                        showBorder: false,
                        hintText: 'Nhập số',
                        fontSize: 16,
                        onChanged: _onTextChanged,
                      ),
                    ),

                    // Increment button
                    GestureDetector(
                      onTap: _increment,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorValue.colorGreenDefault,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                'Nhập số ngày báo hết hạn (tính theo ngày)',
                style: AppTextStyle.textStyleRegular14.copyWith(
                  color: ColorValue.neutral600,
                  fontSize: 16
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: ColorValue.neutral100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Decrement button
                    GestureDetector(
                      onTap: _decrementDealing,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorValue.colorGreenDefault,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    // Input field
                    Expanded(
                      child: SGInputText(
                        height: 50,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        maxLines: 1,
                        controller: _controllerNotifiDealing,
                        borderRadius: 20,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        enabledBorderColor: ColorValue.primaryDarkBlue,
                        showBorder: false,
                        hintText: 'Nhập số',
                        fontSize: 16,
                        onChanged: _onTextChangedDealing,
                      ),
                    ),

                    // Increment button
                    GestureDetector(
                      onTap: _incrementDealing,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorValue.colorGreenDefault,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorValue.colorGreenDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "XÁC NHẬN",
                    style: AppTextStyle.textStyleSemiBold14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to show the popup
void showPopupSettingExpirationTime({
  required BuildContext context,
  required String title,
  required String description,
  int initialValue = 0,
  int initialValueNotifiDealing = 0,
  int minValue = 0,
  int maxValue = 999,
  int step = 1,
  double? width,
  double? height,
  required Function(int, int) onConfirm,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => SizedBox(
          child: PopupSettingExpirationTime(
            title: title,
            description: description,
            initialValue: initialValue,
            initialValueNotifiDealing: initialValueNotifiDealing,
            minValue: minValue,
            maxValue: maxValue,
            step: step,
            width: width,
            height: height,
            onConfirm: onConfirm,
            onCancel: onCancel,
          ),
        ),
  );
}
