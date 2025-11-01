import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/widgets/common_filter_checkbox.dart';

import '../provider/dieu_dong_tai_san_provider.dart';

class RowFindByStatus extends StatelessWidget {
  const RowFindByStatus({
    super.key,
    required this.provider,
    required this.totalAll,
    required this.totalDraft,
    required this.totalApprove,
    required this.totalCancel,
    required this.totalComplete,
  });
  final DieuDongTaiSanProvider provider;
  final int totalAll;
  final int totalDraft;
  final int totalApprove;
  final int totalCancel;
  final int totalComplete;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: _FilterCheckboxes(
        totalAll: totalAll,
        totalDraft: totalDraft,
        totalApprove: totalApprove,
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
    required this.totalApprove,
    required this.totalCancel,
    required this.totalComplete,
  });
  final int totalAll;
  final int totalDraft;
  final int totalApprove;
  final int totalCancel;
  final int totalComplete;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DieuDongTaiSanProvider>(context);

    // Tạo map filter states từ provider
    final filterStates = {
      'all': provider.isShowAll,
      'draft': provider.isShowDraft,
      'approve': provider.isShowApprove,
      'cancel': provider.isShowCancel,
      'complete': provider.isShowComplete,
    };

    // Tạo map filter counts từ provider
    final filterCounts = {
      'all': totalAll,
      'draft': totalDraft,
      'approve': totalApprove,
      'cancel': totalCancel,
      'complete': totalComplete,
    };

    // Tạo map filter colors từ FilterStatus enum
    final filterColors = {
      'all': FilterStatus.all.activeColor,
      'draft': FilterStatus.draft.activeColor,
      'approve': FilterStatus.approve.activeColor,
      'cancel': FilterStatus.cancel.activeColor,
      'complete': FilterStatus.complete.activeColor,
    };

    // Tạo options sử dụng FilterOptionBuilder
    final options = FilterOptionBuilder.createAssetTransferOptionsWithCount(
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
          case 'approve':
            status = FilterStatus.approve;
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

    return CommonFilterCheckbox(
      options: options,
      checkColor: Colors.white,
      textColor: Colors.black87,
      mainAxisAlignment: MainAxisAlignment.end,
      showCount: true,
    );
  }
}
