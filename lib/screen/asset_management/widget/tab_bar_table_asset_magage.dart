import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_management_list.dart';

class TabBarTableAssetManage extends StatefulWidget {
  final AssetManagementProvider provider;
  const TabBarTableAssetManage({super.key, required this.provider});

  @override
  State<TabBarTableAssetManage> createState() => _TabBarTableAssetManageState();
}

class _TabBarTableAssetManageState extends State<TabBarTableAssetManage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final idx = _tabController.index;
      try {
        widget.provider.onReloadTab(context, idx);
      } catch (_) {}
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        widget.provider.onReloadTab(context, 0);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TabBarTableAssetManage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height + 250,
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
                    controller: _tabController,
                    indicatorColor: ColorValue.link,
                    labelColor: ColorValue.link,
                    unselectedLabelColor: Colors.grey.shade600,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.book_outlined, size: 18),
                        text: 'Tài sản đã bàn giao',
                      ),
                      Tab(
                        icon: Icon(Icons.book_outlined, size: 18),
                        text: 'Tài sản chưa bàn giao',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Tab 1: Bàn giao tài sản
                AssetManagementList(provider: widget.provider),
                AssetManagementList(provider: widget.provider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
