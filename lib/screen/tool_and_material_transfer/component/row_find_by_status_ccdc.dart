import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/widgets/common_filter_checkbox.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';


class RowFindByStatusCcdc extends StatelessWidget {
  const RowFindByStatusCcdc({super.key, required this.provider});
  final ToolAndMaterialTransferProvider provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: _FilterCheckboxes(),
    );
  }
}

class _FilterCheckboxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToolAndMaterialTransferProvider>(context);
    
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
      'all': provider.allCount,
      'draft': provider.draftCount,
      'approve': provider.approveCount,
      'cancel': provider.cancelCount,
      'complete': provider.completeCount,
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
          provider.setFilterStatus(status, value);
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
