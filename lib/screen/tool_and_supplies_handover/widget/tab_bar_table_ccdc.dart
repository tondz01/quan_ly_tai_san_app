import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/tool_and_supplies_handover_list.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/tool_and_supplies_handover_transfer_list.dart';

class TabBarTableCcdc extends StatefulWidget {
  final ToolAndSuppliesHandoverProvider provider;
  const TabBarTableCcdc({super.key, required this.provider});

  @override
  State<TabBarTableCcdc> createState() => _TabBarTableCcdcState();
}

class _TabBarTableCcdcState extends State<TabBarTableCcdc> {
  List<ToolAndMaterialTransferDto> dataAssetTransfer = [];
  int quyetDinhCount = 0;
  @override
  void initState() {
    super.initState();
    _getDataAssetTransfer();
  }

  @override
  void didUpdateWidget(TabBarTableCcdc oldWidget) {
    super.didUpdateWidget(oldWidget);
    log('dataAssetTransfer: ${dataAssetTransfer.length}');
    _getDataAssetTransfer();
  }

  void _getDataAssetTransfer() {
    dataAssetTransfer =
        widget.provider.dataAssetTransfer
            ?.where((element) => element.trangThai == 3)
            // .where((element) => element.daBanGiao == false)
            .toList() ??
        [];
    quyetDinhCount = dataAssetTransfer.length;
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
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.table_chart, size: 18),
                                  SizedBox(width: 6),
                                  Text('Quyết định điều động'),
                                ],
                              ),
                              Positioned(
                                right: -10,
                                top: -6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$quyetDinhCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                  ToolAndSuppliesHandoverList(
                    provider: widget.provider,
                    listAssetTransfer: dataAssetTransfer,
                  ),
                  ToolAndSuppliesHandoverTransferList(
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
