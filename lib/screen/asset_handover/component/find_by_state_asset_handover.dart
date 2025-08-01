import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';

class ListStatus {
  final String text;
  final bool isEffective;
  final Function(bool?)? onChanged;

  ListStatus({required this.text, required this.isEffective, this.onChanged});
}

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
    final filters = [
      FilterStatus.all,
      FilterStatus.draft,
      FilterStatus.ready,
      FilterStatus.confirm,
      FilterStatus.browser,
      FilterStatus.complete,
      FilterStatus.cancel,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (final filter in filters)
          _buildFilterCheckbox(context, filter, provider),
      ],
    );
  }

  Widget _buildFilterCheckbox(
    BuildContext context,
    FilterStatus filter,
    AssetHandoverProvider provider,
  ) {
    bool isChecked = false;
    switch (filter) {
      case FilterStatus.all:
        isChecked = provider.isShowAll;
        break;
      case FilterStatus.draft:
        isChecked = provider.isShowDraft;
        break;
      case FilterStatus.ready:
        isChecked = provider.isShowReady;
        break;
      case FilterStatus.confirm:
        isChecked = provider.isShowConfirm;
        break;
      case FilterStatus.browser:
        isChecked = provider.isShowBrowser;
        break;
      case FilterStatus.complete:
        isChecked = provider.isShowComplete;
        break;
      case FilterStatus.cancel:
        isChecked = provider.isShowCancel;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isChecked,
              onChanged: (value) {
                provider.setFilterStatus(filter, value);
              },
              activeColor: const Color(0xFF80C9CB),
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          SGText(text: filter.label),
        ],
      ),
    );
  }
}
