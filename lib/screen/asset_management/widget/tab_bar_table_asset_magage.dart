import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/item_asset_group.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/table_asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_management_list.dart';
import 'package:se_gay_components/common/sg_text.dart';

class TabBarTableAssetManage extends StatefulWidget {
  final AssetManagementProvider provider;
  const TabBarTableAssetManage({super.key, required this.provider});

  @override
  State<TabBarTableAssetManage> createState() => _TabBarTableAssetManageState();
}

class _TabBarTableAssetManageState extends State<TabBarTableAssetManage>
    with SingleTickerProviderStateMixin {
  ScrollController horizontalController = ScrollController();
  String? idNhomTaiSan;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging) return;
    //   final idx = _tabController.index;
    //   try {
    //     widget.provider.onReloadTab(context, idx);
    //   } catch (_) {}
    //   setState(() {});
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   try {
    //     widget.provider.onReloadTab(context, 0);
    //   } catch (_) {}
    // });
  }

  @override
  void didUpdateWidget(TabBarTableAssetManage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final groups = widget.provider.dataGroup ?? const <AssetGroupDto>[];
    final ref = riverpod.ProviderScope.containerOf(context);
    final notifier = ref.read(tableAssetManagementProvider.notifier);
    return DefaultTabController(
      length: 2,
      child: Container(
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
          listAssetGroup(groups, notifier),
          SizedBox(height: 12),
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
                    // controller: _tabController,
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
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Tab 1: Bàn giao tài sản
                AssetManagementList(provider: widget.provider, typeTab: 0),
                AssetManagementList(provider: widget.provider, typeTab: 1),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget listAssetGroup(groups, notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF21A366),
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          SGText(
            text: 'Danh sách nhóm tài sản',
            size: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          Visibility(visible: groups.isNotEmpty, child: Divider()),
          Visibility(
            visible: groups.isEmpty,
            child: Center(
              child: SGText(
                text: 'Không có loại tài sản nào',
                color: ColorValue.link,
                size: 14,
              ),
            ),
          ),
          if (groups.isNotEmpty)
            Scrollbar(
              controller: horizontalController,
              thumbVisibility: true,
              thickness: 4,
              notificationPredicate:
                  (notification) =>
                      notification.metrics.axis == Axis.horizontal,
              child: SingleChildScrollView(
                controller: horizontalController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 13.0),
                  child: Row(
                    // spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...groups.map(
                        (item) => Visibility(
                          visible: item.soLuongTaiSan != 0,
                          child: ItemAssetGroup(
                            titleName: item.tenNhom,
                            numberAsset: item.soLuongTaiSan.toString(),
                            image: "assets/images/assets.png",
                            onTap: () {
                              context.go(AppRoute.staffManager.path);
                            },
                            valueCheckBox: idNhomTaiSan == item.id,
                            onChange: (value) {
                              setState(() {
                                idNhomTaiSan = item.id;
                              });
                              notifier.searchByGroup(item.id ?? '');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
