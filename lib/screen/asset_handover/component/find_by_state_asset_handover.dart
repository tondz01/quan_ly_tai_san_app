import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/widgets/common_filter_checkbox.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';

class FindByStateAssetHandover extends StatelessWidget {
  const FindByStateAssetHandover({super.key, required this.provider});
  final AssetHandoverProvider provider;

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
    final provider = Provider.of<AssetHandoverProvider>(context);
    
    // Tạo map filter states từ provider
    final filterStates = {
      'all': provider.isShowAll,
      'draft': provider.isShowDraft,
      'ready': provider.isShowReady,
      'confirm': provider.isShowConfirm,
      'browser': provider.isShowBrowser,
      'complete': provider.isShowComplete,
      'cancel': provider.isShowCancel,
    };

    // Tạo map filter counts từ provider
    final filterCounts = {
      'all': provider.allCount,
      'draft': provider.draftCount,
      'ready': provider.readyCount,
      'confirm': provider.confirmCount,
      'browser': provider.browserCount,
      'complete': provider.completeCount,
      'cancel': provider.cancelCount,
    };

    // Tạo map filter colors từ FilterStatus enum
    final filterColors = {
      'all': FilterStatus.all.activeColor,
      'draft': FilterStatus.draft.activeColor,
      'ready': FilterStatus.ready.activeColor,
      'confirm': FilterStatus.confirm.activeColor,
      'browser': FilterStatus.browser.activeColor,
      'complete': FilterStatus.complete.activeColor,
      'cancel': FilterStatus.cancel.activeColor,
    };

    // Tạo options sử dụng FilterOptionBuilder
    final options = FilterOptionBuilder.createCustomOptionsWithCount(
      options: [
        {'id': 'all', 'label': 'Tất cả'},
        {'id': 'draft', 'label': 'Nháp'},
        {'id': 'ready', 'label': 'Sẵn sàng'},
        {'id': 'confirm', 'label': 'Xác nhận'},
        {'id': 'browser', 'label': 'Trình duyệt'},
        {'id': 'complete', 'label': 'Hoàn thành'},
        {'id': 'cancel', 'label': 'Hủy'},
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
          case 'ready':
            status = FilterStatus.ready;
            break;
          case 'confirm':
            status = FilterStatus.confirm;
            break;
          case 'browser':
            status = FilterStatus.browser;
            break;
          case 'complete':
            status = FilterStatus.complete;
            break;
          case 'cancel':
            status = FilterStatus.cancel;
            break;
        }
        
        if (status != null) {
          provider.setFilterStatus(status, value);
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
