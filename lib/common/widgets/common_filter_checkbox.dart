import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

/// Model cho một filter option với count
class FilterOption {
  final String id;
  final String label;
  final bool isChecked;
  final int count;
  final Color activeColor;
  final Function(bool?)? onChanged;

  FilterOption({
    required this.id,
    required this.label,
    this.isChecked = false,
    this.count = 0,
    required this.activeColor,
    this.onChanged,
  });
}

/// Component common cho filter checkbox với count
class CommonFilterCheckbox extends StatelessWidget {
  final List<FilterOption> options;
  final Color? checkColor;
  final Color? textColor;
  final double? checkboxSize;
  final double? textSize;
  final double? countTextSize;
  final EdgeInsets? padding;
  final MainAxisAlignment mainAxisAlignment;
  final bool showCount;

  const CommonFilterCheckbox({
    super.key,
    required this.options,
    this.checkColor,
    this.textColor,
    this.checkboxSize,
    this.textSize,
    this.countTextSize,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        for (final option in options) _buildFilterCheckbox(context, option),
      ],
    );
  }

  Widget _buildFilterCheckbox(BuildContext context, FilterOption option) {
    final isChecked = option.isChecked;
    final textColorToUse =
        isChecked ? option.activeColor : (textColor ?? Colors.black87);

    return Padding(
      padding: padding ?? const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          SizedBox(
            width: checkboxSize ?? 24,
            height: checkboxSize ?? 24,
            child: Checkbox(
              value: isChecked,
              onChanged: option.onChanged,
              activeColor: option.activeColor,
              checkColor: checkColor ?? Colors.white,
              side: BorderSide(
                color: option.activeColor,
                width: 3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SGText(
                text: option.label,
                color: textColorToUse,
                textAlign: TextAlign.center,
                size: textSize ?? 14,
              ),
              if (showCount) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isChecked ? option.activeColor : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: SGText(
                    text: option.count.toString(),
                    color: isChecked ? Colors.white : Colors.black87,
                    size: countTextSize ?? 11,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper class để tạo FilterOption dễ dàng hơn
class FilterOptionBuilder {
  static FilterOption create({
    required String id,
    required String label,
    bool isChecked = false,
    int count = 0,
    required Color activeColor,
    Function(bool?)? onChanged,
  }) {
    return FilterOption(
      id: id,
      label: label,
      isChecked: isChecked,
      count: count,
      activeColor: activeColor,
      onChanged: onChanged,
    );
  }

  /// Tạo danh sách filter options cho asset transfer với count
  static List<FilterOption> createAssetTransferOptionsWithCount({
    required Map<String, bool> filterStates,
    required Map<String, int> filterCounts,
    required Map<String, Color> filterColors,
    required Function(String, bool?) onFilterChanged,
  }) {
    return [
      FilterOptionBuilder.create(
        id: 'all',
        label: 'Tất cả',
        isChecked: filterStates['all'] ?? false,
        count: filterCounts['all'] ?? 0,
        activeColor: filterColors['all'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('all', value),
      ),
      FilterOptionBuilder.create(
        id: 'draft',
        label: 'Nháp',
        isChecked: filterStates['draft'] ?? false,
        count: filterCounts['draft'] ?? 0,
        activeColor: filterColors['draft'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('draft', value),
      ),
      FilterOptionBuilder.create(
        id: 'waitingForConfirmation',
        label: 'Chờ xác nhận',
        isChecked: filterStates['waitingForConfirmation'] ?? false,
        count: filterCounts['waitingForConfirmation'] ?? 0,
        activeColor: filterColors['waitingForConfirmation'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('waitingForConfirmation', value),
      ),
      FilterOptionBuilder.create(
        id: 'confirmed',
        label: 'Xác nhận',
        isChecked: filterStates['confirmed'] ?? false,
        count: filterCounts['confirmed'] ?? 0,
        activeColor: filterColors['confirmed'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('confirmed', value),
      ),
      FilterOptionBuilder.create(
        id: 'browser',
        label: 'Trình duyệt',
        isChecked: filterStates['browser'] ?? false,
        count: filterCounts['browser'] ?? 0,
        activeColor: filterColors['browser'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('browser', value),
      ),
      FilterOptionBuilder.create(
        id: 'approve',
        label: 'Duyệt',
        isChecked: filterStates['approve'] ?? false,
        count: filterCounts['approve'] ?? 0,
        activeColor: filterColors['approve'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('approve', value),
      ),
      FilterOptionBuilder.create(
        id: 'reject',
        label: 'Từ chối',
        isChecked: filterStates['reject'] ?? false,
        count: filterCounts['reject'] ?? 0,
        activeColor: filterColors['reject'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('reject', value),
      ),
      FilterOptionBuilder.create(
        id: 'cancel',
        label: 'Hủy',
        isChecked: filterStates['cancel'] ?? false,
        count: filterCounts['cancel'] ?? 0,
        activeColor: filterColors['cancel'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('cancel', value),
      ),
      FilterOptionBuilder.create(
        id: 'complete',
        label: 'Hoàn thành',
        isChecked: filterStates['complete'] ?? false,
        count: filterCounts['complete'] ?? 0,
        activeColor: filterColors['complete'] ?? Colors.grey,
        onChanged: (value) => onFilterChanged('complete', value),
      ),
    ];
  }

  /// Tạo danh sách filter options tùy chỉnh với count
  static List<FilterOption> createCustomOptionsWithCount({
    required List<Map<String, dynamic>> options,
    required Map<String, bool> filterStates,
    required Map<String, int> filterCounts,
    required Map<String, Color> filterColors,
    required Function(String, bool?) onFilterChanged,
  }) {
    return options.map((option) {
      final id = option['id'] as String;
      final label = option['label'] as String;

      return FilterOptionBuilder.create(
        id: id,
        label: label,
        isChecked: filterStates[id] ?? false,
        count: filterCounts[id] ?? 0,
        activeColor: filterColors[id] ?? Colors.grey,
        onChanged: (value) => onFilterChanged(id, value),
      );
    }).toList();
  }
}
