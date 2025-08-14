import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_management_list.dart';

Widget assetView({required AssetManagementProvider provider}) {
  return Flexible(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CommonPageView(
        childInput: AssetDetail(provider: provider),
        childTableView: AssetManagementList(provider: provider),
        title: "Tạo tài sản",
        isShowInput: provider.isShowInput,
        isShowCollapse: provider.isShowCollapse,
        onExpandedChanged: (isExpanded) {
          provider.isShowCollapse = isExpanded;
        },
      ),
    ),
  );
}
