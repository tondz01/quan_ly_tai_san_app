// ignore_for_file: unused_field, deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'dart:math' as math;

class SGDropdownInput<T> extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? textDataNullSearch;
  final double? width;
  final double? height;
  final double? sizeBorderLine;
  final double? sizeBorderCircular;
  final double? sizeBorderMenuItemLine;
  final double? sizeBorderCircularItem;
  final Color? colorBorder;
  final Color? colorBorderMenuItem;
  final Color? colorSelectedText;
  final Color? colorBorderFocus;
  final Color? colorBorderHover;
  final Color? colorHoverItem;
  final bool? isShowSuffixIcon;
  final TextAlign? textAlign;
  final TextAlign? textAlignItem;
  final EdgeInsetsGeometry? contentPadding;
  final T? value;
  final T? defaultValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final TextInputType? inputType;
  final bool enableSearch;
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FocusNode? focusNode;

  const SGDropdownInput({
    super.key,
    required this.controller,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.textDataNullSearch,
    this.width,
    this.height,
    this.sizeBorderLine,
    this.sizeBorderCircular,
    this.sizeBorderMenuItemLine,
    this.sizeBorderCircularItem,
    this.colorBorder,
    this.colorBorderMenuItem,
    this.colorSelectedText,
    this.colorBorderFocus,
    this.colorBorderHover,
    this.colorHoverItem,
    this.isShowSuffixIcon = true,
    this.textAlign,
    this.textAlignItem,
    this.contentPadding,
    this.defaultValue,
    this.hintText,
    this.inputType,
    this.enableSearch = true,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    this.focusNode,
  });

  @override
  State<SGDropdownInput<T>> createState() => _SGDropdownInputState<T>();
}

class _SGDropdownInputState<T> extends State<SGDropdownInput<T>> {
  final LayerLink _layerLink = LayerLink();
  late final FocusNode _focusNode;
  OverlayEntry? _overlayEntry;
  late List<DropdownMenuItem<T>> _filteredItems;
  bool _isOpen = false;
  T? _hoveredItem;
  bool _justSelected = false;
  bool _isProgrammaticChange = false;
  T? _lastSelectedValue;
  bool _initialized = false;
  bool _needsOnChanged = false;
  T? _pendingValue;
  bool _ownsFocusNode = false;

  // Biến để kiểm soát việc đóng overlay
  bool _preventOverlayClose = false;

  @override
  void initState() {
    log('message initState');
    super.initState();

    // Sử dụng focusNode được truyền từ bên ngoài hoặc tạo mới
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      log('message initState: using external focusNode');
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
      log('message initState: created internal focusNode');
    }

    _filteredItems = widget.items;
    _setInitialValue();
    _focusNode.addListener(_handleFocus);

    widget.controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialized = true;
    });
  }

  void _setInitialValue() {
    log('message widget.value: ${widget.value}');
    if (widget.value != null) {
      _setControllerTextByValue(widget.value);
      _lastSelectedValue = widget.value;
    } else if (widget.defaultValue != null &&
        widget.items.any((item) => item.value == widget.defaultValue)) {
      _setControllerTextByValue(widget.defaultValue);
      _lastSelectedValue = widget.defaultValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.defaultValue);
      });
    } else if (widget.items.isNotEmpty) {
      _setControllerTextByValue(widget.items.first.value);
      _lastSelectedValue = widget.items.first.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(widget.items.first.value);
      });
    }
  }

  @override
  void didUpdateWidget(covariant SGDropdownInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _setControllerTextByValue(widget.value);
      _lastSelectedValue = widget.value;
    }
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
      _onTextChanged();
    }
  }

  void _setControllerTextByValue(T? value) {
    final text = _getTextFromValue(value);
    _isProgrammaticChange = true;
    widget.controller.text = text;
    _isProgrammaticChange = false;
  }

  String _getTextFromValue(T? value) {
    final item = widget.items.firstWhere(
      (item) => item.value == value,
      orElse: () => DropdownMenuItem<T>(value: null, child: const SizedBox()),
    );
    if (item.value != null && item.child is Text) {
      return (item.child as Text).data ?? '';
    } else if (item.value != null) {
      return item.value.toString();
    }
    return '';
  }

  void _handleFocus() {
    log('message _handleFocus');
    if (!_initialized) {
      log('message _handleFocus: not initialized, returning');
      return;
    }

    log('message _handleFocus: hasFocus=${_focusNode.hasFocus}');

    if (_focusNode.hasFocus) {
      log('message _handleFocus: has focus');
      if (_justSelected) {
        _justSelected = false;
        log('message _handleFocus: _justSelected=false now');
        return;
      }

      // Khi nhận focus, hiển thị overlay nếu chưa mở
      if (!_isOpen) {
        log('message _handleFocus: showing overlay on focus');
        _preventOverlayClose = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showOverlay();

            // Đặt lại _preventOverlayClose sau một khoảng thời gian
            Future.delayed(Duration(milliseconds: 300), () {
              _preventOverlayClose = false;
            });
          }
        });
      }
    } else {
      log('message _handleFocus: lost focus');

      // Nếu đang ngăn chặn đóng overlay, không làm gì cả
      if (_preventOverlayClose) {
        log('message _handleFocus: preventing overlay close');
        return;
      }

      // QUAN TRỌNG: Thêm kiểm tra để không đóng overlay ngay lập tức
      // Chỉ đóng overlay sau một khoảng thời gian
      Future.delayed(Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus && !_preventOverlayClose) {
          final currentText = widget.controller.text;
          // Xử lý text và đóng overlay
          _handleTextAndCloseOverlay(currentText);
        }
      });
    }
  }

  void _handleTextAndCloseOverlay(String currentText) {
    // Logic xử lý text và đóng overlay từ _handleFocus
    log('message _handleTextAndCloseOverlay: "$currentText"');

    final match = widget.items.firstWhere(
      (item) {
        final itemText =
            item.child is Text
                ? ((item.child as Text).data ?? '')
                : item.value.toString();
        final result = itemText == currentText;
        log('message comparing: "$itemText" == "$currentText" = $result');
        return result;
      },
      orElse: () {
        log('message no match found for "$currentText"');
        return DropdownMenuItem<T>(value: null, child: const SizedBox());
      },
    );

    log('message match: ${match.value}');

    if (match.value == null && _lastSelectedValue != null) {
      log('message match.value: null, _lastSelectedValue: $_lastSelectedValue');
      log('message widget.value: ${widget.value}');

      if (widget.value != _lastSelectedValue) {
        _setControllerTextByValue(_lastSelectedValue);
        log('message _setControllerTextByValue: $_lastSelectedValue');

        // Thay vì gọi onChanged trực tiếp, chúng ta đặt cờ và giá trị chờ
        _needsOnChanged = true;
        _pendingValue = _lastSelectedValue;

        // Sau đó chúng ta sử dụng addPostFrameCallback để gọi onChanged sau khi build hoàn tất
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_needsOnChanged && _pendingValue != null && mounted) {
            log('message calling onChanged with _pendingValue: $_pendingValue');
            widget.onChanged(_pendingValue);
            _needsOnChanged = false;
            _pendingValue = null;
          }
        });
      } else {
        log('message _setControllerTextByValue2: $_lastSelectedValue');
        _setControllerTextByValue(_lastSelectedValue);
      }
    }

    log('message _removeOverlay');
    _removeOverlay();
  }

  void _onTextChanged() {
    if (_isProgrammaticChange) return;
    if (!widget.enableSearch) return;
    final searchValue = widget.controller.text.toLowerCase();
    setState(() {
      if (searchValue.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems =
            widget.items.where((item) {
              final itemText =
                  item.child is Text
                      ? ((item.child as Text).data ?? '')
                      : item.value.toString();
              return itemText.toLowerCase().contains(searchValue);
            }).toList();
      }
      if (_isOpen && _overlayEntry != null) {
        _overlayEntry!.markNeedsBuild();
      }
    });
  }

  void _onItemSelected(DropdownMenuItem<T> item) {
    log('message _onItemSelected: ${item.value}');

    // Đặt cờ để ngăn chặn đóng overlay khi mất focus
    _preventOverlayClose = true;

    _isProgrammaticChange = true;
    widget.controller.text = _getTextFromValue(item.value);
    _isProgrammaticChange = false;
    _lastSelectedValue = item.value;
    log('message _onItemSelected2: ${item.value}');

    // Đóng overlay trước khi gọi onChanged
    _removeOverlay();

    setState(() {
      _filteredItems = widget.items;
      _justSelected = true;
    });

    // Thay vì gọi onChanged trực tiếp, chúng ta sử dụng addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        log('message calling onChanged with value: ${item.value}');
        widget.onChanged(item.value);

        // Đặt lại _preventOverlayClose sau khi onChanged đã được gọi
        Future.delayed(Duration(milliseconds: 300), () {
          _preventOverlayClose = false;
        });
      }
    });

    if (mounted) _focusNode.unfocus();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _justSelected = false);
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
      return;
    }
    _overlayEntry = _createOverlayEntry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlayEntry!);
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpen = false;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final RenderBox box = renderBox;
    final Offset position = box.localToGlobal(Offset.zero, ancestor: overlay);

    final screenHeight = MediaQuery.of(context).size.height;
    final spaceAbove = position.dy;
    final spaceBelow = screenHeight - (position.dy + size.height);

    const itemHeight = 44.0;
    final double estimatedPopupHeight =
        _filteredItems.isEmpty
            ? 60
            : math.min(300, _filteredItems.length * itemHeight);

    final showAbove =
        spaceBelow < estimatedPopupHeight && spaceAbove > spaceBelow;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: widget.width ?? size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor:
                  showAbove ? Alignment.topCenter : Alignment.bottomCenter,
              followerAnchor:
                  showAbove ? Alignment.bottomCenter : Alignment.topCenter,
              offset: Offset(0.0, showAbove ? -4 : 4),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(
                  widget.sizeBorderCircularItem ??
                      widget.sizeBorderCircular ??
                      12,
                ),
                child: _buildDropdownList(),
              ),
            ),
          ),
    );
  }

  Widget _buildDropdownList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children:
            _filteredItems.isNotEmpty
                ? _filteredItems.map(_buildDropdownItem).toList()
                : [_buildEmptyView()],
      ),
    );
  }

  Widget _buildDropdownItem(DropdownMenuItem<T> item) {
    final isSelected = item.value == (widget.value ?? widget.defaultValue);

    Widget child = item.child;
    if (child is Text) {
      child = Text(
        (child).data ?? '',
        textAlign: widget.textAlignItem ?? TextAlign.center,
        style: TextStyle(
          fontSize: widget.fontSize,
          color:
              isSelected
                  ? (widget.colorSelectedText ?? Colors.blue)
                  : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }

    // Sử dụng GestureDetector thay vì MouseRegion + InkWell để đảm bảo sự kiện tap hoạt động
    return MouseRegion(
      onEnter:
          (_) => setState(() {
            _hoveredItem = item.value;
            log('message _hoveredItem: $_hoveredItem');
          }),
      onExit: (_) => setState(() => _hoveredItem = null),
      child: InkWell(
        hoverColor:
            widget.colorHoverItem ??
            SGAppColors.colorBorderGray.withOpacity(0.15),
        onTapDown: (_) {
          log('message _onTapDown: ${item.value}');
          _onItemSelected(item);
        },
        child: Container(
          padding:
              widget.width != null && widget.width! <= 30
                  ? const EdgeInsets.only(top: 5, bottom: 5)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: child,
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SGText(text: widget.textDataNullSearch ?? 'No Data'),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    widget.controller.removeListener(_onTextChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: !widget.enableSearch,
          enableInteractiveSelection: widget.enableSearch,
          keyboardType: widget.inputType ?? TextInputType.text,
          inputFormatters: _buildInputFormatters(),
          textAlign: widget.textAlign ?? TextAlign.center,
          style: _buildTextStyle(),
          decoration: _buildInputDecoration(),
          onTap: _handleTap,
          onEditingComplete: _handleEditingComplete,
        ),
      ),
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    return widget.inputType == TextInputType.number
        ? [FilteringTextInputFormatter.digitsOnly]
        : null;
  }

  TextStyle _buildTextStyle() {
    return widget.textStyle?.copyWith(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ) ??
        TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight);
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.sizeBorderCircular ?? 12),
        borderSide: BorderSide(
          color: widget.colorBorder ?? SGAppColors.colorBorderGray,
          width: widget.sizeBorderLine ?? 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.sizeBorderCircular ?? 12),
        borderSide: BorderSide(
          color: widget.colorBorderFocus ?? SGAppColors.info500,
          width: widget.sizeBorderLine ?? 1,
        ),
      ),
      suffixIcon: _buildSuffixIcon(),
      contentPadding:
          widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  Widget? _buildSuffixIcon() {
    if (!(widget.isShowSuffixIcon ?? false)) {
      return null;
    }

    if (widget.enableSearch && widget.controller.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
        onPressed: () {
          widget.controller.clear();
          if (!_isOpen) _showOverlay();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.arrow_drop_down),
        onPressed: () {
          if (_isOpen) {
            _removeOverlay();
          } else {
            _focusNode.requestFocus();
            _showOverlay();
          }
        },
      );
    }
  }

  void _handleTap() {
    log('message _handleTap called');
    if (_justSelected) {
      log('message _handleTap: _justSelected is true, returning');
      return;
    }

    log('message _handleTap: requesting focus');
    _focusNode.requestFocus();

    // QUAN TRỌNG: Không xóa text trong controller khi tap
    // Đây là nguyên nhân chính gây mất focus
    if (!widget.enableSearch) {
      log('message _handleTap: clearing controller text');
      widget.controller.clear();
    }

    if (!_isOpen) {
      log('message _handleTap: showing overlay');
      // Đảm bảo overlay được hiển thị sau khi widget đã được build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showOverlay();

          Future.microtask(() {
            if (mounted) {
              FocusScope.of(context).requestFocus(_focusNode);
            }
          });
        }
      });
    }
  }

  void _handleEditingComplete() {
    if (widget.enableSearch) {
      final match = widget.items.firstWhere(
        (item) =>
            (item.child is Text
                ? ((item.child as Text).data ?? '')
                : item.value.toString()) ==
            widget.controller.text,
        orElse: () => DropdownMenuItem<T>(value: null, child: const SizedBox()),
      );
      if (match.value == null) {
        _setControllerTextByValue(_lastSelectedValue);
      }
    }
    _removeOverlay();
  }
}
