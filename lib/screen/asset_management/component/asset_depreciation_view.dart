import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_depreciation_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_depreciation_list.dart';

Widget assetDepreciationView({required AssetManagementProvider provider}) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: CommonPageView(
      childInput: AssetDepreciationDetail(provider: provider),
      childTableView: AssetDepreciationList(provider: provider),
      title: "Tạo tài sản",
      isShowInput: provider.isShowInput,
      isShowCollapse: provider.isShowCollapse,
      onExpandedChanged: (isExpanded) {
        provider.isShowCollapse = isExpanded;
      },
    ),
  );
}
