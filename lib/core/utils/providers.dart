import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/provider/tools_and_supplies_provide.dart';

List<SingleChildWidget> get providers {
  return [ChangeNotifierProvider(create: (context) => ToolsAndSuppliesProvider())];
}
