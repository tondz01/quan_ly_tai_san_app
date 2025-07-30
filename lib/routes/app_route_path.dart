enum AppRoute {
  projectManager(path: "/project-manager", name: "project-manager"),
  exemple(path: "/exemple", name: "exemple"),
  exemple1(path: "/exemple/1", name: "exemple-1"),
  exemple2(path: "/exemple/2", name: "exemple-2"),
  exemple3(path: "/exemple/3", name: "exemple-3"),
  exemple4(path: "/exemple/4", name: "exemple-4"),
  toolsAndSupplies(path: "/tools-and-supplies", name: "tools-and-supplies"),
  assetTransfer(path: "/asset-transfer", name: "asset-transfer"),
  assetHandover(path: "/asset-handover", name: "asset-handover"),
  assetHandoverDetail(path: "/asset-handover-detail", name: "asset-handover-detail");

  final String path;
  final String? name;
  const AppRoute({required this.path, this.name});
}
