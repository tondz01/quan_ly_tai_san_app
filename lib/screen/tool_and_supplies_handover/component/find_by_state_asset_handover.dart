import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/widgets/common_filter_checkbox.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';

class FindByStateToolHandover extends StatelessWidget {
  const FindByStateToolHandover({
    super.key,
    required this.provider,
    required this.totalAll,
    required this.totalDraft,
    required this.totalBrowser,
    required this.totalCancel,
    required this.totalComplete,
  });

  final ToolAndSuppliesHandoverProvider provider;
  final int totalAll;
  final int totalDraft;
  final int totalBrowser;
  final int totalCancel;
  final int totalComplete;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: _FilterCheckboxes(
        totalAll: totalAll,
        totalDraft: totalDraft,
        totalBrowser: totalBrowser,
        totalCancel: totalCancel,
        totalComplete: totalComplete,
      ),
    );
  }
}

class _FilterCheckboxes extends StatelessWidget {
  const _FilterCheckboxes({
    required this.totalAll,
    required this.totalDraft,
    required this.totalBrowser,
    required this.totalCancel,
    required this.totalComplete,
  });

  final int totalAll;
  final int totalDraft;
  final int totalBrowser;
  final int totalCancel;
  final int totalComplete;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToolAndSuppliesHandoverProvider>(context);

    // Tạo map filter states từ provider
    final filterStates = {
      'all': provider.isShowAll,
      'draft': provider.isShowDraft,
      'browser': provider.isShowBrowser,
      'complete': provider.isShowComplete,
      'cancel': provider.isShowCancel,
    };

    // Tạo map filter counts từ tham số truyền vào
    final filterCounts = {
      'all': totalAll,
      'draft': totalDraft,
      'browser': totalBrowser,
      'cancel': totalCancel,
      'complete': totalComplete,
    };

    // Tạo map filter colors từ FilterStatus enum
    final filterColors = {
      'all': FilterStatus.all.activeColor,
      'draft': FilterStatus.draft.activeColor,
      'browser': FilterStatus.browser.activeColor,
      'cancel': FilterStatus.cancel.activeColor,
      'complete': FilterStatus.complete.activeColor,
    };

    // Tạo options sử dụng FilterOptionBuilder
    final options = FilterOptionBuilder.createCustomOptionsWithCount(
      options: [
        {'id': 'all', 'label': 'Tất cả'},
        {'id': 'draft', 'label': 'Nháp'},
        {'id': 'browser', 'label': 'Duyệt'},
        {'id': 'cancel', 'label': 'Hủy'},
        {'id': 'complete', 'label': 'Hoàn thành'},
      ],
      filterStates: filterStates,
      filterCounts: filterCounts,
      filterColors: filterColors,
      onFilterChanged: (id, value) {
        // Map id về FilterStatus enum
        FilterStatus? status;
        switch (id) {
          case 'all':
            status = FilterStatus.all;
            break;
          case 'draft':
            status = FilterStatus.draft;
            break;
          case 'browser':
            status = FilterStatus.browser;
            break;
          case 'cancel':
            status = FilterStatus.cancel;
            break;
          case 'complete':
            status = FilterStatus.complete;
            break;
        }
        if (status != null) {
          provider.setFilterStatus(context, status, value);
        }
      },
    );

    return Expanded(
      child: CommonFilterCheckbox(
        options: options,
        checkColor: Colors.white,
        textColor: Colors.black87,
        mainAxisAlignment: MainAxisAlignment.end,
        showCount: true,
      ),
    );
  }
}
