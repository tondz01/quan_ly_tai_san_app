import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class VnNumberFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: 2,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('.', '').replaceAll(',', '.');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double? value = double.tryParse(newText);
    if (value == null) return oldValue;

    final newString = formatter.format(value);

    return TextEditingValue(
      text: newString.trim(),
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
