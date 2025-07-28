import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider(create: (context) => ToolsAndSuppliesProvider()),
    ChangeNotifierProvider(create: (context) => AssetTransferProvider()),
    ChangeNotifierProvider(create: (context) => AssetHandoverProvider()),
  ];
}
