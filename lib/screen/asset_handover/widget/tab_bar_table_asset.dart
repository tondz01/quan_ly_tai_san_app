import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_list.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_transfer_list.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';

class TabBarTableAsset extends StatefulWidget {
  final AssetHandoverProvider provider;
  const TabBarTableAsset({super.key, required this.provider});

  @override
  State<TabBarTableAsset> createState() => _TabBarTableAssetState();
}

class _TabBarTableAssetState extends State<TabBarTableAsset> {
  List<DieuDongTaiSanDto> dataAssetTransfer = [];
  @override
  void initState() {
    super.initState();
    dataAssetTransfer =
        widget.provider.dataAssetTransfer
            ?.where((element) => element.trangThai == 3)
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 400,
                    child: TabBar(
                      indicatorColor: ColorValue.link,
                      labelColor: ColorValue.link,
                      unselectedLabelColor: Colors.grey.shade600,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.book_outlined, size: 18),
                          text: 'Biên bản bàn giao',
                        ),
                        Tab(
                          icon: Icon(Icons.table_chart, size: 18),
                          text: 'Quyết định điều động',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Tab 1: Bàn giao tài sản
                  AssetHandoverList(
                    provider: widget.provider,
                    listAssetTransfer: dataAssetTransfer,
                  ),
                  AssetTransferList(
                    data: dataAssetTransfer,
                    provider: widget.provider,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
