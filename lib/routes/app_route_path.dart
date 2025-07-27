enum AppRoute {
  projectManager(path: "/project-manager", name: "project-manager"),
  exemple(path: "/exemple", name: "exemple"),
  exemple1(path: "/exemple/1", name: "exemple-1"),
  exemple2(path: "/exemple/2", name: "exemple-2"),
  exemple3(path: "/exemple/3", name: "exemple-3"),
  exemple4(path: "/exemple/4", name: "exemple-4"),
  assetManagement(path: "/asset-management", name: "asset-management"),
  asset(path: "/asset-management/asset", name: "asset-management-asset"),
  assetDepreciation(path: "/asset-management/asset-depreciation", name: "asset-management-asset-depreciation"),
  assetModel(path: "/asset-management/asset-model", name: "asset-management-asset-model"),
  assetGroup(path: "/asset-management/asset-group", name: "asset-management-asset-group"),
  assetAttachment(path: "/asset-management/asset-attachment", name: "asset-management-asset-attachment");

  final String path;
  final String? name;
  const AppRoute({required this.path, this.name});
}
