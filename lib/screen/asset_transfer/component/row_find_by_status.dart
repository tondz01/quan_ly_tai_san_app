import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';

class ListStatus {
  final String text;
  final bool isEffective;
  final Function(bool?)? onChanged;

  ListStatus({required this.text, required this.isEffective, this.onChanged});
}

class RowFindByStatus extends StatelessWidget {
  const RowFindByStatus({super.key, required this.provider});
  final AssetTransferProvider provider;

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
    final provider = Provider.of<AssetTransferProvider>(context);
    final filters = [
      FilterStatus.all,
      FilterStatus.request,
      FilterStatus.confirm,
      FilterStatus.approve,
      FilterStatus.reject,
      FilterStatus.complete,
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
    AssetTransferProvider provider,
  ) {
    // Sử dụng các getter công khai thay vì truy cập trực tiếp vào thuộc tính private
    bool isChecked = false;
    switch (filter) {
      case FilterStatus.all:
        isChecked = provider.isShowAll;
        break;
      case FilterStatus.request:
        isChecked = provider.isShowRequest;
        break;
      case FilterStatus.confirm:
        isChecked = provider.isShowConfirm;
        break;
      case FilterStatus.approve:
        isChecked = provider.isShowApprove;
        break;
      case FilterStatus.reject:
        isChecked = provider.isShowReject;
        break;
      case FilterStatus.complete:
        isChecked = provider.isShowComplete;
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
