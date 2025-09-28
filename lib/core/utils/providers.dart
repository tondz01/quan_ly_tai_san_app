import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/providers/project_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/provider/role_provide.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/provider/ccdc_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/provider/type_asset_provider.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/provider/type_ccdc_provider.dart';
import '../../screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider(create: (context) => ToolsAndSuppliesProvider()),
    ChangeNotifierProvider(create: (context) => DieuDongTaiSanProvider()),
    ChangeNotifierProvider(create: (context) => ToolAndMaterialTransferProvider()),
    ChangeNotifierProvider(create: (context) => AssetGroupProvider()),
    ChangeNotifierProvider(create: (context) => CcdcGroupProvider()),
    ChangeNotifierProvider(create: (context) => AssetManagementProvider()),
    ChangeNotifierProvider(create: (context) => LoginProvider()),
    ChangeNotifierProvider(create: (context) => AssetHandoverProvider()),
    ChangeNotifierProvider(create: (context) => ToolAndSuppliesHandoverProvider()),
    ChangeNotifierProvider(create: (context) => RoleProvider()),
    ChangeNotifierProvider(create: (context) => ProjectProvider()),
    ChangeNotifierProvider(create: (context) => TypeAssetProvider()),
    ChangeNotifierProvider(create: (context) => TypeCcdcProvider()),
  ];
}
