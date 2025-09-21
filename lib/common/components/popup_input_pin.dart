// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

/// A popup dialog for PIN input with validation and confirmation
class PopupInputPin extends StatefulWidget {
  final String title;
  final String description;
  final double? width;
  final double? height;
  final Function(int) onConfirm;
  final VoidCallback? onCancel;

  const PopupInputPin({
    super.key,
    required this.title,
    required this.description,
    this.width,
    this.height,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  State<PopupInputPin> createState() => _PopupInputPinState();
}

class _PopupInputPinState extends State<PopupInputPin> {
  String? _errorText;
  late TextEditingController _controller;
  bool _obscurePassword = true;

  // Constants
  static const double _defaultWidthRatio = 0.3;
  static const double _horizontalMargin = 20.0;
  static const double _padding = 24.0;
  static const double _borderRadius = 16.0;
  static const double _buttonHeight = 50.0;
  static const double _buttonBorderRadius = 12.0;
  static const double _shadowBlur = 20.0;
  static const double _shadowOffset = 10.0;
  static const double _shadowOpacity = 0.1;
  static const double _backdropOpacity = 0.5;
  static const String _pinHintText = "Nhập mã Pin";
  static const String _confirmButtonText = "XÁC NHẬN";
  static const String _numberOnlyError = 'Chỉ được nhập số';
  static const String _numberRegex = r'^\d+$';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handles the confirm action
  void _confirm() {
    widget.onConfirm(int.parse(_controller.text));
    Navigator.of(context).pop();
  }

  /// Handles the cancel action
  void _cancel() {
    widget.onCancel?.call();
    Navigator.of(context).pop();
  }

  /// Validates and processes text input changes
  void _onTextChanged(String value) {
    if (value.isEmpty) {
      _clearError();
      return;
    }

    if (!_isValidNumber(value)) {
      _setError(_numberOnlyError);
      return;
    }

    _clearError();
  }

  /// Validates if the input is a valid number
  bool _isValidNumber(String value) {
    return RegExp(_numberRegex).hasMatch(value);
  }

  /// Clears the current error state
  void _clearError() {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  /// Sets an error message
  void _setError(String error) {
    setState(() {
      _errorText = error;
    });
  }

  /// Calculates the popup width based on screen size
  double _calculatePopupWidth() {
    final screenWidth = MediaQuery.of(context).size.width;
    return widget.width ?? screenWidth * _defaultWidthRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(_backdropOpacity),
      child: Center(
        child: Container(
          width: _calculatePopupWidth(),
          constraints: BoxConstraints(minWidth: 300),
          margin: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
          padding: const EdgeInsets.all(_padding),
          decoration: _buildContainerDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCloseButton(),
              const SizedBox(height: 16),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildPinInputField(),
              if (_errorText != null) _buildErrorText(),
              const SizedBox(height: 24),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the container decoration with shadow
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(_shadowOpacity),
          blurRadius: _shadowBlur,
          offset: const Offset(0, _shadowOffset),
        ),
      ],
    );
  }

  /// Builds the close button
  Widget _buildCloseButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: _cancel,
          child: const Icon(Icons.close, color: Colors.grey),
        ),
      ],
    );
  }

  /// Builds the title text
  Widget _buildTitle() {
    return Text(
      widget.title,
      style: TextStyle(color: ColorValue.neutral900),
      textAlign: TextAlign.center,
    );
  }

  /// Builds the description text
  Widget _buildDescription() {
    return Text(
      widget.description,
      style: AppTextStyle.textStyleRegular14.copyWith(
        color: ColorValue.neutral600,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Builds the PIN input field
  Widget _buildPinInputField() {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      style: AppTextStyle.textStyleSemiBold16.copyWith(
        color: ColorValue.neutral800,
      ),
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: _pinHintText,
        hintStyle: AppTextStyle.textStyleRegular14.copyWith(
          color: ColorValue.neutral500,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      onChanged: _onTextChanged,
    );
  }

  /// Builds the error text widget
  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        _errorText!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  /// Builds the confirm button
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: _confirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorValue.primaryDarkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonBorderRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          _confirmButtonText,
          style: AppTextStyle.textStyleSemiBold14.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void showPopupInputPin({
  required BuildContext context,
  required String title,
  required String description,
  double? width,
  double? height,
  required Function(int) onConfirm,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => SizedBox(
          child: PopupInputPin(
            title: title,
            description: description,
            width: width,
            height: height,
            onConfirm: onConfirm,
            onCancel: onCancel,
          ),
        ),
  );
}
