import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

class CustomEditableText extends StatefulWidget {
  final String placeholder;
  final String? initialValue;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Function(String)? onChanged;
  final double? scale;
  final double? width;

  const CustomEditableText({
    super.key,
    required this.placeholder,
    this.initialValue,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.onChanged,
    this.scale,
    this.width,
  });

  @override
  State<CustomEditableText> createState() => _CustomEditableTextState();
}

class _CustomEditableTextState extends State<CustomEditableText> {
  late TextEditingController _controller;
  bool _isEditing = false;
  String _currentValue = '';

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? '';
    _controller = TextEditingController(text: _currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper method to convert TextAlign to Alignment
  Alignment _getAlignment(TextAlign? textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.left:
      case TextAlign.start:
      case null:
      default:
        return Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: _isEditing ? Border.all(color: Colors.blue, width: 1) : null,
        ),
        child:
            _isEditing
                ? Container(
                  width: widget.width ?? 200,
                  height:
                      widget.style?.fontSize != null
                          ? widget.style!.fontSize! * 1.2
                          : 20,
                  alignment: _getAlignment(widget.textAlign),
                  child: TextField(
                    controller: _controller,
                    style: widget.style,
                    textAlign: widget.textAlign ?? TextAlign.start,
                    maxLines: widget.maxLines,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _isEditing = false;
                        _currentValue = value;
                      });
                      widget.onChanged?.call(value);
                    },
                    onTapOutside: (event) {
                      setState(() {
                        _isEditing = false;
                        _currentValue = _controller.text;
                      });
                      widget.onChanged?.call(_controller.text);
                    },
                    autofocus: true,
                  ),
                )
                : Container(
                  width: widget.width ?? 200,
                  height:
                      widget.style?.fontSize != null
                          ? widget.style!.fontSize! * 1.2
                          : 20,
                  alignment: _getAlignment(widget.textAlign),
                  child: SGText(
                    text:
                        _currentValue.isEmpty
                            ? widget.placeholder
                            : _currentValue,
                    style: widget.style?.copyWith(
                      color:
                          _currentValue.isEmpty
                              ? Colors.grey
                              : widget.style?.color,
                    ),
                    textAlign: widget.textAlign,
                    maxLines: widget.maxLines,
                    overflow: widget.overflow ?? TextOverflow.visible,
                  ),
                ),
      ),
    );
  }
}
