import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

/// A reusable multi-select popup for arbitrary object lists.
///
/// - Provide [items] as the source list
/// - Provide [itemLabel] to render the display text of each object
/// - Optionally provide [itemKey] to uniquely identify items (defaults to object identity)
/// - Provide [initialSelected] to pre-select values
/// - Use [onChanged] to receive incremental changes (optional)
/// - Use [onConfirmed] to receive the final selected list when user taps OK
class CMDropwdownAddListObject<T> extends StatefulWidget {
  const CMDropwdownAddListObject({
    super.key,
    required this.items,
    required this.itemLabel,
    this.itemKey,
    this.initialSelected = const [],
    this.onChanged,
    this.onConfirmed,
    this.hintText = 'Search in filters',
    this.okText = 'OK',
    this.resetText = 'Reset',
    this.searchDebounceMs = 0,
    this.maxHeight,
    this.shouldPopOnConfirm = true,
    this.readOnly = false,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final Object Function(T item)? itemKey;
  final List<T> initialSelected;
  final ValueChanged<List<T>>? onChanged;
  final ValueChanged<List<T>>? onConfirmed;
  final String hintText;
  final String okText;
  final String resetText;
  final int searchDebounceMs;
  final double? maxHeight;
  final bool shouldPopOnConfirm;
  final bool readOnly;

  @override
  State<CMDropwdownAddListObject<T>> createState() =>
      _CMDropwdownAddListObjectState<T>();
}

class _CMDropwdownAddListObjectState<T>
    extends State<CMDropwdownAddListObject<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late List<T> _filtered;
  late Set<Object> _selectedKeys;
  int _searchToken = 0;

  @override
  void initState() {
    super.initState();
    _filtered = List<T>.from(widget.items);
    _selectedKeys = widget.initialSelected.map((e) => _k(e)).toSet();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant CMDropwdownAddListObject<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _applyFilter(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Object _k(T item) => widget.itemKey?.call(item) ?? item as Object;

  void _onSearchChanged() {
    if (widget.searchDebounceMs <= 0) {
      _applyFilter(_searchController.text);
      return;
    }
    final current = ++_searchToken;
    Future.delayed(Duration(milliseconds: widget.searchDebounceMs), () {
      if (!mounted || current != _searchToken) return;
      _applyFilter(_searchController.text);
    });
  }

  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List<T>.from(widget.items);
      } else {
        _filtered =
            widget.items
                .where((e) => widget.itemLabel(e).toLowerCase().contains(q))
                .toList();
      }
    });
  }

  void _toggle(T item, bool checked) {
    setState(() {
      final key = _k(item);
      if (checked) {
        _selectedKeys.add(key);
      } else {
        _selectedKeys.remove(key);
      }
    });
    widget.onChanged?.call(_selectedObjects());
  }

  void _reset() {
    setState(() {
      _selectedKeys.clear();
    });
    widget.onChanged?.call(_selectedObjects());
  }

  List<T> _selectedObjects() {
    final keySet = _selectedKeys;
    return widget.items.where((e) => keySet.contains(_k(e))).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double dialogMaxHeight = widget.maxHeight ?? 420;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: dialogMaxHeight, maxWidth: 320),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!widget.readOnly) ...[
                _SearchField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  hintText: widget.hintText,
                ),
                const SizedBox(height: 8),
              ],
              Flexible(
                child: Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      final key = _k(item);
                      final checked = _selectedKeys.contains(key);
                      return CheckboxListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        value: checked,
                        onChanged: widget.readOnly ? null : (v) => _toggle(item, v ?? false),
                        title: Text(
                          widget.itemLabel(item),
                          overflow: TextOverflow.ellipsis,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
                ),
              ),
              if (!widget.readOnly) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: _reset, child: Text(widget.resetText)),
                    FilledButton(
                      onPressed: () {
                        final result = _selectedObjects();
                        widget.onConfirmed?.call(result);
                        if (widget.shouldPopOnConfirm &&
                            Navigator.of(context).canPop()) {
                          Navigator.of(context).pop(result);
                        }
                      },
                      child: Text(widget.okText),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Helper to show the multi-select popup as a dialog and await selected items.
Future<List<T>?> showMultiSelectObjectDialog<T>({
  required BuildContext context,
  required List<T> items,
  required String Function(T item) itemLabel,
  Object Function(T item)? itemKey,
  List<T> initialSelected = const [],
  String hintText = 'Search in filters',
  String okText = 'OK',
  String resetText = 'Reset',
  int searchDebounceMs = 0,
  double? maxHeight,
  bool readOnly = false,
}) {
  return showDialog<List<T>>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CMDropwdownAddListObject<T>(
          items: items,
          itemLabel: itemLabel,
          itemKey: itemKey,
          initialSelected: initialSelected,
          hintText: hintText,
          okText: okText,
          resetText: resetText,
          searchDebounceMs: searchDebounceMs,
          maxHeight: maxHeight,
          shouldPopOnConfirm: true,
          readOnly: readOnly,
        ),
      );
    },
  );
}

class CMDropdownTriggerAddListObject<T> extends StatefulWidget {
  const CMDropdownTriggerAddListObject({
    super.key,
    required this.items,
    required this.itemLabel,
    this.itemKey,
    this.initialSelected = const [],
    this.onChanged,
    this.hintText = 'Search in filters',
    this.okText = 'OK',
    this.resetText = 'Reset',
    this.labelText,
    this.placeholderText,
    this.maxHeight,
    this.readOnly = false,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final Object Function(T item)? itemKey;
  final List<T> initialSelected;
  final ValueChanged<List<T>>? onChanged;
  final String hintText;
  final String okText;
  final String resetText;
  final String? labelText;
  final String? placeholderText;
  final double? maxHeight;
  final bool readOnly;

  @override
  State<CMDropdownTriggerAddListObject<T>> createState() =>
      _CMDropdownTriggerAddListObjectState<T>();
}

class _CMDropdownTriggerAddListObjectState<T>
    extends State<CMDropdownTriggerAddListObject<T>> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.initialSelected);
  }

  Future<void> _openDialog() async {
    if (widget.readOnly) return;
    
    final result = await showMultiSelectObjectDialog<T>(
      context: context,
      items: widget.items,
      itemLabel: widget.itemLabel,
      itemKey: widget.itemKey,
      initialSelected: _selected,
      hintText: widget.hintText,
      okText: widget.okText,
      resetText: widget.resetText,
      maxHeight: widget.maxHeight,
      readOnly: widget.readOnly,
    );
    if (result != null) {
    setState(() {
        _selected = result;
      });
      widget.onChanged?.call(_selected);
    }
  }

  String _displayText() {
    if (_selected.isEmpty) {
      return widget.placeholderText ?? '';
    }
    final labels = _selected.map(widget.itemLabel).toList();
    if (labels.length <= 2) return labels.join(', ');
    return '${labels.take(2).join(', ')} +${labels.length - 2}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.labelText!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        InkWell(
          onTap: widget.readOnly ? null : _openDialog,
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            isEmpty: _selected.isEmpty,
            decoration: InputDecoration(
              hintText: widget.placeholderText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: widget.readOnly 
                ? (_selected.isNotEmpty ? null : const Icon(Icons.arrow_drop_down))
                : const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              _displayText(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

/// A clickable dropdown-like field that opens the multi-select dialog.
/// Displays the selected item labels or a hint when empty.
class CMObjectMultiSelectDropdownField<T> extends StatefulWidget {
  const CMObjectMultiSelectDropdownField({
    super.key,
    required this.items,
    required this.itemLabel,
    this.itemKey,
    this.initialSelected = const [],
    this.hintText = 'Chọn...',
    this.placeholderStyle,
    this.textStyle,
    this.onChanged,
    this.onConfirmed,
    this.searchHintText = 'Search in filters',
    this.okText = 'OK',
    this.resetText = 'Reset',
    this.searchDebounceMs = 0,
    this.maxPopupHeight,
    this.decoration,
    this.enabled = true,
    this.labelText,
    this.readOnly = false,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final Object Function(T item)? itemKey;
  final List<T> initialSelected;
  final String hintText;
  final TextStyle? placeholderStyle;
  final TextStyle? textStyle;
  final ValueChanged<List<T>>? onChanged;
  final ValueChanged<List<T>>? onConfirmed;
  final String searchHintText;
  final String okText;
  final String resetText;
  final int searchDebounceMs;
  final double? maxPopupHeight;
  final InputDecoration? decoration;
  final bool enabled;
  final String? labelText;
  final bool readOnly;

  @override
  State<CMObjectMultiSelectDropdownField<T>> createState() => _CMObjectMultiSelectDropdownFieldState<T>();
}

class _CMObjectMultiSelectDropdownFieldState<T> extends State<CMObjectMultiSelectDropdownField<T>> {
  late List<T> _selected;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Predefined palette for chip colors
  final List<Color> _chipColors = const <Color>[
    Colors.red,
    Colors.deepOrangeAccent,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  // Deterministic color by hashing text to a palette index
  Color _colorForText(String text) {
    int hash = 0;
    for (final codeUnit in text.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return _chipColors[hash % _chipColors.length];
  }

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.initialSelected);
  }

  @override
  void didUpdateWidget(covariant CMObjectMultiSelectDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected) {
      _selected = List<T>.from(widget.initialSelected);
    }
  }

  void _showOverlay() {
    if (!widget.enabled || widget.readOnly) return;
    _removeOverlay();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            // Dismiss area
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
                child: const SizedBox.shrink(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              child: Transform.translate(
                offset: const Offset(0, 52),
                child: Material(
                  color: Colors.transparent,
                  child: CMDropwdownAddListObject<T>(
                    items: widget.items,
                    itemLabel: widget.itemLabel,
                    itemKey: widget.itemKey,
                    initialSelected: _selected,
                    hintText: widget.searchHintText,
                    okText: widget.okText,
                    resetText: widget.resetText,
                    searchDebounceMs: widget.searchDebounceMs,
                    maxHeight: widget.maxPopupHeight ?? 360,
                    shouldPopOnConfirm: false,
                    onChanged: (list) {
                      // do nothing live, only update on OK
                    },
                    onConfirmed: (list) {
                      setState(() => _selected = list);
                      widget.onChanged?.call(List<T>.from(_selected));
                      widget.onConfirmed?.call(List<T>.from(_selected));
                      _removeOverlay();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Widget _builShowItemSeleted(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: _colorForText(text),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selected.removeWhere((e) => widget.itemLabel(e) == text);
              });
              widget.onChanged?.call(List<T>.from(_selected));
              widget.onConfirmed?.call(List<T>.from(_selected));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
          SGText(
            text: text,
            size: 12,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _selected.isNotEmpty;

    final theme = Theme.of(context);
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor),
    );

    final decoration = (widget.decoration ?? const InputDecoration()).copyWith(
      hintText: null,
      labelText: widget.labelText,
      suffixIcon: widget.readOnly && hasValue ? null : const Icon(Icons.arrow_drop_down),
      enabled: widget.enabled,
      border: widget.decoration?.border ?? baseBorder,
      enabledBorder: widget.decoration?.enabledBorder ?? baseBorder,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: widget.readOnly ? null : _showOverlay,
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          isEmpty: !hasValue,
          decoration: decoration,
          child:
              hasValue
                  ? Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _selected
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: _builShowItemSeleted(widget.itemLabel(e)),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            setState(() => _selected.clear());
                            widget.onChanged?.call(List<T>.from(_selected));
                            widget.onConfirmed?.call(List<T>.from(_selected));
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.clear_all, size: 18),
                          ),
                        ),
                      ],
                    )
                  : (widget.labelText != null
                      ? const SizedBox.shrink()
                      : Text(
                          widget.hintText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              widget.placeholderStyle ??
                              theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                        )),
        ),
      ),
    );
  }
}

