import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/provider/asset_category_provide.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider(create: (context) => ToolsAndSuppliesProvider()),
    ChangeNotifierProvider(create: (context) => AssetTransferProvider()),
    ChangeNotifierProvider(create: (context) => AssetHandoverProvider()),
    ChangeNotifierProvider(create: (context) => ToolAndMaterialTransferProvider()),
    ChangeNotifierProvider(create: (context) => AssetGroupProvider()),
    ChangeNotifierProvider(create: (context) => AssetManagementProvider()),
    ChangeNotifierProvider(create: (context) => AssetCategoryProvider()),
  ];
}
